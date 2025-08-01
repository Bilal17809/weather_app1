import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import '../../../presentation/weather/contl/weather_service.dart';

class CurrentWeatherController extends GetxController {
  var conditionText = ''.obs;
  var iconUrl = ''.obs;
  var currentTemperature = ''.obs;
  var cityName = ''.obs;

  /// ✅ General function: Fetch weather from coordinates
  Future<void> fetchWeatherByCoords(double lat, double lng) async {
    try {
      final json = await WeatherApiService.getForecast(lat, lng);
      final c = json['current'];

      conditionText.value = c['condition']['text'];
      iconUrl.value = 'https:${c['condition']['icon']}';
      currentTemperature.value = c['temp_c'].toStringAsFixed(0);
      cityName.value = json['location']['name'];
    } catch (e) {
      print('❌ fetchWeatherByCoords error: $e');
    }
  }

  /// 🌐 Fetch current location from GPS
  Future<void> fetchCurrentLocationWeather() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        await Geolocator.requestPermission();
      }

      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      final lat = position.latitude;
      final lng = position.longitude;

      await fetchWeatherByCoords(lat, lng);
    } catch (e) {
      print('❌ Error getting location or weather: $e');
    }
  }
}
