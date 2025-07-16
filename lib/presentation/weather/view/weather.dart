import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:weather/presentation/hourly_forecast/contrl/hourly_contrl.dart';
import 'package:weather/presentation/weather/view/w_forter.dart';
import '../../../core/common/controller/controller.dart' show CityController;
import '../../../core/routes/routes_name.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';

class weather extends StatelessWidget {
  weather({super.key});
  final CityController ctr = Get.put(CityController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgDark2,
        automaticallyImplyLeading: false,
        title: Obx(() {
          final city = ctr.selectedCity.value;
          final selectedDate = ctr.selectedDate.value;
          final now = DateTime.now();

          // Show selected date or current date
          final formattedDate = DateFormat('EEEE d MMMM').format(
            selectedDate ?? now,
          );

          final showCurrentLocation =
              ctr.currentLocationName.value != 'Detecting...' &&
                  !ctr.isCityManuallySelected.value;

          final locationName = showCurrentLocation
              ? ctr.currentLocationName.value
              : city?.city ?? 'Select city';

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: kWhite, size: 17),
                      const SizedBox(width: 5),
                      Text(
                        locationName,
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
                    formattedDate, // ← updated to show selected day
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: kWhite,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, RoutesName.citypage);
                  },
                  child: const Icon(Icons.add_circle_sharp, color: kWhite, size: 28),
                ),
              ),
            ],
          );
        })

      ),
      body: Container(
        decoration: bgwithgradent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [


            SizedBox(height: 25),
            Obx(() {
              final detail = Get.find<HourlyForecastController>().currentLocationDetail.value;

              if (detail == null) return SizedBox();

              return Column(
                children: [
                  Image.network(
                    detail.conditionIcon,
                    width: 210,
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 10),
                  Text(
                    detail.conditionText,
                    style: context.textTheme.bodyLarge?.copyWith(color: kWhite, fontSize: 15),
                  ),
                ],
              );
            }),
            SizedBox(height: 10),

            Divider(
              color:textGreyColor, // Line color
              thickness: 1, // Line thickness
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50, right: 30),
              child: Obx(() {
                final detail = Get.find<CityController>().details;

                print("🔍 details length: ${detail.length}");

                if (detail.isEmpty) {
                  return Center(
                    child: Text(
                      "no data",
                      style: context.textTheme.bodyLarge?.copyWith(color: kWhite),
                    ),
                  );
                }

                final d = detail.first;

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
              color: textGreyColor, // Line color
              thickness: 1, // Line thickness
            ),
            Weather_forter(),
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
        Text(label, style: TextStyle(color: kWhite)),
        Text(value, style: TextStyle(color: kWhite)),
      ],
    ),
  );
}
