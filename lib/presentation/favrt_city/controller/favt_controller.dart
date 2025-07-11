import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/model/city_model.dart';
import '../../../core/common/controller/controller.dart'; // <-- Make sure this import exists

class FavoriteController extends GetxController {
  RxList<Malta> favoriteCities = <Malta>[].obs;
  RxList<Malta> filteredFavoriteCities = <Malta>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadFavoritesFromPrefs();
  }

  void toggleFavorite(Malta city) async {
    final cityController = Get.find<CityController>();

    city.isFavorite = !city.isFavorite;

    if (city.isFavorite) {
      // Avoid duplicate
      if (!favoriteCities.any((c) => c.city == city.city)) {
        favoriteCities.add(city);
        cityController.favoriteCities.add(city);
      }
    } else {
      favoriteCities.removeWhere((c) => c.city == city.city);
      cityController.favoriteCities.removeWhere((c) => c.city == city.city);
    }

    // Update UI
    filteredFavoriteCities.assignAll(favoriteCities);
    cityController.filteredFavoriteCities.assignAll(cityController.favoriteCities);

    await saveFavoriteCitiesToPrefs();
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

  Future<void> saveFavoriteCitiesToPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> favoriteJsonList = favoriteCities.map((city) {
      return jsonEncode({
        'city': city.city,
        'lat': city.lat,
        'lng': city.lng,
      });
    }).toList();

    await prefs.setStringList('favorite_cities', favoriteJsonList);
    print("💾 Saved ${favoriteJsonList.length} favorite cities");
  }

  Future<void> loadFavoritesFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('favorite_cities');

    if (saved != null && saved.isNotEmpty) {
      final cityController = Get.find<CityController>();
      final List<Malta> loadedFavorites = [];

      for (final str in saved) {
        final map = jsonDecode(str);
        final match = cityController.cityList.firstWhereOrNull(
                (c) => c.city.toLowerCase() == map['city'].toLowerCase());

        if (match != null) {
          match.isFavorite = true;
          loadedFavorites.add(match);
        }
      }

      favoriteCities.assignAll(loadedFavorites);
      filteredFavoriteCities.assignAll(loadedFavorites);
      cityController.favoriteCities.assignAll(loadedFavorites);
      cityController.filteredFavoriteCities.assignAll(loadedFavorites);

      print("✅ Loaded ${loadedFavorites.length} favorite cities from SharedPreferences");
    } else {
      print("⚠️ No favorite cities found in storage.");
    }
  }
}
