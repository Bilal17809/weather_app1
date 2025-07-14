import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../contrl/hourly_contrl.dart';

class hourly_cast extends StatelessWidget {
  const hourly_cast({super.key});

  // 🕒 Safely format time from string like "2025-07-14 16:00"
  String formatTime(String rawTime) {
    try {
      final parsed = DateTime.parse(rawTime);
      return DateFormat.j().format(parsed); // e.g., "4 PM"
    } catch (e) {
      print("❌ Time parse failed for: $rawTime");
      return rawTime; // fallback: show raw string
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        decoration: roundedDecorationWithShadow,
        child: Obx(() {
          final hourly = Get.find<HourlyForecastController>().hourlyList;

          print("📦 UI rebuilding — Hourly count: ${hourly.length}");

          if (hourly.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  "❌ No hourly forecast available",
                  style: context.textTheme.bodyLarge?.copyWith(color: kWhite),
                ),
              ),
            );
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(hourly.length, (index) {
                final h = hourly[index];
                final formattedTime = formatTime(h.time); // ✅ formatted "4 PM"

                return Padding(
                  padding: const EdgeInsets.only(left: 14, bottom: 10, top: 10),
                  child: Column(
                    children: [
                      Image.network(
                        h.icon,
                        width: 53,
                        height: 53,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Icon(Icons.error, color: kWhite),
                      ),
                      SizedBox(height: 10),
                      Text(
                        formattedTime,
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: kWhite,
                          fontSize: 13,
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "${h.temperature.round()}",
                              style: context.textTheme.bodyLarge?.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: kWhite,
                              ),
                            ),
                            WidgetSpan(
                              child: Transform.translate(
                                offset: const Offset(2, 1),
                                child: Text(
                                  '°',
                                  style: context.textTheme.bodyLarge?.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: kWhite,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          );
        }),
      ),
    );
  }
}
