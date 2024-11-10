import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokedex/core/theme/app_theme.dart';

class TypeChip extends StatelessWidget {
  final String type;

  const TypeChip({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6.0,
        vertical: 3.0,
      ),
      margin: const EdgeInsets.only(right: 7.0),
      decoration: BoxDecoration(
        color: AppTheme.typeChipColors[type],
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/$type.svg',
            width: 15.0,
            height: 15.0,
          ),
          const SizedBox(width: 5.0),
          Text(
            type,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }
}
