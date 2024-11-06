import 'package:pokedex/src/home/data/models/pokemon_node.dart';

class EvolutionEdge {
  final PokemonNode from;
  final PokemonNode to;

  EvolutionEdge({required this.from, required this.to});
}
