import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class KeyValueText extends StatelessWidget {
  final String title;
  final String value;
  final Color textColor;
  final IconData icon;

  const KeyValueText({
    super.key,
    required this.title,
    required this.value,
    required this.textColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,

            ),
            onPressed: () {},
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: textColor,
                  ),
                ),
                Icon(icon, color: textColor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}