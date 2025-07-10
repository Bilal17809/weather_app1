import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// class CityController extends GetxController {
//   RxList<Malta> cityList = <Malta>[].obs;
//   RxList<Malta> filteredList = <Malta>[].obs;
//   RxList<Malta> favoriteCities = <Malta>[].obs;
//   RxString lastQuery = ''.obs;
//   RxBool loading = true.obs;
//   Rx<Malta?> selectedCity = Rx<Malta?>(null);
//   RxList<HourlyWeather> hourlyList = <HourlyWeather>[].obs;
//   RxList<DailyForecast> dailylist = <DailyForecast>[].obs;
//   RxList<WeatherDetails>details = <WeatherDetails>[].obs;
//
//   var filteredFavoriteCities = <Malta>[].obs;
//   final String apiKey = '7d7cead5f21da78ea50ea22ff44f5797';
//
//   @override
//   void onInit() {
//     super.onInit();
//     loadHourlyFromPrefs();
//     loadCities().then((_) => restoreSelectedPreview());
//     filterCities('');
//     loadWeeklyFromPrefs();
//     final city = selectedCity.value;
//     if (city != null) {
//       fetchAllForecast(city.lat, city.lng);
//     } else {
//       print('❌ selectedCity is null');
//     }
//   }
//
//   /// Set and save selected city preview
//   Future<void> setSelectedCity(Malta city) async {
//     print("👉 setSelectedCity called with: ${city.city}");
//     selectedCity.value = city;
//
//     await fetchAllForecast(city.lat, city.lng);
//
//     final model = CityModel(
//       city: city.city,
//       temperature: city.temperature ?? 0.0,
//     );
//     await saveCityPreview(model);
//   }
//     /// Fetch temperature from OpenWeatherMap using lat/lng
//   Future<double?> fetchCityTemperature(double lat, double lng) async {
//     final url = Uri.parse(
//       'http://api.weatherapi.com/v1/forecast.json?key=07e14a15571440079f5110300250407&q=$lat,$lng&days=7&aqi=no&alerts=no',
//     );
//
//     try {
//       final response = await http.get(url).timeout(const Duration(seconds: 5));
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final temp = data['current']?['temp_c'];
//
//         if (temp != null) {
//           final double temperature = (temp as num).toDouble();
//
//           /// ✅ Save to SharedPreferences
//           final prefs = await SharedPreferences.getInstance();
//           await prefs.setDouble('last_temperature', temperature);
//
//           return temperature;
//         } else {
//           print('⚠️ Temperature missing in response');
//         }
//       } else {
//         print('❌ API error: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('❌ Error fetching temperature: $e');
//     }
//
//     return null;
//   }
//
//   Future<void> fetchAllForecast(double lat, double lng) async {
//     final url = Uri.parse(
//       'http://api.weatherapi.com/v1/forecast.json?key=07e14a15571440079f5110300250407&q=$lat,$lng&days=7&aqi=no&alerts=no',
//     );
//
//     try {
//       final response = await http.get(url).timeout(Duration(seconds: 10));
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//
//         // ✅ Parse daily forecast
//         final forecast = WeatherForecastResponse.fromJson(data);
//         dailylist.value = forecast.forecastDays;
//         dailylist.refresh();
//         await saveWeeklyToPrefs();
//
//         // ✅ Parse hourly forecast from all 7 days
//         final List allHours = (data['forecast']['forecastday'] as List)
//             .expand((day) => day['hour'] as List)
//             .toList();
//
//         final now = DateTime.now().toUtc(); // UTC to match API
//
//         final next24 = allHours
//             .where((h) {
//           final dt = DateTime.parse(h['time']).toUtc();
//           return dt.isAfter(now);
//         })
//             .take(24)
//             .map((e) => HourlyWeather.fromJson(e))
//             .toList();
//
//         print("🕓 Parsed ${next24.length} hourly items:");
//         for (var h in next24) {
//           print("→ ${h.time}, ${h.temperature}°C, ${h.icon}");
//         }
//
//         hourlyList.value = next24;
//         hourlyList.refresh();
//         await saveHourlyToPrefs();
//
//         print("✅ Forecast fetch complete");
//       } else {
//         print("❌ Forecast API error: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("❌ Forecast fetch failed: $e");
//     }
//   }
//
//
//   Future<void> saveWeeklyToPrefs() async {
//     final prefs = await SharedPreferences.getInstance();
//     final jsonList = dailylist.map((d) => jsonEncode(d.toJson())).toList();
//     await prefs.setStringList('weekly_forecast', jsonList);
//     print("✅ Saved ${jsonList.length} weekly forecast items");
//   }
//
//   Future<void> loadWeeklyFromPrefs() async {
//     final prefs = await SharedPreferences.getInstance();
//     final List<String>? jsonList = prefs.getStringList('weekly_forecast');
//
//     if (jsonList != null && jsonList.isNotEmpty) {
//       final List<DailyForecast> loaded = jsonList
//           .map((str) => DailyForecast.fromFlatJson(jsonDecode(str)))
//           .toList();
//       dailylist.assignAll(loaded);
//       dailylist.refresh();
//       print("✅ Loaded ${loaded.length} weekly forecast items");
//     } else {
//       print("⚠️ No weekly forecast data found");
//     }
//   }
//
//
//
//   void toggleFavorite(Malta city, BuildContext context) async {
//     city.isFavorite = !city.isFavorite;
//
//     final prefs = await SharedPreferences.getInstance();
//     final favs = cityList
//         .where((c) => c.isFavorite)
//         .map((c) => jsonEncode({'city': c.city}))
//         .toList();
//     await prefs.setStringList('favorite_cities', favs);
//
//     print("✅ Favorite cities updated: ${favs.length}");
//
//     // ✅ Delay reactive updates until after build
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       favoriteCities.value = cityList.where((c) => c.isFavorite).toList();
//       cityList.refresh();
//       filterCities(lastQuery.value);
//     });
//
//     // Optional: navigate only if needed
//     if (city.isFavorite) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         Navigator.pushNamed(context, RoutesName.favorite);
//       });
//     }
//   }
//
//
//   /// Load cities from JSON and update temperatures
//   Future<void> loadCities() async {
//     loading.value = true;
//
//     try {
//       // ✅ Load cities from JSON asset
//       final jsonString = await rootBundle.loadString('assets/MaltaWeather.json');
//       final jsonList = json.decode(jsonString) as List;
//       final loadedCities = jsonList.map((e) => Malta.fromJson(e)).toList();
//
//       // ✅ Load favorites from SharedPreferences
//       final prefs = await SharedPreferences.getInstance();
//       final favs = prefs.getStringList('favorite_cities') ?? [];
//
//       // ✅ Extract favorite city names
//       final favoriteNames = favs
//           .map((e) => jsonDecode(e)['city'].toString().toLowerCase())
//           .toList();
//
//       // ✅ Loop through each city, fetch temp & mark favorite
//       for (var city in loadedCities) {
//         city.temperature = await fetchCityTemperature(city.lat, city.lng);
//
//         if (favoriteNames.contains(city.city.toLowerCase())) {
//           city.isFavorite = true;
//         }
//
//         print("🌡️ ${city.city}: ${city.temperature}, ❤️ Favorite: ${city.isFavorite}");
//       }
//
//       // ✅ Update reactive lists
//       cityList.value = loadedCities;
//       favoriteCities.value = loadedCities.where((c) => c.isFavorite).toList();
//
//       // ✅ ✅ ✅ Show all cities before search (favorites first)
//       final favsFirst = loadedCities.where((c) => c.isFavorite).toList();
//       final others = loadedCities.where((c) => !c.isFavorite).toList();
//       filteredFavoriteCities.assignAll(favoriteCities);
//
//       filteredList.value = [...favsFirst, ...others];
//
//     } catch (e) {
//       print('❌ Error loading cities: $e');
//     } finally {
//       loading.value = false;
//     }
//   }
//
//   void filterCities(String query) {
//     lastQuery.value = query;
//
//     if (query.trim().isEmpty) {
//       final favs = cityList.where((c) => c.isFavorite).toList();
//       final nonFavs = cityList.where((c) => !c.isFavorite).toList();
//       filteredList.value = [...favs, ...nonFavs]; // All cities, favorites first
//     } else {
//       filteredList.value = cityList
//           .where((city) =>
//           city.city.toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     }
//   }
//
//
//   void filterFavoriteCities(String query) {
//     if (query.trim().isEmpty) {
//       filteredFavoriteCities.assignAll(favoriteCities);
//     } else {
//       filteredFavoriteCities.assignAll(
//         favoriteCities.where((city) =>
//             city.city.toLowerCase().contains(query.toLowerCase())),
//       );
//     }
//   }
//
//
//   /// Save selected city to SharedPreferences
//   Future<void> saveCityPreview(CityModel model) async {
//     final prefs = await SharedPreferences.getInstance();
//     final jsonString = jsonEncode(model.toJson());
//     print("💾 Saving preview: $jsonString");
//     await prefs.setString('city_preview', jsonString);
//   }
//   Future<void> saveHourlyToPrefs() async {
//     final prefs = await SharedPreferences.getInstance();
//     final List<String> hourlyJsonList =
//     hourlyList.map((h) => jsonEncode(h.toJson())).toList();
//     await prefs.setStringList('hourly_data', hourlyJsonList);
//   }
//
//   Future<void> loadHourlyFromPrefs() async {
//     final prefs = await SharedPreferences.getInstance();
//     final List<String>? hourlyJsonList = prefs.getStringList('hourly_data');
//
//     if (hourlyJsonList != null) {
//       final List<HourlyWeather> loadedHourly =
//           hourlyJsonList
//               .map((jsonStr) => HourlyWeather.fromJson(jsonDecode(jsonStr)))
//               .toList();
//       hourlyList.assignAll(loadedHourly);
//       print(
//         "✅ Loaded ${loadedHourly.length} hourly items from SharedPreferences",
//       );
//     } else {
//       print("⚠️ No hourly data found in SharedPreferences");
//     }
//   }
//
//
//
//   /// Load city preview from SharedPreferences
//   Future<CityModel?> loadCityPreview() async {
//     final prefs = await SharedPreferences.getInstance();
//     final jsonString = prefs.getString('city_preview');
//     print("📥 Loaded preview from SharedPreferences: $jsonString");
//
//     if (jsonString != null) {
//       final jsonMap = jsonDecode(jsonString);
//       return CityModel.fromJson(jsonMap);
//     }
//     return null;
//   }
//
//   /// Restore selected city from preview
//   Future<void> restoreSelectedPreview() async {
//     final preview = await loadCityPreview();
//
//     if (preview != null) {
//       final matched = cityList.firstWhereOrNull(
//         (c) => c.city.toLowerCase() == preview.city.toLowerCase(),
//       );
//
//       if (matched != null) {
//         matched.temperature = preview.temperature;
//         selectedCity.value = matched;
//         print(
//           "✅ Restored city: ${matched.city} | Temp: ${matched.temperature}",
//         );
//       } else {
//         print("❌ Saved city not found in loaded list.");
//       }
//     } else {
//       print("❌ No saved city preview found.");
//     }
//   }
//
//   /// Refresh city list and temps
//   void refreshCities() {
//     loadCities();
//   }
// }
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/model/city_model.dart';
import '../../../data/model/forecast.dart';
import '../../../data/model/wpaw_model.dart';
import '../../../presentation/daily_forecast/contrl/daily_contrl.dart';
import '../../../presentation/hourly_forecast/contrl/hourly_contrl.dart';

