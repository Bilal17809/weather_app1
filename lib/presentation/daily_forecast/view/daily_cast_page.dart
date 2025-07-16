import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/common/controller/controller.dart';
import '../../../core/routes/routes_name.dart';
import '../../../core/theme/app_colors.dart';
import '../../hourly_forecast/contrl/hourly_contrl.dart';
import '../contrl/daily_contrl.dart';

class DailyCastPage extends StatefulWidget {
  const DailyCastPage({super.key});

  @override
  State<DailyCastPage> createState() => _DailyCastPageState();
}

class _DailyCastPageState extends State<DailyCastPage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Called when returning to app
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _resetToTodayIfOnHome();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resetToTodayIfOnHome();
  }

  void _resetToTodayIfOnHome() {
    final controller = Get.find<HourlyForecastController>();
    final routeName = ModalRoute.of(context)?.settings.name;

    if (routeName == '/') {
      final lat = controller.currentLat.value;
      final lng = controller.currentLng.value;

      // Reset selected hour + fetch today's data
      controller.setSelectedHour(null);
      controller.fetchHourlyForecast(lat, lng);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Obx(() {
        final controller = Get.find<DailyForecastController>();
        final daily = controller.dailyList;

        print("📅 Daily forecast items: ${daily.length}");

        if (daily.isEmpty) {
          return Center(
            child: Text(
              "⚠️ Forecast data not available.",
              style: context.textTheme.bodyLarge?.copyWith(color: kWhite, fontSize: 16),
            ),
          );
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(daily.length.clamp(0, 7), (index) {
              final w = daily[index];

              return InkWell(
                onTap: () async {
                  final selected = daily[index];
                  final selectedDateTime = DateTime.parse(selected.date);

                  final hourlyController = Get.find<HourlyForecastController>();
                  final lat = hourlyController.currentLat.value;
                  final lng = hourlyController.currentLng.value;

                  // Set selected day's condition
                  hourlyController.setSelectedDayDetail(
                    selected.conditionText,
                    selected.iconUrl,
                  );

                  // Fetch forecast for selected date
                  await hourlyController.fetchHourlyForecast(lat, lng, selectedDate: selected.date);

                  // Auto-select the first hour of selected day
                  if (hourlyController.hourlyList.isNotEmpty) {
                    hourlyController.setSelectedHour(hourlyController.hourlyList.first.time);
                  }

                  // Update selected date in UI
                  Get.find<CityController>().selectedDate.value = selectedDateTime;

                  // Navigate to detail screen
                  Navigator.pushNamed(context, RoutesName.weatherpage);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Column(
                    children: [
                      const SizedBox(height: 9),
                      Image.network(
                        w.iconUrl,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.error, color: kRed),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        w.dayName,
                        style: context.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: kWhite,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "${w.maxTemp.round()}",
                              style: context.textTheme.bodyLarge?.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF01474E),
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
                                    color: const Color(0xFF01474E),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "${w.minTemp.round()}",
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
    );
  }
}
