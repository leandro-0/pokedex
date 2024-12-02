import 'package:flutter/material.dart';
import '../../domains/enums/pokemon_sort.dart';

class SortMenuButton extends StatelessWidget {
  final PokemonSort currentSort;
  final Function(PokemonSort) onSortSelected;

  const SortMenuButton({
    super.key,
    required this.currentSort,
    required this.onSortSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopupMenuButton<PokemonSort>(
      tooltip: 'Sort Pokémon',
      position: PopupMenuPosition.under,
      icon: const Icon(Icons.sort_rounded),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      offset: const Offset(0, 8),
      onSelected: onSortSelected,
      itemBuilder: (context) {
        return PokemonSort.values.map((PokemonSort sort) {
          final isSelected = currentSort == sort;
          return PopupMenuItem<PokemonSort>(
            value: sort,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 12.0,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primaryContainer.withOpacity(0.2)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    size: 20,
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      sort.displayName,
                      style: TextStyle(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList();
      },
    );
  }
}
