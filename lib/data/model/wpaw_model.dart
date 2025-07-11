class WeatherDetails {
  final String wind;
  final String humidity;
  final String pressure;
  final String precip;
  final String moonrise;
  final String moonset;
  final String conditionText;
  final String conditionIcon;
  final String airQualityIndex;
  final String airQualityText;

  WeatherDetails({
    required this.wind,
    required this.humidity,
    required this.pressure,
    required this.precip,
    required this.moonrise,
    required this.moonset,
    required this.conditionText,
    required this.conditionIcon,
    required this.airQualityIndex,
    required this.airQualityText,
  });

  factory WeatherDetails.fromJson(Map<String, dynamic> json) {
    final airQuality = json['current']?['air_quality'];
    final double aqi = airQuality?['pm2_5'] ?? 0.0;

    String aqiText;
    if (aqi <= 50) {
      aqiText = "Good";
    } else if (aqi <= 100) {
      aqiText = "Moderate";
    } else if (aqi <= 150) {
      aqiText = "Unhealthy (Sensitive)";
    } else if (aqi <= 200) {
      aqiText = "Unhealthy";
    } else if (aqi <= 300) {
      aqiText = "Very Unhealthy";
    } else {
      aqiText = "Hazardous";
    }

    return WeatherDetails(
      wind: '${json['current']['wind_kph']} kph ${json['current']['wind_dir']}',
      humidity: '${json['current']['humidity']}%',
      pressure: '${json['current']['pressure_mb']} mb',
      precip: '${json['current']['precip_mm']} mm',
      moonrise: json['forecast']['forecastday'][0]['astro']['moonrise'],
      moonset: json['forecast']['forecastday'][0]['astro']['moonset'],
      conditionText: json['current']['condition']['text'] ?? 'Unknown',
      conditionIcon: "https:${json['current']['condition']['icon']}",
      airQualityIndex: aqi.toStringAsFixed(0),
      airQualityText: aqiText,
    );
  }
}
