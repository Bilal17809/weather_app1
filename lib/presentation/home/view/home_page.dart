import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:weather/core/routes/routes_name.dart';
import 'package:weather/data/model/hourly_model.dart';
import '../../../core/common/controller/controller.dart';
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
