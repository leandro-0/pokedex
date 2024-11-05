import 'package:pokedex/src/home/data/models/pokemon_tile.dart';

class PokemonNode implements Comparable {
  final PokemonTile pokemonTile;
  final int evolvesFrom;
  final int order;

  PokemonNode({
    required this.pokemonTile,
    required this.evolvesFrom,
    required this.order,
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
    );
  }

  @override
  int compareTo(other) => order.compareTo(other.order);

  @override
  String toString() => evolvesFrom.toString();
}
