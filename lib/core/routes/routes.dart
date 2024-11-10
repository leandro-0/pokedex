import 'package:flutter/material.dart';
import 'package:pokedex/src/guess_pokemon/presentation/views/guess_pokemon_screen.dart';
import 'package:pokedex/src/home/presentation/views/home_screen.dart';
import 'package:pokedex/src/pokemon_details/presentation/views/details_screen.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  HomeScreen.routeName: (_) => const HomeScreen(),
  DetailsScreen.routeName: (_) => const DetailsScreen(),
  GuessPokemonScreen.routeName: (_) => const GuessPokemonScreen(),
};
