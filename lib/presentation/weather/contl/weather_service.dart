import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:weather/presentation/weather/contl/weather%20_ctr.dart';

import '../../../data/model/hourly_model.dart';
import '../../daily_forecast/contrl/daily_contrl.dart';
import '../../hourly_forecast/contrl/hourly_contrl.dart';

class WeatherForecastService {
  /// Master function: fetch daily, hourly, and temperature from one API call
  static Future<void> fetchWeatherForecast(double lat, double lon) async {
    final url = Uri.parse(

      'https://api.weatherapi.com/v1/forecast.json?key=8e1b9cfeaccc48c4b2b85154230304&q=$lat,$lon&days=7&aqi=no&alerts=no',
    );
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        /// ✅ 1. Store current temperature
        final temp = data['current']?['temp_c'];
        if (temp != null) {
          final temperature = (temp as num).toDouble();
          final prefs = await SharedPreferences.getInstance();
          await prefs.setDouble('last_temperature', temperature);
          print("🌡️ Temperature: $temperature°C");
        } else {
          print("⚠️ 'current.temp_c' not found in response");
        }

        /// ✅ 2. Parse daily forecast
        final forecast = WeatherForecastResponse.fromJson(data);
        final dailyForecastController = Get.find<DailyForecastController>();
        dailyForecastController.dailyList.value = forecast.forecastDays;
        await dailyForecastController.saveWeeklyToPrefs();
        dailyForecastController.dailyList.refresh();
        print("✅ Loaded ${forecast.forecastDays.length} daily forecast items");

        /// ✅ 3. Parse today's hourly forecast
        final List<dynamic> hourData = data['forecast']['forecastday'][0]['hour'];
        final List<HourlyWeather> parsedHours =
        hourData.map((json) => HourlyWeather.fromJson(json)).toList();

        final hourlyForecastController = Get.find<HourlyForecastController>();
        hourlyForecastController.hourlyList.assignAll(parsedHours);

        final prefs = await SharedPreferences.getInstance();
        final encoded = jsonEncode(parsedHours.map((e) => e.toJson()).toList());
        await prefs.setString('hourly_forecast', encoded);

        hourlyForecastController.autoScrollToCurrentHour();

        print("✅ Hourly forecast saved (${parsedHours.length} hours)");
      } else {
        print("❌ Weather API error: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Exception in fetchWeatherForecast: $e");
    }
  }

  /// Reuse temperature if only temperature is needed
  static Future<double?> loadLastTemperature() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('last_temperature');
  }
}
