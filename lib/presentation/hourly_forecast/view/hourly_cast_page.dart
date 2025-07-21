import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../contrl/hourly_contrl.dart';

class hourly_cast extends StatelessWidget {
  const hourly_cast({super.key});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(left: 10,right: 10),
      child: Container(
        decoration: roundedDecorationWithShadow,
        child: Obx(() {
          final hourly = Get.find<HourlyForecastController>().hourlyList;

          print("📦 UI rebuilding — Hourly count: ${hourly.length}");

          if (hourly.isEmpty) {
            return Center(
              child: Text("❌ No hourly forecast", style: context.textTheme.bodyLarge?.copyWith(color: kWhite)),
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
                      Text(h.time, style: context.textTheme.bodyLarge?.copyWith(color: kWhite, fontSize: 13)),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "${h.temperature.round()}",
                              style: context.textTheme.bodyLarge?.copyWith(fontSize: 20, fontWeight: FontWeight.bold, color: kWhite),
                            ),
                            WidgetSpan(
                              child: Transform.translate(
                                offset: const Offset(2, 1),
                                child: Text('°', style: context.textTheme.bodyLarge?.copyWith(fontSize: 20, fontWeight: FontWeight.bold, color: kWhite)),
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
    );
  }
}
