import 'package:get/get.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../../../data/model/forecast.dart';
import '../../weather/contl/weather _ctr.dart';

class DailyForecastController extends GetxController {
  RxList<DailyForecast> dailyList = <DailyForecast>[].obs;

  @override
  void onInit() {
    super.onInit();

    getCurrentLocationAndFetchDaily(); // 🔄 Auto-fetch on startup
  }

  Future<void> getCurrentLocationAndFetchDaily() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('❌ Location service disabled');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          print('❌ Location permission denied forever');
          return;
        }
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      print("📍 Current location: ${position.latitude}, ${position.longitude}");

      await fetchDailyForecast(position.latitude, position.longitude);
    } catch (e) {
      print("❌ Error getting location: $e");
    }
  }

  Future<void> fetchDailyForecast(double lat, double lng) async {
    final url = Uri.parse(
      'http://api.weatherapi.com/v1/forecast.json?key=07e14a15571440079f5110300250407&q=$lat,$lng&days=3&aqi=no&alerts=no',
    );


    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final forecast = WeatherForecastResponse.fromJson(data);

        dailyList.value = forecast.forecastDays;
        await saveWeeklyToPrefs();
        dailyList.refresh();

        print("✅ Got ${forecast.forecastDays.length} daily items from API");
      } else {
        print("❌ Daily API error: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Exception in fetchDailyForecast: $e");
    }
  }

  Future<void> saveWeeklyToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = dailyList.map((d) => jsonEncode(d.toJson())).toList();
    await prefs.setStringList('weekly_forecast', jsonList);
  }

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
}
