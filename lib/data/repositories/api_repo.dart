
// Use these for weather

// 8e1b9cfeaccc48c4b2b85154230304
// https://www.weatherapi.com
// Future<double?> fetchCityTemperature(double lat, double lon) async {
//   final apiKey = '7d7cead5f21da78ea50ea22ff44f5797';
//   final url =
//       'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=metric&appid=$apiKey';
//
//   final response = await http.get(Uri.parse(url));
//
//   if (response.statusCode == 200) {
//     final data = jsonDecode(response.body);
//     return (data['main']['temp'] as num).toDouble();
//   } else {
//     return null;
//   }
// }
