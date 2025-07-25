import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../data/model/city_model.dart';
import '../../example.dart';


class E_CityController extends GetxController {
  var cityList = <Malta>[].obs;
  var filteredList = <Malta>[].obs;
  var selectedCity = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadCities();
  }

  /// 🔁 Load city data from JSON and fetch weather
  Future<void> loadCities() async {
    cityList.value = await loadCitiesWithWeather();
    filteredList.value = cityList;
  }

  /// ✅ Fetch and attach weather info to cities
  Future<List<Malta>> loadCitiesWithWeather() async {
    final String jsonString = await rootBundle.loadString('assets/MaltaWeather_sorted.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    List<Malta> cities = jsonData.map((e) => Malta.fromJson(e)).toList();

    // ✅ Remove duplicate city names
    final uniqueCities = <String, Malta>{};
    for (var city in cities) {
      uniqueCities[city.city] = city;
    }
    cities = uniqueCities.values.toList();

    // ✅ Fetch weather for top 15 cities
    for (int i = 0; i < cities.length && i < 15; i++) {
      final city = cities[i];
      final weather = await WeatherService.fetchWeatherForCity(city);
      if (weather != null && weather['error'] == null) {
        city.temperature = double.tryParse(weather['temperature']?.replaceAll('°C', '') ?? '');
        city.conditionText = weather['condition'];
        city.conditionIcon = weather['icon'];
      }
    }

    return cities;
  }

  /// 🔍 Filter city list by query
  void filterCities(String query) {
    if (query.isEmpty) {
      filteredList.value = cityList;
    } else {
      filteredList.value = cityList
          .where((city) => city.city.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  /// 📍 Select city
  void selectCity(String cityName) {
    selectedCity.value = cityName;
  }
}
