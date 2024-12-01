import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pokedex/core/utils/utils.dart';
import 'package:pokedex/src/home/data/models/pokemon_tile.dart';
import 'package:pokedex/src/home/presentation/widgets/pokemon_types.dart';
import 'package:pokedex/src/pokemon_details/data/repository/details_repository.dart';
import 'package:pokedex/src/pokemon_details/presentation/providers/pokemon_info_notifier.dart';
import 'package:pokedex/src/pokemon_details/presentation/widgets/add_favorite_button.dart';
import 'package:pokedex/src/pokemon_details/presentation/widgets/pokemon_share_card.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class PokemonDetailsImage extends StatefulWidget {
  final PokemonTile pkBasicInfo;

  const PokemonDetailsImage({super.key, required this.pkBasicInfo});

  @override
  State<PokemonDetailsImage> createState() => _PokemonDetailsImageState();
}

class _PokemonDetailsImageState extends State<PokemonDetailsImage> {
  bool _isShiny = false;
  final player = AudioPlayer();
  final _screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final imgSize = size.height * 0.2;
    final pkInfoNotifier = context.watch<PokemonInfoNotifier>();

    return SizedBox(
      height: size.height * 0.37,
      width: double.infinity,
      child: Stack(
        children: [
          AddFavoriteButton(pkBasicInfo: widget.pkBasicInfo),
          Positioned(
            top: 40.0,
            left: 10.0,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          Positioned(
            top: 90.0,
            right: 5.0,
            child: AnimatedOpacity(
              opacity: pkInfoNotifier.pokemonDescription == null ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: IconButton(
                icon: const Icon(Icons.ios_share_rounded, color: Colors.white),
                onPressed: () async {
                  final card = PokemonShareCard(
                    pk: widget.pkBasicInfo,
                    cardText: pkInfoNotifier.pokemonDescription!,
                    screenshotController: _screenshotController,
                  );
                  Utils.shareImageWithText(
                    await _screenshotController.captureFromWidget(card),
                    'Check out this Pokémon on the Pokedex app!',
                  );
                },
              ),
            ),
          ),
          Positioned(
            right: 20.0,
            bottom: 10.0,
            child: PokemonTypes(
              types: widget.pkBasicInfo.types,
              direction: Axis.vertical,
            ),
          ),
          Positioned(
            left: 10.0,
            bottom: 10.0,
            child: IconButton(
              tooltip: 'Shiny version',
              onPressed: () => setState(() => _isShiny =
                  !_isShiny && widget.pkBasicInfo.shinySpriteUrl != null),
              icon: Icon(
                Icons.auto_awesome_rounded,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Hero(
              tag: 'card-${widget.pkBasicInfo.id}',
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 225),
                switchInCurve: Curves.easeIn,
                transitionBuilder: (child, animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: child,
                  );
                },
                child: Image.network(
                  key: ValueKey(_isShiny),
                  !_isShiny
                      ? widget.pkBasicInfo.spriteUrl
                      : widget.pkBasicInfo.shinySpriteUrl!,
                  height: imgSize,
                ),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0.0, 0.75),
            child: Text(
              Utils.capitalize(widget.pkBasicInfo.name),
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0.0, 0.87),
            child: Text(
              '#${widget.pkBasicInfo.id.toString().padLeft(4, '0')}',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ),
          FutureBuilder(
            future: DetailsRepository.getPokemonCry(
              GraphQLProvider.of(context).value,
              widget.pkBasicInfo.id,
            ),
            builder: (context, snapshot) {
              return Positioned(
                left: 10.0,
                bottom: 60.0,
                child: AnimatedOpacity(
                  opacity: !snapshot.hasData ||
                          snapshot.connectionState != ConnectionState.done
                      ? 0.0
                      : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: IconButton(
                    tooltip: 'Play cry',
                    onPressed: () async {
                      if (snapshot.data == null || player.playing) return;
                      await player.setUrl(snapshot.data as String);
                      await player.play();
                      await player.stop();
                    },
                    icon: Icon(
                      Icons.graphic_eq_rounded,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
