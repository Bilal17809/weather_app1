import 'package:get/get.dart';
import '../../service/api/api_service.dart';
import '../model/daily_model.dart';

class E_DailyForecastController extends GetxController {
  RxList<E_DailyForecast> selectedCityForecast = <E_DailyForecast>[].obs;
  RxList<E_DailyForecast> currentLocationForecast = <E_DailyForecast>[].obs;
  RxString currentCityName = 'Getting location...'.obs;

  void setCurrentCityName(String name) {
    currentCityName.value = name;
  }



  /// ✅ Correct: Parses and sets current location forecast
  void fetchCurrentLocationForecast(double lat, double lng) async {
    try {
      final data = await WeatherForecastService.Forecast(lat, lng);
      final List forecastList = data['forecast']['forecastday'];
      final parsedList = forecastList.map((e) => E_DailyForecast.fromJson(e)).toList();

      currentLocationForecast.value = parsedList;
    } catch (e) {
      print('❌ Error in fetchCurrentLocationForecast: $e');
      currentLocationForecast.clear();
    }
  }

  /// ✅ Correct: Parses and sets selected city forecast
  void fetchSelectedCityForecast(double lat, double lng) async {
    try {
      final data = await WeatherForecastService.Forecast(lat, lng);
      final List forecastList = data['forecast']['forecastday'];
      final parsedList = forecastList.map((e) => E_DailyForecast.fromJson(e)).toList();

      selectedCityForecast.value = parsedList;
    } catch (e) {
      print('❌ Error in fetchSelectedCityForecast: $e');
      selectedCityForecast.clear();
    }
  }

  /// ✅ Optional reusable method for both types
  Future<void> fetchDailyForecast(double lat, double lon, {bool isCurrentLocation = false}) async {
    try {
      final data = await WeatherForecastService.Forecast(lat, lon);
      final List forecastList = data['forecast']['forecastday'];
      final parsedList = forecastList.map((e) => E_DailyForecast.fromJson(e)).toList();

      if (isCurrentLocation) {
        currentLocationForecast.value = parsedList;
      } else {
        selectedCityForecast.value = parsedList;
      }
    } catch (e) {
      print('❌ Error fetching daily forecast: $e');
    }
  }
}
