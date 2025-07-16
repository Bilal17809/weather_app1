class HourlyWeather {
  final String time; // Keep full time string
  final double temperature;
  final String icon;

  HourlyWeather({
    required this.time,
    required this.temperature,
    required this.icon,
  });

  /// ✅ From WeatherAPI format — keep ISO datetime format
  factory HourlyWeather.fromJson(Map<String, dynamic> json) {
    return HourlyWeather(
      time: json['time'], // e.g., "2025-07-16 14:00"
      temperature: (json['temp_c'] as num).toDouble(),
      icon: "https:${json['condition']['icon']}",
    );
  }

  /// ✅ From SharedPreferences
  factory HourlyWeather.fromFlatJson(Map<String, dynamic> json) {
    return HourlyWeather(
      time: json['time'],
      temperature: (json['temperature'] as num).toDouble(),
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'temperature': temperature,
      'icon': icon,
    };
  }
}
