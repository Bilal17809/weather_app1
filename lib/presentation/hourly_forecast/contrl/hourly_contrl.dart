import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/model/hourly_model.dart';

class HourlyForecastController extends GetxController {
  RxList<HourlyWeather> hourlyList = <HourlyWeather>[].obs;

  final String apiKey = '7d7cead5f21da78ea50ea22ff44f5797';

  Future<void> fetchHourlyForecast(double lat, double lng) async {
    final url = Uri.parse(
      'http://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$lat,$lng&days=7&aqi=no&alerts=no',
    );
    final response = await http.get(url).timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List allHours = (data['forecast']['forecastday'] as List)
          .expand((day) => day['hour'] as List)
          .toList();
      final now = DateTime.now().toUtc();
      final next24 = allHours
          .where((h) {
        final dt = DateTime.parse(h['time']).toUtc();
        return dt.isAfter(now);
      })
          .take(24)
          .map((e) => HourlyWeather.fromJson(e))
          .toList();

      hourlyList.value = next24;
      hourlyList.refresh();
      await saveHourlyToPrefs();
    }
  }

  Future<void> saveHourlyToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> hourlyJsonList =
    hourlyList.map((h) => jsonEncode(h.toJson())).toList();
    await prefs.setStringList('hourly_data', hourlyJsonList);
  }

  Future<void> loadHourlyFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? hourlyJsonList = prefs.getStringList('hourly_data');

    if (hourlyJsonList != null) {
      final List<HourlyWeather> loadedHourly =
      hourlyJsonList
          .map((jsonStr) => HourlyWeather.fromJson(jsonDecode(jsonStr)))
          .toList();
      hourlyList.assignAll(loadedHourly);
    }
  }
}
