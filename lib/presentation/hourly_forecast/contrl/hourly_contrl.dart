import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import '../../../data/model/WeatherDetails.dart';
import '../../../data/model/hourly_model.dart';
import '../../../data/model/wpaw_model.dart';

class HourlyForecastController extends GetxController {
  RxList<HourlyWeather> hourlyList = <HourlyWeather>[].obs;
  final Rxn<WeatherDetail> currentLocationDetail = Rxn<WeatherDetail>();
  RxDouble currentLat = 0.0.obs;
  RxDouble currentLng = 0.0.obs;
  var selectedHourTime = Rxn<String>();

  void setSelectedHour(String? time) {
    selectedHourTime.value = time;
  }
  @override
  void onInit() {
    super.onInit();
    getCurrentLocationAndFetchWeather();
  }

  var cityName = ''.obs;
  var currentTemperature = ''.obs;

  Future<void> getCurrentLocationAndFetchWeather() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      currentLat.value = position.latitude;
      currentLng.value = position.longitude;

      print("📍 Got location: ${position.latitude}, ${position.longitude}");

      // 🔽 Fetch and parse response here
      final data = await fetchHourlyForecast(currentLat.value, currentLng.value);

      // ✅ Update city and temperature
      if (data != null) {
        cityName.value = data['location']['name'];
        currentTemperature.value = data['current']['temp_c'].toString();

        print("✅ City: ${cityName.value}, Temp: ${currentTemperature.value}°C");
      }

    } catch (e) {
      print("❌ Failed to get location: $e");
    }
  }

  Future<Map<String, dynamic>?> fetchHourlyForecast(double lat, double lng, {String? selectedDate}) async {
    final url = Uri.parse(
        'http://api.weatherapi.com/v1/forecast.json?key=07e14a15571440079f5110300250407&q=$lat,$lng&days=7&aqi=no&alerts=no'
    );

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        currentLocationDetail.value = WeatherDetail(
          conditionText: data['current']['condition']['text'],
          conditionIcon: "https:${data['current']['condition']['icon']}",
        );

        final List allHours = (data['forecast']['forecastday'] as List)
            .expand((day) => day['hour'] as List)
            .toList();

        final String targetDate = selectedDate ?? DateFormat('yyyy-MM-dd').format(DateTime.now());

        final filteredHours = allHours
            .where((h) => h['time'].toString().startsWith(targetDate))
            .map((e) => HourlyWeather.fromJson(e))
            .toList();

        hourlyList.value = filteredHours;
        await saveHourlyToPrefs();
        hourlyList.refresh();

        print("✅ Got ${filteredHours.length} hourly items for $targetDate");

        return data; // ✅ Add this
      } else {
        print("❌ Hourly API error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("❌ Exception in fetchHourlyForecast: $e");
      return null;
    }
  }



  void setSelectedDayDetail(String conditionText, String iconUrl) {
    currentLocationDetail.value = WeatherDetail(
      conditionText: conditionText,
      conditionIcon: iconUrl,
    );
  }

  Future<void> saveHourlyToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> hourlyJsonList = hourlyList.map((h) => jsonEncode(h.toJson())).toList();
    await prefs.setStringList('hourly_data', hourlyJsonList);
  }

  Future<void> loadHourlyFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? hourlyJsonList = prefs.getStringList('hourly_data');

    if (hourlyJsonList != null && hourlyJsonList.isNotEmpty) {
      final List<HourlyWeather> loadedHourly = hourlyJsonList
          .map((jsonStr) => HourlyWeather.fromFlatJson(jsonDecode(jsonStr)))
          .toList();

      hourlyList.assignAll(loadedHourly);
      hourlyList.refresh();

      print("✅ Loaded ${loadedHourly.length} hourly items from storage");
    } else {
      print("⚠️ No hourly forecast data found in SharedPreferences");
    }
  }
}
