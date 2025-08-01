class E_DailyForecast {
  final String date;
  final String dayName;
  final double minTemp;
  final double maxTemp;
  final String conditionText;
  final String conditionIcon;
  final double wind;
  final int humidity;
  final double pressure;
  final double water;
  final String moonrise;
  final String moonset;

  // 🔶 New fields for air quality


  E_DailyForecast({
    required this.date,
    required this.dayName,
    required this.minTemp,
    required this.maxTemp,
    required this.conditionText,
    required this.conditionIcon,
    required this.wind,
    required this.humidity,
    required this.pressure,
    required this.water,
    required this.moonrise,
    required this.moonset,

  });

  factory E_DailyForecast.fromJson(Map<String, dynamic> json) {
    final date = json['date'];
    final weekday = DateTime.parse(date).weekday;
    final dayName = _getWeekdayName(weekday);

    return E_DailyForecast(
      date: date,
      dayName: dayName,
      minTemp: json['day']['mintemp_c']?.toDouble() ?? 0.0,
      maxTemp: json['day']['maxtemp_c']?.toDouble() ?? 0.0,
      conditionText: json['day']['condition']['text'] ?? '',
      conditionIcon: json['day']['condition']['icon'] ?? '',
      wind: json['day']['maxwind_kph']?.toDouble() ?? 0.0,
      humidity: json['day']['avghumidity']?.toInt() ?? 0,
      pressure: json['hour']?[0]['pressure_mb']?.toDouble() ?? 0.0,
      water: json['day']['avgtemp_c']?.toDouble() ?? 0.0,
      moonrise: json['astro']['moonrise'] ?? '',
      moonset: json['astro']['moonset'] ?? '',

      // ✅ Optional air quality, depends on your API structure

    );
  }

  static String _getWeekdayName(int weekday) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[(weekday - 1) % 7];
  }
}
