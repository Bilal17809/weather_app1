
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../data/model/forecast.dart';
import '../../../data/model/wpaw_model.dart';

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
