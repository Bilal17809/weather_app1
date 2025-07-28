import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'daily_controller.dart';

class E_DailyForecastWidget extends StatelessWidget {
  final E_DailyForecastController dcontroller;
  final bool isCurrentLocation; // 👈 add this flag

  const E_DailyForecastWidget({
    super.key,
    required this.dcontroller,
    this.isCurrentLocation = false, // 👈 default to false
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // 👇 Use current or selected forecast list based on flag
      final forecast = isCurrentLocation
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

      return SizedBox(
        height: 206,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: forecast.length,
          itemBuilder: (context, index) {
            final day = forecast[index];
            return Container(
              width: 120,
              margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 3),
              padding: const EdgeInsets.all(5),
              // decoration: BoxDecoration(
              //   color: Colors.white.withOpacity(0.1),
              //   borderRadius: BorderRadius.circular(12),
              // ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    day.dayName,
                    style: const TextStyle(color: Colors.white,fontSize: 25),
                  ),
                  Image.network(
                    "https:${day.conditionIcon.replaceAll("64x64", "128x128")}",
                    width: 50,
                  ),
                  Text(
                    "${day.maxTemp.toStringAsFixed(0)}° \n ${day.minTemp.toStringAsFixed(0)}°",
                    style: const TextStyle(color: Colors.white,fontSize: 25),
                  ),

                ],
              ),
            );
          },
        ),
      );
    });
  }
}
