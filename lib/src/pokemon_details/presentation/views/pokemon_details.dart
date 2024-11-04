import 'package:flutter/material.dart';
import 'package:pokedex/src/home/data/models/pokemon_tile.dart';
import 'package:pokedex/core/theme/app_theme.dart';
import 'package:pokedex/src/pokemon_details/presentation/models/pokemon_stats';
import 'package:pokedex/src/pokemon_details/presentation/widgets/pokemon_about.dart';

class PokemonDetails extends StatefulWidget {
  static const String routeName = '/details';

  const PokemonDetails({super.key});

  @override
  State<PokemonDetails> createState() => _PokemonDetailsState();
}

class _PokemonDetailsState extends State<PokemonDetails>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Color backgroundColor = Colors.green.shade300;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final pkBasicInfo =
          ModalRoute.of(context)!.settings.arguments as PokemonTile;
      setState(() {
        backgroundColor = AppTheme.typeColors[pkBasicInfo.types.first] ??
            Colors.green.shade300;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    final pkBasicInfo =
        ModalRoute.of(context)!.settings.arguments as PokemonTile;
    final pkStatInfo = ModalRoute.of(context)!.settings.arguments as PokemonStats;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Positioned(
            top: 40,
            right: 10,
            child: IconButton(
              icon: Icon(Icons.favorite_border, color: Colors.white),
              onPressed: () {},
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 80),
              Hero(
                tag: 'card-${pkBasicInfo.id}',
                child: Image.network(
                  pkBasicInfo.spriteUrl,
                  height: 180,
                ),
              ),
              SizedBox(height: 10),
              Text(
                capitalize(pkBasicInfo.name),
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
              Text(
                '#${pkBasicInfo.id.toString().padLeft(4, '0')}',
                style: TextStyle(
                    fontSize: 16, color: Colors.black.withOpacity(0.4)),
              ),
              SizedBox(height: 10),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      TabBar(
                        controller: _tabController,
                        tabs: [
                          Tab(text: 'About'),
                          Tab(text: 'Stats'),
                          Tab(text: 'Evolution'),
                          Tab(text: 'Moves'),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            PokemonAbout(pokemonId: pkBasicInfo.id),
                            Center(child: Text('Stats')),
                            Center(child: Text('Evolution')),
                            Center(child: Text('Moves')),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildEvolutionTab() {
    return Center(child: Text('Evolution'));
  }

  Widget _buildMovesTab() {
    return Center(child: Text('Moves'));
  }
}
