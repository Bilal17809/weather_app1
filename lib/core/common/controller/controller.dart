
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/model/city_model.dart';
import '../../../data/model/forecast.dart';
import '../../../data/model/wpaw_model.dart';
import '../../../presentation/city/contrl/model.dart';
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
    Get.find<DailyForecastController>().loadWeeklyFromPrefs();
    Get.find<HourlyForecastController>().loadHourlyFromPrefs();
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








