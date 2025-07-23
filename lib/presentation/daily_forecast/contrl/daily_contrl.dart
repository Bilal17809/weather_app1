import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/model/forecast.dart';
import '../../weather/contl/weather_service.dart';

class DailyForecastController extends GetxController {
  RxList<DailyForecast> dailyList = <DailyForecast>[].obs;
  final selectedDayIndex = 0.obs;

  /// ✅ Coordinates for current location
  final RxDouble Lat = 0.0.obs;
  final RxDouble Lng = 0.0.obs;

  /// ✅ Fetch daily forecast for any given lat/lng
  Future<void> fetchFullForecastForCurrentLocation() async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      print('📴 Offline – skipping API fetch');
      return;
    }
    await WeatherForecastService.fetchWeatherForecast(Lat.value, Lng.value);
  }


  /// ✅ Fetch forecast using stored current location
  Future<void> fetchCurrentLocationForecast() async {
    if (Lat.value == 0.0 || Lng.value == 0.0) {
      print("⚠️ Coordinates not set for current location forecast");
      return;
    }

    await WeatherForecastService.fetchWeatherForecast(Lat.value, Lng.value);
  }

  /// ✅ Save forecast to SharedPreferences
  Future<void> saveWeeklyToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = dailyList.map((d) => jsonEncode(d.toJson())).toList();
    await prefs.setStringList('weekly_forecast', jsonList);
  }

  /// ✅ Load forecast from SharedPreferences
  Future<void> loadWeeklyFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? jsonList = prefs.getStringList('weekly_forecast');

    if (jsonList != null && jsonList.isNotEmpty) {
      final List<DailyForecast> loaded = jsonList
          .map((str) => DailyForecast.fromFlatJson(jsonDecode(str)))
          .toList();

      dailyList.assignAll(loaded);
      dailyList.refresh();
      print("✅ Loaded ${loaded.length} weekly forecast items from storage");
    } else {
      print("⚠️ No weekly forecast data found in storage");
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadWeeklyFromPrefs();

    // Optionally auto-fetch if coordinates are set
    if (Lat.value != 0.0 && Lng.value != 0.0) {
      fetchCurrentLocationForecast();
    }
  }
}
