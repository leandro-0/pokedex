import 'package:flutter/material.dart';

class DetailCard extends StatelessWidget {
  final String title1;
  final String value1;
  final String title2;
  final String value2;

  const DetailCard({
    super.key,
    required this.title1,
    required this.value1,
    required this.title2,
    required this.value2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title1,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              value1,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title2,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              value2,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ],
    );
  }
}

