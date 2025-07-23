import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/model/city_model.dart';

import '../../../data/model/wpaw_model.dart';
import '../../../presentation/city/contrl/model.dart';
import '../../../presentation/daily_forecast/contrl/daily_contrl.dart';
import '../../../presentation/hourly_forecast/contrl/hourly_contrl.dart';
import '../../../presentation/weather/contl/weather_service.dart';


class CityController extends GetxController {
  RxList<Malta> cityList = <Malta>[].obs;
  RxList<Malta> favoriteCities = <Malta>[].obs;
  RxList<Malta> filteredList = <Malta>[].obs;
  RxString lastQuery = ''.obs;
  RxBool loading = true.obs;
  final RxDouble Lat = 0.0.obs;
  final RxDouble Lng = 0.0.obs;
  Rx<Malta?> selectedCity = Rx<Malta?>(null);
  RxList<WeatherDetails> details = <WeatherDetails>[].obs;
  var isCityManuallySelected = false.obs;

  final DailyForecastController dailyForecastController = Get.put(DailyForecastController());
  final HourlyForecastController hourlyForecastController = Get.put(HourlyForecastController());

  var filteredFavoriteCities = <Malta>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadCities().then((_) async {
      await restoreSelectedPreview();
      final city = selectedCity.value;
      if (city != null) {
        await fetchFullForecastForCurrentLocation();
      }
    });
    filterCities('');
    loadCityPreview();
    dailyForecastController.loadWeeklyFromPrefs();
    hourlyForecastController.loadFromPreferences();
  }

  Future<void> setSelectedCity(Malta city) async {
    isCityManuallySelected.value = true;
    selectedCity.value = city;

    final dailyController = Get.find<DailyForecastController>();
    dailyController.Lat.value = city.lat;
    dailyController.Lng.value = city.lng;

    final hourlyController = Get.find<HourlyForecastController>();
    hourlyController.Lat.value = city.lat;
    hourlyController.Lng.value = city.lng;

    await WeatherForecastService.fetchWeatherForecast(city.lat, city.lng);

    await saveCityPreview(CityModel(
      city: city.city,
      temperature: city.temperature ?? 0.0,
    ));
  }

  void updateSelectedCity(Malta city) {
    selectedCity.value = city;

    // Update hourly forecast for selected city


    // Fetch weather forecast using lat/lng
    WeatherForecastService.fetchWeatherForecast(city.lat, city.lng);
  }

  Future<void> fetchFullForecastForCurrentLocation() async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      print('📴 Offline – skipping API fetch');
      return;
    }

    await WeatherForecastService.fetchWeatherForecast(Lat.value, Lng.value);
  }


  void filterCities(String query) {
    lastQuery.value = query;

    if (query.trim().isEmpty) {
      final favs = cityList.where((c) => c.isFavorite).toList();
      final nonFavs = cityList.where((c) => !c.isFavorite).toList();
      filteredList.value = [...favs, ...nonFavs];
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

  Future<void> loadCities() async {
    loading.value = true;

    try {
      final jsonString = await rootBundle.loadString('assets/MaltaWeather.json');
      final jsonList = json.decode(jsonString) as List;
      final loadedCities = jsonList.map((e) => Malta.fromJson(e)).toList();

      final prefs = await SharedPreferences.getInstance();
      final favs = prefs.getStringList('favorite_cities') ?? [];

      final favoriteNames = favs
          .map((e) => jsonDecode(e)['city'].toString().toLowerCase())
          .toList();

      for (var city in loadedCities) {
        await WeatherForecastService.fetchWeatherForecast(city.lat, city.lng);
        final temp = await WeatherForecastService.loadLastTemperature();
        city.temperature = temp ?? 0.0;

        if (favoriteNames.contains(city.city.toLowerCase())) {
          city.isFavorite = true;
        }

        print("🌡️ ${city.city}: ${city.temperature}, ❤️ Favorite: ${city.isFavorite}");
      }

      cityList.value = loadedCities;
      favoriteCities.value = loadedCities.where((c) => c.isFavorite).toList();

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

  Future<void> saveCityPreview(CityModel model) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(model.toJson());
    print("💾 Saving preview: $jsonString");
    await prefs.setString('city_preview', jsonString);
  }

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

  Future<void> restoreSelectedPreview() async {
    final preview = await loadCityPreview();

    if (preview != null) {
      final matched = cityList.firstWhereOrNull(
            (c) => c.city.toLowerCase() == preview.city.toLowerCase(),
      );

      if (matched != null) {
        matched.temperature = preview.temperature;
        selectedCity.value = matched;
        print("✅ Restored city: ${matched.city} | Temp: ${matched.temperature}");
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
