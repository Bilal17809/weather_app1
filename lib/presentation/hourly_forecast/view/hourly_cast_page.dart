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
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        decoration: roundedDecorationWithShadow,
        child: Obx(() {
          final hourly = controller.hourlyList;
          final selectedIndex = controller.selectedHourIndex.value;

          if (hourly.isEmpty) {
            return const SizedBox(
              height: 120,
              child: Center(child: CircularProgressIndicator(color: kWhite)),
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
                  padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                  child: GestureDetector(
                    onTap: () => controller.selectedHourIndex.value = index,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white24 : Colors.transparent,
                        border: Border.all(
                          color: isSelected ? kWhite : Colors.transparent,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 9),
                          Image.network(
                            h.icon,
                            width: 53,
                            height: 53,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.cloud, size: 48, color: kWhite),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            h.time,
                            style: context.textTheme.bodyLarge?.copyWith(color: kWhite, fontSize: 13),
                          ),
                          Text(
                            "${h.temperature.round()}°",
                            style: context.textTheme.bodyLarge?.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: kWhite,
                            ),
                          ),
                        ],
                      ),
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
