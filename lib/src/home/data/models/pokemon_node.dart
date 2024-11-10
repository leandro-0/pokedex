import 'package:pokedex/src/home/data/models/pokemon_tile.dart';

class PokemonNode implements Comparable {
  final PokemonTile pokemonTile;
  final int evolvesFrom;
  final int order;
  final String? evolutionTrigger;

  PokemonNode({
    required this.pokemonTile,
    required this.evolvesFrom,
    required this.order,
    this.evolutionTrigger,
  });

  factory PokemonNode.fromJson(Map<String, dynamic> json) {
    return PokemonNode(
      pokemonTile: PokemonTile(
        id: json['id'],
        name: json['name'],
        spriteUrl: json['pokemon_v2_pokemons'][0]['pokemon_v2_pokemonsprites']
            ?[0]['sprites'],
        types: List<String>.from(
            json['pokemon_v2_pokemons'][0]['pokemon_v2_pokemontypes'].map(
          (x) => x['pokemon_v2_type']['name'],
        )),
      ),
      evolvesFrom: json['evolves_from_species_id'] ?? -1,
      order: json['order'],
      evolutionTrigger: _extractEvolutionTrigger(json),
    );
  }

  static String? _extractEvolutionTrigger(Map<String, dynamic> json) {
    try {
      final hasTriggers = (json['pokemon_v2_pokemonspecies'] as List).isEmpty;

      if (hasTriggers) return null;
      final trigger = json['pokemon_v2_pokemonspecies']?[0]
              ['pokemon_v2_pokemonevolutions']?[0]
          ['pokemon_v2_evolutiontrigger']['name'];

      return _evolutionTriggerNames.containsKey(trigger)
          ? _evolutionTriggerNames[trigger]
          : null;
    } catch (e) {
      return null;
    }
  }

  static final Map<String, String> _evolutionTriggerNames = {
    "level-up": "Level Up",
    "trade": "Trade",
    "use-item": "Item",
    "shed": "Shed",
    "spin": "Spin",
    "tower-of-darkness": "Tower of darkness",
    "tower-of-waters": "Tower of waters",
    "three-critical-hits": "Three critical hits",
    "take-damage": "Take damage",
    "other": "Other",
    "agile-style-move": "Agile style move",
    "strong-style-move": "Strong style move",
    "recoil-damage": "Recoil damage",
  };

  @override
  int compareTo(other) => order.compareTo(other.order);

  @override
  String toString() => evolvesFrom.toString();
}
