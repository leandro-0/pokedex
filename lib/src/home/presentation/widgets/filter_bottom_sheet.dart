import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokedex/src/pokemon_details/presentation/widgets/about_heading.dart';

class FilterBottomSheet extends StatefulWidget {
  final List<String>? selectedTypes;
  final int? selectedGeneration;

  const FilterBottomSheet({
    super.key,
    this.selectedTypes,
    this.selectedGeneration,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  static const List<String> pokemonTypes = [
    'normal',
    'fire',
    'water',
    'grass',
    'electric',
    'ice',
    'fighting',
    'poison',
    'ground',
    'flying',
    'psychic',
    'bug',
    'rock',
    'ghost',
    'dark',
    'dragon',
    'steel',
    'fairy'
  ];

  static const Map<int, String> generations = {
    1: 'Gen 1 (1-151)',
    2: 'Gen 2 (152-251)',
    3: 'Gen 3 (252-386)',
    4: 'Gen 4 (387-493)',
    5: 'Gen 5 (494-649)',
    6: 'Gen 6 (650-721)',
    7: 'Gen 7 (722-809)',
    8: 'Gen 8 (810-905)',
    9: 'Gen 9 (906-1025)',
  };

  static const Map<String, Color> typeColors = {
    'normal': Color(0xFFA8A77A),
    'fire': Color(0xFFEE8130),
    'water': Color(0xFF6390F0),
    'electric': Color(0xFFF7D02C),
    'grass': Color(0xFF7AC74C),
    'ice': Color(0xFF96D9D6),
    'fighting': Color(0xFFC22E28),
    'poison': Color(0xFFA33EA1),
    'ground': Color(0xFFE2BF65),
    'flying': Color(0xFFA98FF3),
    'psychic': Color(0xFFF95587),
    'bug': Color(0xFFA6B91A),
    'rock': Color(0xFFB6A136),
    'ghost': Color(0xFF735797),
    'dragon': Color(0xFF6F35FC),
    'dark': Color(0xFF705746),
    'steel': Color(0xFFB7B7CE),
    'fairy': Color(0xFFD685AD),
  };

  List<String> selectedTypes = [];
  int? selectedGeneration;

  @override
  void initState() {
    super.initState();
    selectedTypes = widget.selectedTypes ?? [];
    selectedGeneration = widget.selectedGeneration;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        16 + MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        color: Colors.white,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Visibility(
                  visible: selectedTypes.isNotEmpty ||
                      (selectedGeneration ?? -1) > 0,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: IconButton(
                    tooltip: 'Reset filters',
                    onPressed: () {
                      setState(() {
                        selectedTypes.clear();
                        selectedGeneration = -1;
                      });
                    },
                    icon: const Icon(Icons.restart_alt_rounded),
                  ),
                ),
                const Spacer(),
                const Center(
                  child: Text(
                    'Filter Pokémon',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: AboutHeading(text: 'Types'),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: pokemonTypes.map((type) {
                final isSelected = selectedTypes.contains(type);
                final typeColor = typeColors[type] ?? Colors.grey;
                return FilterChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/$type.svg',
                        width: 20,
                        height: 20,
                        colorFilter: ColorFilter.mode(
                          isSelected ? Colors.white : Colors.black,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        type,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  selected: isSelected,
                  selectedColor: typeColor,
                  checkmarkColor: Colors.white,
                  showCheckmark: false,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedTypes.add(type);
                      } else {
                        selectedTypes.remove(type);
                      }
                    });
                  },
                  backgroundColor: Colors.grey[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: AboutHeading(text: 'Generation'),
            ),
            const SizedBox(height: 8),
            DropdownButton<int>(
              value: selectedGeneration,
              hint: const Text('All generations'),
              isExpanded: true,
              items: [
                const DropdownMenuItem(
                  value: -1,
                  child: Text('All generations'),
                ),
                ...generations.entries.map(
                  (e) => DropdownMenuItem(
                    value: e.key,
                    child: Text(e.value),
                  ),
                ),
              ],
              onChanged: (value) => setState(() => selectedGeneration = value),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.redAccent),
                ),
                onPressed: () => Navigator.pop(
                  context,
                  (selectedTypes, selectedGeneration),
                ),
                child: const Text('Apply Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
