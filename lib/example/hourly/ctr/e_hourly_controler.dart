// hourly_forecast_controller.dart
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/e_houry_model.dart';
class E_HourlyForecastController extends GetxController {
  var hourlyWeatherList = <E_HourlyWeather>[].obs;
  var isLoading = false.obs;
  Future<void> fetchHourlyForecast(double lat, double lon, {bool isCurrentLocation = false}) async {
    try {
      isLoading.value = true;
      final url = Uri.parse(
        'https://api.weatherapi.com/v1/forecast.json?key=8e1b9cfeaccc48c4b2b85154230304&q=$lat,$lon&days=7&aqi=no&alerts=no',
      );
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final forecastHours = data['forecast']['forecastday'][0]['hour'] as List;
        final now = DateTime.now();
        final currentHour = now.hour;
        final List<E_HourlyWeather> loaded = forecastHours.map((item) {
          final dateTime = DateTime.parse(item['time']);
          final hourFormatted = DateFormat('h a').format(dateTime); // AM/PM format
          return E_HourlyWeather(
            time: hourFormatted,
            temperature: "${item['temp_c']}°C",
            condition: item['condition']['text'],
            iconUrl: "https:${item['condition']['icon']}".replaceAll('64x64', '128x128'),
            isCurrentHour: dateTime.hour == currentHour,
          );
        }).toList();
        hourlyWeatherList.value = loaded;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          isCurrentLocation ? 'hourly_current_location' : 'hourly_selected_city',
          jsonEncode(loaded.map((e) => e.toJson()).toList()),
        );
      } else {
        throw Exception('Failed to fetch hourly forecast');
      }
    } catch (e) {
      print('❌ Hourly Forecast Error: $e');
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString(
        isCurrentLocation ? 'hourly_current_location' : 'hourly_selected_city',
      );
      if (cachedData != null) {
        final decoded = jsonDecode(cachedData) as List;
        hourlyWeatherList.value =
            decoded.map((e) => E_HourlyWeather.fromJson(e)).toList();
      }
    } finally {
      isLoading.value = false;
    }
  }
}
