import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pokedex/core/theme/app_theme.dart';
import 'package:pokedex/core/utils/utils.dart';
import 'package:pokedex/src/home/data/models/pokemon_tile.dart';
import 'package:pokedex/src/home/presentation/widgets/pokemon_types.dart';
import 'package:screenshot/screenshot.dart';

class PokemonShareCard extends StatelessWidget {
  final PokemonTile pk;
  final String cardText;
  final ScreenshotController screenshotController;

  const PokemonShareCard({
    super.key,
    required this.pk,
    required this.cardText,
    required this.screenshotController,
  });

  @override
  Widget build(BuildContext context) {
    const imgSize = 150.0, cardWidth = 350.0, cardHeight = 500.0;
    final cardColor = AppTheme.typeColors[pk.types.first] ?? Colors.grey;
    final auxColor = AppTheme.typeChipColors[pk.types.first] ?? Colors.grey;

    return Screenshot(
      controller: screenshotController,
      child: Container(
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -10.0,
              right: -30.0,
              child: Transform.rotate(
                angle: pi / 6,
                child: SvgPicture.asset(
                  'assets/icons/pokeball_background.svg',
                  width: imgSize * 2,
                  height: imgSize * 2,
                  colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.2),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            Align(
              alignment: const Alignment(-0.8, -0.9),
              child: Text(
                Utils.capitalize(pk.name),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Align(
              alignment: const Alignment(0.8, -0.9),
              child: Text(
                '#${pk.id.toString().padLeft(4, '0')}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Align(
              alignment: const Alignment(0.6, -0.55),
              child: Image.network(
                pk.spriteUrl,
                height: imgSize,
              ),
            ),
            Align(
              alignment: const Alignment(0.0, -0.7),
              child: SizedBox(
                width: 300.0,
                child: PokemonTypes(types: pk.types),
              ),
            ),
            Align(
              alignment: const Alignment(0.0, 0.75),
              child: Container(
                width: cardWidth - 60.0,
                height: cardHeight * 0.25,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info,
                          color: auxColor,
                          size: 18.0,
                        ),
                        const SizedBox(width: 5.0),
                        Text(
                          'About this Pokémon',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: auxColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5.0),
                    Flexible(
                      child: Text(
                        cardText,
                        style: const TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
