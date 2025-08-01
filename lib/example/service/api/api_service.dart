import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherForecastService {
  static const String apiKey = '8e1b9cfeaccc48c4b2b85154230304';

  static Future<Map<String, dynamic>> Forecast(double lat, double lon) async {
    final url = Uri.parse(
      'https://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$lat,$lon&days=7&aqi=yes&alerts=yes',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('❌ Failed to fetch forecast');
    }
  }
}
