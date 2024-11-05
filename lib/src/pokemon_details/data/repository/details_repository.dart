import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokedex/src/pokemon_details/data/models/about_info.dart';

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
}
