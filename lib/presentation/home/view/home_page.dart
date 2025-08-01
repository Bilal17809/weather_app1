import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:weather/presentation/home/view/sidebar.dart';

import '../../../core/common/controller/controller.dart';
import '../../../core/common/controller/current_weather_controller.dart';
import '../../../core/routes/routes_name.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../daily_forecast/contrl/daily_contrl.dart';
import '../../daily_forecast/view/daily_cast_page.dart';
import '../../hourly_forecast/contrl/hourly_contrl.dart';
import '../../hourly_forecast/view/hourly_cast_page.dart';

class HomeScreen extends StatelessWidget {
  final ctr = Get.find<CityController>();
  final cctr = Get.find<CurrentWeatherController>();
  final hourlyCtrl = Get.find<HourlyForecastController>();
  final forecastCtr = Get.find<DailyForecastController>();

  @override
  Widget build(BuildContext context) {
    // Fetch current location weather initially
    cctr.fetchCurrentLocationWeather();

    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        backgroundColor: bgDark2,
        automaticallyImplyLeading: false,
        title: Obx(() {
          final cname = ctr.selectedCity.value?.city ?? cctr.cityName.value;
          final dateStr = DateFormat('EEEE d MMMM').format(DateTime.now());
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Builder(builder: (ctx) => InkWell(
                onTap: () => Scaffold.of(ctx).openDrawer(),
                child: const Icon(Icons.menu, color: kWhite, size: 28),
              )),
              Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: kWhite, size: 17),
                      const SizedBox(width: 5),
                      Text(cname.isNotEmpty ? cname : 'Locating...',
                        style: context.textTheme.bodyLarge?.copyWith(color: kWhite, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  Text(dateStr, style: context.textTheme.bodySmall?.copyWith(color: kWhite, fontSize: 12)),
                ],
              ),
              InkWell(
                onTap: () => Navigator.pushNamed(context, RoutesName.citypage),
                child: const Icon(Icons.add_circle_sharp, color: kWhite, size: 28),
              ),
            ],
          );
        }),
      ),
      body: Container(
        decoration: bgwithgradent,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Obx(() {
                  final icon = cctr.iconUrl.value;
                  final cond = cctr.conditionText.value;
                  final temp = cctr.currentTemperature.value;

                  return Column(children: [
                    if (icon.isNotEmpty)
                      Image.network(icon, width: 210, height: 180, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Icon(Icons.error, color: kWhite)),
                    const SizedBox(height: 10),
                    Text(cond.isNotEmpty ? cond : 'Fetching...', style: context.textTheme.bodyLarge?.copyWith(color: kWhite, fontSize: 20)),
                    const SizedBox(height: 5),
                    Text(temp.isEmpty ? '--°C' : '$temp°C',
                      style: const TextStyle(fontSize: 40, color: kWhite, fontWeight: FontWeight.bold),
                    ),
                  ]);
                }),

                const SizedBox(height: 10),
                hourly_cast(),
                const SizedBox(height: 10),
                DailyCastPage(),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
