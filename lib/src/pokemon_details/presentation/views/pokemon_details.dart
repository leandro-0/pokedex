import 'package:flutter/material.dart';
import 'package:pokedex/core/utils/utils.dart';
import 'package:pokedex/src/home/data/models/pokemon_tile.dart';
import 'package:pokedex/core/theme/app_theme.dart';
import 'package:pokedex/src/pokemon_details/presentation/widgets/evolution_chain.dart';
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
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pkBasicInfo =
        ModalRoute.of(context)!.settings.arguments as PokemonTile;
    final backgroundColor =
        AppTheme.typeColors[pkBasicInfo.types.first] ?? Colors.grey;
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: 40.0,
            left: 10.0,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Positioned(
            top: 40.0,
            right: 10.0,
            child: IconButton(
              icon: const Icon(Icons.favorite_border, color: Colors.white),
              onPressed: () {},
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80.0),
              Hero(
                tag: 'card-${pkBasicInfo.id}',
                child: Image.network(
                  pkBasicInfo.spriteUrl,
                  height: size.height * 0.2,
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                Utils.capitalize(pkBasicInfo.name),
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              Text(
                '#${pkBasicInfo.id.toString().padLeft(4, '0')}',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 10.0),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 10.0),
                      TabBar(
                        labelColor: backgroundColor,
                        dividerColor: Colors.transparent,
                        indicatorColor: backgroundColor.withOpacity(0.99),
                        controller: _tabController,
                        tabs: const [
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
                            PokemonAbout(pkBasicInfo: pkBasicInfo),
                            const Center(child: Text('Stats')),
                            EvolutionChain(pk: pkBasicInfo),
                            const Center(child: Text('Moves')),
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
}
