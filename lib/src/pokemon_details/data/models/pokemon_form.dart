class PokemonForm {
  final int order;
  final String name;
  final String? spriteUrl;

  PokemonForm({
    required this.order,
    required this.name,
    this.spriteUrl,
  });

  factory PokemonForm.fromJson(Map<String, dynamic> json) {
    return PokemonForm(
      order: json['form_order'],
      name: json['name'],
      spriteUrl: json['pokemon_v2_pokemonformsprites']?[0]['sprites'],
    );
  }
}
