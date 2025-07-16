import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/routes/routes_name.dart';
import '../../../core/theme/app_colors.dart';
import '../../hourly_forecast/contrl/hourly_contrl.dart';

class Weather_forter extends StatefulWidget {
  const Weather_forter({super.key});

  @override
  State<Weather_forter> createState() => _Weather_forterState();
}

class _Weather_forterState extends State<Weather_forter> {
  final ScrollController _scrollController = ScrollController();

  void scrollToCurrentHour(List hourly) {
    final now = DateTime.now();

    final index = hourly.indexWhere((h) {
      final parsed = DateTime.tryParse(h.time)?.toLocal();
      return parsed != null &&
          parsed.hour == now.hour &&
          parsed.day == now.day &&
          parsed.month == now.month &&
          parsed.year == now.year;
    });

    if (index != -1 && _scrollController.hasClients) {
      _scrollController.animateTo(
        index * 90.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  String formatTime(String rawTime) {
    try {
      final parsed = DateTime.parse(rawTime).toLocal();
      return DateFormat.j().format(parsed);
    } catch (e) {
      print("❌ Time parse failed for: $rawTime");
      return rawTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hourly = Get.find<HourlyForecastController>().hourlyList;
      final now = DateTime.now();

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

      // ✅ Only scroll after build if data is ready
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollToCurrentHour(hourly);
      });

      return SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(hourly.length, (index) {
            final h = hourly[index];
            final parsedTime = DateTime.tryParse(h.time)?.toLocal();

            final isCurrentHour = parsedTime != null &&
                parsedTime.hour == now.hour &&
                parsedTime.day == now.day &&
                parsedTime.month == now.month &&
                parsedTime.year == now.year;

            return Padding(
              padding: const EdgeInsets.only(left: 14, bottom: 10, top: 10),
              child: Container(
                decoration: BoxDecoration(
                  border: isCurrentHour
                      ? Border.all(color: Colors.white, width: 2)
                      : null,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Column(
                  children: [
                    Image.network(
                      h.icon,
                      width: 53,
                      height: 53,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                      const Icon(Icons.error, color: kWhite),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      formatTime(h.time),
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
              ),
            );
          }),
        ),
      );
    });

  }
}
