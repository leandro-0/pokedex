// weakness_item.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokedex/core/theme/app_theme.dart';

class WeaknessItem extends StatelessWidget {
  final String type;
  final double multiplier;

  const WeaknessItem({
    super.key,
    required this.type,
    required this.multiplier,
  });

  @override
  Widget build(BuildContext context) {
    final typeLower = type.toLowerCase();
    final iconPath = 'assets/icons/$typeLower.svg';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.typeColors[typeLower] ?? Colors.grey,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            iconPath,
            width: 20,
            height: 20,
            colorFilter: const ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '×${multiplier.toStringAsFixed(1)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
