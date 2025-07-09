import 'package:intl/intl.dart';

class DailyForecast {
  final String date;
  final String dayName;
  final double maxTemp;
  final double minTemp;
  final double avgTemp;
  final String conditionText;
  final String iconUrl;

  DailyForecast({
    required this.date,
    required this.dayName,
    required this.maxTemp,
    required this.minTemp,
    required this.avgTemp,
    required this.conditionText,
    required this.iconUrl,
  });

  // ✅ From Weather API
  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    final parsedDate = DateTime.parse(json['date']);
    return DailyForecast(
      date: json['date'],
      dayName: DateFormat('E').format(parsedDate),
      maxTemp: (json['day']['maxtemp_c'] as num).toDouble(),
      minTemp: (json['day']['mintemp_c'] as num).toDouble(),
      avgTemp: (json['day']['avgtemp_c'] as num).toDouble(),
      conditionText: json['day']['condition']['text'],
      iconUrl: "https:${json['day']['condition']['icon']}",
    );
  }

  // ✅ From SharedPreferences
  factory DailyForecast.fromFlatJson(Map<String, dynamic> json) {
    return DailyForecast(
      date: json['date'],
      dayName: json['dayName'],
      maxTemp: (json['maxTemp'] as num).toDouble(),
      minTemp: (json['minTemp'] as num).toDouble(),
      avgTemp: (json['avgTemp'] as num).toDouble(),
      conditionText: json['conditionText'],
      iconUrl: json['iconUrl'],
    );
  }

  // ✅ To SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'dayName': dayName,
      'maxTemp': maxTemp,
      'minTemp': minTemp,
      'avgTemp': avgTemp,
      'conditionText': conditionText,
      'iconUrl': iconUrl,
    };
  }
}
