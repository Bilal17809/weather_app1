import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/model/hourly_model.dart';
import '../../weather/contl/weather_service.dart';

class HourlyForecastController extends GetxController {
  var currentLocationHourlyList = <HourlyWeather>[].obs;
  var selectedCityHourlyList = <HourlyWeather>[].obs;

  var selectedHourIndex = 0.obs;
  var useCurrentLocation = true.obs;

  final scrollController = ScrollController();

  /// Dynamic list for the UI
  List<HourlyWeather> get hourlyList =>
      useCurrentLocation.value ? currentLocationHourlyList : selectedCityHourlyList;

  /// ✅ Fetch and store hourly for current location
  Future<void> fetchHourlyForCurrentLocation(double lat, double lng) async {
    try {
      final json = await WeatherApiService.getForecast(lat, lng);
      final list = (json['forecast']['forecastday'][0]['hour'] as List)
          .map((e) => HourlyWeather.fromJson(e)).toList();
      currentLocationHourlyList.assignAll(list);
      useCurrentLocation.value = true;
      autoSelectCurrentHour();

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('hourly_forecast_current_location',
          jsonEncode(list.map((i) => i.toJson()).toList()));
    } catch (e) {
      print('❌ fetchHourlyForCurrentLocation error: $e');
    }
  }

  /// ✅ Fetch and store hourly for selected city
  Future<void> fetchHourlyForSelectedCity(double lat, double lng) async {
    try {
      final json = await WeatherApiService.getForecast(lat, lng);
      final list = (json['forecast']['forecastday'][0]['hour'] as List)
          .map((e) => HourlyWeather.fromJson(e)).toList();
      selectedCityHourlyList.assignAll(list);
      useCurrentLocation.value = false;
      autoSelectCurrentHour();

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('hourly_forecast_selected_city',
          jsonEncode(list.map((i) => i.toJson()).toList()));
    } catch (e) {
      print('❌ fetchHourlyForSelectedCity error: $e');
    }
  }

  /// ✅ Load both from local storage
  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    final currentData = prefs.getString('hourly_forecast_current_location');
    if (currentData != null) {
      final list = (jsonDecode(currentData) as List)
          .map((j) => HourlyWeather.fromFlatJson(j)).toList();
      currentLocationHourlyList.assignAll(list);
    }

    final selectedData = prefs.getString('hourly_forecast_selected_city');
    if (selectedData != null) {
      final list = (jsonDecode(selectedData) as List)
          .map((j) => HourlyWeather.fromFlatJson(j)).toList();
      selectedCityHourlyList.assignAll(list);
    }

    autoSelectCurrentHour();
  }

  void autoSelectCurrentHour() {
    final nowHour = DateFormat('hh:00 a').format(DateTime.now());
    final i = hourlyList.indexWhere((h) => h.time == nowHour);
    if (i >= 0) selectedHourIndex.value = i;
  }

  void autoScrollToCurrentHour() {
    Future.delayed(Duration(milliseconds: 400), () {
      final i = selectedHourIndex.value;
      scrollController.animateTo(
        i * 100.0,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }
}
