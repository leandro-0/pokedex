import 'package:graphql_flutter/graphql_flutter.dart';
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
}
