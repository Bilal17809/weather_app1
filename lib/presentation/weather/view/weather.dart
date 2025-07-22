import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:weather/presentation/hourly_forecast/contrl/hourly_contrl.dart';
import 'package:weather/presentation/weather/view/w_forter.dart';
import '../../../core/common/controller/controller.dart' show CityController;
import '../../../core/common/controller/current_weather_controller.dart';
import '../../../core/routes/routes_name.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../daily_forecast/contrl/daily_contrl.dart';

class weather extends StatelessWidget {
  weather({super.key});
  final CityController ctr = Get.put(CityController());
  final cctr = Get.find<CurrentWeatherController>();
  final forecastCtr = Get.find<DailyForecastController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF001B31),
        automaticallyImplyLeading: false,
        title: Obx(() {
          final selectedDay = forecastCtr.dailyList.isNotEmpty
              ? DateTime.parse(forecastCtr.dailyList[forecastCtr.selectedDayIndex.value].date)
              : DateTime.now();

          final formattedDate = DateFormat('EEEE d MMMM').format(selectedDay);

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             SizedBox(width: 40,),

              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.white, size: 17),
                      const SizedBox(width: 5),
                      Obx(() {
                        final cityName = cctr.cityName.value;
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
                    style: context.textTheme.bodyLarge?.copyWith(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () => Navigator.pushNamed(context, RoutesName.citypage),
                  child: const Icon(Icons.add_circle_sharp, color: Colors.white, size: 28),
                ),
              ),
            ],
          );
        }),



      ),
      body: Container(
        decoration: bgwithgradent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),

            SizedBox(height: 25),
            Obx(() {
              final detail = Get.find<CityController>().details;
              print("🔍 detail length: ${detail.length}"); // DEBUG

              final icon = cctr.iconUrl.value;
              final condition = cctr.conditionText.value;
              final temp = cctr.currentTemperature.value;

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
                ],
              );
            }),
            SizedBox(height: 8),

            Divider(
              color:textGreyColor, // Line color
              thickness: 1, // Line thickness
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50, right: 30),
              child: Obx(() {
                final detail = Get.find<CityController>().details;

                print("🔍 details length: ${detail.length}");

                if (detail.isEmpty) {
                  return Center(
                    child: Text(
                      "no data",
                      style: context.textTheme.bodyLarge?.copyWith(color: kWhite),
                    ),
                  );
                }

                final d = detail.first;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildInfoRow("Wind", d.wind),
                    buildInfoRow("Humidity", d.humidity),
                    buildInfoRow("Atm pressure", d.pressure),
                    buildInfoRow("Water", d.precip),
                    buildInfoRow("Moonrise", d.moonrise),
                    buildInfoRow("Moonset", d.moonset),
                  ],
                );
              }),
            ),

            Divider(
              color: textGreyColor, // Line color
              thickness: 1, // Line thickness
            ),
            Weather_forter(),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

Widget buildInfoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: kWhite)),
        Text(value, style: TextStyle(color: kWhite)),
      ],
    ),
  );
}
