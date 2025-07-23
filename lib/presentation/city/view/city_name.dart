import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather/core/routes/routes_name.dart';

import '../../../core/common/controller/current_weather_controller.dart';
import '../../../core/common/controller/controller.dart';
import '../../../core/common_widgets/overlay_widget.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../weather/contl/weather_service.dart';
import '../contrl/favt_controller.dart';
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
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showLoadingOverlay(context); // ✅ Safe to show overlay now
        });
      }

      final favoriteCities =
          ctr.filteredList.where((c) => c.isFavorite).toList();
      final otherCities = ctr.filteredList.where((c) => !c.isFavorite).toList();

      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 13),
        children: [
          InkWell(
            onTap: () {
              // Fetch location weather
              Get.find<CurrentWeatherController>()
                  .getCurrentLocationAndFetchWeather();
              // Get.find<DailyForecastController>().getCurrentLocationAndFetchDaily()
              Get.find<CityController>().loadCityPreview();
              // Navigate to home screen
              Navigator.pushNamed(context, RoutesName.homePage);
            },
            child: Container(
              height: 50,
              decoration: currenlocation,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: const [
                        Icon(Icons.my_location, color: dividerColor),
                        SizedBox(width: 8),
                        Text(
                          "Current Location",
                          style: TextStyle(
                            color: dividerColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(color: Colors.white24),

          if (favoriteCities.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.only(top: 3, bottom: 3),
              child: Text(
                '⭐ Favorite Cities',
                style: TextStyle(
                  color: kWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(color: Colors.white24),
            ...favoriteCities.map((city) => buildCityCard(city)).toList(),
          ],
          if (otherCities.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.only(top: 3, bottom: 3),
              child: Text(
                '📍 Other Cities',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(color: Colors.white24),
            ...otherCities.map((city) => buildCityCard(city)).toList(),
          ],
        ],
      );
    });
  }

  Widget buildCityCard(city) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        height: 70,
        decoration: roundedWithGradient(city),
        child: InkWell(
          onTap: () async {
            ctr.selectedCity.value = city; // ✅ assign whole Malta object
            await WeatherForecastService.fetchWeatherForecast(
              city.lat,
              city.lng,
            );
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // City Name & Air Quality
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          city.city,
                          style: context.textTheme.bodyLarge?.copyWith(
                            color: dividerColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Icon(
                          Icons.location_pin,
                          color: dividerColor,
                          size: 17,
                        ),
                      ],
                    ),
                    Obx(() {
                      final detail = Get.find<CityController>().details;
                      if (detail.isEmpty) return const SizedBox();
                      final d = detail.first;
                      return Text(
                        "Air Quality ${d.airQualityIndex} - ${d.airQualityText}",
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: dividerColor,
                          fontSize: 14,
                        ),
                      );
                    }),
                  ],
                ),
              ),

              // Temperature & Favorite Toggle
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              city.temperature != null
                                  ? city.temperature!.toStringAsFixed(1)
                                  : '...',
                              style: context.textTheme.bodyLarge?.copyWith(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: kWhite,
                              ),
                            ),
                            const SizedBox(width: 1),
                            Text(
                              '°',
                              style: context.textTheme.bodyLarge?.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: kWhite,
                              ),
                            ),
                          ],
                        ),
                        Obx(() {
                          final detail = Get.find<CityController>().details;
                          if (detail.isEmpty) return const SizedBox();
                          final d = detail.first;
                          return Text(
                            d.conditionText,
                            style: context.textTheme.bodySmall?.copyWith(
                              fontSize: 12,
                              color: kWhite,
                            ),
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
                          duration: const Duration(seconds: 2),
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
  }
}
