import 'package:flutter/material.dart';
import 'package:pokedex/src/home/data/models/pokemon_tile.dart';
import 'package:pokedex/core/theme/app_theme.dart';
import 'package:pokedex/src/pokemon_details/presentation/widgets/evolution_chain.dart';
import 'package:pokedex/src/pokemon_details/presentation/widgets/pokemon_about.dart';
import 'package:pokedex/src/pokemon_details/presentation/widgets/pokemon_details_image.dart';

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

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PokemonDetailsImage(pkBasicInfo: pkBasicInfo),
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
    );
  }
}
