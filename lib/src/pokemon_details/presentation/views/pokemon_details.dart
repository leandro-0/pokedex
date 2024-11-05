import 'package:flutter/material.dart';
import 'package:pokedex/src/home/data/models/pokemon_tile.dart';
import 'package:pokedex/core/theme/app_theme.dart';
import 'package:pokedex/src/pokemon_details/presentation/widgets/details_tab_view.dart';
import 'package:pokedex/src/pokemon_details/presentation/widgets/pokemon_details_image.dart';

class PokemonDetails extends StatelessWidget {
  static const String routeName = '/details';

  const PokemonDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final pkBasicInfo =
        ModalRoute.of(context)!.settings.arguments as PokemonTile;
    final backgroundColor =
        AppTheme.typeColors[pkBasicInfo.types.first] ?? Colors.grey;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PokemonDetailsImage(pkBasicInfo: pkBasicInfo),
          DetailsTabView(
            backgroundColor: backgroundColor,
            pkBasicInfo: pkBasicInfo,
          ),
        ],
      ),
    );
  }
}
