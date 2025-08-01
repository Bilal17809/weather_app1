import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Required for date formatting
import 'package:weather/data/model/city_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../city/ctr/e_city_controller.dart';
import '../../weather/controller/e_weather_controller.dart';
import '../../weather/screen/weather_screen.dart';
import '../controller/daily_controller.dart';

class E_DailyForecastWidget extends StatelessWidget {
  final E_DailyForecastController dcontroller;
  final bool isCurrentLocation;
  final selectedDayController = Get.find<SelectedDayWeatherController>();

  E_DailyForecastWidget({
    super.key,
    required this.dcontroller,
    this.isCurrentLocation = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final today = DateFormat(
      'yyyy-MM-dd',
    ).format(DateTime.now()); // 👈 Get today's date in same format

    return Obx(() {
      final forecast =
          isCurrentLocation
              ? dcontroller.currentLocationForecast
              : dcontroller.selectedCityForecast;

      if (forecast.isEmpty) {
        return const Center(
          child: Text(
            "No daily forecast available.",
            style: TextStyle(color: Colors.white),
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.only(top: 2),
        child: SizedBox(
          height: screenHeight * 0.24,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: forecast.length,
            itemBuilder: (context, index) {
              final day = forecast[index];
              final isToday = day.date == today; // 👈 Compare with today's date

              return InkWell(
                onTap: () {
                  final selectedCity =
                      Get.find<SelectedDayWeatherController>()
                          .selectedCity
                          .value;
                  print("no working");

                  if (selectedCity != null) {
                    selectedDayController.updateSelectedDay(day, selectedCity);
                    print("✅ selectedCity is set: ${selectedCity.city}");
                    Get.to(() => SelectedDayDetailsWidget());
                  } else {
                    print("❌ selectedCity is null!");
                  }
                },

                child: Container(
                  width: screenWidth * 0.23,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 1,

                  ),
                  // padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    boxShadow: isToday
                        ? [
                      BoxShadow(
                        color: Color(0xFF01474E).withOpacity(0.5), // Custom shadow color
                        blurRadius: 10.0,
                        offset: Offset(0, 4),
                        spreadRadius: 2.0,
                      ),
                    ]
                        : [],
                    gradient: isToday
                        ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF075A47), // #075A47
                        Color(0xFF029C78), // #029C78
                        Color(0xFF013847),],
                    )
                        : null,
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        "https:${day.conditionIcon.replaceAll("64x64", "128x128")}",
                        width: screenWidth * 0.19,
                        height: screenHeight * 0.09,
                      ),
                      Text(
                        day.dayName,
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          fontSize: screenWidth * 0.055,
                        ),
                      ),
                      Text(
                        "${day.maxTemp.toStringAsFixed(0)}°",
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: minitempcolor,
                          fontSize: screenWidth * 0.058,
                        ),
                      ),
                      Text(
                        "${day.minTemp.toStringAsFixed(0)}°",
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          fontSize: screenWidth * 0.058,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }
}
