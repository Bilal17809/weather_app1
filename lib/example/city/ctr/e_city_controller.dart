import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../data/model/city_model.dart';
import '../../service/function/example.dart';

class E_CityController extends GetxController {
  var cityList = <Malta>[].obs;
  var filteredList = <Malta>[].obs;

  RxList<Malta> favoriteCities = <Malta>[].obs;
  RxList<Malta> nonFavoriteCities = <Malta>[].obs;

  Rx<Malta?> selectedCity = Rx<Malta?>(null);
  // RxString currentCityName = ''.obs;
  RxDouble currentLat = 0.0.obs;
  RxDouble currentLon = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadCities();

  }

  Future<void> loadCities() async {
    cityList.value = await loadCitiesWithWeather();
    filterCities(""); // populate favorite/non-favorite
  }

  Future<List<Malta>> loadCitiesWithWeather() async {
    final String jsonString = await rootBundle.loadString('assets/MaltaWeather_sorted.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    List<Malta> cities = jsonData.map((e) => Malta.fromJson(e)).toList();

    // Remove duplicate cities
    final uniqueCities = <String, Malta>{};
    for (var city in cities) {
      uniqueCities[city.city] = city;
    }
    cities = uniqueCities.values.toList();

    // Fetch weather
    for (final city in cities) {
      final weather = await WeatherService.fetchWeatherForCity(city);
      if (weather != null && weather['error'] == null) {
        city.temperature = double.tryParse(weather['temperature']?.replaceAll('°C', '') ?? '');
        city.conditionText = weather['condition'];
        city.conditionIcon = weather['icon'];
      }
    }

    return cities;
  }

  void filterCities(String query) {
    List<Malta> filtered = query.isEmpty
        ? cityList
        : cityList
        .where((c) => c.city.toLowerCase().contains(query.toLowerCase()))
        .toList();

    favoriteCities.value = filtered.where((c) => c.isFavorite).toList();
    nonFavoriteCities.value = filtered.where((c) => !c.isFavorite).toList();

    filteredList.value = filtered;
  }

  void toggleFavorite(Malta city) {
    city.isFavorite = !city.isFavorite;
    filterCities(""); // refresh lists
  }

  void selectCity(Malta city) {
    selectedCity.value = city;
  }
}
