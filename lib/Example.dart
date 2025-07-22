import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'core/common/controller/current_weather_controller.dart';

class weather_curr_loc extends StatelessWidget {
  final controller = Get.find<CurrentWeatherController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🌤 Current Weather')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Obx(() {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.cityName.value.isEmpty
                      ? '📍 Waiting for location...'
                      : '📍 ${controller.cityName.value}',
                  style: const TextStyle(fontSize: 22),
                ),
                const SizedBox(height: 16),
                Text(
                  controller.currentTemperature.value.isEmpty
                      ? '--°C'
                      : '${controller.currentTemperature.value}°C',
                  style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  controller.conditionText.value,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 16),
                controller.iconUrl.value.isNotEmpty
                    ? Image.network(controller.iconUrl.value, width: 64)
                    : const SizedBox(),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: controller.getCurrentLocationAndFetchWeather,
                  icon: const Icon(Icons.location_on),
                  label: const Text('Get Current Location Weather'),
                )
              ],
            );
          }),
        ),
      ),
    );
  }
}