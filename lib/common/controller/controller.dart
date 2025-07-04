import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/model/model.dart';
import '../../share_reference/share_reference.dart';

class CityController extends GetxController {
  RxList<Malta> cityList = <Malta>[].obs;
  RxBool loading = true.obs;
  Rx<Malta?> selectedCity = Rx<Malta?>(null);
  RxList<HourlyWeather> hourlyList = <HourlyWeather>[].obs;
  final String apiKey = '7d7cead5f21da78ea50ea22ff44f5797';


  @override
  void onInit() {
    super.onInit();
    loadHourlyFromPrefs();
    loadCities().then((_) => restoreSelectedPreview());
  }

  /// Set and save selected city preview
  Future<void> setSelectedCity(Malta city) async {
    print("👉 setSelectedCity called with: ${city.city}");

    selectedCity.value = city;

    // 🔄 Optionally re-fetch temperature (if not already fetched)
    city.temperature = await fetchCityTemperature(city.lat, city.lng);
    print("🌡️ Updated temperature: ${city.temperature}");

    // 🌤️ Fetch hourly forecast
    await fetchHourlyForecast(city.lat, city.lng);

    // 💾 Save preview
    CityModel model = CityModel(
      city: city.city,
      temperature: city.temperature ?? 0.0,
    );
    await saveCityPreview(model);
  }

  /// Fetch temperature from OpenWeatherMap using lat/lng
  Future<double?> fetchCityTemperature(double lat, double lng) async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lng&units=metric&appid=$apiKey';
    // 'https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lng&exclude=current,minutely,hourly,alerts&appid=$apiKey';


    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final temp = data['main']?['temp'];

        if (temp != null) {
          final double temperature = (temp as num).toDouble();

          /// ✅ Save temperature to SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setDouble('last_temperature', temperature);

          return temperature;
        } else {
          print('⚠️ Temperature field missing in response');
        }
      } else {
        print('❌ API error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching temperature: $e');
    }

    return null;
  }

  Future<void> fetchHourlyForecast(double lat, double lon) async {
    final url =
        'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&units=metric&appid=$apiKey';

    print("📡 Requesting forecast: $url");

    try {
      final response = await http.get(Uri.parse(url));
      print("🌐 Response status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final List<dynamic> forecastList = data['list'];
        print("📦 Forecast items found: ${forecastList.length}");

        final items =
            forecastList.take(10).map((e) {
              print("➡️ Parsing: ${e['dt_txt']}");
              return HourlyWeather.fromJson(e);
            }).toList();

        hourlyList.value = items;
        print("✅ Parsed hourlyList with ${items.length} entries");
      } else {
        print("❌ Forecast API Error: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Forecast fetch failed: $e");
    }
  }

  /// Load cities from JSON and update temperatures
  Future<void> loadCities() async {
    loading.value = true;

    try {
      final jsonString = await rootBundle.loadString(
        'assets/MaltaWeather.json',
      );
      final jsonList = json.decode(jsonString) as List;
      final loadedCities = jsonList.map((e) => Malta.fromJson(e)).toList();

      for (var city in loadedCities) {
        city.temperature = await fetchCityTemperature(city.lat, city.lng);
        print("🌡️ Fetched temp for ${city.city}: ${city.temperature}");
      }

      cityList.value = loadedCities;
    } catch (e) {
      print('❌ Error loading cities: $e');
    } finally {
      loading.value = false;
    }
  }

  /// Save selected city to SharedPreferences
  Future<void> saveCityPreview(CityModel model) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(model.toJson());
    print("💾 Saving preview: $jsonString");
    await prefs.setString('city_preview', jsonString);
  }



  Future<void> loadHourlyFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? hourlyJsonList = prefs.getStringList('hourly_data');

    if (hourlyJsonList != null) {
      final List<HourlyWeather> loadedHourly = hourlyJsonList
          .map((jsonStr) => HourlyWeather.fromJson(jsonDecode(jsonStr)))
          .toList();
      hourlyList.assignAll(loadedHourly);
      print("✅ Loaded ${loadedHourly.length} hourly items from SharedPreferences");
    } else {
      print("⚠️ No hourly data found in SharedPreferences");
    }
  }



  Future<void> saveHourlyToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> hourlyJsonList =
        hourlyList.map((h) => jsonEncode(h.toJson())).toList();
    await prefs.setStringList('hourly_data', hourlyJsonList);
  }

  /// Load city preview from SharedPreferences
  Future<CityModel?> loadCityPreview() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('city_preview');
    print("📥 Loaded preview from SharedPreferences: $jsonString");

    if (jsonString != null) {
      final jsonMap = jsonDecode(jsonString);
      return CityModel.fromJson(jsonMap);
    }
    return null;
  }

  /// Restore selected city from preview
  Future<void> restoreSelectedPreview() async {
    final preview = await loadCityPreview();

    if (preview != null) {
      final matched = cityList.firstWhereOrNull(
        (c) => c.city.toLowerCase() == preview.city.toLowerCase(),
      );

      if (matched != null) {
        matched.temperature = preview.temperature;
        selectedCity.value = matched;
        print(
          "✅ Restored city: ${matched.city} | Temp: ${matched.temperature}",
        );
      } else {
        print("❌ Saved city not found in loaded list.");
      }
    } else {
      print("❌ No saved city preview found.");
    }
  }

  /// Refresh city list and temps
  void refreshCities() {
    loadCities();
  }
}

class HourlyWeather {
  final String day; // e.g. "Thu"
  final String time;
  final double temperature;
  final double tempMin; // e.g. 27.3
  final double tempMax; // e.g. 30.5
  final String icon;


  HourlyWeather({
    required this.day,
    required this.time,
    required this.temperature,
    required this.tempMin,
    required this.tempMax,
    required this.icon,

  });

  factory HourlyWeather.fromJson(Map<String, dynamic> json) {
    final dateTime = DateTime.parse(json['dt_txt']);

    final weekday = HourlyWeather._getWeekday(dateTime.weekday); // Thu
    final formattedTime = DateFormat('h:mm a').format(dateTime); // 3:00 PM

    return HourlyWeather(
      day: weekday,
      time: formattedTime,
      temperature: (json['main']['temp'] as num).toDouble(),
      tempMin: (json['main']['temp_min'] as num).toDouble(),
      tempMax: (json['main']['temp_max'] as num).toDouble(),
      icon: json['weather'][0]['icon'],
    );
  }
  static String _getWeekday(int day) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[(day - 1) % 7];
  }

  Map<String, dynamic> toJson() => {
    'day': day,
    'time': time,
    'temperature': temperature,
    'tempMin': tempMin,
    'tempMax': tempMax,
    'icon': icon,
  };
}
