import 'package:flutter/material.dart';
import 'package:pokedex/src/favorite_pokemons/data/repository/favorite_pokemon_repository.dart';
import 'package:pokedex/src/home/data/models/pokemon_tile.dart';

class AddFavoriteButton extends StatefulWidget {
  const AddFavoriteButton({super.key, required this.pkBasicInfo});

  final PokemonTile pkBasicInfo;

  @override
  State<AddFavoriteButton> createState() => _AddFavoriteButtonState();
}

class _AddFavoriteButtonState extends State<AddFavoriteButton> {
  int? _favoriteId;
  bool? _isFavorite;

  void _loadInitialData() async {
    final favoriteId =
        await FavoritePokemonRepository.isFavorite(widget.pkBasicInfo.id);
    if (!mounted) return;
    setState(() {
      _favoriteId = favoriteId;
      _isFavorite = favoriteId != null;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    if (_favoriteId == null && _isFavorite == null) return const SizedBox();

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.transparent,
      child: Stack(
        children: [
          Align(
            alignment: const Alignment(0.97, -0.7),
            child: IconButton(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: Icon(
                  _isFavorite! ? Icons.favorite : Icons.favorite_border,
                  key: ValueKey<bool>(_isFavorite!),
                  color: _isFavorite!
                      ? Colors.red[300]!.withOpacity(0.9)
                      : Colors.white,
                ),
              ),
              onPressed: () async {
                setState(() => _isFavorite = !_isFavorite!);

                if (!_isFavorite!) {
                  if (_favoriteId == null) return;
                  await FavoritePokemonRepository.removeFavorite(_favoriteId!);
                  _favoriteId = null;
                } else {
                  _favoriteId = await FavoritePokemonRepository.addFavorite(
                    widget.pkBasicInfo,
                  );
                  if (_favoriteId == null) _isFavorite = false;
                }
                if (!context.mounted) return;
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }
}
