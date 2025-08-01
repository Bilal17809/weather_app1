// lib/core/services/weather_api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherApiService {
  static const _apiKey = '8e1b9cfeaccc48c4b2b85154230304';
  static const _baseUrl = 'https://api.weatherapi.com/v1';

  static Future<Map<String, dynamic>> getForecast(double lat, double lng) async {
    final url = Uri.parse(
      '$_baseUrl/forecast.json?key=$_apiKey&q=$lat,$lng&days=7&aqi=yes&alerts=no',
    );

    final res = await http.get(url);

    if (res.statusCode != 200) {
      throw Exception('Forecast API error: ${res.statusCode}');
    }

    return jsonDecode(res.body);
  }
}
