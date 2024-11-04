import 'package:flutter/material.dart';

class PokemonStats extends StatelessWidget {
  final List<Map<String, dynamic>> stats;
  final List<String> weaknesses;

  const PokemonStats({
    super.key,
    required this.stats,
    required this.weaknesses,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Base Stats',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          ...stats.map((stat) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(stat['name'].toString().toUpperCase()),
                  Text(stat['base_stat'].toString()),
                ],
              ),
            );
          }).toList(),
          SizedBox(height: 20),
          Text(
            'Weaknesses',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: weaknesses.map((weakness) {
              return Chip(
                label: Text(
                  weakness.toUpperCase(),
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.redAccent,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}