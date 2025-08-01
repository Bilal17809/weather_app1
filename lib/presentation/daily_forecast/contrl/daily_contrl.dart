import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import '../../../presentation/weather/contl/weather_service.dart';
import '../../../data/model/forecast.dart';

class DailyForecastController extends GetxController {
  RxList<DailyForecast> dailyList = <DailyForecast>[].obs;
  var selectedDayIndex = 0.obs;

  /// ✅ Fetch 7-day forecast from lat/lng
  Future<void> fetchDailyForecast(double lat, double lng) async {
    try {
      final json = await WeatherApiService.getForecast(lat, lng);
      final data = json['forecast']['forecastday'] as List;
      dailyList.value = data.map((e) => DailyForecast.fromJson(e)).toList();
      selectedDayIndex.value = 0;
    } catch (e) {
      print('❌ Daily forecast error: $e');
    }
  }

  /// ✅ Fetch forecast using current GPS location
  Future<void> fetchCurrentLocationForecast() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        await Geolocator.requestPermission();
      }

      final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      await fetchDailyForecast(pos.latitude, pos.longitude);
    } catch (e) {
      print('❌ GPS forecast error: $e');
    }
  }
}
