import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TextLink extends StatelessWidget {
  final String beforeLink;
  final String link;
  final String? afterLink;
  final Color linkColor;
  final double fontSize;
  final void Function()? onTap;

  const TextLink({
    super.key,
    required this.beforeLink,
    required this.link,
    this.afterLink,
    this.linkColor = Colors.redAccent,
    this.fontSize = 14.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final normalTextStyle = TextStyle(color: Colors.black, fontSize: fontSize);
    final linkTextStyle = TextStyle(color: linkColor, fontSize: fontSize);

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: beforeLink,
            style: normalTextStyle,
          ),
          TextSpan(
            text: link,
            style: linkTextStyle,
            recognizer: TapGestureRecognizer()..onTap = onTap,
          ),
          if (afterLink != null)
            TextSpan(
              text: afterLink,
              style: normalTextStyle,
            ),
        ],
      ),
    );
  }
}
