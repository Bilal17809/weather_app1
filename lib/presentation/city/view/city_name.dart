import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../core/common/controller/controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../favrt_city/controller/favt_controller.dart';
import '../../home/view/home_page.dart';

class CityName extends StatefulWidget {
  const CityName({super.key});

  @override
  State<CityName> createState() => _CityNameState();
}

class _CityNameState extends State<CityName> {
  final CityController ctr = Get.find();
  final FavoriteController favController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (ctr.loading.value) {
        return Center(child: CircularProgressIndicator());
      }

      if (ctr.filteredList.isEmpty) {
        return Center(
          child: Text(
            "No cities found.",
            style: context.textTheme.bodyLarge?.copyWith(color: kWhite, fontSize: 16)
            ,
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 13),
        itemCount: ctr.filteredList.length,
        itemBuilder: (context, index) {
          final city = ctr.filteredList[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              height: 70,
              decoration: roundedwithgradent,
              child: InkWell(
                onTap: () {
                  ctr.setSelectedCity(city);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 🏙 City Name + Population
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                city.city,
                                style:context.textTheme.bodyLarge?.copyWith(
                                  color: dividerColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                )
                              
                              ),
                              SizedBox(width: 2),
                              Icon(
                                Icons.location_pin,
                                color: dividerColor,
                                size: 17,
                              ),
                            ],
                          ),
                          Obx(() {
                            final detail = Get.find<CityController>().details;
                            print(
                              "🔍 detail length: ${detail.length}",
                            ); // DEBUG

                            if (detail.isEmpty) return SizedBox();

                            final d = detail.first;

                            return Text(
                              "Air Quality ${d.airQualityIndex} - ${d.airQualityText}",
                              style:context.textTheme.bodyLarge?.copyWith(
                                color: dividerColor,
                                  fontSize: 16,
                              )

                            );
                          }),
                        ],
                      ),
                    ),

                    // 🌡 Temperature + Favorite Icon
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              city.temperature != null
                                                  ? city.temperature!
                                                      .toStringAsFixed(1)
                                                  : 'Loading...',
                                          style: context.textTheme.bodyLarge?.copyWith(
                                            fontSize: 23,
                                            fontWeight: FontWeight.bold,
                                            color: kWhite,
                                          )
                                         
                                        ),
                                        WidgetSpan(
                                          child: Transform.translate(
                                            offset: Offset(1, 1),
                                            child: Text(
                                              '°',
                                              style:  context.textTheme.bodyLarge?.copyWith(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: kWhite,
                                              )
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Obx(() {
                                final detail =
                                    Get.find<CityController>().details;
                                print(
                                  "🔍 detail length: ${detail.length}",
                                ); // DEBUG

                                if (detail.isEmpty) return SizedBox();

                                final d = detail.first;

                                return Text(
                                  d.conditionText,
                                  style: context.textTheme.bodyLarge?.copyWith(
                                    color: kWhite,
                                    fontSize: 12,
                                  )
                                 
                                );
                              }),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            city.isFavorite
                                ? Icons.remove_circle
                                : Icons.add_circle_sharp,
                            color: kWhite,
                          ),
                          onPressed: () {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              favController.toggleFavorite(city);
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  city.isFavorite
                                      ? '${city.city} removed from favorites'
                                      : '${city.city} added to favorites',
                                ),
                                duration: Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: bgPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
