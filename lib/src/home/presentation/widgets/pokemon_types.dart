import 'package:flutter/material.dart';
import 'package:pokedex/src/home/presentation/widgets/type_chip.dart';

class PokemonTypes extends StatelessWidget {
  final List<String> types;
  final Axis direction;
  const PokemonTypes({
    super.key,
    required this.types,
    this.direction = Axis.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    return Flex(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      direction: direction,
      children: types
          .map((type) => TypeChip(type: type, direction: direction))
          .toList(),
    );
  }
}
