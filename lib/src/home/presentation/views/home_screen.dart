import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokedex/src/home/data/models/pokemon_filter.dart';
import 'package:pokedex/src/home/data/models/pokemon_tile.dart';
import 'package:pokedex/src/home/data/repository/home_repository.dart';
import 'package:pokedex/src/home/presentation/widgets/filter_bottom_sheet.dart';
import 'package:pokedex/src/guess_pokemon/presentation/views/guess_pokemon_screen.dart';
import 'package:pokedex/src/home/presentation/widgets/pokemon_card.dart';
import 'package:pokedex/src/home/presentation/widgets/rounded_text_field.dart';

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
    if (!_thereIsMoreData || _isLoading) return;

    setState(() => _isLoading = true);

    final data =
        await HomeRepository.getPokemons(_client, _page, filter: _filter);
    if (data.isEmpty) {
      _thereIsMoreData = false;
    } else {
      setState(() {
        _page++;
        _pokemons.addAll(data);
      });
    }

    setState(() => _isLoading = false);
  }

  void _updateFilter({
    String? name,
    List<String>? types,
    int? generation,
  }) {
    setState(() {
      _filter = PokemonFilter(
        name: name ?? _filter?.name,
        types: types ?? _filter?.types,
        generation: generation ?? _filter?.generation,
      );
      _initialLoad();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex'),
        centerTitle: true,
        forceMaterialTransparency: true,
        actions: [
          IconButton(
            tooltip: 'Guess the Pokémon!',
            icon: const Icon(
              Icons.question_mark_rounded,
              color: Colors.redAccent,
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
                    hintText: 'Search by name',
                    prefixIcon: const Icon(Icons.search),
                    onChanged: (value) => _updateFilter(name: value),
                  ),
                ),
                IconButton(
                  tooltip: 'Filters',
                  icon: const Icon(Icons.filter_alt_rounded),
                  onPressed: () async {
                    final result =
                        await showModalBottomSheet<(List<String>, int?)>(
                      context: context,
                      builder: (_) => FilterBottomSheet(
                        selectedTypes: _filter?.types,
                        selectedGeneration: _filter?.generation,
                      ),
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                    );

                    if (result != null) {
                      final (types, generation) = result;
                      _updateFilter(
                        name: _searchController.text,
                        types: types.isEmpty ? null : types,
                        generation: generation,
                      );
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            Expanded(
              child: ListView.separated(
                controller: _controller,
                itemCount: _pokemons.length + (_isLoading ? 1 : 0),
                separatorBuilder: (_, __) => const SizedBox(height: 10.0),
                itemBuilder: _buildPokemonCard,
              ),
            ),
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
