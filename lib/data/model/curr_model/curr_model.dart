import 'package:intl/intl.dart';

class HourlyWeather {
  final String time;            // Formatted time e.g. 9:00 PM
  final double temperature;     // Celsius
  final String icon;            // Icon URL

  HourlyWeather({
    required this.time,
    required this.temperature,
    required this.icon,
  });

  factory HourlyWeather.fromJson(Map<String, dynamic> json) {
    final rawTime = json['time'] ?? '';
    final dateTime = DateTime.tryParse(rawTime)?.toLocal() ?? DateTime.now();

    final formattedTime = DateFormat('HH:mm').format(dateTime); // 24-hour local time

    final temp = (json['temp_c'] as num?)?.toDouble() ?? 0.0;
    final icon = "https:${json['condition']?['icon'] ?? ''}";

    return HourlyWeather(
      time: formattedTime,
      temperature: temp,
      icon: icon,
    );
  }


  Map<String, dynamic> toJson() => {
    'time': time,
    'temperature': temperature,
    'icon': icon,
  };
}
