class PokemonTile {
  final int id;
  final String name;
  final String? spriteUrl;
  final List<String> types;

  PokemonTile({
    required this.id,
    required this.name,
    this.spriteUrl,
    required this.types,
  });

  factory PokemonTile.fromJson(Map<String, dynamic> json) => PokemonTile(
        id: json['id'],
        name: json['name'],
        spriteUrl: json['pokemon_v2_pokemonsprites']?[0]['sprites'],
        types: List<String>.from(json['pokemon_v2_pokemontypes'].map(
          (x) => x['pokemon_v2_type']['name'],
        )),
      );
}
