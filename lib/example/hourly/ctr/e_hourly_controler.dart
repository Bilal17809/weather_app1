// hourly_forecast_controller.dart
import 'dart:convert';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../service/api/api_service.dart';
import '../model/e_houry_model.dart';

class E_HourlyForecastController extends GetxController {
  var hourlyWeatherList = <E_HourlyWeather>[].obs;
  var selectedHourIndex = 0.obs;
  var isLoading = false.obs;


  Future<void> fetchHourlyForecast(double lat, double lon, {bool isCurrentLocation = false}) async {
    isLoading.value = true;

    try {
      // Fetch from centralized service
      final data = await WeatherForecastService.Forecast(lat, lon);
      final forecastHours = data['forecast']['forecastday'][0]['hour'] as List;
      final now = DateTime.now();
      final currentHour = now.hour;

      // Parse forecast hours
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

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        isCurrentLocation ? 'hourly_current_location' : 'hourly_selected_city',
        jsonEncode(loaded.map((e) => e.toJson()).toList()),
      );

    } catch (e) {
      print('❌ Hourly Forecast Error: $e');

      // Load from cache
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
