import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokedex/core/theme/app_theme.dart';
import 'package:pokedex/core/utils/utils.dart';
import 'package:pokedex/src/guess_pokemon/data/repository/guess_pokemon_repository.dart';
import 'package:pokedex/src/guess_pokemon/presentation/widgets/text_link.dart';
import 'package:pokedex/src/home/data/models/pokemon_tile.dart';
import 'package:pokedex/src/home/presentation/widgets/rounded_text_field.dart';
import 'package:pokedex/src/pokemon_details/presentation/views/details_screen.dart';

class GuessPokemonScreen extends StatefulWidget {
  static const String routeName = '/guess-the-pokemon';

  const GuessPokemonScreen({super.key});

  @override
  State<GuessPokemonScreen> createState() => _GuessPokemonScreenState();
}

class _GuessPokemonScreenState extends State<GuessPokemonScreen> {
  Future<PokemonTile>? future;
  final _controller = TextEditingController();
  bool _showAnswer = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    future ??= GuessPokemonRepository.getRandomPokemon(
      GraphQLProvider.of(context).value,
    );
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Who is that Pokémon?'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => setState(() {
              _showAnswer = false;
              future = null;
              _controller.clear();
            }),
          ),
        ],
      ),
      body: FutureBuilder(
        future: future!,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.redAccent),
            );
          } else if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Text(
                'An error occurred: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final pk = snapshot.data as PokemonTile;
          return FadeIn(
            child: Column(
              children: [
                Hero(
                  tag: 'card-${pk.id}',
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder: (child, animation) {
                      final curvedAnimation = CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeInOutCubic,
                      );

                      return ScaleTransition(
                        scale: curvedAnimation,
                        child: child,
                      );
                    },
                    child: Image.network(
                      key: ValueKey(_showAnswer),
                      pk.spriteUrl,
                      width: size.height * 0.3,
                      height: size.height * 0.3,
                      color: _showAnswer ? null : Colors.black38,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                if (_showAnswer)
                  ElasticIn(
                    child: TextLink(
                      beforeLink: 'It\'s ',
                      link: Utils.capitalize(pk.name),
                      afterLink: '!',
                      fontSize: 20.0,
                      linkColor: AppTheme.typeColors[pk.types.first] ??
                          Colors.redAccent,
                      onTap: () => Navigator.pushNamed(
                        context,
                        DetailsScreen.routeName,
                        arguments: pk,
                      ),
                    ),
                  ),
                SizedBox(height: _showAnswer ? 20.0 : 43.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35.0),
                  child: RoundedTextField(
                    controller: _controller,
                    hintText: 'Type the Pokémon name',
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon:
                          const Icon(Icons.sentiment_very_dissatisfied_rounded),
                      label: const Text('Give up'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: !_showAnswer
                          ? () => setState(
                                () => _showAnswer = !_showAnswer,
                              )
                          : null,
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.mood_rounded),
                      label: const Text('Guess!'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF292929),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _controller.text.trim().isEmpty || _showAnswer
                          ? null
                          : () => _verifyAnswer(pk.name),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _verifyAnswer(String pokemonName) {
    // Hide keyboard
    FocusManager.instance.primaryFocus?.unfocus();

    if (_controller.text.trim().toLowerCase() != pokemonName.toLowerCase()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Wrong answer! Try again'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _showAnswer = true);
  }
}
