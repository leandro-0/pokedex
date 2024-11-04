import 'package:flutter/material.dart';
import '../repository/details_repository.dart';
import 'weight_height_detail.dart'; // Asegúrate de importar el nuevo widget
import 'pokemon_gender.dart'; // Asegúrate de importar el nuevo widget

class PokemonAbout extends StatefulWidget {
  final int pokemonId;

  const PokemonAbout({
    super.key,
    required this.pokemonId,
  });

  @override
  State<PokemonAbout> createState() => _PokemonAboutState();
}

class _PokemonAboutState extends State<PokemonAbout> {
  final _pokemonService = PokemonDetails();
  Map<String, dynamic>? _pokemonData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPokemonData();
  }

  Future<void> _loadPokemonData() async {
    try {
      setState(() => _isLoading = true);
      final data = await _pokemonService.getPokemonDescription(widget.pokemonId);
      setState(() {
        _pokemonData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _pokemonData = null;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_pokemonData == null) {
      return const Center(child: Text('No se pudieron cargar los datos'));
    }

    final heightInMeters = _pokemonData!['height'] / 10;
    final weightInKilograms = _pokemonData!['weight'] / 10;
    final types = _pokemonData!['types'];
    final description = _pokemonData!['description'].replaceAll('\n', ' ').replaceAll('\f', ' ');

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        const SizedBox(height: 16),
        Text(
          description,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
        Row(
          children: types
              .map<Widget>(
                (type) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5.0,
                    vertical: 2.0,
                  ),
                  margin: const EdgeInsets.only(right: 5.0),
                  decoration: BoxDecoration( 
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    type,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12.0,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
          const SizedBox(height: 16),
          if (_pokemonData!['isLegendary'] || _pokemonData!['isMythical'])
            Text(
              _pokemonData!['isLegendary'] ? '⭐ Pokémon Legendario' : '✨ Pokémon Mítico',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
          DetailCard(
            title1: 'Height',
            value1: '${heightInMeters.toStringAsFixed(1)} m',
            title2: 'Weight',
            value2: '${weightInKilograms.toStringAsFixed(1)} kg',
          ),
          const SizedBox(height: 16),
          Text(
            'Breeding',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          PokemonGender(
            malePercentage: _pokemonData!['malePercentage'],
            femalePercentage: _pokemonData!['femalePercentage'],
          ),
          const SizedBox(height: 16),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: 'Egg Groups: ',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                TextSpan(
                  text: '${(_pokemonData!['eggGroups'] as List).map((e) => e.toString().split(' ').map((str) => str[0].toUpperCase() + str.substring(1)).join(' ')).join(', ')}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: 'Egg Cycle: ',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                TextSpan(
                  text: '${_pokemonData!['hatchCounter']}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}