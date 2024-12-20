class PokemonMove {
  final String name;
  final int? power;
  final int? accuracy;
  final String type;
  final String category;
  final String moveType;
  final int? level;

  PokemonMove({
    required this.name,
    this.power,
    this.accuracy,
    required this.type,
    required this.category,
    required this.moveType,
    this.level,
  });

  factory PokemonMove.fromJson(Map<String, dynamic> json) {
    final move = json['pokemon_v2_move'];
    final learnMethod = json['pokemon_v2_movelearnmethod']['name'];
    
    String getMoveType(String learnMethod) {
      switch (learnMethod) {
        case 'level-up':
          return 'level-up';
        case 'machine':
          return 'machine';
        case 'egg':
          return 'egg';
        default:
          return 'other';
      }
    }

    return PokemonMove(
      name: move['pokemon_v2_movenames'][0]['name'],
      power: move['power'],
      accuracy: move['accuracy'],
      type: move['pokemon_v2_type']['name'],
      category: move['pokemon_v2_movedamageclass']['name'],
      moveType: getMoveType(learnMethod),
      level: json['level'],
    );
  }
}