class CityController extends GetxController {
  RxList<Malta> cityList = <Malta>[].obs;
  RxList<Malta> favoriteCities = <Malta>[].obs;
  RxList<Malta> filteredList = <Malta>[].obs;
  RxString lastQuery = ''.obs;
  RxBool loading = true.obs;
  Rx<Malta?> selectedCity = Rx<Malta?>(null);
  RxList<WeatherDetails>details = <WeatherDetails>[].obs;
  // Instance of the newly created controllers
  final DailyForecastController dailyForecastController = Get.put(DailyForecastController());
  final HourlyForecastController hourlyForecastController = Get.put(HourlyForecastController());

  var filteredFavoriteCities = <Malta>[].obs;
  final String apiKey = '7d7cead5f21da78ea50ea22ff44f5797';

  @override
  void onInit() {
    super.onInit();
    loadCities().then((_) => restoreSelectedPreview());
    filterCities('');
  }

  Future<void> setSelectedCity(Malta city) async {
    selectedCity.value = city;

    // Fetch daily and hourly forecasts
    await dailyForecastController.fetchDailyForecast(city.lat, city.lng);
    await hourlyForecastController.fetchHourlyForecast(city.lat, city.lng);

    // Save selected city preview to preferences
    await saveCityPreview(CityModel(city: city.city, temperature: city.temperature ?? 0.0));
  }

