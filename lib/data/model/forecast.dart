// lib/data/model/forecast.dart
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

  factory DailyForecast.fromJson(Map<String, dynamic> j) {
    final d = j['day'];
    final dateStr = j['date'];
    final dayName = DateFormat('EEEE').format(DateTime.parse(dateStr));
    return DailyForecast(
      date: dateStr,
      dayName: dayName,
      maxTemp: (d['maxtemp_c'] as num).toDouble(),
      minTemp: (d['mintemp_c'] as num).toDouble(),
      avgTemp: (d['avgtemp_c'] as num).toDouble(),
      conditionText: d['condition']['text'],
      iconUrl: 'https:${d['condition']['icon']}',
    );
  }

  factory DailyForecast.fromFlatJson(Map<String, dynamic> j) => DailyForecast(
    date: j['date'], dayName: j['dayName'],
    maxTemp: (j['maxTemp'] as num).toDouble(),
    minTemp: (j['minTemp'] as num).toDouble(),
    avgTemp: (j['avgTemp'] as num).toDouble(),
    conditionText: j['conditionText'], iconUrl: j['iconUrl'],
  );

  Map<String, dynamic> toJson() => {
    'date': date, 'dayName': dayName,
    'maxTemp': maxTemp, 'minTemp': minTemp,
    'avgTemp': avgTemp,
    'conditionText': conditionText,
    'iconUrl': iconUrl,
  };
}
