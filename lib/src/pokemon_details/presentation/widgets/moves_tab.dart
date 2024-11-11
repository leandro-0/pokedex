import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokedex/src/pokemon_details/data/models/pokemon_move';
import 'package:pokedex/src/pokemon_details/data/repository/details_repository.dart';
import 'package:pokedex/core/theme/app_theme.dart';
import 'package:pokedex/src/pokemon_details/presentation/widgets/empty_indicator.dart';

class MovesTab extends StatefulWidget {
  final int id;

  const MovesTab({super.key, required this.id});

  @override
  State<MovesTab> createState() => _MovesTabState();
}

class _MovesTabState extends State<MovesTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<PokemonMove>? _moves;
  bool _isLoading = true;
  late GraphQLClient _client;

  static const Map<String, IconData> categoryIcons = {
    'physical': Icons.fitness_center,
    'special': Icons.auto_awesome,
    'status': Icons.change_circle_outlined,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _client = GraphQLProvider.of(context).value;
    _loadMoves();
  }

  Future<void> _loadMoves() async {
    setState(() => _isLoading = true);
    _moves = await DetailsRepository.getPokemonMoves(_client, widget.id);
    setState(() => _isLoading = false);
  }

  List<PokemonMove> _filterMoves(String moveType) {
    return _moves?.where((move) => move.moveType == moveType).toList() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(25),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.white,
            ),
            dividerColor: Colors.transparent,
            tabs: const [
              Tab(text: 'Level'),
              Tab(text: 'TM'),
              Tab(text: 'Breed'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _MovesList(moves: _filterMoves('level-up')),
              _MovesList(moves: _filterMoves('machine')),
              _MovesList(moves: _filterMoves('egg')),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class _MovesList extends StatelessWidget {
  final List<PokemonMove> moves;

  const _MovesList({required this.moves});

  @override
  Widget build(BuildContext context) {
    if (moves.isEmpty) {
      return const EmptyIndicator(text: 'No moves available');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: moves.length,
      itemBuilder: (context, index) {
        final move = moves[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                if (move.moveType == 'egg')
                  Container(
                    width: 32,
                    height: 32,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: Colors.pink[100],
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.egg_outlined,
                        color: Colors.pink,
                        size: 20,
                      ),
                    ),
                  )
                else if (move.moveType == 'machine')
                  Container(
                    width: 32,
                    height: 32,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.engineering,
                        color: Colors.blue,
                        size: 20,
                      ),
                    ),
                  )
                else if (move.level != null)
                  Container(
                    width: 32,
                    height: 32,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${move.level}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        move.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          _MoveInfo(
                            label: 'Power',
                            value: move.power?.toString() ?? '-',
                          ),
                          const SizedBox(width: 16),
                          _MoveInfo(
                            label: 'Accuracy',
                            value: move.accuracy?.toString() ?? '-',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.typeColors[move.type.toLowerCase()] ??
                            Colors.grey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/${move.type}.svg',
                            width: 16,
                            height: 16,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            move.type,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Icon(
                      _MovesTabState.categoryIcons[move.category.toLowerCase()],
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MoveInfo extends StatelessWidget {
  final String label;
  final String value;

  const _MoveInfo({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
