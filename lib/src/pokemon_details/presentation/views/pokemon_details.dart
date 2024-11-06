import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokedex/src/home/data/models/pokemon_tile.dart';
import 'package:pokedex/core/theme/app_theme.dart';
import 'package:pokedex/src/pokemon_details/data/repository/details_repository.dart';
import 'package:pokedex/src/pokemon_details/presentation/widgets/details_tab_view.dart';
import 'package:pokedex/src/pokemon_details/presentation/widgets/pokemon_details_image.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PokemonDetails extends StatelessWidget {
  static const String routeName = '/details';

  final int id;
  final PokemonTile? pk;

  const PokemonDetails({super.key, required this.id, this.pk});

  @override
  Widget build(BuildContext context) {
    if (pk != null) {
      final bgColor = AppTheme.typeColors[pk!.types.first] ?? Colors.grey;
      return Scaffold(
        backgroundColor: bgColor,
        body: _Details(pkBasicInfo: pk!, backgroundColor: bgColor),
      );
    }

    final placeholder = PokemonTile(
      id: 1,
      name: 'Bulbasaur',
      spriteUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png',
      types: ['grass', 'poison'],
    );

    return FutureBuilder(
      future: DetailsRepository.getPokemonInfo(
        GraphQLProvider.of(context).value,
        id,
      ),
      builder: (context, snapshot) {
        final backgroundColor =
            AppTheme.typeColors[placeholder.types.first] ?? Colors.grey;

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Skeletonizer(
              containersColor: Colors.white,
              child: _Details(
                pkBasicInfo: placeholder,
                backgroundColor: backgroundColor,
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text('An error occurred'),
            ),
          );
        }

        final data = snapshot.data as PokemonTile;
        return Scaffold(
          backgroundColor: AppTheme.typeColors[data.types.first] ?? Colors.grey,
          body: _Details(
            pkBasicInfo: data,
            backgroundColor:
                AppTheme.typeColors[data.types.first] ?? Colors.grey,
          ),
        );
      },
    );
  }
}

class _Details extends StatelessWidget {
  final PokemonTile pkBasicInfo;
  final Color backgroundColor;

  const _Details({required this.pkBasicInfo, required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        PokemonDetailsImage(pkBasicInfo: pkBasicInfo),
        DetailsTabView(
          backgroundColor: backgroundColor,
          id: pkBasicInfo.id,
        ),
      ],
    );
  }
}
