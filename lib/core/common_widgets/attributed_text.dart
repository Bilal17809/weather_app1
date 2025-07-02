import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AttributedText extends StatelessWidget {
  final List<RichTextItem> items;

  const AttributedText({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: items
            .map(
              (item) => TextSpan(
            text: item.text,
            style: item.style,
            recognizer: TapGestureRecognizer()..onTap = item.onTap,
          ),
        )
            .toList(),
      ),
    );
  }
}

class RichTextItem {
  final String text;
  final TextStyle? style;
  final VoidCallback? onTap;

  RichTextItem({
    required this.text,
    required this.style,
    this.onTap,
  });
}