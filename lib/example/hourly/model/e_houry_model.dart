class E_HourlyWeather {
  final String time;
  final String temperature;
  final String condition;
  final String iconUrl;
  final bool isCurrentHour;

  E_HourlyWeather({
    required this.time,
    required this.temperature,
    required this.condition,
    required this.iconUrl,
    this.isCurrentHour = false,
  });

  factory E_HourlyWeather.fromJson(Map<String, dynamic> json) {
    return E_HourlyWeather(
      time: json['time'],
      temperature: json['temperature'],
      condition: json['condition'],
      iconUrl: json['iconUrl'],
      isCurrentHour: json['isCurrentHour'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'temperature': temperature,
      'condition': condition,
      'iconUrl': iconUrl,
      'isCurrentHour': isCurrentHour,
    };
  }
}
