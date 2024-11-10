class PokemonStats {
  final int hp;
  final int attack;
  final int defense;
  final int specialAttack;
  final int specialDefense;
  final int speed;

  PokemonStats({
    required this.hp,
    required this.attack,
    required this.defense,
    required this.specialAttack,
    required this.specialDefense,
    required this.speed,
  });

  int get total =>
      hp + attack + defense + specialAttack + specialDefense + speed;

  factory PokemonStats.fromJson(Map<String, dynamic> json) => PokemonStats(
        hp: json['stats'][0]['base_stat'],
        attack: json['stats'][1]['base_stat'],
        defense: json['stats'][2]['base_stat'],
        specialAttack: json['stats'][3]['base_stat'],
        specialDefense: json['stats'][4]['base_stat'],
        speed: json['stats'][5]['base_stat'],
      );
}
