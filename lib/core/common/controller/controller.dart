import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/model/city_model.dart';
import '../../../data/model/wpaw_model.dart';
import '../../../presentation/weather/contl/weather_service.dart';
import 'current_weather_controller.dart';

class CityController extends GetxController {
  // Forecast details for selected city
  var details = <WeatherDetail>[].obs;
  var loading = false.obs;
  // All cities and filtered city list
  RxList<Malta> cityList = <Malta>[].obs;
  RxList<Malta> filteredList = <Malta>[].obs;

  // Selected city coordinates
  var selectedLat = 0.0.obs;
  var selectedLng = 0.0.obs;

  // Favorite cities and filtered favorite list
  RxList<Malta> favoriteCities = <Malta>[].obs;
  RxList<Malta> filteredFavoriteCities = <Malta>[].obs;

  // Currently selected city full data
  final selectedCity = Rxn<WeatherDetail>();

  // Controller to update current weather based on selection
  final currentWeatherController = Get.find<CurrentWeatherController>();

  @override
  void onInit() {
    super.onInit();
    loadSavedCity(); // Restore saved city if available
  }

  /// Fetch full forecast from API and update details list
  Future<void> fetchCityDetails(double lat, double lng) async {
    try {
      loading.value = true;
      final json = await WeatherApiService.getForecast(lat, lng);
      details.assign(WeatherDetail.fromJson(json));
    } catch (e) {
      print('❌ fetchCityDetails error: $e');
    } finally {
      loading.value = false;
    }
  }


  /// Set new selected city, update coordinates, and fetch weather
  Future<void> updateSelectedCity(WeatherDetail city) async {
    selectedCity.value = city;
    selectedLat.value = city.lat;
    selectedLng.value = city.lng;

    await fetchCityDetails(city.lat, city.lng);
    await currentWeatherController.fetchWeatherByCoords(city.lat, city.lng);
  }

  /// Save full forecast JSON for selected city
  Future<void> saveCityToPrefs(Map<String, dynamic> fullJson) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('selected_city_json', jsonEncode(fullJson));
  }

  /// Load saved city JSON and restore forecast + weather
  Future<void> loadSavedCity() async {
    final prefs = await SharedPreferences.getInstance();
    final cityJsonStr = prefs.getString('selected_city_json');

    if (cityJsonStr != null) {
      final cityJson = jsonDecode(cityJsonStr);
      final savedCity = WeatherDetail.fromJson(cityJson);
      await updateSelectedCity(savedCity);
    }
  }

  /// Filter main city list
  void filterCities(String query) {
    if (query.isEmpty) {
      filteredList.assignAll(cityList);
    } else {
      filteredList.assignAll(
        cityList.where((city) =>
            city.city.toLowerCase().contains(query.toLowerCase())),
      );
    }
  }

  /// Filter favorite cities list
  void filterFavoriteCities(String query) {
    if (query.isEmpty) {
      filteredFavoriteCities.assignAll(favoriteCities);
    } else {
      filteredFavoriteCities.assignAll(
        favoriteCities.where((city) =>
            city.city.toLowerCase().contains(query.toLowerCase())),
      );
    }
  }

  /// Set full city list and filtered list initially
  void setCityList(List<Malta> cities) {
    cityList.assignAll(cities);
    filteredList.assignAll(cities);
  }

  /// Set favorite cities and filtered favorites
  void setFavoriteCities(List<Malta> favorites) {
    favoriteCities.assignAll(favorites);
    filteredFavoriteCities.assignAll(favorites);
  }
}
