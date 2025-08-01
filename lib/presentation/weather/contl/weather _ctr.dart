import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/presentation/weather/contl/weather_service.dart';

import '../../../data/model/wpaw_model.dart';

class WeatherController extends GetxController {
  var details = <WeatherDetail>[].obs;

  Future<void> fetchWeatherDetail({required double lat, required double lng}) async {
    try {
      final data =  await WeatherApiService.getForecast(lat, lng);
      final weatherDetail = WeatherDetail.fromJson(data);

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('weather_${lat}_$lng', jsonEncode(data));

      details.assign(weatherDetail);
    } catch (e) {
      print("❌ Error fetching weather detail: $e");

      // Try loading from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString('weather_${lat}_$lng');

      if (cached != null) {
        final decoded = jsonDecode(cached);
        details.assign(WeatherDetail.fromJson(decoded));
      }
    }
  }
}
