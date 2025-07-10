import 'package:intl/intl.dart';

class HourlyWeather {
  final String time;
  final double temperature;
  final String icon;

  HourlyWeather({
    required this.time,
    required this.temperature,
    required this.icon,
  });

  /// ✅ From API JSON (WeatherAPI)
  factory HourlyWeather.fromJson(Map<String, dynamic> json) {
    final dateTime = DateTime.parse(json['time']);
    return HourlyWeather(
      time: DateFormat('HH:mm').format(dateTime),
      temperature: (json['temp_c'] as num).toDouble(),
      icon: "https:${json['condition']['icon']}",
    );
  }

  // /// ✅ From SharedPreferences (flat JSON)
  // factory HourlyWeather.fromFlatJson(Map<String, dynamic> json) {
  //   return HourlyWeather(
  //     time: json['time'],
  //     temperature: (json['temperature'] as num).toDouble(),
  //     icon: json['icon'],
  //   );
  // }

  /// ✅ For saving to SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'temperature': temperature,
      'icon': icon,
    };
  }
}
