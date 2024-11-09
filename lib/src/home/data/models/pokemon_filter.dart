class PokemonFilter {
  final String? name;
  final List<String>? types;
  final int? generation;

  const PokemonFilter({
    this.name,
    this.types,
    this.generation,
  });

  Map<String, dynamic> toQueryVariables() {
    final where = <String, dynamic>{
      'id': {'_lte': 1025}
    };

    if (name != null && name!.isNotEmpty) {
      where['name'] = {'_ilike': '%$name%'};
    }

    if (types != null && types!.isNotEmpty) {
      where['pokemon_v2_pokemontypes'] = {
        'pokemon_v2_type': {
          'name': {'_in': types}
        }
      };
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
      where['id'] = ranges[generation];
    }

    return where;
  }
}
