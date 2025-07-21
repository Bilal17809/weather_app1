import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../contrl/hourly_contrl.dart';

class hourly_cast extends StatelessWidget {
  const hourly_cast({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HourlyForecastController>();

    return Padding(
      padding: const EdgeInsets.only(left: 8.0,right: 8),
      child: Container(
        decoration: roundedDecorationWithShadow,
        child: Obx(() {
          final hourly = controller.hourlyList;
          final selectedIndex = controller.selectedHourIndex.value;

          if (hourly.isEmpty) {
            return Center(
              child: Text(
                "❌ No hourly forecast",
                style: context.textTheme.bodyLarge?.copyWith(color: kWhite),
              ),
            );
          }

          return SingleChildScrollView(
            controller: controller.scrollController,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(hourly.length, (index) {
                final h = hourly[index];
                final isSelected = index == selectedIndex;

                return Padding(
                  padding: const EdgeInsets.only(left: 20,top: 5, bottom: 5),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: controller.selectedHourIndex.value == index ? Colors.white : Colors.transparent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 9),
                        Image.network(h.icon, width: 53, height: 53, fit: BoxFit.cover),
                        const SizedBox(height: 10),
                        Text(
                          h.time,
                          style: context.textTheme.bodyLarge?.copyWith(color: kWhite, fontSize: 13),
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
