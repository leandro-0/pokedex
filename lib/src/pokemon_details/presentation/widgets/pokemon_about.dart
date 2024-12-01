import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokedex/src/pokemon_details/data/models/about_info.dart';
import 'package:pokedex/src/pokemon_details/data/repository/details_repository.dart';
import 'package:pokedex/src/pokemon_details/presentation/providers/pokemon_info_notifier.dart';
import 'package:pokedex/src/pokemon_details/presentation/widgets/about_heading.dart';
import 'package:pokedex/src/pokemon_details/presentation/widgets/info_item.dart';
import 'package:pokedex/src/pokemon_details/presentation/widgets/pokemon_gender.dart';
import 'package:pokedex/src/pokemon_details/presentation/widgets/weight_height_detail.dart';
import 'package:provider/provider.dart';

class PokemonAbout extends StatefulWidget {
  final int id;

  const PokemonAbout({super.key, required this.id});

  @override
  State<PokemonAbout> createState() => _PokemonAboutState();
}

class _PokemonAboutState extends State<PokemonAbout> {
  @override
  Widget build(BuildContext context) {
    final GraphQLClient client = GraphQLProvider.of(context).value;
    final pkInfoNotifier = context.read<PokemonInfoNotifier>();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder(
        future: DetailsRepository.getPokemonDescription(
          client,
          widget.id,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          final about = snapshot.data as AboutInfo;
          if (pkInfoNotifier.pokemonDescription == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              pkInfoNotifier.pokemonDescription = about.description;
            });
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16.0),
                Text(
                  about.description,
                  style: const TextStyle(fontSize: 16.0),
                ),
                if (about.isLegendary || about.isMythical) ...[
                  const SizedBox(height: 16.0),
                  Text(
                    about.isLegendary
                        ? '⭐ Pokémon Legendario'
                        : '✨ Pokémon Mítico',
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                ],
                const AboutHeading(text: 'Physical Traits'),
                DetailCard(
                  title1: 'Height',
                  value1: '${about.height.toStringAsFixed(1)} m',
                  title2: 'Weight',
                  value2: '${about.weight.toStringAsFixed(1)} kg',
                ),
                const AboutHeading(text: 'Origins'),
                InfoItem(
                  title: 'Habitat',
                  value: about.habitat,
                ),
                InfoItem(
                  title: 'Generation',
                  value: about.generation,
                ),
                const AboutHeading(text: 'Abilities'),
                ...about.abilities.map((ability) => InfoItem(
                      title: ability.isHidden ? 'Hidden Ability' : 'Ability',
                      value: ability.name,
                    )),
                const AboutHeading(text: 'Breeding'),
                PokemonGender(
                  malePercentage: about.malePercentage,
                  femalePercentage: about.femalePercentage,
                ),
                InfoItem(
                  title: 'Egg Groups',
                  value: about.eggGroups.toString(),
                ),
                InfoItem(
                  title: 'Egg Cycle',
                  value: about.eggCycle.toString(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
