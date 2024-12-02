enum PokemonSort {
  numberAsc,
  numberDesc,
  nameAsc,
  nameDesc,
  typeAsc,
  typeDesc;

  String get displayName {
    switch (this) {
      case PokemonSort.numberAsc:
        return 'Number (asc)';
      case PokemonSort.nameAsc:
        return 'Name (asc)';
      case PokemonSort.typeAsc:
        return 'Type (asc)';
      case PokemonSort.numberDesc:
        return 'Number (desc)';
      case PokemonSort.nameDesc:
        return 'Name (desc)';
      case PokemonSort.typeDesc:
        return 'Type (desc)';
    }
  }

  bool get isNumber =>
      this == PokemonSort.numberAsc || this == PokemonSort.numberDesc;
  bool get isName =>
      this == PokemonSort.nameAsc || this == PokemonSort.nameDesc;
  bool get isType =>
      this == PokemonSort.typeAsc || this == PokemonSort.typeDesc;

  String get order {
    switch (this) {
      case PokemonSort.numberAsc:
      case PokemonSort.nameAsc:
      case PokemonSort.typeAsc:
        return 'asc';
      case PokemonSort.numberDesc:
      case PokemonSort.nameDesc:
      case PokemonSort.typeDesc:
        return 'desc';
    }
  }
}
