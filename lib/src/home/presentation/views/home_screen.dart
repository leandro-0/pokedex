import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokedex/src/home/data/models/pokemon_tile.dart';
import 'package:pokedex/src/home/data/repository/home_repository.dart';
import 'package:pokedex/src/home/presentation/widgets/pokemon_card.dart';

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

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _client = GraphQLProvider.of(context).value;
      _initialLoad();
      _controller.addListener(_scrollListener);
    });
  }

  /// Listener to load more pokemons when the user reaches the end of the list
  void _scrollListener() {
    if (_isLoading ||
        _controller.position.pixels != _controller.position.maxScrollExtent) {
      return;
    }

    _loadPokemonList();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Load the first page of pokemons
  Future<void> _initialLoad() async {
    _page = 0;
    _thereIsMoreData = true;
    _pokemons.clear();
    await _loadPokemonList();
  }

  /// Load the next page of pokemons
  Future<void> _loadPokemonList() async {
    if (!_thereIsMoreData || _isLoading) return;

    setState(() => _isLoading = true);

    final data = await HomeRepository.getPokemons(_client, _page);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.question_mark_rounded,
              color: Colors.redAccent,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.separated(
        controller: _controller,
        padding: const EdgeInsets.all(10.0),
        itemCount: _pokemons.length + (_isLoading ? 1 : 0),
        separatorBuilder: (_, __) => const SizedBox(height: 10.0),
        itemBuilder: (_, index) {
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
        },
      ),
    );
  }
}
