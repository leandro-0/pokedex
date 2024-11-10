class TypeEffectivenessCalculator {
  static const Map<String, Map<String, double>> typeChart = {
    'normal': {
      'fighting': 2.0,
      'ghost': 0.0,
    },
    'fire': {
      'water': 2.0,
      'ground': 2.0,
      'rock': 2.0,
      'fire': 0.5,
      'grass': 0.5,
      'ice': 0.5,
      'bug': 0.5,
      'steel': 0.5,
      'fairy': 0.5,
    },
    'water': {
      'electric': 2.0,
      'grass': 2.0,
      'fire': 0.5,
      'water': 0.5,
      'ice': 0.5,
      'steel': 0.5,
    },
    'electric': {
      'ground': 2.0,
      'electric': 0.5,
      'flying': 0.5,
      'steel': 0.5,
    },
    'grass': {
      'fire': 2.0,
      'ice': 2.0,
      'poison': 2.0,
      'flying': 2.0,
      'bug': 2.0,
      'water': 0.5,
      'electric': 0.5,
      'grass': 0.5,
      'ground': 0.5,
    },
    'ice': {
      'fire': 2.0,
      'fighting': 2.0,
      'rock': 2.0,
      'steel': 2.0,
      'ice': 0.5,
    },
    'fighting': {
      'flying': 2.0,
      'psychic': 2.0,
      'fairy': 2.0,
      'bug': 0.5,
      'rock': 0.5,
      'dark': 0.5,
    },
    'poison': {
      'ground': 2.0,
      'psychic': 2.0,
      'fighting': 0.5,
      'poison': 0.5,
      'bug': 0.5,
      'grass': 0.5,
      'fairy': 0.5,
    },
    'ground': {
      'water': 2.0,
      'grass': 2.0,
      'ice': 2.0,
      'poison': 0.5,
      'rock': 0.5,
      'electric': 0.0,
    },
    'flying': {
      'electric': 2.0,
      'ice': 2.0,
      'rock': 2.0,
      'fighting': 0.5,
      'ground': 0.0,
      'bug': 0.5,
      'grass': 0.5,
    },
    'psychic': {
      'bug': 2.0,
      'ghost': 2.0,
      'dark': 2.0,
      'fighting': 0.5,
      'psychic': 0.5,
    },
    'bug': {
      'fire': 2.0,
      'flying': 2.0,
      'rock': 2.0,
      'fighting': 0.5,
      'ground': 0.5,
      'grass': 0.5,
    },
    'rock': {
      'water': 2.0,
      'grass': 2.0,
      'fighting': 2.0,
      'ground': 2.0,
      'steel': 2.0,
      'normal': 0.5,
      'fire': 0.5,
      'poison': 0.5,
      'flying': 0.5,
    },
    'ghost': {
      'ghost': 2.0,
      'dark': 2.0,
      'poison': 0.5,
      'bug': 0.5,
      'normal': 0.0,
      'fighting': 0.0,
    },
    'dragon': {
      'ice': 2.0,
      'dragon': 2.0,
      'fairy': 2.0,
      'fire': 0.5,
      'water': 0.5,
      'electric': 0.5,
      'grass': 0.5,
    },
    'dark': {
      'fighting': 2.0,
      'bug': 2.0,
      'fairy': 2.0,
      'ghost': 0.5,
      'dark': 0.5,
      'psychic': 0.0,
    },
    'steel': {
      'fire': 2.0,
      'fighting': 2.0,
      'ground': 2.0,
      'normal': 0.5,
      'grass': 0.5,
      'ice': 0.5,
      'flying': 0.5,
      'psychic': 0.5,
      'bug': 0.5,
      'rock': 0.5,
      'dragon': 0.5,
      'steel': 0.5,
      'fairy': 0.5,
      'poison': 0.0,
    },
    'fairy': {
      'poison': 2.0,
      'steel': 2.0,
      'fighting': 0.5,
      'bug': 0.5,
      'dark': 0.5,
      'dragon': 0.0,
    },
  };

  static List<Map<String, dynamic>> calculateWeaknesses(List<String> pokemonTypes) {
    Map<String, double> effectiveness = {};
    for (var type in typeChart.keys) {
      effectiveness[type] = 1.0;
    }

    for (var defenderType in pokemonTypes) {
      defenderType = defenderType.toLowerCase();
      
      if (!typeChart.containsKey(defenderType)) continue;

      for (var attackerType in typeChart.keys) {
        double? multiplier = typeChart[attackerType]?[defenderType];
        
        if (multiplier != null) {
          effectiveness[attackerType] = effectiveness[attackerType]! * multiplier;
        }
      }
    }

    return effectiveness.entries
        .map((e) => {
              'type': e.key,
              'multiplier': e.value,
            })
        .toList();
  }
}