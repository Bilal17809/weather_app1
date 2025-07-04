import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:weather/core/routes/routes_name.dart';


import '../../../common/controller/controller.dart';

import '../../city/view/city.dart';
import '../../weather/view/weather.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final CityController ctr = Get.put(CityController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF001B31),
        automaticallyImplyLeading: false,
        title:Obx(() {
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
                    Navigator.pushNamed(context, RoutesName.citypage);
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
                  width: 160, // set your desired width
                  height: 120, // set your desired height
                  fit:
                  BoxFit
                      .cover, // optional, defines how the image should be fitted
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
                    style: TextStyle(fontSize: 80, color: Colors.white),
                  );
                }),

                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
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
                        final hourly = Get.find<CityController>().hourlyList;

                        if (hourly.isEmpty) return CircularProgressIndicator(    );

                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: hourly.map((h) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 8.0,right: 8),
                                child: Column(
                                  children: [
                                    SizedBox(height: 9),
                                    Image.network(
                                      "https://openweathermap.org/img/wn/${h.icon}@2x.png",
                                      width: 50,
                                      height: 50,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      h.time,
                                      style: TextStyle(color: Colors.white, fontSize: 13),
                                    ),
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "${h.temperature.round()}",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          WidgetSpan(
                                            child: Transform.translate(
                                              offset: const Offset(2, 1),
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
                              );
                            }).toList(),
                          ),
                        );
                      })

                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Container(
                      child:Obx(() {
                        final hourly = Get.find<CityController>().hourlyList;

                        if (hourly.isEmpty) {
                          return Center(
                            child: CircularProgressIndicator(color: Color(0xFF00A67D)),
                          );
                        }

                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: hourly.take(7).map((h)  {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(context, RoutesName.weatherpage);
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(height: 9),
                                      Image.network(
                                        "https://openweathermap.org/img/wn/${h.icon}@2x.png",
                                        width: 45,
                                        height: 45,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "${h.day}",
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
                                              text: "${h.tempMax.round()}",
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
                                              text: "${h.tempMin.round()}",
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
                            }).toList(),
                          ),
                        );
                      })

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
