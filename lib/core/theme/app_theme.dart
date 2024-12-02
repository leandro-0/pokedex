import 'package:flutter/material.dart' show Color;

class AppTheme {
  static const Map<String, Color> typeColors = {
    'normal': Color(0xFFb5b9c4),
    'fighting': Color(0xFFeb4972),
    'flying': Color(0xFF83a2e3),
    'poison': Color(0xFFa1729a),
    'ground': Color(0xFFf68551),
    'rock': Color(0xFFd4c294),
    'bug': Color(0xFF8ad674),
    'ghost': Color(0xFF8671be),
    'steel': Color(0xFF4c91b2),
    'fire': Color(0xFFffa657),
    'water': Color(0xFF58abf7),
    'grass': Color(0xFF8cbe8b),
    'electric': Color(0xFFf2cb56),
    'psychic': Color(0xFFff6468),
    'ice': Color(0xFF91d9df),
    'dragon': Color(0xFF7382b9),
    'dark': Color(0xFF6f6d78),
    'fairy': Color(0xFFeaa8c2),
  };

  static const Map<String, Color> typeChipColors = {
    'normal': Color(0xFF9fa19f),
    'fighting': Color(0xFFff8000),
    'flying': Color(0xFF81b9ef),
    'poison': Color(0xFF9141cb),
    'ground': Color(0xFF915121),
    'rock': Color(0xFFafa981),
    'bug': Color(0xFF3a400a),
    'ghost': Color(0xFF704170),
    'steel': Color(0xFF60a1b8),
    'fire': Color(0xFFe62829),
    'water': Color(0xFF2980ef),
    'grass': Color(0xFF3fa129),
    'electric': Color(0xFFfac000),
    'psychic': Color(0xFFef4179),
    'ice': Color(0xFF3dcef3),
    'dragon': Color(0xFF5060e0),
    'dark': Color(0xFF624d4e),
    'fairy': Color(0xFFef70ef),
    'stellar': Color(0xFF40b5a5),
  };

  static const Map<String, Map<String, Color>> generationColors = {
    'III': {
      'background': Color(0xFF96d9d6), // Soft teal
      'foreground': Color(0xFF305f60), // Dark teal
    },
    'IV': {
      'background': Color(0xFFa8b9e0), // Soft lavender blue
      'foreground': Color(0xFF3b4f7e), // Deep blue
    },
    'V': {
      'background': Color(0xFFe0e0e0), // Neutral light gray
      'foreground': Color(0xFF6d6d6d), // Charcoal gray
    },
    'VI': {
      'background': Color(0xFFf4d8a8), // Pastel yellow-orange
      'foreground': Color(0xFF815c28), // Warm brown
    },
    'VII': {
      'background': Color(0xFFf7b3c2), // Pale pink
      'foreground': Color(0xFF8f4a56), // Deep rose
    },
    'VIII': {
      'background': Color(0xFFc5b0d5), // Light mauve
      'foreground': Color(0xFF5e4473), // Dark purple
    },
    'IX': {
      'background': Color(0xFFd5e6a3), // Soft green-yellow
      'foreground': Color(0xFF62773d), // Olive green
    },
  };
}
