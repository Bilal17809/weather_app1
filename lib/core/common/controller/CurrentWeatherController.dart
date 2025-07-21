// current_weather_controller.dart
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
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      await fetchCurrentWeather(position.latitude, position.longitude);
    } catch (e) {
      print('❌ Error getting current location: $e');
    }
  }

  Future<void> fetchCurrentWeather(double lat, double lng) async {
    final url = Uri.parse(
        'http://api.weatherapi.com/v1/current.json?key=07e14a15571440079f5110300250407&q=$lat,$lng');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        currentTemperature.value = data['current']['temp_c'].toString();
        cityName.value = data['location']['name'];
        conditionText.value = data['current']['condition']['text'];
        iconUrl.value = "https:${data['current']['condition']['icon']}";

        print("✅ Current weather fetched: ${currentTemperature.value}°C");
      } else {
        print('❌ API Error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Exception fetching weather: $e');
    }
  }
}
