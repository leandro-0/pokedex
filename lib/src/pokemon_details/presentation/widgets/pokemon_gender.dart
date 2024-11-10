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
    return Container(
      margin: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Gender: ',
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 10.0),
          _GenderItem(
            percentage: malePercentage,
            iconColor: Colors.blue,
            iconData: FontAwesomeIcons.mars,
          ),
          const SizedBox(width: 12.0),
          _GenderItem(
            percentage: femalePercentage,
            iconColor: Colors.pink,
            iconData: FontAwesomeIcons.venus,
          ),
        ],
      ),
    );
  }
}

class _GenderItem extends StatelessWidget {
  const _GenderItem({
    required this.percentage,
    required this.iconData,
    required this.iconColor,
  });

  final IconData iconData;
  final double percentage;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(iconData, color: iconColor, size: 16.0),
        const SizedBox(width: 4.0),
        Text(
          '${percentage.toStringAsFixed(1)}%',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }
}
