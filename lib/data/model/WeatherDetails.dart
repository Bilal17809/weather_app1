// class WeatherDetail {
//   final String conditionText;
//   final String conditionIcon;
//
//   WeatherDetail({
//     required this.conditionText,
//     required this.conditionIcon,
//   });
//
//   factory WeatherDetail.fromJson(Map<String, dynamic> json) {
//     return WeatherDetail(
//       conditionText: json['text'] ?? '',
//       conditionIcon: "https:${json['icon'] ?? ''}",
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     'text': conditionText,
//     'icon': conditionIcon,
//   };
// }
