import 'package:flutter/material.dart';

class EmptyIndicator extends StatelessWidget {
  final String text;
  final EdgeInsets padding;

  const EmptyIndicator({
    super.key,
    required this.text,
    this.padding = const EdgeInsets.all(20.0),
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 20.0,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
