import 'dart:async';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokedex/src/favorite_pokemons/presentation/views/favorite_pokemons_screen.dart';
import 'package:pokedex/src/home/data/models/pokemon_filter.dart';
import 'package:pokedex/src/home/data/models/pokemon_tile.dart';
import 'package:pokedex/src/home/data/repository/home_repository.dart';
import 'package:pokedex/src/home/domains/enums/pokemon_sort.dart';
import 'package:pokedex/src/home/presentation/widgets/filter_bottom_sheet.dart';
import 'package:pokedex/src/guess_pokemon/presentation/views/guess_pokemon_screen.dart';
import 'package:pokedex/src/home/presentation/widgets/pokemon_card.dart';
import 'package:pokedex/src/home/presentation/widgets/rounded_text_field.dart';
import 'package:pokedex/src/pokemon_details/presentation/widgets/empty_indicator.dart';
import 'package:pokedex/src/home/presentation/widgets/sort_menu_button.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 0;
  bool _thereIsMoreData = true, _isLoading = false;
  final List<PokemonTile> _pokemons = [];
  late final GraphQLClient _client;
  final ScrollController _controller = ScrollController();
  PokemonFilter? _filter;
  final TextEditingController _searchController = TextEditingController();
  PokemonSort _currentSort = PokemonSort.numberAsc;
  final TextEditingController _numberController = TextEditingController();
  Timer? _timer;
  String? _previousKeyword;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _client = GraphQLProvider.of(context).value;
      _initialLoad();
      _controller.addListener(_scrollListener);
    });
  }

  void _scrollListener() {
    if (_isLoading ||
        _controller.position.pixels != _controller.position.maxScrollExtent) {
      return;
    }

    _loadPokemonList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _numberController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _initialLoad() async {
    _page = 0;
    _thereIsMoreData = true;
    _pokemons.clear();
    await _loadPokemonList();
  }

  Future<void> _loadPokemonList() async {
    if (!_thereIsMoreData || _isLoading || !mounted) return;

    setState(() => _isLoading = true);

    final data = await HomeRepository.getPokemons(
      _client,
      _page,
      filter: _filter,
      orderBy: _currentSort,
    );
    if (data.isEmpty) {
      _thereIsMoreData = false;
    } else {
      setState(() {
        _page++;
        _pokemons.addAll(data);
      });
    }

    setState(() {
      _isLoading = false;
      _previousKeyword = _searchController.text;
    });
  }

  void _updateFilter(String input) {
    _timer?.cancel();

    final trimmedInput = input.trim();
    final number = int.tryParse(trimmedInput);
    final keyword = number != null ? number.toString() : trimmedInput;

    if (keyword.isNotEmpty && keyword != _previousKeyword || input.isEmpty) {
      setState(() {
        _previousKeyword = keyword;
        _timer = Timer.periodic(const Duration(milliseconds: 300), (tmr) {
          _filter = PokemonFilter(
            name:
                number == null && trimmedInput.isNotEmpty ? trimmedInput : null,
            number: number,
            types: _filter?.types,
            generation: _filter?.generation,
            ability: _filter?.ability,
          );

          _initialLoad();

          tmr.cancel();
        });
      });
    }
  }

  void _onSortSelected(PokemonSort sort) {
    setState(() {
      _currentSort = sort;
      _initialLoad();
    });
  }

  Future<void> _showFilterBottomSheet() async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows custom height control
      builder: (_) => FilterBottomSheet(
        selectedTypes: _filter?.types,
        selectedGeneration: _filter?.generation,
        selectedAbility: _filter?.ability,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
    if (result != null) {
      final (types, generation, ability) = result;
      setState(() {
        _filter = PokemonFilter(
          name: _searchController.text,
          types: types.isEmpty ? null : types,
          generation: generation,
          ability: ability,
          number: _filter?.number,
        );
        _initialLoad();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex'),
        centerTitle: true,
        forceMaterialTransparency: true,
        leading: IconButton(
          tooltip: 'Favorite Pokémon',
          icon: Icon(
            Icons.favorite_border_rounded,
            color: Colors.red[300],
          ),
          onPressed: () => Navigator.pushNamed(
            context,
            FavoritePokemonsScreen.routeName,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Guess the Pokémon!',
            icon: Icon(
              Icons.question_mark_rounded,
              color: Colors.red[300],
            ),
            onPressed: () => Navigator.pushNamed(
              context,
              GuessPokemonScreen.routeName,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 10.0,
          left: 10.0,
          right: 10.0,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: RoundedTextField(
                    controller: _searchController,
                    hintText: 'Search by name or number',
                    prefixIcon: const Icon(Icons.search),
                    onChanged: _updateFilter,
                  ),
                ),
                IconButton(
                  tooltip: 'Filters',
                  icon: const Icon(Icons.filter_alt_rounded),
                  onPressed: _showFilterBottomSheet,
                ),
                SortMenuButton(
                  currentSort: _currentSort,
                  onSortSelected: _onSortSelected,
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            if (_pokemons.isNotEmpty)
              Expanded(
                child: ListView.separated(
                  controller: _controller,
                  itemCount: _pokemons.length + (_isLoading ? 1 : 0),
                  separatorBuilder: (_, __) => const SizedBox(height: 10.0),
                  itemBuilder: _buildPokemonCard,
                ),
              ),
            if (_pokemons.isEmpty && !_isLoading)
              const Center(child: EmptyIndicator(text: 'No Pokémon found')),
          ],
        ),
      ),
    );
  }

  Widget? _buildPokemonCard(_, index) {
    if (index == _pokemons.length) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 35.0),
        child: const Center(
            child: CircularProgressIndicator(
          color: Colors.redAccent,
        )),
      );
    } else {
      return PokemonCard(pk: _pokemons[index]);
    }
  }
}
