import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../core/theme/app_colors.dart';
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
            color: bgPrimary,
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
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: kWhite,
                      fontSize: 13,
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "${h.temperature.round()}",
                          style: context.textTheme.bodyLarge?.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: kWhite,
                          ),
                        ),
                        WidgetSpan(
                          child: Transform.translate(
                            offset: const Offset(2, 1),
                            child: Text(
                              '°',
                              style: context.textTheme.bodyLarge?.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: kWhite,
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
