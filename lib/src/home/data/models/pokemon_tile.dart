import 'dart:typed_data';

class PokemonTile {
  final int id;
  final String name;
  final String spriteUrl;
  final List<String> types;
  final String? shinySpriteUrl;
  final Uint8List? spriteBytes;

  PokemonTile({
    required this.id,
    required this.name,
    required this.spriteUrl,
    required this.types,
    this.shinySpriteUrl,
    this.spriteBytes,
  });

  factory PokemonTile.fromJson(Map<String, dynamic> json) {
    final sprites = json['pokemon_v2_pokemonsprites']?[0];
    return PokemonTile(
      id: json['id'],
      name: json['pokemon_v2_pokemonspecy']['name'],
      spriteUrl: sprites['sprites'],
      shinySpriteUrl: sprites['pokemon_v2_pokemon']
          ?['pokemon_v2_pokemonsprites']?[0]['sprites'],
      types: List<String>.from(json['pokemon_v2_pokemontypes'].map(
        (x) => x['pokemon_v2_type']['name'],
      )),
    );
  }
}
