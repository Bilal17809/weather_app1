import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weather/core/routes/routes_name.dart';

import '../../../core/common/controller/current_weather_controller.dart';
import '../../../core/common/controller/controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../daily_forecast/view/daily_cast_page.dart';
import '../../hourly_forecast/view/hourly_cast_page.dart';
import '../../hourly_forecast/contrl/hourly_contrl.dart';
import '../../daily_forecast/contrl/daily_contrl.dart';
import '../view/sidebar.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final ctr = Get.find<CityController>();
  final forecastCtr = Get.find<DailyForecastController>();
  final hourlyCtrl = Get.find<HourlyForecastController>();
  final cctr = Get.find<CurrentWeatherController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      // appBar: PreferredSize(
      //   preferredSize: const Size.fromHeight(100),
      appBar: AppBar(
        backgroundColor: bgDark2,
        automaticallyImplyLeading: false,
        title: Obx(() {
          if (forecastCtr.dailyList.isEmpty) {
            return Text(
              'Loading...',
              style: context.textTheme.bodyLarge?.copyWith(color: Colors.white),
            );
          }

          final formattedDate = DateFormat('EEEE d MMMM').format(DateTime.now());

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Builder(
                builder:
                    (context) => InkWell(
                      onTap: () => Scaffold.of(context).openDrawer(),
                      child: const Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 17,
                      ),
                      const SizedBox(width: 5),
                      Obx(() {
                        final cityName = ctr.selectedCity.value?.city ?? '';
                        return Text(
                          cityName.isNotEmpty ? cityName : 'Locating...',
                          style: context.textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        );
                      }),

                    ],
                  ),
                  Text(
                    formattedDate,
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap:
                      () => Navigator.pushNamed(context, RoutesName.citypage),
                  child: const Icon(
                    Icons.add_circle_sharp,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ],
          );
        }),
      ),

      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: bgwithgradent,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// 🌤️ Current weather from GPS
                Obx(() {
                  final icon = cctr.iconUrl.value;
                  final condition = cctr.conditionText.value;

                  return Column(
                    children: [
                      if (icon.isNotEmpty)
                        Image.network(
                          icon,
                          width: 210,
                          height: 180,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.error, color: kWhite);
                          },
                        ),

                      const SizedBox(height: 10),
                      Text(
                        condition.isNotEmpty ? condition : 'Fetching...',
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        cctr.currentTemperature.value.isEmpty
                            ? '--°C'
                            : '${cctr.currentTemperature.value}°C',
                        style: const TextStyle(
                          fontSize: 40,
                          color: kWhite,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                }),

                const SizedBox(height: 10),

                /// 🕓 Hourly forecast widget
                hourly_cast(),

                const SizedBox(height: 10),

                /// 📅 Daily forecast widget
                DailyCastPage(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
