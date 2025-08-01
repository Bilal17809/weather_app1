// lib/data/model/weather_detail.dart
class WeatherDetail {
  final String wind,
      humidity,
      pressure,
      precip,
      moonrise,
      moonset,
      conditionText,
      conditionIcon,
      airQualityIndex,
      airQualityText;
  final double lat;
  final double lng;
  final String city;

  WeatherDetail({
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
    required this.lat,
    required this.lng,
    required this.city,
  });

  factory WeatherDetail.fromJson(Map<String, dynamic> json) {
    final c = json['current'];
    final location = json['location'];
    final fday = json['forecast']['forecastday'][0];
    // final d = fday['day'];
    final aqiVal = (c['air_quality']?['pm2_5'] as num?)?.toDouble() ?? 0.0;

    String aqiText;
    if (aqiVal <= 50)
      aqiText = 'Good';
    else if (aqiVal <= 100)
      aqiText = 'Moderate';
    else if (aqiVal <= 150)
      aqiText = 'Unhealthy (Sensitive)';
    else if (aqiVal <= 200)
      aqiText = 'Unhealthy';
    else if (aqiVal <= 300)
      aqiText = 'Very Unhealthy';
    else
      aqiText = 'Hazardous';

    return WeatherDetail(
      wind: '${c['wind_kph']} kph ${c['wind_dir']}',
      humidity: '${c['humidity']}%',
      pressure: '${c['pressure_mb']} mb',
      precip: '${c['precip_mm']} mm',
      moonrise: fday['astro']['moonrise'],
      moonset: fday['astro']['moonset'],
      conditionText: c['condition']['text'],
      conditionIcon: 'https:${c['condition']['icon']}',
      airQualityIndex: aqiVal.toStringAsFixed(0),
      airQualityText: aqiText,
      lat: (location['lat'] as num).toDouble(),
      lng: (location['lon'] as num).toDouble(),
      city: location['name'] ?? '',
    );
  }
}
