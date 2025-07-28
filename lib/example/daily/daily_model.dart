class E_DailyForecast {
  final String date;
  final String dayName;
  final double minTemp;
  final double maxTemp;
  final String conditionText;
  final String conditionIcon;

  E_DailyForecast({
    required this.date,
    required this.dayName,
    required this.minTemp,
    required this.maxTemp,
    required this.conditionText,
    required this.conditionIcon,
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
    );
  }

  static String _getWeekdayName(int weekday) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[(weekday - 1) % 7];
  }
}
