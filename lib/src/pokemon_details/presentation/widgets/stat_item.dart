import 'package:flutter/material.dart';
import 'package:pokedex/src/pokemon_details/presentation/widgets/progress_bar.dart';

final Map<String, String> statLabels = {
  'hp': 'Hp',
  'attack': 'Attack',
  'defense': 'Defense',
  'special-attack': 'Sp. Atk',
  'special-defense': 'Sp. Def',
  'speed': 'Speed',
};

class StatItem extends StatelessWidget {
  final Animation<double> animation;
  final String label;
  final int value;
  final double? progress;
  final Color color;

  const StatItem({
    super.key,
    required this.animation,
    required this.label,
    required this.value,
    required this.color,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              statLabels[label] ?? label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(
              value.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 5,
            child: AnimatedBuilder(
              animation: animation,
              builder: (context, _) {
                return ProgressBar(
                  progress: animation.value * (progress ?? value / 150),
                  color: color,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
