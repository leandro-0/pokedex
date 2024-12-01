import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex/src/pokemon_details/presentation/widgets/empty_indicator.dart';

class Utils {
  static String capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  static Future<bool> hasInternetConnection() async {
    try {
      final response = await http.get(
        Uri.parse('https://clients3.google.com/generate_204'),
      );
      return response.statusCode == 204;
    } catch (e) {
      return false;
    }
  }

  static void showNoInternetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 32.0,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.wifi_off,
                size: 50.0,
                color: Colors.red[300],
              ),
              const SizedBox(height: 16.0),
              const EmptyIndicator(
                text:
                    'You cannot access this feature without an internet connection',
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        );
      },
    );
  }
}
