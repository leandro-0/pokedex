import 'package:flutter/material.dart';
import 'package:pokedex/src/pokemon_details/presentation/widgets/stat_item.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokedex/src/pokemon_details/data/repository/details_repository.dart';
import 'package:pokedex/src/pokemon_details/presentation/widgets/weakness_item.dart';

class PokemonStats extends StatefulWidget {
  final int id;

  const PokemonStats({
    super.key,
    required this.id,
  });

  @override
  State<PokemonStats> createState() => _PokemonStatsState();
}

class _PokemonStatsState extends State<PokemonStats>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final List<String> orderedStatLabels = [
    'Hp',
    'Attack',
    'Defense',
    'Sp. Atk',
    'Sp. Def',
    'Speed'
  ];

  @override
  Widget build(BuildContext context) {
    final client = GraphQLProvider.of(context).value;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Base Stats',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: DetailsRepository.getPokemonStats(client, widget.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final stats = snapshot.data ?? [];
              final total = stats.fold<int>(
                  0, (sum, stat) => sum + (stat['base_stat'] as int));

              return Column(
                children: [
                  ...List.generate(
                    stats.length,
                    (index) => StatItem(
                      animation: _animation,
                      label: orderedStatLabels[index],
                      value: stats[index]['base_stat'] as int,
                      color: _getStatColor(stats[index]['base_stat'] as int,
                          orderedStatLabels[index]),
                    ),
                  ),
                  StatItem(
                    animation: _animation,
                    label: 'Total',
                    value: total,
                    color: _getStatColor(total ~/ stats.length),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 32),
          const Text(
            'Type Defenses',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'The effectiveness of each type on this Pokémon.',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: DetailsRepository.getPokemonWeaknesses(client, widget.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final weaknesses = snapshot.data ?? [];

              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: weaknesses.map((weakness) {
                  return WeaknessItem(
                    type: weakness['type'] as String,
                    multiplier: weakness['multiplier'] as double,
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Color _getStatColor(int value, [String? statLabel]) {
    if (statLabel == null) {
      if (value < 50) return Colors.red;
      if (value < 70) return Colors.orange;
      return Colors.teal;
    }

    switch (statLabel) {
      case 'Hp':
        return const Color(0xFFFF0000);
      case 'Attack':
        return const Color(0xFFF08030);
      case 'Defense':
        return const Color(0xFFF8D030);
      case 'Sp. Atk':
        return const Color(0xFF6890F0);
      case 'Sp. Def':
        return const Color(0xFF78C850);
      case 'Speed':
        return const Color(0xFFF85888);
      default:
        return Colors.grey;
    }
  }
}
