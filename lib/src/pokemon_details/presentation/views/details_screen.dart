import 'package:flutter/material.dart';
import 'package:pokedex/src/home/data/models/pokemon_tile.dart';
import 'package:pokedex/src/pokemon_details/presentation/views/pokemon_details.dart';

class DetailsScreen extends StatefulWidget {
  static const String routeName = '/global-details';

  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  PageController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The argument is int when the user navigates to the details screen
    // and swipes to the next or previous pokemon
    // The argument is a PokemonTile when the user taps on a pokemon card
    final arg = ModalRoute.of(context)!.settings.arguments;
    if (arg is! PokemonTile && arg is! int) {
      throw Exception(
        'Invalid argument type, expected a PokemonTile or an int',
      );
    }

    if (arg is int) {
      final currentId = ModalRoute.of(context)!.settings.arguments as int?;
      controller ??= PageController(initialPage: (currentId ?? 1) - 1);
    } else {
      controller ??= PageController(initialPage: (arg as PokemonTile).id - 1);
    }

    return PageView.builder(
      controller: controller,
      itemCount: 1025,
      itemBuilder: (_, index) => PokemonDetails(
        id: index + 1,
        pk: _getPokemonTile(arg, index + 1),
      ),
    );
  }

  PokemonTile? _getPokemonTile(dynamic arg, int id) {
    if (arg is! PokemonTile) return null;
    return arg.id == id ? arg : null;
  }
}
