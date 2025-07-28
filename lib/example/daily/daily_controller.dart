import 'package:get/get.dart';
import '../service/api_service.dart';
import 'daily_model.dart';

class E_DailyForecastController extends GetxController {
  RxList<E_DailyForecast> selectedCityForecast = <E_DailyForecast>[].obs;
  RxList<E_DailyForecast> currentLocationForecast = <E_DailyForecast>[].obs;

  /// Fetch forecast from WeatherAPI
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
