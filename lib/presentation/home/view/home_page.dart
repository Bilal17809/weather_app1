import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weather/core/routes/routes_name.dart';
import 'package:weather/presentation/home/view/sidebar.dart';
import '../../../core/common/controller/controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../daily_forecast/view/daily_cast_page.dart';
import '../../hourly_forecast/view/hourly_cast_page.dart';
import '../../hourly_forecast/contrl/hourly_contrl.dart';
import '../../daily_forecast/contrl/daily_contrl.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final CityController ctr = Get.put(CityController());
  final hourlyCtrl = Get.find<HourlyForecastController>();
  final dailyCtrl = Get.find<DailyForecastController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        backgroundColor: bgDark2,
        automaticallyImplyLeading: false,
        title: Obx(() {
          final city = ctr.selectedCity.value;
          final controller = Get.find<DailyForecastController>();

          final selectedDay = controller.dailyList.isNotEmpty
              ? DateTime.parse(controller.dailyList[controller.selectedDayIndex.value].date)
              : DateTime.now();

          final formattedDate = DateFormat('EEEE d MMMM').format(selectedDay);

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Builder(
                builder: (context) => InkWell(
                  onTap: () => Scaffold.of(context).openDrawer(),
                  child: const Icon(Icons.menu, color: Colors.white, size: 28),
                ),
              ),
              // SizedBox(width: 60,),
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
                    style: context.textTheme.bodyLarge?.copyWith(color: kWhite, fontSize: 12),
                  ),
                ],
              ),
              // SizedBox(width: 60,),
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, RoutesName.citypage);
                  },
                  child: Icon(
                    Icons.add_circle_sharp,
                    color: kWhite,
                    size: 28,
                  ),
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
                SizedBox(height: 15),

                // ✅ Weather icon and condition from current location
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

                // ✅ Temperature from current location
                Obx(() {
                  final temp = hourlyCtrl.currentTemperature.value;

                  return Text(
                    temp != null && temp != 0
                        ? "${temp.toStringAsFixed(1)}°"
                        : "Loading...",
                    style: context.textTheme.bodyLarge?.copyWith(
                      fontSize: 50,
                      color: dividerColor,
                    ),
                  );
                }),

                SizedBox(height: 10),
                hourly_cast(),       // ⏰ Hourly Forecast
                SizedBox(height: 10),
                DailyCastPage(),     // 📅 7-Day Forecast
              ],
            ),
          ),
        ),
      ),
    );
  }
}
