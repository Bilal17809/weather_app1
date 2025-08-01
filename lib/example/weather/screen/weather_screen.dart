import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../../data/model/city_model.dart';
import '../../city/ctr/e_city_controller.dart';
import '../../city/view/cityname.dart';
import '../../daily/controller/daily_controller.dart';
import '../../home/screen/home_screen.dart';
import '../../hourly/ctr/e_hourly_controler.dart';
import '../../hourly/view/E_hourly_screen.dart';
import '../controller/e_weather_controller.dart';

class SelectedDayDetailsWidget extends StatelessWidget {
  final SelectedDayWeatherController controller = Get.find();
  final E_CityController ctr = Get.put(E_CityController());
  final E_HourlyForecastController hourlyController = Get.put(E_HourlyForecastController());


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenhight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgDark2,

        title: Obx(() {
          final detail = controller.selectedDayDetail.value;
          final city = controller.selectedCity.value;
          if (detail == null) return SizedBox();
          return Column(
            children: [
              Text(
                city?.city ?? "Unknown City",
                style: context.textTheme.bodyLarge?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: kWhite,
                ),
              ),
              Text(
                "${detail.dayName}, ${detail.date}",
                style: TextStyle(
                  fontSize: 18,
                  color: kWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        }),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle, color: kWhite),
            onPressed: () async {
              final selectedCity = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CitySelectionScreen()),
              );

              if (selectedCity != null && selectedCity is Malta) {
                // 1. Fetch weather


                // 2. ✅ Update selected city in controller
                Get.find<SelectedDayWeatherController>().selectedCity.value = selectedCity;

                // 3. ✅ Fetch hourly forecast
                await Get.find<E_HourlyForecastController>().fetchHourlyForecast(
                  selectedCity.lat,
                  selectedCity.lng,
                );

                // 4. ✅ Fetch daily forecast
                await Get.find<E_DailyForecastController>().fetchDailyForecast(
                  selectedCity.lat,
                  selectedCity.lng,
                );

                print("✅ selectedCity updated: ${selectedCity.city}");
              }
            },
          ),
        ],
      ),

      body: Container(
        decoration: bgwithgradent,
        padding: const EdgeInsets.all(10),
        child: Obx(() {
          final detail = controller.selectedDayDetail.value;
          if (detail == null) return SizedBox();

          return Column(
            children: [
              Image.network(
                "https:${detail.conditionIcon.replaceAll('64x64', '128x128')}",
                width: screenWidth * 0.5,
                // height: screenhight * 0.5,
                fit: BoxFit.contain,
              ),
              Text(
                detail.conditionText,
                style: TextStyle(fontSize: 19, color: kWhite),
              ),

              SizedBox(height: 10),
              Divider(),
              _buildInfoTile("Wind", "${detail.wind} m/s"),
              _buildInfoTile("Humidity", "${detail.humidity}%"),
              _buildInfoTile("Pressure", "${detail.pressure} mmHg"),
              _buildInfoTile("Water", "${detail.water}°"),
              _buildInfoTile("Moonrise", detail.moonrise),
              _buildInfoTile("Moonset", detail.moonset),
              Divider(),
              Obx(() {
                if (hourlyController.hourlyWeatherList.isEmpty) {
                  return const CircularProgressIndicator(color: Colors.white);
                }
                return E_HourlyCastWidget(hourlyData: hourlyController.hourlyWeatherList
                  ,removeBackground: true,);
              }),



            ],
          );
        }),
      ),
    );
  }

  Widget _buildInfoTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 30, right: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: kWhite)),
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, color: kWhite),
          ),
        ],
      ),
    );
  }
}
