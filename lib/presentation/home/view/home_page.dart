import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:weather/core/routes/routes_name.dart';
import 'package:weather/data/model/hourly_model.dart';
import '../../../core/common/controller/controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../daily_forecast/contrl/daily_contrl.dart';
import '../../daily_forecast/view/daily_cast_page.dart';
import '../../hourly_forecast/contrl/hourly_contrl.dart';
import '../../hourly_forecast/view/hourly_cast_page.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final CityController ctr = Get.put(CityController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgDark2,
        automaticallyImplyLeading: false,
        title: Obx(() {
          final city = ctr.selectedCity.value;
          final now = DateTime.now();
          final formattedDate = DateFormat('EEEE d MMMM').format(now);

          final showCurrentLocation =
              ctr.currentLocationName.value != 'Detecting...' &&
                  !ctr.isCityManuallySelected.value;

          final locationName = showCurrentLocation
              ? ctr.currentLocationName.value
              : city?.city ?? 'Select city';

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Icon(Icons.menu, color: kWhite, size: 28),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on, color: kWhite, size: 17),
                      SizedBox(width: 5),
                      Text(
                        locationName,
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: kWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                  Text(
                    formattedDate,
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: kWhite,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, RoutesName.citypage);
                  },
                  child: Icon(Icons.add_circle_sharp, color: kWhite, size: 28),
                ),
              ),
            ],
          );
        })
        ,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: bgwithgradent,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [


                SizedBox(height: 15),
                Obx(() {
                  final detail = Get.find<HourlyForecastController>().currentLocationDetail.value;

                  if (detail == null) return SizedBox();

                  return Column(
                    children: [
                      Image.network(
                        detail.conditionIcon,
                        width: 210,
                        height: 160,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 10),
                      Text(
                        detail.conditionText,
                        style: context.textTheme.bodyLarge?.copyWith(color: kWhite, fontSize: 15),
                      ),
                    ],
                  );
                }),


                Obx(() {
                  final city = ctr.selectedCity.value;

                  final showCurrentLocation =
                      ctr.currentLocationName.value != 'Detecting...' &&
                          !ctr.isCityManuallySelected.value;

                  final temp = showCurrentLocation
                      ? ctr.currentLocationTemp.value
                      : city?.temperature;

                  return Text(
                    temp != null && temp != 0
                        ? "${temp.toStringAsFixed(1)}°"
                        : "Loading...",
                    style: context.textTheme.bodyLarge?.copyWith(fontSize: 50, color: dividerColor),
                  );
                }),



                HourlyCast(),
                SizedBox(height: 10),
                DailyCastPage(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
