import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokedex/core/theme/app_theme.dart';
import 'package:pokedex/src/home/data/models/pokemon_tile.dart';
import 'package:pokedex/src/home/presentation/widgets/pokemon_types.dart';
import 'package:pokedex/src/pokemon_details/presentation/views/details_screen.dart';

class PokemonCard extends StatelessWidget {
  final PokemonTile pk;

  const PokemonCard({super.key, required this.pk});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final imgSize = size.height * 0.1;
    final borderRadius = BorderRadius.circular(10.0);

    return Material(
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(
          context,
          DetailsScreen.routeName,
          arguments: pk,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 5.0,
          ),
          decoration: BoxDecoration(
            color: AppTheme.typeColors[pk.types.first],
            borderRadius: borderRadius,
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  SvgPicture.asset(
                    'assets/icons/pokeball_background.svg',
                    width: imgSize + 10.0,
                    height: imgSize + 10.0,
                    colorFilter: ColorFilter.mode(
                      Colors.white.withOpacity(0.2),
                      BlendMode.srcIn,
                    ),
                  ),
                  Positioned(
                    left: 7.0,
                    top: 7.0,
                    child: Hero(
                      tag: 'card-${pk.id}',
                      child: Image(
                        image: pk.spriteBytes == null
                            ? NetworkImage(pk.spriteUrl)
                            : MemoryImage(pk.spriteBytes!),
                        width: imgSize,
                        height: imgSize,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 15.0),
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Tooltip(
                    message: pk.name,
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
                  const SizedBox(height: 5.0),
                  PokemonTypes(types: pk.types),
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
      ),
    );
  }
}
