import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class CurrentWeatherController extends GetxController {
  var currentTemperature = ''.obs;
  var cityName = ''.obs;
  var conditionText = ''.obs;
  var iconUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getCurrentLocationAndFetchWeather();
  }

  Future<void> getCurrentLocationAndFetchWeather() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('❌ Location services are disabled.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('❌ Location permission denied.');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('❌ Location permission permanently denied.');
        return;
      }

      // ✅ Try to get location with longer timeout
      Position position;
      try {
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        ).timeout(const Duration(seconds: 30));
      } catch (e) {
        print('⚠️ Primary location fetch failed: $e');
        // ✅ Fallback to last known position
        final fallback = await Geolocator.getLastKnownPosition();
        if (fallback != null) {
          print('📍 Using last known location');
          position = fallback;
        } else {
          print('❌ No last known location available');
          return;
        }
      }

      print('📍 Location: ${position.latitude}, ${position.longitude}');
      await fetchCurrentWeather(position.latitude, position.longitude);
    } catch (e) {
      print('❌ General location error: $e');
    }
  }


  Future<void> fetchCurrentWeather(double lat, double lng) async {
    final url = Uri.parse(
      'http://api.weatherapi.com/v1/forecast.json?key=8e1b9cfeaccc48c4b2b85154230304&q=$lat,$lng&days=1&aqi=no&alerts=no',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        print('📦 Weather API Response: ${response.body}');
        final data = jsonDecode(response.body);

        currentTemperature.value = data['current']['temp_c'].toString();
        cityName.value = data['location']['name'];
        conditionText.value = data['current']['condition']['text'];
        iconUrl.value = "https:${data['current']['condition']['icon']}";

        print("✅ Weather loaded: ${cityName.value} - ${currentTemperature.value}°C");
      } else {
        print('❌ API Error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Exception fetching weather: $e');
    }
  }
}
