import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokedex/src/home/data/models/pokemon_tile.dart';
import 'package:pokedex/src/pokemon_details/data/models/about_info.dart';
import 'package:pokedex/src/pokemon_details/data/models/pokemon_form.dart';

class DetailsRepository {
  static String get pokemonCompleteQuery => '''
  query getPokemonAboutInfo(\$id: Int!) {
    pokemon_v2_pokemonspecies(where: {id: {_eq: \$id}}) {
      is_legendary
      is_mythical
      gender_rate
      hatch_counter
      pokemon_v2_pokemonhabitat {
        name
      }
      pokemon_v2_pokemons {
        height
        weight
      }
      pokemon_v2_pokemonegggroups {
        pokemon_v2_egggroup {
          name
        }
      }
      pokemon_v2_generation {
        name
      }
      pokemon_v2_pokemonspeciesflavortexts(where: {language_id: {_eq: 9}}, limit: 1) {
        flavor_text
      }
    }
  }
''';

  static Future<AboutInfo> getPokemonDescription(
    GraphQLClient client,
    int pokemonId,
  ) async {
    final QueryResult result = await client.query(QueryOptions(
      document: gql(pokemonCompleteQuery),
      variables: {'id': pokemonId},
    ));

    if (result.hasException) throw Exception(result.exception.toString());

    final data = result.data?['pokemon_v2_pokemonspecies']?[0];
    if (data == null) throw Exception('This Pokémon has no data.');

    return AboutInfo.fromJson(data);
  }

  static List<String> _calculateWeaknesses(List<String> types) {
    final typeWeaknesses = {
      'normal': ['fighting'],
      'fire': ['water', 'rock', 'ground'],
      'water': ['electric', 'grass'],
      'electric': ['ground'],
      'grass': ['fire', 'ice', 'poison', 'flying', 'bug'],
      'ice': ['fire', 'fighting', 'rock', 'steel'],
      'fighting': ['flying', 'psychic', 'fairy'],
      'poison': ['ground', 'psychic'],
      'ground': ['water', 'ice', 'grass'],
      'flying': ['electric', 'ice', 'rock'],
      'psychic': ['bug', 'ghost', 'dark'],
      'bug': ['fire', 'flying', 'rock'],
      'rock': ['water', 'grass', 'fighting', 'ground', 'steel'],
      'ghost': ['ghost', 'dark'],
      'dragon': ['ice', 'dragon', 'fairy'],
      'dark': ['fighting', 'bug', 'fairy'],
      'steel': ['fire', 'fighting', 'ground'],
      'fairy': ['poison', 'steel'],
    };

    final weaknesses = <String>{};

    for (final type in types) {
      weaknesses.addAll(typeWeaknesses[type] ?? []);
    }

    return weaknesses.toList();
  }

  static Future<PokemonTile> getPokemonInfo(
    GraphQLClient client,
    int id,
  ) async {
    final query = gql(r'''
      query pokemonsList($id: Int) {
        pokemon_v2_pokemon(where: {id: {_eq: $id}}) {
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
      variables: {'id': id},
    ));

    if (response.data?['pokemon_v2_pokemon'] == null) {
      throw Exception('Failed to load pokemons');
    }

    return PokemonTile.fromJson(response.data?['pokemon_v2_pokemon'][0]);
  }

  static Future<List<PokemonForm>> getPokemonForms(
      GraphQLClient client, int id) async {
    final query = gql(r'''
      query GetPokemonForms($id: Int) {
        pokemon_v2_pokemon(where: {id: {_eq: $id}}) {
          pokemon_v2_pokemonspecy {
            pokemon_v2_pokemons {
              pokemon_v2_pokemonforms(order_by: {form_order: asc}) {
                name
                pokemon_v2_pokemonformsprites {
                  sprites(path: "front_default")
                }
                form_order
              }
            }
          }
        }
      }
    ''');

    final response = await client.query(QueryOptions(
      document: query,
      variables: {'id': id},
    ));

    if (response.data?['pokemon_v2_pokemon'] == null) {
      throw Exception('Failed to load data');
    }

    final forms = response.data?['pokemon_v2_pokemon'][0]
        ['pokemon_v2_pokemonspecy']['pokemon_v2_pokemons'];
    final mappedForms = <PokemonForm>[];

    for (final form in forms) {
      final formList = form['pokemon_v2_pokemonforms'];
      for (final form in formList) {
        mappedForms.add(PokemonForm.fromJson(form));
      }
    }

    return mappedForms;
  }

  static Future<String?> getPokemonCry(GraphQLClient client, int id) async {
    final query = gql(r'''
      query getPokemonCry($id: Int) {
        pokemon_v2_pokemon(where: {id: {_eq: $id}}) {
          pokemon_v2_pokemoncries {
            cries(path: "latest")
          }
        }
      }
    ''');

    final response = await client.query(QueryOptions(
      document: query,
      variables: {'id': id},
    ));

    if (response.data?['pokemon_v2_pokemon'] == null) {
      throw Exception('Failed to load data');
    }

    try {
      return response.data?['pokemon_v2_pokemon'][0]?['pokemon_v2_pokemoncries']
          ?[0]['cries'];
    } catch (e) {
      return null;
    }
  }
}
