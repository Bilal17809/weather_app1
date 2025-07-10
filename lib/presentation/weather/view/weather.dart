import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:weather/presentation/hourly_forecast/contrl/hourly_contrl.dart';
import '../../../core/common/controller/controller.dart' show CityController;
import '../../../core/routes/routes_name.dart';

class weather extends StatelessWidget {
  weather({super.key});
  final CityController ctr = Get.put(CityController());

  @override
  Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF001B31),
        automaticallyImplyLeading: false,
        title:  Obx(() {
          final city = ctr.selectedCity.value;
          final now = DateTime.now();
          final formattedDate = DateFormat('EEEE d MMMM').format(now);

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.topLeft,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),

            SizedBox(height: 25),
            Image.asset(
              "assets/images/weather5.png",
              width: 200, // set your desired width
              height: 180, // set your desired height
              fit:
              BoxFit
                  .cover, // optional, defines how the image should be fitted
            ),
            SizedBox(height: 10,),

            Divider(
              color: Colors.grey,    // Line color
              thickness: 1,          // Line thickness
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50,right: 30),
              child:Obx(() {
                final detail = Get.find<CityController>().details;
                if (detail.isEmpty) return Center(child: Text("c", style: TextStyle(color: Colors.white)));

                final d = detail.first; // just show first entry's details

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildInfoRow("Wind", d.wind),
                    buildInfoRow("Humidity", d.humidity),
                    buildInfoRow("Atm pressure", d.pressure),
                    buildInfoRow("Water", d.precip),
                    buildInfoRow("Moonrise", d.moonrise),
                    buildInfoRow("Moonset", d.moonset),
                  ],
                );
              }),

            ),



            Divider(
              color: Colors.grey,    // Line color
              thickness: 1,          // Line thickness
            ),
            Obx(() {
              final hourly = Get.find<HourlyForecastController>().hourlyList;


              if (hourly.isEmpty) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF00A67D),
                  ),
                );
              }

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(5, (index) {
                    final h = hourly[index];
                  // Safe fallback

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 9),
                          Image.network(
                            h.icon,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 10),
                          Text(
                            h.time,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
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
                  }),
                ),
              );
            }),
            SizedBox(height: 10),

          ],
        ),
      ),
    );
  }
}
Widget buildInfoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.white)),
        Text(value, style: TextStyle(color: Colors.white)),
      ],
    ),
  );
}
