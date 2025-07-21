import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/model/hourly_model.dart';

class HourlyForecastController extends GetxController {
  RxList<HourlyWeather> hourlyList = <HourlyWeather>[].obs;


  @override
  void onInit() {
    super.onInit();
    loadHourlyFromPrefs(); // ✅ Load saved data at startup
  }

  /// ✅ Fetch next 24 hours from API
  Future<void> fetchHourlyForecast(double lat, double lng) async {
    print("📡 fetchHourlyForecast() called for $lat, $lng");

    final url = Uri.parse(
      'http://api.weatherapi.com/v1/forecast.json?key=07e14a15571440079f5110300250407&q=$lat,$lng&days=7&aqi=no&alerts=no',
    );

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List allHours = (data['forecast']['forecastday'] as List)
            .expand((day) => day['hour'] as List)
            .toList();

        final now = DateTime.now(); // ✅ Use local time
        final next24 = allHours
            .where((h) {
          final dt = DateTime.parse(h['time']);
          return dt.isAfter(now);
        })
            .take(24)
            .map((e) => HourlyWeather.fromJson(e))
            .toList();

        hourlyList.value = next24;
        await saveHourlyToPrefs();
        hourlyList.refresh();

        print("✅ Got ${allHours.length} total hours from API");
        print("⏰ Now: $now");
        print("⏭️ Filtered ${next24.length} upcoming hours");
      } else {
        print("❌ Hourly API error: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Exception in fetchHourlyForecast: $e");
    }
  }

  /// ✅ Save to SharedPreferences using flat JSON
  Future<void> saveHourlyToPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> hourlyJsonList = hourlyList.map((h) {
      return jsonEncode({
        'time': h.time,
        'temperature': h.temperature,
        'icon': h.icon,
      });
    }).toList();

    print("💾 Saving ${hourlyJsonList.length} hourly items to SharedPreferences");

    await prefs.setStringList('hourly_data', hourlyJsonList);
  }

  /// ✅ Load from SharedPreferences using flat parser
  Future<void> loadHourlyFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? hourlyJsonList = prefs.getStringList('hourly_data');

    if (hourlyJsonList != null && hourlyJsonList.isNotEmpty) {
      final List<HourlyWeather> loadedHourly = hourlyJsonList
          .map((jsonStr) => HourlyWeather.fromFlatJson(jsonDecode(jsonStr)))
          .toList();

      hourlyList.assignAll(loadedHourly);
      hourlyList.refresh();

      print("✅ Loaded ${loadedHourly.length} hourly items from storage");
    } else {
      print("⚠️ No hourly forecast data found in SharedPreferences");
    }
  }
}
