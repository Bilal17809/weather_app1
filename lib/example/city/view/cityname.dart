import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather/core/theme/app_colors.dart';
import '../../../core/common_widgets/textform_field.dart';
import '../../../core/routes/routes_name.dart';
import '../../../core/theme/app_styles.dart';
import '../../../data/model/city_model.dart';
import '../../daily/controller/daily_controller.dart';
import '../ctr/e_city_controller.dart';
import '../../home/screen/home_screen.dart';

class CitySelectionScreen extends StatefulWidget {
  @override
  State<CitySelectionScreen> createState() => _CitySelectionScreenState();
}

class _CitySelectionScreenState extends State<CitySelectionScreen> {
  final E_CityController ctr = Get.put(E_CityController());

  final TextEditingController searchController = TextEditingController();

  final E_DailyForecastController dctr= Get.put(E_DailyForecastController());

  double responsiveFont(BuildContext context, double size) {
    return MediaQuery.of(context).size.height * size;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: imagebg,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Stack(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(
                      Icons.keyboard_backspace_outlined,
                      color: kWhite,
                      size: responsiveFont(context, 0.04),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      'Select City',
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: kWhite,
                        fontSize: responsiveFont(context, 0.03),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: CustomTextFormField(
                  hintText: "Search city...",
                  controller: searchController,
                  onChanged: (value) => ctr.filterCities(value),
                  style: context.textTheme.bodyLarge?.copyWith(color: blackTextColor),
                  fillColor: dividerColor,
                  prefixIcon: Icon(Icons.search, color: sreachbarcol),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: bgPrimary),
                  ),
                ),
              ),

              // Current Location Card

              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, RoutesName.homePage);
                },
                child: Container(
                  height: responsiveFont(context, 0.07),
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [bgPrimary, bgSecondary, bgDark],
                    ),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      const Icon(Icons.my_location, color: Colors.white),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Use Current Location",
                            style: context.textTheme.bodyLarge?.copyWith(
                              color: Colors.white,
                              fontSize: responsiveFont(context, 0.024),
                            ),
                          ),
                          Obx(() => Text(
                            dctr.currentCityName.value,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: Colors.white70,
                              fontSize: responsiveFont(context, 0.02),
                            ),
                          )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Favorite & Other City Lists
              Expanded(
                child: Obx(() {
                  final favorites = ctr.favoriteCities;
                  final others = ctr.nonFavoriteCities;

                  return ListView(
                    children: [
                      if (favorites.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child: Text("Favorite Cities", style: TextStyle(color: Colors.white)),
                        ),
                        ...favorites.map((city) => buildCityTile(context, city)).toList(),
                        const Divider(color: Colors.white),
                      ],
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: Text("Other Cities", style: TextStyle(color: Colors.white)),
                      ),
                      ...others.map((city) => buildCityTile(context, city)).toList(),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCityTile(BuildContext context, Malta city) {
    return Container(
      height: responsiveFont(context, 0.08),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(

        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [bgPrimary, bgSecondary, bgDark],
        ),
        border: Border.all(
          color: ctr.selectedCity.value?.city == city.city
              ? Colors.white
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              city.city,
              style: context.textTheme.bodyLarge?.copyWith(
                color: kWhite,
                fontSize: responsiveFont(context, 0.020),
              ),
            ),
            if (city.airQualityIndex != null && city.airQualityText != null)
              Text(
                'Air Quality: ${city.airQualityIndex} - ${city.airQualityText}',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),




          ],
        ),

        trailing: (city.temperature != null && city.conditionText != null)
            ? Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,

          children: [
            SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${city.temperature?.toStringAsFixed(1)}°C',
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: kWhite,
                    fontSize: responsiveFont(context, 0.021),
                  ),
                ),
                Text(
                  city.conditionText!,
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: kWhite,
                    fontSize: responsiveFont(context, 0.018),
                  ),
                ),
              ],
            ),
            // SizedBox(width: 10,),
            IconButton(
              icon: Icon(
                city.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.white,
              ),
              onPressed: () => ctr.toggleFavorite(city),
            ),
          ],
        )
            : const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            color: kWhite,
            strokeWidth: 2,
          ),
        ),
        onTap: () {
          ctr.selectCity(city); // save selected city
          Navigator.pop(context, city); // close dialog
        },

      ),
    );
  }
}
