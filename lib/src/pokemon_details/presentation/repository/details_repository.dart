import 'package:graphql_flutter/graphql_flutter.dart';

class PokemonDetails {
  final GraphQLClient client;

  PokemonDetails()
      : client = GraphQLClient(
          link: HttpLink('https://beta.pokeapi.co/graphql/v1beta'),
          cache: GraphQLCache(),
        );

  static String get pokemonSpeciesQuery => '''
  query getPokemonSpecies(\$id: Int!) {
    pokemon_v2_pokemonspecies(where: {id: {_eq: \$id}}) {
      is_legendary
      is_mythical
      gender_rate
      hatch_counter
      pokemon_v2_pokemonhabitat {
        name
      }
      evolution_chain_id
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

  static String get pokemonStatsQuery => '''
  query getPokemonStats (\$id: Int!) {
    pokemon_v2_pokemons(where: {id: {_eq: \$id}}) {
      pokemon_v2_pokemonstats {
        base_stat
        pokemon_v2_stat {
          name
        }
      }
      pokemon_v2_pokemontypes {
          pokemon_v2_type {
            name
          }
        }
      }
    }
''';

  Future<Map<String, dynamic>> getPokemonDescription(int pokemonId) async {
    try {
      final QueryOptions options = QueryOptions(
        document: gql(pokemonSpeciesQuery),
        variables: {
          'id': pokemonId,
        },
      );

      final QueryResult result = await client.query(options);

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      final data = result.data?['pokemon_v2_pokemonspecies']?[0];
      if (data == null) {
        throw Exception('No se encontraron datos para este Pokémon');
      }

      final pokemon = data['pokemon_v2_pokemons']?[0];
      final eggGroups = data['pokemon_v2_pokemonegggroups']
              ?.map((e) => e['pokemon_v2_egggroup']['name'])
              .toList() ??
          [];

      final genderRate = data['gender_rate'];
      final malePercentage = genderRate == -1 ? 0 : (8 - genderRate) / 8 * 100;
      final femalePercentage = genderRate == -1 ? 0 : genderRate / 8 * 100;

      final stats = pokemon?['pokemon_v2_pokemonstats']?.map((e) {
            return {
              'name': e['pokemon_v2_stat']['name'],
              'base_stat': e['base_stat'],
            };
          }).toList() ??
          [];

      final types = pokemon?['pokemon_v2_pokemontypes']
              ?.map((e) => e['pokemon_v2_type']['name'])
              .toList() ??
          [];

      return {
        'description': data['pokemon_v2_pokemonspeciesflavortexts']?[0]
                ?['flavor_text'] ??
            'No hay descripción disponible',
        'isLegendary': data['is_legendary'] ?? false,
        'isMythical': data['is_mythical'] ?? false,
        'habitat': data['pokemon_v2_pokemonhabitat']?['name'] ?? 'unknown',
        'generation': data['pokemon_v2_generation']?['name'] ?? 'unknown',
        'height': pokemon?['height'] ?? 0,
        'weight': pokemon?['weight'] ?? 0,
        'types': pokemon?['pokemon_v2_pokemontypes']
                ?.map((e) => e['pokemon_v2_type']['name'])
                .toList() ??
            [],
        'eggGroups': eggGroups,
        'malePercentage': malePercentage,
        'femalePercentage': femalePercentage,
        'hatchCounter': data['hatch_counter'] ?? 0,
        'stats': stats,
        'weaknesses': _calculateWeaknesses(types),
      };
    } catch (e) {
      throw Exception('Error al obtener los datos: $e');
    }
  }

  List<String> _calculateWeaknesses(List<String> types) {
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
