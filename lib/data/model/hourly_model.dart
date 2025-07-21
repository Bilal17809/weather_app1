import 'package:intl/intl.dart';

class HourlyWeather {
  final String time; // e.g., "08:00 AM"
  final double temperature;
  final String icon;
  final DateTime rawTime; // <-- new field to hold actual DateTime

  HourlyWeather({
    required this.time,
    required this.temperature,
    required this.icon,
    required this.rawTime,
  });

  factory HourlyWeather.fromJson(Map<String, dynamic> json) {
    final dateTime = DateTime.parse(json['time']);
    return HourlyWeather(
      time: DateFormat('hh:mm a').format(dateTime),
      rawTime: dateTime, // Save original
      temperature: (json['temp_c'] as num).toDouble(),
      icon: "https:${json['condition']['icon']}",
    );
  }

  Map<String, dynamic> toJson() => {
    'time': time,
    'temperature': temperature,
    'icon': icon,
    'rawTime': rawTime.toIso8601String(), // save in prefs
  };

  factory HourlyWeather.fromFlatJson(Map<String, dynamic> json) {
    return HourlyWeather(
      time: json['time'],
      temperature: json['temperature'],
      icon: json['icon'],
      rawTime: DateTime.parse(json['rawTime']),
    );
  }
}
