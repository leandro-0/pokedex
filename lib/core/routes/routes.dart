import 'package:flutter/material.dart';
import 'package:pokedex/src/home/presentation/views/home_screen.dart';
import 'package:pokedex/src/pokemon_details/presentation/views/pokemon_details.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  HomeScreen.routeName: (_) => const HomeScreen(),
  PokemonDetails.routeName: (_) => const PokemonDetails(),
};
