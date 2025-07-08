import 'package:intl/intl.dart';

class HourlyWeather {
  final String day; // e.g. "Mon"
  final String time; // e.g. "9:00 AM"
  final double temperature;
  final double tempMin;
  final double tempMax;
  final String icon;

  HourlyWeather({
    required this.day,
    required this.time,
    required this.temperature,
    required this.tempMin,
    required this.tempMax,
    required this.icon,
  });

  factory HourlyWeather.fromJson(Map<String, dynamic> json) {
    // Parse the date and time from the API
    final dateTime = DateTime.parse(json['time']);

    // Format the day and time
    final formattedDay = DateFormat('E').format(dateTime); // e.g. "Mon"
    final formattedTime = DateFormat('HH:mm').format(dateTime); // e.g. "9:00 AM"

    // Safely get temperature
    final double temp = (json['temp_c'] as num?)?.toDouble() ?? 0.0;

    // Safely get weather icon
    final String iconUrl = "https:${json['condition']?['icon'] ?? ''}";

    return HourlyWeather(
      day: formattedDay,
      time: formattedTime,
      temperature: temp,
      tempMin: temp, // fallback (API does not provide hourly min/max)
      tempMax: temp,
      icon: iconUrl,
    );
  }

  Map<String, dynamic> toJson() => {
    'day': day,
    'time': time,
    'temperature': temperature,
    'tempMin': tempMin,
    'tempMax': tempMax,
    'icon': icon,
  };
}
