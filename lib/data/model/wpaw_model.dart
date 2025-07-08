class WeatherDetails {
  final String wind;
  final String humidity;
  final String pressure;
  final String precip;
  final String moonrise;
  final String moonset;

  WeatherDetails({
    required this.wind,
    required this.humidity,
    required this.pressure,
    required this.precip,
    required this.moonrise,
    required this.moonset,
  });

  factory WeatherDetails.fromJson(Map<String, dynamic> json) {
    return WeatherDetails(
      wind: '${json['current']['wind_kph']} kph ${json['current']['wind_dir']}',
      humidity: '${json['current']['humidity']}%',
      pressure: '${json['current']['pressure_mb']} mb',
      precip: '${json['current']['precip_mm']} mm',
      moonrise: json['forecast']['forecastday'][0]['astro']['moonrise'],
      moonset: json['forecast']['forecastday'][0]['astro']['moonset'],
    );
  }
}
