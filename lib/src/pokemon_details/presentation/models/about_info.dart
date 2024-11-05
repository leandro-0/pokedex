import 'package:pokedex/core/utils/utils.dart';
import 'package:pokedex/src/pokemon_details/presentation/models/egg_groups.dart';

class AboutInfo {
  final String description;
  final String generation;
  final double height;
  final double weight;
  final String habitat;
  final bool isLegendary;
  final bool isMythical;
  final double malePercentage;
  final double femalePercentage;
  final EggGroups eggGroups;
  final int eggCycle;

  AboutInfo({
    required this.description,
    required this.height,
    required this.weight,
    required this.generation,
    required this.isLegendary,
    required this.isMythical,
    required this.malePercentage,
    required this.femalePercentage,
    required this.eggGroups,
    required this.eggCycle,
    required this.habitat,
  });

  factory AboutInfo.fromJson(Map<String, dynamic> json) {
    final pokemon = json['pokemon_v2_pokemons']?[0];
    final genderRate = json['gender_rate'];

    return AboutInfo(
      description: json['pokemon_v2_pokemonspeciesflavortexts']?[0]
                  ?['flavor_text']
              .replaceAll('\n', ' ')
              .replaceAll('\f', ' ') ??
          'No available description',
      height: pokemon?['height'] / 10 ?? 0,
      weight: pokemon?['weight'] / 10 ?? 0,
      isLegendary: json['is_legendary'] ?? false,
      isMythical: json['is_mythical'] ?? false,
      malePercentage: genderRate == -1 ? 0 : (8 - genderRate) / 8 * 100,
      femalePercentage: genderRate == -1 ? 0 : genderRate / 8 * 100,
      eggGroups: EggGroups.fromJson(json),
      eggCycle: json['hatch_counter'] ?? 0,
      generation: (json['pokemon_v2_generation']['name'] as String)
          .replaceFirst('generation-', '')
          .toUpperCase(),
      habitat: Utils.capitalize(json['pokemon_v2_pokemonhabitat']['name']),
    );
  }
}
