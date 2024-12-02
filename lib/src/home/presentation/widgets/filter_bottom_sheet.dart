import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokedex/src/home/data/repository/home_repository.dart';

class FilterBottomSheet extends StatefulWidget {
  final List<String>? selectedTypes;
  final int? selectedGeneration;
  final String? selectedAbility;

  const FilterBottomSheet({
    super.key,
    this.selectedTypes,
    this.selectedGeneration,
    this.selectedAbility,
  });

  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet>
    with SingleTickerProviderStateMixin {
  static const List<String> pokemonTypes = [
    'normal',
    'fire',
    'water',
    'electric',
    'grass',
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
    'fairy',
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
  String? selectedAbility;
  late TabController _tabController;
  List<String> abilities = [];
  bool isLoadingAbilities = true;

  @override
  void initState() {
    super.initState();
    selectedTypes = widget.selectedTypes ?? [];
    selectedGeneration = widget.selectedGeneration;
    selectedAbility = widget.selectedAbility;
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAbilities();
  }

  Future<void> _loadAbilities() async {
    final client = GraphQLProvider.of(context).value;
    try {
      final fetchedAbilities = await HomeRepository.getAbilities(client);
      setState(() {
        abilities = fetchedAbilities;
        isLoadingAbilities = false;
      });
    } catch (e) {
      // Handle error
      setState(() {
        isLoadingAbilities = false;
      });
    }
  }

  void _resetFilters() {
    setState(() {
      selectedTypes.clear();
      selectedGeneration = null;
      selectedAbility = null;
    });
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          const SizedBox(height: 8),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Types'),
              Tab(text: 'Abilities'),
              Tab(text: 'Generations'),
            ],
          ),
          SizedBox(
            height: 200,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTypesTab(),
                _buildAbilitiesTab(),
                _buildGenerationsTab(),
              ],
            ),
          ),
          _buildApplyButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final hasFilters = selectedTypes.isNotEmpty ||
        selectedGeneration != null ||
        (selectedAbility?.isNotEmpty ?? false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (hasFilters)
          IconButton(
            tooltip: 'Reset filters',
            onPressed: _resetFilters,
            icon: const Icon(Icons.restart_alt_rounded),
          ),
        const Spacer(),
        const Text(
          'Filter Pokémon',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(
            context,
            (selectedTypes, selectedGeneration, selectedAbility),
          ),
        ),
      ],
    );
  }

  Widget _buildTypesTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16),
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
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAbilitiesTab() {
    if (isLoadingAbilities) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16),
          DropdownButton<String>(
            value: selectedAbility,
            hint: const Text('Select an ability'),
            isExpanded: true,
            items: [
              const DropdownMenuItem(
                value: null,
                child: Text('All abilities'),
              ),
              ...abilities.map(
                (ability) => DropdownMenuItem(
                  value: ability,
                  child: Text(
                    ability
                        .replaceAll('-', ' ')
                        .split(' ')
                        .map(
                          (str) => '${str[0].toUpperCase()}${str.substring(1)}',
                        )
                        .join(' '),
                  ),
                ),
              ),
            ],
            onChanged: (value) => setState(() => selectedAbility = value),
          ),
        ],
      ),
    );
  }

  Widget _buildGenerationsTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16),
          DropdownButton<int>(
            value: selectedGeneration,
            hint: const Text('Select a generation'),
            isExpanded: true,
            items: [
              const DropdownMenuItem(
                value: null,
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
        ],
      ),
    );
  }

  Widget _buildApplyButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ElevatedButton(
        onPressed: () => Navigator.pop(
          context,
          (selectedTypes, selectedGeneration, selectedAbility),
        ),
        child: const Text('Apply Filters'),
      ),
    );
  }
}