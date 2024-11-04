import 'package:flutter/material.dart';
import 'package:pokedex/src/home/data/models/pokemon_tile.dart';

class PokemonDetails extends StatefulWidget {
  static const String routeName = '/details';

  const PokemonDetails({super.key});

  @override
  State<PokemonDetails> createState() => _PokemonDetailsState();
}

class _PokemonDetailsState extends State<PokemonDetails> {
  @override
  Widget build(BuildContext context) {
    final pkBasicInfo =
        ModalRoute.settingsOf(context)!.arguments as PokemonTile;

    return Scaffold(
      body: Center(
        child: Hero(
          tag: 'card-${pkBasicInfo.id}',
          child: Image.network(pkBasicInfo.spriteUrl),
        ),
      ),
    );
  }
}
