import 'dart:convert';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/model/hourly_model.dart';

class HourlyForecastController extends GetxController {
  RxList<HourlyWeather> hourlyList = <HourlyWeather>[].obs;

  RxInt selectedHourIndex = 0.obs;
  var currentLat = 0.0.obs;
  var currentLng = 0.0.obs;
  var currentLocationDetail = Rxn<HourlyWeather>();
  var currentTemperature = 0.0.obs;
  var selectedHourTime = ''.obs;

  final ScrollController scrollController = ScrollController();

  /// ✅ Converts current time to Malta local time (UTC+2)
  DateTime getMaltaTime() {
    return DateTime.now().toUtc().add(const Duration(hours: 2));
  }

  void setSelectedHour(String hour) {
    selectedHourTime.value = hour;
  }

  void autoScrollToCurrentHour() {
    if (hourlyList.isEmpty) return;

    final now = getMaltaTime(); // ✅ Use Malta local time

    print("📍 Malta local time: ${now.hour}:${now.minute}");

    for (int i = 0; i < hourlyList.length; i++) {
      final h = hourlyList[i];
      final apiHour = h.rawTime.hour;

      if (apiHour == now.hour) {
        selectedHourIndex.value = i;

        Future.delayed(const Duration(milliseconds: 200), () {
          final offset = (i * 90).toDouble();
          scrollController.animateTo(
            offset,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        });

        print("✅ Found matching hour: $apiHour at index $i");
        break;
      }
    }
  }

  void setHourlyForecast(List<HourlyWeather> data) {
    hourlyList.value = data;
    autoScrollToCurrentHour();
  }

  void updateSelectedHour(int index) {
    selectedHourIndex.value = index;
  }

  /// ✅ Fetch hourly forecast for a specific lat/lng
  Future<void> fetchHourlyForecast(double lat, double lng) async {
    print("📡 fetchHourlyForecast() called for $lat, $lng");

    final url = Uri.parse(
      'http://api.weatherapi.com/v1/forecast.json?key=8e1b9cfeaccc48c4b2b85154230304&q=$lat,$lng&days=1&aqi=no&alerts=no',
    );

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List allHours = (data['forecast']['forecastday'] as List)
            .expand((day) => day['hour'] as List)
            .toList();

        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);

        final start = today;
        final end = today.add(const Duration(hours: 23));

        final filteredHours = allHours
            .where((h) {
          final dt = DateTime.parse(h['time']);
          return dt.isAfter(start.subtract(const Duration(minutes: 1))) &&
              dt.isBefore(end.add(const Duration(minutes: 1)));
        })
            .map((e) => HourlyWeather.fromJson(e))
            .toList();

        hourlyList.value = filteredHours;

        // Save current condition and temperature
        if (filteredHours.isNotEmpty) {
          currentLocationDetail.value = filteredHours.first;
          currentTemperature.value = filteredHours.first.temperature;
        }

        await saveHourlyToPrefs();
        hourlyList.refresh();

        print("✅ Got ${filteredHours.length} hourly items from 00:00 to 23:00");

        autoScrollToCurrentHour();
      } else {
        print("❌ Hourly API error: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Exception in fetchHourlyForecast: $e");
    }
  }

  /// ✅ Fetch hourly forecast using stored currentLat and currentLng
  Future<void> fetchCurrentLocationForecast() async {
    if (currentLat.value == 0.0 || currentLng.value == 0.0) {
      print("⚠️ Location coordinates not set.");
      return;
    }

    await fetchHourlyForecast(currentLat.value, currentLng.value);
  }

  /// ✅ Load data from SharedPreferences
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

  /// ✅ Save data to SharedPreferences
  Future<void> saveHourlyToPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> hourlyJsonList = hourlyList.map((h) {
      return jsonEncode(h.toJson());
    }).toList();

    print("💾 Saving ${hourlyJsonList.length} hourly items to SharedPreferences");

    await prefs.setStringList('hourly_data', hourlyJsonList);
  }

  @override
  void onInit() {
    super.onInit();
    loadHourlyFromPrefs();

    // Optional: auto-fetch if coordinates are already set
    if (currentLat.value != 0.0 && currentLng.value != 0.0) {
      fetchCurrentLocationForecast();
    }
  }
}