    void filterCities(String query) {
    lastQuery.value = query;

    if (query.trim().isEmpty) {
      final favs = cityList.where((c) => c.isFavorite).toList();
      final nonFavs = cityList.where((c) => !c.isFavorite).toList();
      filteredList.value = [...favs, ...nonFavs]; // All cities, favorites first
    } else {
      filteredList.value = cityList
          .where((city) =>
          city.city.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

    void filterFavoriteCities(String query) {
    if (query.trim().isEmpty) {
      filteredFavoriteCities.assignAll(favoriteCities);
    } else {
      filteredFavoriteCities.assignAll(
        favoriteCities.where((city) =>
            city.city.toLowerCase().contains(query.toLowerCase())),
      );
    }
  }

  /// Load cities from JSON and update temperatures
  Future<void> loadCities() async {
    loading.value = true;

    try {
      // Load cities from JSON asset
      final jsonString = await rootBundle.loadString('assets/MaltaWeather.json');
      final jsonList = json.decode(jsonString) as List;
      final loadedCities = jsonList.map((e) => Malta.fromJson(e)).toList();

      // Load favorites from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final favs = prefs.getStringList('favorite_cities') ?? [];

      // Extract favorite city names
      final favoriteNames = favs
          .map((e) => jsonDecode(e)['city'].toString().toLowerCase())
          .toList();

      // Loop through each city, fetch temp & mark favorite
      for (var city in loadedCities) {
        city.temperature = await fetchCityTemperature(city.lat, city.lng);

        if (favoriteNames.contains(city.city.toLowerCase())) {
          city.isFavorite = true;
        }

        print("🌡️ ${city.city}: ${city.temperature}, ❤️ Favorite: ${city.isFavorite}");
      }

      // Update reactive lists
      cityList.value = loadedCities;
      favoriteCities.value = loadedCities.where((c) => c.isFavorite).toList();

      // Show all cities before search (favorites first)
      final favsFirst = loadedCities.where((c) => c.isFavorite).toList();
      final others = loadedCities.where((c) => !c.isFavorite).toList();
      filteredFavoriteCities.assignAll(favoriteCities);

      filteredList.value = [...favsFirst, ...others];
    } catch (e) {
      print('❌ Error loading cities: $e');
    } finally {
      loading.value = false;
    }
  }

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

          /// Save to SharedPreferences
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

  Future<void> saveCityPreview(CityModel model) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(model.toJson());
    print("💾 Saving preview: $jsonString");
    await prefs.setString('city_preview', jsonString);
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

  void refreshCities() {
    loadCities();
  }
}


class WeatherForecastResponse {
  final List<DailyForecast> forecastDays;

  WeatherForecastResponse({required this.forecastDays});

  factory WeatherForecastResponse.fromJson(Map<String, dynamic> json) {
    final List forecastList = json['forecast']?['forecastday'] ?? [];

    return WeatherForecastResponse(
      forecastDays: forecastList
          .map((item) => DailyForecast.fromJson(item))
          .toList(),
    );
  }
}






