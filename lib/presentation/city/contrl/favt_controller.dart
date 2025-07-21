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
    city.isFavorite = !city.isFavorite;

    if (city.isFavorite) {
      if (!favoriteCities.any((c) => c.city == city.city)) {
        favoriteCities.insert(0, city);
      }
    } else {
      favoriteCities.removeWhere((c) => c.city == city.city);
    }

    // 🔄 Update filtered lists
    final cityController = Get.find<CityController>();
    cityController.filteredList.refresh(); // ✅ important if UI depends on it
    filteredFavoriteCities.assignAll(favoriteCities);

    // ✅ Save to SharedPreferences
    await saveFavoriteCitiesToPrefs();
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



  Future<void> loadFavoritesFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('favorite_cities');

    final cityController = Get.find<CityController>();

    if (saved == null || saved.isEmpty) {
      print("⚠️ No favorite cities found in SharedPreferences.");
      return;
    }

    // Wait until city list is available
    if (cityController.cityList.isEmpty) {
      print("⏳ Waiting for city list to load before restoring favorites...");
      await Future.delayed(Duration(milliseconds: 300)); // optional wait
    }

    final List<Malta> loadedFavorites = [];

    for (final str in saved) {
      try {
        final map = jsonDecode(str);
        final match = cityController.cityList.firstWhereOrNull(
              (c) => c.city.toLowerCase() == map['city'].toLowerCase(),
        );

        if (match != null) {
          match.isFavorite = true;
          loadedFavorites.add(match);
        }
      } catch (e) {
        print("❌ Error parsing favorite city: $e");
      }
    }

    // Update all controllers
    favoriteCities.assignAll(loadedFavorites);
    filteredFavoriteCities.assignAll(loadedFavorites);

    cityController.favoriteCities.assignAll(loadedFavorites);
    cityController.filteredFavoriteCities.assignAll(loadedFavorites);

    print("✅ Loaded ${loadedFavorites.length} favorite cities from SharedPreferences.");
    print("📋 Restored favorites: ${loadedFavorites.map((c) => c.city).join(', ')}");
  }

}
