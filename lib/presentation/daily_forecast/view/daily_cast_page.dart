import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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


      final now = DateFormat('hh:00 a').format(DateTime.now());
      controller.setSelectedHour(now);
      controller.fetchFullForecastForCurrentLocation();
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
                  onTap: () {
                    Navigator.pushNamed(context, RoutesName.weatherpage);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Column(
                      children: [
                        SizedBox(height: 9),
                        Image.network(
                          w.iconUrl,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.error, color: kRed),
                        ),
                        SizedBox(height: 10),
                        Text(
                          w.dayName,
                          style: context.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: kWhite,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "${w.maxTemp.round()}",
                                style: context.textTheme.bodyLarge?.copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF01474E),
                                ),
                              ),
                              WidgetSpan(
                                child: Transform.translate(
                                  offset: Offset(2, 1),
                                  child: Text(
                                    '°',
                                    style: context.textTheme.bodyLarge?.copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF01474E),
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
                                  offset: Offset(2, 1),
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
