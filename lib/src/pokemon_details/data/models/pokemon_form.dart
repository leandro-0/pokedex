class PokemonForm {
  final int order;
  final String name;
  final String? alternativeName;
  final String? spriteUrl;
  final bool isMega;
  final bool isGmax;

  PokemonForm({
    required this.order,
    required this.name,
    required this.isMega,
    required this.isGmax,
    this.alternativeName,
    this.spriteUrl,
  });

  factory PokemonForm.fromJson(Map<String, dynamic> json) {
    return PokemonForm(
      order: json['form_order'],
      name: json['name'],
      spriteUrl: json['pokemon_v2_pokemonformsprites']?[0]['sprites'],
      alternativeName: json['pokemon_v2_pokemonformnames'] != null &&
              (json['pokemon_v2_pokemonformnames'] as List).isNotEmpty
          ? json['pokemon_v2_pokemonformnames'][0]['name']
          : null,
      isMega: json['is_mega'],
      isGmax: (json['name'] as String).contains('gmax'),
    );
  }
}
