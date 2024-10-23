import 'package:flutter/material.dart';
import 'package:pokedex/core/routes/routes.dart';
import 'package:pokedex/src/home/presentation/views/home_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pokédex',
      routes: routes,
      initialRoute: HomeScreen.routeName,
    );
  }
}
