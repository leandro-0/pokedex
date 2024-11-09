import 'package:flutter/material.dart';
import 'package:pokedex/src/pokemon_details/presentation/widgets/evolution_chain.dart';
import 'package:pokedex/src/pokemon_details/presentation/widgets/moves_tab.dart';
import 'package:pokedex/src/pokemon_details/presentation/widgets/pokemon_about.dart';
import 'package:pokedex/src/pokemon_details/presentation/widgets/pokemon_forms.dart';
import 'package:pokedex/src/pokemon_details/presentation/widgets/pokemon_stats.dart';

class DetailsTabView extends StatefulWidget {
  const DetailsTabView({
    super.key,
    required this.backgroundColor,
    required this.id,
  });

  final Color backgroundColor;
  final int id;

  @override
  State<DetailsTabView> createState() => _DetailsTabViewState();
}

class _DetailsTabViewState extends State<DetailsTabView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
              labelColor: widget.backgroundColor,
              dividerColor: Colors.transparent,
              indicatorColor: widget.backgroundColor.withOpacity(0.99),
              controller: _tabController,
              tabs: const [
                Tab(text: 'About'),
                Tab(text: 'Stats'),
                Tab(text: 'Evos'),
                Tab(text: 'Moves'),
                Tab(text: 'Forms'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  PokemonAbout(id: widget.id),
                  PokemonStats(id: widget.id),
                  EvolutionChain(id: widget.id),
                  MovesTab(id: widget.id), // Add moves tab here
                  PokemonForms(id: widget.id),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
