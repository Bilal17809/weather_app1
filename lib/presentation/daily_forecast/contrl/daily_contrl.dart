import 'package:get/get.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../core/common/controller/controller.dart';
import '../../../data/model/forecast.dart';
import '../../weather/contl/weather _ctr.dart';

class DailyForecastController extends GetxController {
  RxList<DailyForecast> dailyList = <DailyForecast>[].obs;
  final selectedDayIndex = 0.obs; // or selectedDate = Rx<DateTime>()




  Future<void> fetchDailyForecast(double lat, double lng) async {
    final url = Uri.parse(
      'http://api.weatherapi.com/v1/forecast.json?key=8e1b9cfeaccc48c4b2b85154230304&q=$lat,$lng&days=7&aqi=no&alerts=no',
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
