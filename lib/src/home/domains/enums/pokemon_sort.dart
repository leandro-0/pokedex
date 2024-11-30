enum PokemonSort {
  number,
  name,
  abilities,
  type;

  String get displayName {
    switch (this) {
      case PokemonSort.number:
        return 'Número';
      case PokemonSort.name:
        return 'Nombre';
      case PokemonSort.abilities:
        return 'Habilidades';
      case PokemonSort.type:
        return 'Tipo';
    }
  }

  String get orderBy {
    switch (this) {
      case PokemonSort.number:
        return 'number';
      case PokemonSort.name:
        return 'name';
      case PokemonSort.abilities:
        return 'abilities';
      case PokemonSort.type:
        return 'type';
    }
  }
}