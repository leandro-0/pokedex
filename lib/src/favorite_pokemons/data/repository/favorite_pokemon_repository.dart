import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pokedex/objectbox.g.dart';
import 'package:pokedex/src/favorite_pokemons/data/models/favorite_pokemon.dart';
import 'package:pokedex/src/home/data/models/pokemon_tile.dart';

class FavoritePokemonRepository {
  static const String storeName = 'favorite_pokemon';

  static Future<Store> _getStore() async {
    final dir = await getApplicationDocumentsDirectory();
    return openStore(directory: '${dir.path}/$storeName');
  }

  static Future<int?> addFavorite(PokemonTile pokemonData) async {
    final store = await _getStore();
    final favBox = store.box<FavoritePokemon>();

    try {
      final imageResponse = await http.get(Uri.parse(pokemonData.spriteUrl));
      final imageBytes = imageResponse.bodyBytes;
      final favoritePokemon = FavoritePokemon.fromPokemonTile(
        pokemonData,
        imageBytes,
      );

      favBox.put(favoritePokemon);
      return favoritePokemon.id;
    } catch (e) {
      print(e);
      return null;
    } finally {
      store.close();
    }
  }

  static Future<void> removeFavorite(int id) async {
    final store = await _getStore();
    final favBox = store.box<FavoritePokemon>();

    try {
      favBox.remove(id);
    } finally {
      store.close();
    }
  }

  static Future<List<FavoritePokemon>> getAllFavorites() async {
    final store = await _getStore();
    try {
      final favorites = store.box<FavoritePokemon>().getAll();
      return favorites;
    } finally {
      store.close();
    }
  }

  /// Returns the id of the favorite pokemon if it exists, otherwise returns null.
  static Future<int?> isFavorite(int pokedexId) async {
    final store = await _getStore();
    try {
      final pokemonBox = store.box<FavoritePokemon>();
      final query = pokemonBox
          .query(FavoritePokemon_.pokedexId.equals(pokedexId))
          .build();

      return query.findFirst()?.id;
    } finally {
      store.close();
    }
  }
}
