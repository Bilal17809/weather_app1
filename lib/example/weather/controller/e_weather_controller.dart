import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../data/model/city_model.dart';
import '../../daily/model/daily_model.dart';

class SelectedDayWeatherController extends GetxController {
  var selectedDayDetail = Rxn<E_DailyForecast>();
  var selectedCity = Rxn<Malta>();

  void updateSelectedDay(E_DailyForecast detail, Malta city) {
    selectedDayDetail.value = detail;
    selectedCity.value = city;
  }

}

