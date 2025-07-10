import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/model/city_model.dart';

class FavoriteController extends GetxController {
  RxList<Malta> favoriteCities = <Malta>[].obs;
  RxList<Malta> filteredFavoriteCities = <Malta>[].obs;

  @override
  void onInit() {
    super.onInit();

  }

  void toggleFavorite(Malta city) {
    city.isFavorite = !city.isFavorite;

    if (city.isFavorite) {
      favoriteCities.add(city);
    } else {
      favoriteCities.removeWhere((c) => c.city == city.city);
    }

    saveFavoriteCitiesToPrefs();
    filterFavoriteCities('');
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


}
