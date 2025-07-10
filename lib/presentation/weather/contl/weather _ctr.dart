
import '../../../data/model/forecast.dart';

class WeatherForecastResponse {
  final List<DailyForecast> forecastDays;

  WeatherForecastResponse({required this.forecastDays});

  factory WeatherForecastResponse.fromJson(Map<String, dynamic> json) {
    final List forecastList = json['forecast']?['forecastday'] ?? [];

    return WeatherForecastResponse(
      forecastDays: forecastList
          .map((item) => DailyForecast.fromJson(item))
          .toList(),
    );
  }
}