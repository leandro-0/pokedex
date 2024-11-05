import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PokemonGender extends StatelessWidget {
  final double malePercentage;
  final double femalePercentage;

  const PokemonGender({
    super.key,
    required this.malePercentage,
    required this.femalePercentage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Gender: ',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
        const SizedBox(width: 10),
        Row(
          children: [
            const Icon(FontAwesomeIcons.mars, color: Colors.blue, size: 16),
            const SizedBox(width: 4),
            Text(
              '${malePercentage.toStringAsFixed(1)}%',
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(width: 12),
        Row(
          children: [
            const Icon(FontAwesomeIcons.venus, color: Colors.pink, size: 16),
            const SizedBox(width: 4),
            Text(
              '${femalePercentage.toStringAsFixed(1)}%',
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }
}