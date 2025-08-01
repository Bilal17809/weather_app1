// lib/data/model/hourly_model.dart
import 'package:intl/intl.dart';

class HourlyWeather {
  final String time;
  final double temperature;
  final String icon;
  final DateTime rawTime;

  HourlyWeather({required this.time, required this.temperature, required this.icon, required this.rawTime});

  factory HourlyWeather.fromJson(Map<String, dynamic> j) {
    final dt = DateTime.parse(j['time']);
    return HourlyWeather(
      rawTime: dt,
      time: DateFormat('hh:mm a').format(dt),
      temperature: (j['temp_c'] as num).toDouble(),
      icon: 'https:${j['condition']['icon']}',
    );
  }

  Map<String, dynamic> toJson() => {
    'time': time, 'temperature': temperature, 'icon': icon, 'rawTime': rawTime.toIso8601String()
  };

  factory HourlyWeather.fromFlatJson(Map<String, dynamic> j) {
    return HourlyWeather(
      rawTime: DateTime.parse(j['rawTime']),
      time: j['time'],
      temperature: (j['temperature'] as num).toDouble(),
      icon: j['icon'],
    );
  }
}
