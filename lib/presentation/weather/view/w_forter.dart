import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../hourly_forecast/contrl/hourly_contrl.dart';

class Weather_forter extends StatefulWidget {
  const Weather_forter({super.key});

  @override
  State<Weather_forter> createState() => _Weather_forterState();
}

class _Weather_forterState extends State<Weather_forter> {
  @override
  Widget build(BuildContext context) {
    return  Obx(() {
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
    });
  }
}
