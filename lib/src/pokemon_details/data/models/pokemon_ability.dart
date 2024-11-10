import 'package:pokedex/core/utils/utils.dart';

class PokemonAbility {
  final String name;
  final bool isHidden;

  PokemonAbility({
    required this.name,
    required this.isHidden,
  });

  factory PokemonAbility.fromJson(Map<String, dynamic> json) {
    return PokemonAbility(
      name: Utils.capitalize(json['pokemon_v2_ability']['name']),
      isHidden: json['is_hidden'],
    );
  }
}