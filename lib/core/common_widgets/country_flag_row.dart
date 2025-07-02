import 'package:flutter/material.dart';

class CurrencyRowWidget extends StatelessWidget {
  final String imagePath;
  final String shortName;
  final bool isUp;
  final double percentage;
  final double buy;
  final double sell;

  const CurrencyRowWidget({
    super.key,
    required this.imagePath,
    required this.shortName,
    required this.isUp,
    required this.percentage,
    required this.buy,
    required this.sell,
  });

  @override
  Widget build(BuildContext context) {
    final arrowIcon = isUp ? Icons.arrow_upward : Icons.arrow_downward;
    final arrowColor = isUp ? Colors.green : Colors.red;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Image.asset(imagePath, width: 32, height: 32),
          const SizedBox(width: 12),
          Text(shortName, style: const TextStyle(fontSize: 16)),
          const Spacer(),
          Icon(arrowIcon, color: arrowColor, size: 16),
          const SizedBox(width: 5),
          Text(
            "${percentage.toStringAsFixed(2)}%",
            style: TextStyle(
              color: arrowColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width:16),
          Text("$buy", style: const TextStyle(fontSize: 14)),
          SizedBox(width: 16,),
          Text("$sell", style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}