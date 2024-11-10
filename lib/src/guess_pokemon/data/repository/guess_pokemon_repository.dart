import 'dart:math';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokedex/src/home/data/models/pokemon_tile.dart';
import 'package:pokedex/src/pokemon_details/data/repository/details_repository.dart';

class GuessPokemonRepository {
  static Future<PokemonTile> getRandomPokemon(GraphQLClient client) {
    int id = Random().nextInt(1025) + 1;
    return DetailsRepository.getPokemonInfo(client, id);
  }
}
