import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokedex/core/utils/utils.dart';
import 'package:pokedex/src/home/data/models/evolution_edge.dart';
import 'package:pokedex/src/home/data/models/pokemon_node.dart';
import 'package:pokedex/src/home/data/repository/home_repository.dart';
import 'package:pokedex/src/pokemon_details/presentation/views/details_screen.dart';

class EvolutionChain extends StatelessWidget {
  final int id;

  const EvolutionChain({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: HomeRepository.getEvolutionChain(
        GraphQLProvider.of(context).value,
        id,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final chain = snapshot.data as List<EvolutionEdge>;
        if (chain.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'This Pokémon is so special that it has no evolution chain!',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return ListView.separated(
          itemCount: chain.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10.0),
          itemBuilder: (context, index) {
            final edge = chain[index];

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _Chain(
                  node: edge.from,
                  isOriginalPk: id == edge.from.pokemonTile.id,
                ),
                const Icon(Icons.arrow_forward_ios_rounded),
                _Chain(
                  node: edge.to,
                  isOriginalPk: id == edge.to.pokemonTile.id,
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _Chain extends StatelessWidget {
  final bool isOriginalPk;
  final PokemonNode node;

  const _Chain({required this.node, required this.isOriginalPk});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final imgSize = size.width * 0.25;
    return GestureDetector(
      onTap: () {
        if (isOriginalPk) return;

        Navigator.pushReplacementNamed(
          context,
          DetailsScreen.routeName,
          arguments: node.pokemonTile,
        );
      },
      child: Column(
        children: [
          Stack(
            children: [
              SvgPicture.asset(
                'assets/icons/pokeball_background.svg',
                width: imgSize + 10.0,
                height: imgSize + 10.0,
                colorFilter: ColorFilter.mode(
                  Colors.grey.withOpacity(0.2),
                  BlendMode.srcIn,
                ),
              ),
              Positioned(
                left: 7.0,
                top: 7.0,
                child: Image.network(
                  node.pokemonTile.spriteUrl,
                  width: imgSize,
                  height: imgSize,
                ),
              ),
            ],
          ),
          Text(
            '#${node.pokemonTile.id.toString().padLeft(4, '0')}',
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 13.0,
            ),
          ),
          Text(
            Utils.capitalize(node.pokemonTile.name),
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
