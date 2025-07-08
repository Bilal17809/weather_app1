import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/model/curr_model/curr_model.dart';
import '../../data/model/model.dart';
import '../../share_reference/share_reference.dart';

class CityController extends GetxController {
  RxList<Malta> cityList = <Malta>[].obs;
  RxBool loading = true.obs;
  Rx<Malta?> selectedCity = Rx<Malta?>(null);
  RxList<HourlyWeather> hourlyList = <HourlyWeather>[].obs;
  RxList<HourlyWeather> dailySummaries = <HourlyWeather>[].obs;


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
    // await fetchHourlyForecast(city.lat, city.lng);

    // 💾 Save preview
    CityModel model = CityModel(
      city: city.city,
      temperature: city.temperature ?? 0.0,
    );
    await saveCityPreview(model);
  }



  /// Fetch temperature from OpenWeatherMap using lat/lng
  Future<double?> fetchCityTemperature(double lat, double lng) async {
    final url = Uri.parse(
      'http://api.weatherapi.com/v1/forecast.json?key=07e14a15571440079f5110300250407&q=$lat,$lng&days=7&aqi=no&alerts=no',
    );

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final temp = data['current']?['temp_c'];

        if (temp != null) {
          final double temperature = (temp as num).toDouble();

          /// ✅ Save to SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setDouble('last_temperature', temperature);

          return temperature;
        } else {
          print('⚠️ Temperature missing in response');
        }
      } else {
        print('❌ API error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching temperature: $e');
    }

    return null;
  }

  // Future<void> fetchHourlyForecast(double lat, double lon) async {
  //   final url = Uri.parse('http://api.weatherapi.com/v1/forecast.json?key=07e14a15571440079f5110300250407&q=$lat,$lon&days=1&aqi=no&alerts=no',);
  //   print("📡 Requesting forecast: $url");
  //
  //   try {
  //     final response = await http.get(url);
  //     print("🌐 Response status: ${response.statusCode}");
  //
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       final List<dynamic> forecastList =
  //       data['forecast']?['forecastday']?[0]?['hour'];
  //
  //       if (forecastList != null) {
  //         final items = forecastList.map((e) {
  //           print("➡️ Parsing hour: ${e['time']}");
  //           return HourlyWeather.fromJson(e);
  //         }).toList();
  //
  //         hourlyList.value = items;
  //
  //         /// ✅ Add this line to compute daily summaries from hourlyList
  //
  //         /// ✅ Optionally store hourly data
  //         await saveHourlyToPrefs();
  //
  //         print("✅ Parsed hourlyList with ${items.length} entries");
  //       } else {
  //         print("⚠️ Hourly forecast data not found");
  //       }
  //     } else {
  //       print("❌ Forecast API Error: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     print("❌ Forecast fetch failed: $e");
  //   }
  // }


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
      final List<HourlyWeather> loadedHourly =
          hourlyJsonList
              .map((jsonStr) => HourlyWeather.fromJson(jsonDecode(jsonStr)))
              .toList();
      hourlyList.assignAll(loadedHourly);
      print(
        "✅ Loaded ${loadedHourly.length} hourly items from SharedPreferences",
      );
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

