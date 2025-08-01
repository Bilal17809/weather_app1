import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../presentation/daily_forecast/contrl/daily_contrl.dart';

class DailyCastPage extends StatelessWidget {
  const DailyCastPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DailyForecastController>();

    return Obx(() {
      final list = controller.dailyList;

      if (list.isEmpty) {
        return const Center(
          child: Text("No forecast available", style: TextStyle(color: Colors.white)),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Text("7-Day Forecast",
                style: context.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )),
          ),
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: list.length,
              itemBuilder: (context, index) {
                final item = list[index];
                final dayName = DateFormat('EEE').format(DateTime.parse(item.date));
                final isSelected = controller.selectedDayIndex.value == index;

                return GestureDetector(
                  onTap: () => controller.selectedDayIndex.value = index,
                  child: Container(
                    width: 100,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white.withOpacity(0.15) : Colors.white10,
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected
                          ? Border.all(color: Colors.white, width: 1.5)
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(dayName,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            )),
                        const SizedBox(height: 6),
                        Image.network(
                          item.iconUrl,
                          width: 48,
                          height: 48,
                          errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.cloud, color: Colors.white, size: 40),
                        ),
                        const SizedBox(height: 4),
                        Text("${item.maxTemp}° / ${item.minTemp}°",
                            style: const TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
