import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
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
  late final Future<List<FavoritePokemon>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _favoritesFuture = FavoritePokemonRepository.getAllFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        centerTitle: true,
        forceMaterialTransparency: true,
      ),
      body: FutureBuilder(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('An unexpected error occurred'));
          }
          final favorites = snapshot.data as List<FavoritePokemon>;
          if (favorites.isEmpty) {
            return ElasticIn(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.sentiment_very_dissatisfied_rounded,
                    size: size.width * 0.15,
                    color: Colors.grey,
                  ),
                  const EmptyIndicator(
                    text: 'No favorites yet, add some!',
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            itemCount: favorites.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10.0),
            itemBuilder: (_, i) => Dismissible(
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.red[300],
                ),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              key: Key(favorites[i].id.toString()),
              child: PokemonCard(
                pk: favorites[i].toPokemonTile(),
              ),
              onDismissed: (_) {
                FavoritePokemonRepository.removeFavorite(favorites[i].id);
                setState(() {
                  favorites.removeAt(i);
                });
              },
            ),
          );
        },
      ),
    );
  }
}
