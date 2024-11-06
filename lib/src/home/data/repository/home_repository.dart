import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokedex/src/home/data/models/evolution_edge.dart';
import 'package:pokedex/src/home/data/models/pokemon_node.dart';
import 'package:pokedex/src/home/data/models/pokemon_tile.dart';

class HomeRepository {
  static Future<List<PokemonTile>> getPokemons(
    GraphQLClient client,
    int page, {
    int pageSize = 20,
  }) async {
    final query = gql(r'''
      query pokemonsList($limit: Int, $offset: Int) {
        pokemon_v2_pokemon(limit: $limit, offset: $offset, where: {id: {_lte: 1025}}) {
          id
          name
          pokemon_v2_pokemonsprites {
            sprites(path: "other.official-artwork.front_default")
            pokemon_v2_pokemon {
              pokemon_v2_pokemonsprites {
                sprites(path: "other.official-artwork.front_shiny")
              }
            }
          }
          pokemon_v2_pokemontypes {
            pokemon_v2_type {
              name
            }
          }
        }
      }
    ''');

    final response = await client.query(QueryOptions(
      document: query,
      variables: {'limit': pageSize, 'offset': page * pageSize},
    ));

    if (response.data?['pokemon_v2_pokemon'] == null) {
      throw Exception('Failed to load pokemons');
    }

    return response.data?['pokemon_v2_pokemon']
        .map<PokemonTile>((pokemon) => PokemonTile.fromJson(pokemon))
        .toList();
  }

  static Future<List<EvolutionEdge>> getEvolutionChain(
    GraphQLClient client,
    int id,
  ) async {
    final query = gql(r'''
      query GetEvolutionChain($id: Int) {
        pokemon_v2_pokemon(where: {id: {_eq: $id}}) {
          pokemon_v2_pokemonspecy {
            pokemon_v2_evolutionchain {
              pokemon_v2_pokemonspecies {
                name
                id
                evolves_from_species_id
                order
                pokemon_v2_pokemons(limit: 1) {
                  pokemon_v2_pokemonsprites(limit: 1) {
                    sprites(path: "other.official-artwork.front_default")
                  }
                  pokemon_v2_pokemontypes {
                    pokemon_v2_type {
                      name
                    }
                  }
                }
              }
            }
          }
        }
      }
    ''');

    final response = await client.query(
      QueryOptions(document: query, variables: {'id': id}),
    );

    final chain = response.data!['pokemon_v2_pokemon'][0]
            ['pokemon_v2_pokemonspecy']['pokemon_v2_evolutionchain']
        ['pokemon_v2_pokemonspecies'] as List;

    if (chain.length == 1) return [];

    return _buildEvolutionTree(chain);
  }

  static List<EvolutionEdge> _buildEvolutionTree(List<dynamic> chain) {
    final edges = <EvolutionEdge>[];
    final nodes = chain.map((e) => PokemonNode.fromJson(e)).toList();
    nodes.sort((a, b) => a.compareTo(b));
    final Map<int, int> idToIndex = {};

    for (var i = 0; i < nodes.length; i++) {
      idToIndex[nodes[i].pokemonTile.id] = i;
    }

    for (final node in nodes) {
      if (node.evolvesFrom == -1) continue;

      final fromIndex = idToIndex[node.evolvesFrom];
      final from = nodes[fromIndex!];
      final to = node;

      edges.add(EvolutionEdge(from: from, to: to));
    }

    return edges;
  }
}
