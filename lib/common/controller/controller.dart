import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/routes/routes_name.dart';
import '../../data/model/curr_model/curr_model.dart';
import '../../data/model/fu_model/fur_model.dart';
import '../../data/model/model.dart';
import '../../data/model/wpaw_model.dart';
import '../../share_reference/share_reference.dart';

class CityController extends GetxController {
  RxList<Malta> cityList = <Malta>[].obs;
  RxList<Malta> filteredList = <Malta>[].obs;
  RxList<Malta> favoriteCities = <Malta>[].obs;
  RxString lastQuery = ''.obs;
  RxBool loading = true.obs;
  Rx<Malta?> selectedCity = Rx<Malta?>(null);
  RxList<HourlyWeather> hourlyList = <HourlyWeather>[].obs;
  RxList<DailyForecast> dailylist = <DailyForecast>[].obs;
  RxList<WeatherDetails>details = <WeatherDetails>[].obs;


  final String apiKey = '7d7cead5f21da78ea50ea22ff44f5797';

  @override
  void onInit() {
    super.onInit();
    loadHourlyFromPrefs();
    loadCities().then((_) => restoreSelectedPreview());
    filterCities('');
    final city = selectedCity.value;
    if (city != null) {
      fetchAllForecast(city.lat, city.lng);
    } else {
      print('❌ selectedCity is null');
    }
  }

  /// Set and save selected city preview
  Future<void> setSelectedCity(Malta city) async {
    print("👉 setSelectedCity called with: ${city.city}");
    selectedCity.value = city;

    await fetchAllForecast(city.lat, city.lng);

    final model = CityModel(
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

  Future<void> fetchAllForecast(double lat, double lon) async {
    final url = Uri.parse(
      'https://api.weatherapi.com/v1/forecast.json?key=07e14a15571440079f5110300250407&q=$lat,$lon&days=7&aqi=no&alerts=no',
    );

    try {
      final response = await http.get(url).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // 🌡️ Current temp
        final temp = data['current']?['temp_c'];
        if (temp != null) {
          selectedCity.value?.temperature = (temp as num).toDouble();
        }

        // ✅ 🧭 Add wind, humidity, pressure, precipitation
        final windSpeed = data['current']?['wind_kph'];
        final windDir = data['current']?['wind_dir'];
        final humidity = data['current']?['humidity'];
        final pressure = data['current']?['pressure_mb'];
        final precip = data['current']?['precip_mm'];

        // 🌙 Moonrise and moonset from first forecast day
        final moonrise = data['forecast']?['forecastday']?[0]?['astro']?['moonrise'];
        final moonset = data['forecast']?['forecastday']?[0]?['astro']?['moonset'];

        print('🌬️ Wind: $windSpeed kph ($windDir)');
        print('💧 Humidity: $humidity%');
        print('🧪 Pressure: $pressure mb');
        print('🌧️ Precipitation: $precip mm');
        print('🌙 Moonrise: $moonrise, Moonset: $moonset');
        final detailsModel = WeatherDetails.fromJson(data);
        details.assignAll([detailsModel]);

        // ✅ ⏰ Combine hours from all forecast days
        final List allHours = (data['forecast']?['forecastday'] as List)
            .expand((day) => day['hour'] as List)
            .toList();

        final now = DateTime.now();

        final next24 = allHours
            .where((h) => DateTime.parse(h['time']).toLocal().isAfter(now))
            .take(24)
            .map((e) => HourlyWeather.fromJson(e))
            .toList();

        hourlyList.value = next24;
        await saveHourlyToPrefs();

        // 📅 Daily forecast
        final weather = WeatherForecastResponse.fromJson(data);
        dailylist.value = weather.forecastDays;
        await saveDailyToPrefs();

        print("✅ Forecast loaded: ${hourlyList.length} hours, ${dailylist.length} days");
      } else {
        print("❌ Forecast API error: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Forecast fetch failed: $e");
    }
  }



  Future<void> saveDailyToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> dailyJsonList =
    dailylist.map((d) => jsonEncode(d.toJson())).toList();
    await prefs.setStringList('daily_data', dailyJsonList);
  }

  Future<void> loadDailyFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? dailyJsonList = prefs.getStringList('daily_data');

    if (dailyJsonList != null) {
      final List<DailyForecast> loadedDaily = dailyJsonList
          .map((jsonStr) => DailyForecast.fromJson(jsonDecode(jsonStr)))
          .toList();
      dailylist.assignAll(loadedDaily);
      print("✅ Loaded ${loadedDaily.length} daily forecasts from SharedPreferences");
    } else {
      print("⚠️ No daily data found in SharedPreferences");
    }
  }
  void toggleFavorite(Malta city, BuildContext context) async {
    city.isFavorite = true;

    // ✅ Save to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final favs = cityList
        .where((c) => c.isFavorite)
        .map((c) => jsonEncode(c.toJson()))
        .toList();
    await prefs.setStringList('favorite_cities', favs);

    // ✅ Update lists
    favoriteCities.value = cityList.where((c) => c.isFavorite).toList();
    cityList.refresh();
    filterCities(lastQuery.value);

    // ✅ Navigate to favorite screen
    Navigator.pushNamed(context, RoutesName.favorite);
  }



  /// Load cities from JSON and update temperatures
  Future<void> loadCities() async {
    loading.value = true;

    try {
      // Load JSON file
      final jsonString = await rootBundle.loadString('assets/MaltaWeather.json');
      final jsonList = json.decode(jsonString) as List;
      final loadedCities = jsonList.map((e) => Malta.fromJson(e)).toList();

      // 🔁 Load saved favorites from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final favs = prefs.getStringList('favorite_cities') ?? [];

      final favoriteNames = favs
          .map((e) => jsonDecode(e)['city'].toString().toLowerCase())
          .toList();

      // 🔁 Loop through each city: fetch temp + mark favorite
      for (var city in loadedCities) {
        city.temperature = await fetchCityTemperature(city.lat, city.lng);

        if (favoriteNames.contains(city.city.toLowerCase())) {
          city.isFavorite = true;
        }

        print("🌡️ Fetched temp for ${city.city}: ${city.temperature}, "
            "❤️ Favorite: ${city.isFavorite}");
      }

      // ✅ Set city list and favorite list
      cityList.value = loadedCities;
      favoriteCities.value = loadedCities.where((c) => c.isFavorite).toList();

    } catch (e) {
      print('❌ Error loading cities: $e');
    } finally {
      loading.value = false;
    }
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
      !city.isFavorite &&
          city.city.toLowerCase().contains(query.toLowerCase()))
          .toList();
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

