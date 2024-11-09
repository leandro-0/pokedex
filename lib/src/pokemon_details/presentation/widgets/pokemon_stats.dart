import 'package:flutter/material.dart';
import 'package:pokedex/src/pokemon_details/presentation/widgets/stat_item.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokedex/src/pokemon_details/data/repository/details_repository.dart';

// pokemon_stats.dart
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

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DetailsRepository.getPokemonStats(client, widget.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final stats = snapshot.data!;
        final total =
            stats.fold<int>(0, (sum, stat) => sum + (stat['base_stat'] as int));
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Base Stats',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...List.generate(stats.length, (index) => 
                  StatItem(
                  animation: _animation,
                  label: orderedStatLabels[index],
                  value: stats[index]['base_stat'] as int,
                  color: _getStatColor(stats[index]['base_stat'] as int),
                ),
              ),
              StatItem(
                animation: _animation,
                label: 'Total',
                value: total,
                color: _getStatColor(total ~/ stats.length),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getStatColor(int value) {
    if (value < 50) return Colors.red;
    if (value < 70) return Colors.orange;
    return Colors.teal;
  }

}
