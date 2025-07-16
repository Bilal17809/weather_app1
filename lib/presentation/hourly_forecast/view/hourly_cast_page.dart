import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../contrl/hourly_contrl.dart';

class HourlyCast extends StatefulWidget {
  const HourlyCast({super.key});

  @override
  State<HourlyCast> createState() => _HourlyCastState();
}

class _HourlyCastState extends State<HourlyCast> {
  final ScrollController _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final hourly = Get.find<HourlyForecastController>().hourlyList;
      final now = DateTime.now();

      final index = hourly.indexWhere((h) {
        try {
          final parsed = DateTime.parse(h.time);
          return parsed.hour == now.hour && parsed.day == now.day;
        } catch (_) {
          return false;
        }
      });

      if (index != -1 && _scrollController.hasClients) {
        _scrollController.animateTo(
          index * 90.0, // Approximate width of each card
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  String formatTime(String rawTime) {
    try {
      final parsed = DateTime.parse(rawTime);
      return DateFormat.j().format(parsed);
    } catch (e) {
      print("❌ Time parse failed for: $rawTime");
      return rawTime;
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
          final now = DateTime.now();

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
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(hourly.length, (index) {
                final h = hourly[index];
                final parsedTime = DateTime.tryParse(h.time);
                final isCurrentHour = parsedTime != null &&
                    parsedTime.hour == now.hour &&
                    parsedTime.day == now.day;

                return Padding(
                  padding: const EdgeInsets.only(left: 14, bottom: 10, top: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      border: isCurrentHour
                          ? Border.all(color: Colors.white, width: 2)
                          : null,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
        }),
      ),
    );
  }
}
