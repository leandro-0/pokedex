import 'package:flutter/material.dart';
import 'package:pokedex/src/favorite_pokemons/data/models/favorite_pokemon.dart';
import 'package:pokedex/src/favorite_pokemons/data/repository/favorite_pokemon_repository.dart';
import 'package:pokedex/src/home/presentation/widgets/pokemon_card.dart';
import 'package:pokedex/src/pokemon_details/presentation/widgets/empty_indicator.dart';

class FavoritePokemonsScreen extends StatefulWidget {
  static const String routeName = '/favorite-pokemons';

  const FavoritePokemonsScreen({super.key});

  @override
  State<FavoritePokemonsScreen> createState() => _FavoritePokemonsScreenState();
}

class _FavoritePokemonsScreenState extends State<FavoritePokemonsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        centerTitle: true,
        forceMaterialTransparency: true,
      ),
      body: FutureBuilder(
        future: FavoritePokemonRepository.getAllFavorites(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('An unexpected error occurred'));
          }
          final favorites = snapshot.data as List<FavoritePokemon>;
          if (favorites.isEmpty) {
            return const EmptyIndicator(text: 'No favorites yet, add some!');
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            itemCount: favorites.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10.0),
            itemBuilder: (_, i) => PokemonCard(
              pk: favorites[i].toPokemonTile(),
            ),
          );
        },
      ),
    );
  }
}
