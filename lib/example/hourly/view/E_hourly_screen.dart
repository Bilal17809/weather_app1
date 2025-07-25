// hourly_cast_widget.dart

import 'package:flutter/material.dart';

import '../model/e_houry_model.dart';

class HourlyCastWidget extends StatelessWidget {
  final List<E_HourlyWeather> hourlyData;

  const HourlyCastWidget({super.key, required this.hourlyData});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: hourlyData.length,
        itemBuilder: (context, index) {
          final item = hourlyData[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(
                color: item.isCurrentHour ? Colors.white : Colors.transparent,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
              color: Colors.white.withOpacity(0.1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(item.time, style: const TextStyle(color: Colors.white)),
                const SizedBox(height: 4),
                Image.network(item.iconUrl, width: 40, height: 40),
                const SizedBox(height: 4),
                Text(item.temperature, style: const TextStyle(color: Colors.white)),
              ],
            ),
          );
        },
      ),
    );
  }
}
