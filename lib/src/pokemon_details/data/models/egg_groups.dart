import 'package:pokedex/core/utils/utils.dart';

class EggGroups {
  final List<String> groups;

  EggGroups({required this.groups});

  factory EggGroups.fromJson(Map<String, dynamic> json) {
    return EggGroups(
      groups: json['pokemon_v2_pokemonegggroups']
              ?.map((e) =>
                  Utils.capitalize(e['pokemon_v2_egggroup']['name'].toString()))
              ?.toList()
              ?.cast<String>() ??
          [],
    );
  }

  @override
  String toString() => groups.join(', ');
}
