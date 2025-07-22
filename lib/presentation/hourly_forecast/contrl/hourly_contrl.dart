import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../data/model/hourly_model.dart';

class HourlyForecastController extends GetxController {
  final RxList<HourlyWeather> hourlyList = <HourlyWeather>[].obs;
  RxInt selectedHourIndex = 0.obs;
  RxDouble currentLat = 0.0.obs;
  RxDouble currentLng = 0.0.obs;
  var currentLocationDetail = Rxn<HourlyWeather>();
  var currentTemperature = 0.0.obs;
  var selectedHourTime = ''.obs;
  var setSelectedHour=''.obs;

  final ScrollController scrollController = ScrollController();

  final String apiKey = 'YOUR_API_KEY'; // Replace with your actual WeatherAPI key

  Future<void> fetchHourlyForecast(double lat, double lon) async {
    try {
      final now = DateTime.now();
      final formattedDate = DateFormat('yyyy-MM-dd').format(now);

      final url = Uri.parse(
        'http://api.weatherapi.com/v1/forecast.json?key=8e1b9cfeaccc48c4b2b85154230304&q=$lat,$lon&days=7&aqi=no&alerts=no',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> forecastHourList =
        data['forecast']['forecastday'][0]['hour']; // Only today's hourly data

        final List<HourlyWeather> parsed = forecastHourList
            .map((json) => HourlyWeather.fromJson(json))
            .toList();

        hourlyList.assignAll(parsed);

        // Save in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        final encoded = jsonEncode(parsed.map((e) => e.toJson()).toList());
        await prefs.setString('hourly_forecast', encoded);

        autoScrollToCurrentHour();

        print('✅ Hourly forecast fetched and saved (${parsed.length} items)');
      } else {
        print('❌ Failed to fetch hourly data. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('⚠️ Error fetching hourly forecast: $e');
    }
  }


  Future<void> loadFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('hourly_forecast');

    if (jsonString != null) {
      final List<dynamic> decoded = jsonDecode(jsonString);
      final restoredList =
      decoded.map((e) => HourlyWeather.fromFlatJson(e)).toList();
      hourlyList.assignAll(restoredList);

      print('📥 Loaded hourly forecast from SharedPreferences (${restoredList.length} items)');
      autoScrollToCurrentHour();
    } else {
      print('ℹ️ No saved hourly forecast found.');
    }
  }
  Future<void> loadHourlyFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? hourlyJsonList = prefs.getStringList('hourly_data');

    if (hourlyJsonList != null && hourlyJsonList.isNotEmpty) {
      final List<HourlyWeather> loadedHourly = hourlyJsonList
          .map((jsonStr) => HourlyWeather.fromFlatJson(jsonDecode(jsonStr)))
          .toList();

      hourlyList.assignAll(loadedHourly);
      hourlyList.refresh();

      if (loadedHourly.isNotEmpty) {
        currentLocationDetail.value = loadedHourly.first;
        currentTemperature.value = loadedHourly.first.temperature;
      }

      print("✅ Loaded ${loadedHourly.length} hourly items from storage");
    } else {
      print("⚠️ No hourly forecast data found in SharedPreferences");
    }
  }

  void autoScrollToCurrentHour() {
    final now = DateTime.now();
    final index = hourlyList.indexWhere((h) => h.rawTime.hour == now.hour);

    if (index != -1) {
      Future.delayed(const Duration(milliseconds: 400), () {
        scrollController.animateTo(
          index * 90.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadFromPreferences();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
