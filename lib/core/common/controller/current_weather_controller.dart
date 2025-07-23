import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

import '../../../presentation/weather/contl/weather_service.dart';

class CurrentWeatherController extends GetxController {
  var currentTemperature = ''.obs;
  var cityName = ''.obs;
  var conditionText = ''.obs;
  var iconUrl = ''.obs;
  final RxDouble currentLng=0.0.obs;
  final RxDouble currentLat =0.0.obs;

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
      await fetchFullForecastForCurrentLocation();
    } catch (e) {
      print('❌ General location error: $e');
    }
  }
  Future<void> fetchFullForecastForCurrentLocation() async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      print('📴 Offline – skipping API fetch');
      return;
    }

    await WeatherForecastService.fetchWeatherForecast(currentLat.value, currentLng.value);
  }
}
