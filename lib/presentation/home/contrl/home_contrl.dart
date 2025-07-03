import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../../../data/model/model.dart';

class home_ctr extends GetxController {
  RxList<Malta> home_list = <Malta>[].obs;

  @override
  void onInit() {
    loadadmin();
    // TODO: implement onInit
    super.onInit();
  }

  Future<void> loadadmin() async {
    final String jsonString = await rootBundle.loadString(
        'assets/MaltaWeather.json');
    final List<dynamic>jsondata = json.decode(jsonString);
    home_list.value = jsondata.map((e) => Malta.fromJson(e)).toList();
  }
}




