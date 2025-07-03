import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../data/model/model.dart';


class Controller extends GetxController {
  RxList<Malta> cityList = <Malta>[].obs;

  @override
  void onInit() {
    loadCities();
    super.onInit();
  }

  Future<void> loadCities() async {
    final String jsonString = await rootBundle.loadString('assets/MaltaWeather.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    cityList.value = jsonData.map((e) => Malta.fromJson(e)).toList();
  }
}