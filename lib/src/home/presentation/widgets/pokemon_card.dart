import 'package:flutter/material.dart';
import 'package:pokedex/core/theme/app_theme.dart';
import 'package:pokedex/src/home/data/models/pokemon_tile.dart';

class PokemonCard extends StatelessWidget {
  final PokemonTile pk;

  const PokemonCard({super.key, required this.pk});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final imgSize = size.height * 0.1;

    return Material(
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 15.0,
        ),
        decoration: BoxDecoration(
          color: AppTheme.typeColors[pk.types.first],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: [
            // TODO: show not available image
            Image.network(
              pk.spriteUrl!,
              width: imgSize,
              height: imgSize,
            ),
            const SizedBox(width: 15.0),
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Tooltip(
                  message: pk.name,
                  child: Flexible(
                    child: Text(
                      pk.name[0].toUpperCase() + pk.name.substring(1),
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.6),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(height: 5.0),
                Row(
                  children: pk.types
                      .map<Widget>(
                        (type) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5.0,
                            vertical: 2.0,
                          ),
                          margin: const EdgeInsets.only(right: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            type,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12.0,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
            const Expanded(child: SizedBox()),
            Text(
              '#${pk.id}',
              style: TextStyle(
                color: Colors.black.withOpacity(0.15),
                fontSize: 30.0,
                fontWeight: FontWeight.w900,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
