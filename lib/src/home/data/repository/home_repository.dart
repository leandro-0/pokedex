import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokedex/src/home/data/models/ability.dart';
import 'package:pokedex/src/home/data/models/pokemon_filter.dart';
import 'package:pokedex/src/home/data/models/pokemon_tile.dart';
import 'package:pokedex/src/home/domains/enums/pokemon_sort.dart';

class HomeRepository {
  static Future<List<PokemonTile>> getPokemons(
    GraphQLClient client,
    int page, {
    int pageSize = 20,
    PokemonFilter? filter,
    required PokemonSort orderBy,
  }) async {
    final query = gql(r'''
      query pokemonsList($limit: Int, $offset: Int, $where: pokemon_v2_pokemon_bool_exp, $orderBy: [pokemon_v2_pokemon_order_by!]) {
        pokemon_v2_pokemon(
          limit: $limit, 
          offset: $offset, 
          where: $where,
          order_by: $orderBy
        ) {
          id
          pokemon_v2_pokemonspecy {
            name
          }
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
        'orderBy': _getOrderByVariable(orderBy),
      },
    ));

    if (response.data?['pokemon_v2_pokemon'] == null) {
      throw Exception('Failed to load pokemons');
    }

    return response.data?['pokemon_v2_pokemon']
        .map<PokemonTile>((pokemon) => PokemonTile.fromJson(pokemon))
        .toList();
  }

  static List<Map<String, dynamic>> _getOrderByVariable(PokemonSort orderBy) {
    if (orderBy.isType) {
      return [
        {
          'pokemon_v2_pokemontypes_aggregate': {
            'min': {'type_id': orderBy.order}
          }
        },
        {'id': orderBy.order}
      ];
    } else if (orderBy.isName) {
      return [
        {
          'pokemon_v2_pokemonspecy': {'name': orderBy.order}
        }
      ];
    } else {
      return [
        {'id': orderBy.order}
      ];
    }
  }

  static Future<List<Ability>> getAbilities(GraphQLClient client) async {
    const String query = '''
    query getAbilities {
      pokemon_v2_ability(order_by: {name: asc}, where: {is_main_series: {_eq: true}}) {
        pokemon_v2_abilitynames(where: {pokemon_v2_language: {name: {_eq: "en"}}}) {
          name
          pokemon_v2_ability {
            name
            pokemon_v2_generation {
              name
            }
          }
        }
      }
    }
    ''';

    final QueryResult result = await client.query(
      QueryOptions(document: gql(query)),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final List abilities = result.data?['pokemon_v2_ability'] ?? [];
    return abilities
        .map<Ability>((ability) => Ability.fromJson(ability))
        .toList();
  }
}
