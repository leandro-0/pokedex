import 'package:flutter/material.dart';

class PokemonInfoNotifier extends ChangeNotifier {
  String? _pokemonDescription;
  String? get pokemonDescription => _pokemonDescription;
  set pokemonDescription(String? description) {
    _pokemonDescription = description;
    notifyListeners();
  }
}
