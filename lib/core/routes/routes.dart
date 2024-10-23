import 'package:flutter/material.dart';
import 'package:pokedex/src/home/presentation/views/home_screen.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  HomeScreen.routeName: (_) => const HomeScreen(),
};
