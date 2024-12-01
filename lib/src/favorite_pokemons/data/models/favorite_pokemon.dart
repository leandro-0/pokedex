import 'dart:typed_data';

import 'package:objectbox/objectbox.dart';
import 'package:pokedex/src/home/data/models/pokemon_tile.dart';

@Entity()
class FavoritePokemon {
  @Id()
  int id = 0;

  int pokedexId;
  String? shinySpriteUrl;
  String spriteUrl;
  String name;

  @Property(type: PropertyType.byteVector)
  Uint8List spriteBytes;

  final List<String> types;

  FavoritePokemon({
    this.id = 0,
    required this.pokedexId,
    required this.name,
    required this.spriteBytes,
    required this.spriteUrl,
    required this.shinySpriteUrl,
    required this.types,
  });

  factory FavoritePokemon.fromPokemonTile(
    PokemonTile pokemonTile,
    Uint8List spriteBytes,
  ) {
    return FavoritePokemon(
      pokedexId: pokemonTile.id,
      name: pokemonTile.name,
      spriteBytes: spriteBytes,
      spriteUrl: pokemonTile.spriteUrl,
      shinySpriteUrl: pokemonTile.shinySpriteUrl,
      types: pokemonTile.types,
    );
  }

  PokemonTile toPokemonTile() {
    return PokemonTile(
      id: pokedexId,
      name: name,
      spriteUrl: spriteUrl,
      types: types,
      shinySpriteUrl: shinySpriteUrl,
      spriteBytes: spriteBytes,
    );
  }
}
