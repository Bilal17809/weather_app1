import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:weather/core/routes/routes_name.dart';
import 'package:weather/data/model/hourly_model.dart';
import '../../../core/common/controller/controller.dart';
import '../../daily_forecast/contrl/daily_contrl.dart';
import '../../hourly_forecast/contrl/hourly_contrl.dart';


class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final CityController ctr = Get.put(CityController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF001B31),
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
                child: Icon(Icons.menu, color: Colors.white, size: 28),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.white, size: 17),
                      SizedBox(width: 5),
                      Text(
                        city?.city ?? 'Select city',
                        style: TextStyle(
                          color: Colors.white,
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
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, RoutesName.favorite);
                  },
                  child: Icon(
                    Icons.add_circle_sharp,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
      body: Container(
        height:double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF001B31),
              Color(0xFF003847),
              Color(0xFF00A67D),
              Color(0xFF009072),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),

                SizedBox(height: 15),
                Image.asset(
                  "assets/images/Frame .png",
                  width: 160,
                  height: 120,
                  fit:
                      BoxFit
                          .cover,
                ),
                SizedBox(height: 10),
                Text(
                  "Party Cloudy",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Obx(() {
                  final city = ctr.selectedCity.value;
                  return Text(
                    city?.temperature != null
                        ? "${city!.temperature!.toStringAsFixed(1)}°"
                        : "Loading...",
                    style: TextStyle(fontSize: 50, color: Colors.white),
                  );
                }),

                Padding(
                  padding: const EdgeInsets.only(left: 10,right: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFF85DFC7).withOpacity(0.7),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // Shadow color
                          spreadRadius: 2, // How much the shadow spreads
                          blurRadius: 6, // How soft the shadow is
                          offset: Offset(4, 4), // x, y: move right & down
                        ),
                      ],
                    ),
                    child: Obx(() {
                      final hourly = Get.find<HourlyForecastController>().hourlyList;

                      print("📦 UI rebuilding — Hourly count: ${hourly.length}");

                      if (hourly.isEmpty) {
                        return Center(
                          child: Text("❌ No hourly forecast", style: TextStyle(color: Colors.white)),
                        );
                      }

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(5, (index) {
                            final h = hourly[index];
                            return Padding(
                              padding: const EdgeInsets.only(left: 14, bottom: 10),
                              child: Column(
                                children: [
                                  SizedBox(height: 9),
                                  Image.network(h.icon, width: 53, height: 53, fit: BoxFit.cover),
                                  SizedBox(height: 10),
                                  Text(h.time, style: TextStyle(color: Colors.white, fontSize: 13)),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "${h.temperature.round()}",
                                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                        ),
                                        WidgetSpan(
                                          child: Transform.translate(
                                            offset: const Offset(2, 1),
                                            child: Text('°', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      );
                    }),


                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Container(
                    child: Obx(() {
                      final controller = Get.find<DailyForecastController>();
                      final daily = controller.dailyList;

                      print("📅 Daily forecast items: ${daily.length}"); // ✅ Debug log

                      if (daily.isEmpty) {
                        return Center(
                          child: Text(
                            "⚠️ Forecast data not available.",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        );
                      }

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(daily.length.clamp(0, 7), (index) {
                            final w = daily[index];
                            return InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, RoutesName.weatherpage);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6),
                                child: Column(
                                  children: [
                                    SizedBox(height: 9),
                                    Image.network(
                                      w.iconUrl,
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          Icon(Icons.error, color: Colors.red),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      w.dayName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "${w.maxTemp.round()}",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF01474E),
                                            ),
                                          ),
                                          WidgetSpan(
                                            child: Transform.translate(
                                              offset: Offset(2, 1),
                                              child: Text(
                                                '°',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF01474E),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "${w.minTemp.round()}",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          WidgetSpan(
                                            child: Transform.translate(
                                              offset: Offset(2, 1),
                                              child: Text(
                                                '°',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      );
                    }),


                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
