class WeatherForecastResponse {
  final List<DailyForecast> forecastDays;

  WeatherForecastResponse({required this.forecastDays});

  factory WeatherForecastResponse.fromJson(Map<String, dynamic> json) {
    final forecastList = json['forecast']['forecastday'] as List;
    return WeatherForecastResponse(
      forecastDays: forecastList
          .map((item) => DailyForecast.fromJson(item))
          .toList(),
    );
  }
}

class DailyForecast {
  final String date;
  final double maxTemp;
  final double minTemp;
  final double avgTemp;
  final String conditionText;
  final String iconUrl;

  DailyForecast({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.avgTemp,
    required this.conditionText,
    required this.iconUrl,
  });

  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    return DailyForecast(
      date: json['date'],
      maxTemp: json['day']['maxtemp_c'].toDouble(),
      minTemp: json['day']['mintemp_c'].toDouble(),
      avgTemp: json['day']['avgtemp_c'].toDouble(),
      conditionText: json['day']['condition']['text'],
      iconUrl: "https:${json['day']['condition']['icon']}",
    );
  }
}
