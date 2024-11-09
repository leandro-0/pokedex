import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokedex/src/home/data/models/pokemon_filter.dart';
import 'package:pokedex/src/home/data/models/pokemon_tile.dart';

class HomeRepository {
  static Future<List<PokemonTile>> getPokemons(
    GraphQLClient client,
    int page, {
    int pageSize = 20,
    PokemonFilter? filter,
  }) async {
    final query = gql(r'''
      query pokemonsList($limit: Int, $offset: Int, $where: pokemon_v2_pokemon_bool_exp) {
        pokemon_v2_pokemon(
          limit: $limit, 
          offset: $offset, 
          where: $where,
          order_by: {id: asc}
        ) {
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

    final whereCondition = filter?.toQueryVariables() ??
        {
          'id': {'_lte': 1025}
        };

    final response = await client.query(QueryOptions(
      document: query,
      variables: {
        'limit': pageSize,
        'offset': page * pageSize,
        'where': whereCondition,
      },
    ));

    if (response.data?['pokemon_v2_pokemon'] == null) {
      throw Exception('Failed to load pokemons');
    }

    return response.data?['pokemon_v2_pokemon']
        .map<PokemonTile>((pokemon) => PokemonTile.fromJson(pokemon))
        .toList();
  }
}
