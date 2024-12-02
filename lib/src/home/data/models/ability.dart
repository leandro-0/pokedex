class Ability {
  final String displayName;
  final String apiName;
  final String generation;

  Ability({
    required this.displayName,
    required this.generation,
    required this.apiName,
  });

  factory Ability.fromJson(Map<String, dynamic> json) {
    return Ability(
      apiName: json['pokemon_v2_abilitynames'][0]['pokemon_v2_ability']['name'],
      displayName: json['pokemon_v2_abilitynames'][0]['name'],
      generation: json['pokemon_v2_abilitynames'][0]['pokemon_v2_ability']
              ['pokemon_v2_generation']['name']
          .toString()
          .split('-')[1]
          .toUpperCase(),
    );
  }

  @override
  String toString() => displayName;
}
