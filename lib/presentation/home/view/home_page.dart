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
                        city?.city ?? 'Select city',
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
                    Navigator.pushNamed(context, RoutesName.favorite);
                  },
                  child: Icon(Icons.add_circle_sharp, color: kWhite, size: 28),
                ),
              ),
            ],
          );
        }),
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
                SizedBox(height: 20),

                SizedBox(height: 15),
                Obx(() {
                  final detail = Get.find<CityController>().details;
                  print("🔍 detail length: ${detail.length}"); // DEBUG

                  if (detail.isEmpty) return SizedBox();

                  final d = detail.first;

                  return Column(
                    children: [
                      Image.network(
                        d.conditionIcon,
                        width: 210,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.error, color: kWhite);
                        },
                      ),
                      SizedBox(height: 10),
                      Text(
                        d.conditionText,
                        style: context.textTheme.bodyLarge?.copyWith(color: kWhite, fontSize: 20),
                      ),
                    ],
                  );
                }),

                Obx(() {
                  final city = ctr.selectedCity.value;
                  return Text(
                    city?.temperature != null
                        ? "${city!.temperature!.toStringAsFixed(1)}°"
                        : "Loading...",
                    style: context.textTheme.bodyLarge?.copyWith(fontSize: 50, color: dividerColor),
                  );
                }),

                hourly_cast(),
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
