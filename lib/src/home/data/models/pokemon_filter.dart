class PokemonFilter {
  final String? name;
  final List<String>? types;
  final int? generation;
  final int? number;
  final String? ability;

  const PokemonFilter({
    this.name,
    this.types,
    this.generation,
    this.number,
    this.ability,
  });

  Map<String, dynamic> toQueryVariables() {
    final List<Map<String, dynamic>> andConditions = [
      {
        'id': {'_lte': 1025}
      },
    ];

    if (number != null) {
      andConditions.add({
        'id': {'_eq': number}
      });
    } else if (name != null && name!.isNotEmpty) {
      andConditions.add({
        'name': {'_ilike': '$name%'}
      });
    }

    if (generation != null) {
      final ranges = {
        1: {'_gte': 1, '_lte': 151},
        2: {'_gte': 152, '_lte': 251},
        3: {'_gte': 252, '_lte': 386},
        4: {'_gte': 387, '_lte': 493},
        5: {'_gte': 494, '_lte': 649},
        6: {'_gte': 650, '_lte': 721},
        7: {'_gte': 722, '_lte': 809},
        8: {'_gte': 810, '_lte': 905},
        9: {'_gte': 906, '_lte': 1025},
      };
      andConditions.add({'id': ranges[generation]!});
    }

    if (ability != null && ability!.isNotEmpty) {
      andConditions.add({
        'pokemon_v2_pokemonabilities': {
          'pokemon_v2_ability': {
            'name': {'_ilike': '$ability'}
          }
        }
      });
    }

    if (types != null && types!.isNotEmpty) {
      andConditions.add({
        'pokemon_v2_pokemontypes': {
          'pokemon_v2_type': {
            'name': {'_in': types}
          }
        }
      });
    }

    return {'_and': andConditions};
  }
}
