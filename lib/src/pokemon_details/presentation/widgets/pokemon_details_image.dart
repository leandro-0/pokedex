import 'package:flutter/material.dart';
import 'package:pokedex/core/utils/utils.dart';
import 'package:pokedex/src/home/data/models/pokemon_tile.dart';
import 'package:pokedex/src/home/presentation/widgets/pokemon_types.dart';

class PokemonDetailsImage extends StatelessWidget {
  final PokemonTile pkBasicInfo;

  const PokemonDetailsImage({super.key, required this.pkBasicInfo});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final imgSize = size.height * 0.2;
    final image = Image.network(
      pkBasicInfo.spriteUrl,
      height: imgSize,
    );
    return SizedBox(
      height: size.height * 0.37,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned(
            top: 40.0,
            left: 10.0,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Positioned(
            top: 40.0,
            right: 10.0,
            child: IconButton(
              icon: const Icon(Icons.favorite_border, color: Colors.white),
              onPressed: () {},
            ),
          ),
          Positioned(
            right: 20.0,
            bottom: 10.0,
            child: PokemonTypes(
              types: pkBasicInfo.types,
              direction: Axis.vertical,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Hero(tag: 'card-${pkBasicInfo.id}', child: image),
          ),
          Align(
            alignment: const Alignment(0.0, 0.75),
            child: Text(
              Utils.capitalize(pkBasicInfo.name),
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0.0, 0.87),
            child: Text(
              '#${pkBasicInfo.id.toString().padLeft(4, '0')}',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
