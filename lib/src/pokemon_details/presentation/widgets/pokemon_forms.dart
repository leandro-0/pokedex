import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokedex/core/utils/utils.dart';
import 'package:pokedex/src/pokemon_details/data/models/pokemon_form.dart';
import 'package:pokedex/src/pokemon_details/data/repository/details_repository.dart';

class PokemonForms extends StatelessWidget {
  final int id;

  const PokemonForms({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DetailsRepository.getPokemonForms(
        GraphQLProvider.of(context).value,
        id,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final forms = snapshot.data as List<PokemonForm>;

        return ListView.separated(
          itemCount: forms.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10.0),
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          itemBuilder: (context, index) {
            final form = forms[index];

            return ListTile(
              leading: form.spriteUrl == null
                  ? null
                  : Image.network(
                      form.spriteUrl!,
                      height: 60.0,
                      width: 60.0,
                    ),
              title: Text(
                Utils.capitalize(form.name),
                style: const TextStyle(fontSize: 16.0),
              ),
            );
          },
        );
      },
    );
  }
}
