import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../core/common/controller/controller.dart';
import '../../../data/model/hourly_model.dart';
import '../../weather/contl/weather_service.dart';


class HourlyForecastController extends GetxController {
  final RxList<HourlyWeather> hourlyList = <HourlyWeather>[].obs;
  final RxInt selectedHourIndex = 0.obs;
  final RxDouble Lat = 0.0.obs;
  final RxDouble Lng = 0.0.obs;

  final Rx<HourlyWeather?> currentLocationDetail = Rx<HourlyWeather?>(null);
  final RxDouble currentTemperature = 0.0.obs;
  final RxString selectedHourTime = ''.obs;
  final RxString setSelectedHour = ''.obs;
  final RxString conditionText = ''.obs;
  final RxString iconUrl = ''.obs;

  final ScrollController scrollController = ScrollController();

  /// ✅ Load hourly forecast from SharedPreferences based on selected city
  Future<void> loadFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final city = Get.find<CityController>().selectedCity.value;
    final cityKey = 'hourly_forecast_$city';

    final jsonString = prefs.getString(cityKey);

    if (jsonString != null) {
      final List<dynamic> decoded = jsonDecode(jsonString);
      final List<HourlyWeather> restoredList =
      decoded.map((e) => HourlyWeather.fromFlatJson(e)).toList();

      hourlyList.assignAll(restoredList);

      if (restoredList.isNotEmpty) {
        currentLocationDetail.value = restoredList.first;
        currentTemperature.value = restoredList.first.temperature;
      }

      print('📥 Loaded $city hourly forecast from SharedPreferences (${restoredList.length} items)');
      autoScrollToCurrentHour();
    } else {
      print('ℹ️ No saved hourly forecast found for $city.');
    }
  }

  /// ✅ Check internet and fetch fresh forecast if online
  Future<void> fetchFullForecastForCurrentLocation() async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      print('📴 Offline – skipping API fetch');
      return;
    }

    await WeatherForecastService.fetchWeatherForecast(Lat.value, Lng.value);
  }

  /// ✅ Auto-scroll to current hour in the horizontal hourly scroll list
  void autoScrollToCurrentHour() {
    final now = DateTime.now();
    final index = hourlyList.indexWhere((h) => h.rawTime.hour == now.hour);

    if (index != -1) {
      Future.delayed(const Duration(milliseconds: 400), () {
        scrollController.animateTo(
          index * 90.0, // Adjust based on card width
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadFromPreferences(); // Load offline cache
    fetchFullForecastForCurrentLocation(); // Try online fetch
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
