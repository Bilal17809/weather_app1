import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../core/common/controller/controller.dart';
import '../../../core/common_widgets/textform_field.dart';
import '../../../core/routes/routes_name.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../home/view/home_page.dart';
import '../../city/contrl/favt_controller.dart';

class FavoriteCity extends StatefulWidget {
  const FavoriteCity({super.key});

  @override
  State<FavoriteCity> createState() => _FavoriteCityState();
}

class _FavoriteCityState extends State<FavoriteCity> {
  final CityController ctr = Get.find();
  final TextEditingController searchController = TextEditingController();
  final favController = Get.find<FavoriteController>();
  void initState() {
    super.initState();

    // ✅ SAFELY assign filtered list after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ctr.filteredFavoriteCities.assignAll(ctr.favoriteCities);
    });
  }
  @override
  Widget build(BuildContext context) {



    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: imagebg,
        child: Column(
          children: [
            SizedBox(height: 40),
            Row(
              children: [
                SizedBox(width: 20),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, RoutesName.homePage);
                  },
                  child: Icon(Icons.arrow_back, color: kWhite, size: 30),
                ),
                SizedBox(width: 60),
                Text(
                  "Favorite cities",
                  style:context.textTheme.bodyLarge?.copyWith(
                    color: kWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  )
                  // TextStyle(
                  //   color: kWhite,
                  //   fontWeight: FontWeight.bold,
                  //   fontSize: 20,
                  // ),
                ),
                SizedBox(width: 68),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RoutesName.citypage);
                    },
                    icon: Icon(
                      Icons.add_circle_sharp,
                      color: kWhite,
                      size: 28,
                    ),
                  ),
                ),

              ],
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 10,right: 10),
              child: CustomTextFormField(
                hintText: "Search city...",
                controller: searchController,
                onChanged: (value) => ctr.filterFavoriteCities(value),
                style: TextStyle(color: blackTextColor),
                fillColor: kWhite,
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

              )

            ),

            // ✅ Fix: Wrap ListView.builder with Expanded
            Expanded(
              child: Obx(() {
                if (ctr.filteredFavoriteCities.isEmpty) {
                  return Center(
                    child: Text(
                      "No favorites yet",
                      style:context.textTheme.bodyLarge?.copyWith(
                          color: kWhite, fontSize: 16
                      )

                    ),
                  );
                }

                return ListView.builder(
                  itemCount: ctr.filteredFavoriteCities.length,
                  itemBuilder: (context, index) {
                    final city = ctr.filteredFavoriteCities[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12, left: 10, right: 10),
                      child: Container(
                        height: 70,

                        child: InkWell(
                          onTap: () {
                            ctr.setSelectedCity(city);
                           Navigator.pushNamed(context, RoutesName.homePage);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
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
                                            color: kWhite,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          )

                                        ),
                                        SizedBox(width: 2),
                                        Icon(Icons.location_pin, color: kWhite, size: 17),
                                      ],
                                    ),
                                    Obx(() {
                                      final detail = Get.find<CityController>().details;
                                      print("🔍 detail length: ${detail.length}"); // DEBUG

                                      if (detail.isEmpty) return SizedBox();

                                      final d = detail.first;

                                      return Text(
                                        "Air Quality ${d.airQualityIndex} - ${d.airQualityText}",
                                        style: context.textTheme.bodyLarge?.copyWith(
                                            color: kWhite, fontSize: 16
                                        )

                                      );
                                    }),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              city.temperature?.toStringAsFixed(1) ?? 'Loading...',
                                              style: context.textTheme.bodyLarge?.copyWith(
                                                fontSize: 23,
                                                fontWeight: FontWeight.bold,
                                                color:kWhite,
                                              )

                                            ),
                                            Transform.translate(
                                              offset: Offset(1, 1),
                                              child: Text(
                                                '°',
                                                style: context.textTheme.bodyLarge?.copyWith(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color:kWhite,
                                                )

                                              ),
                                            ),
                                          ],
                                        ),
                                        Obx(() {
                                          final detail = Get.find<CityController>().details;
                                          print("🔍 detail length: ${detail.length}"); // DEBUG

                                          if (detail.isEmpty) return SizedBox();

                                          final d = detail.first;

                                          return Text(
                                            d.conditionText,
                                            style: context.textTheme.bodyLarge?.copyWith(
                                              fontSize: 12,

                                              color: kWhite,
                                            )

                                          );
                                        }),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      city.isFavorite ? Icons.remove_circle: Icons.add_circle_sharp,
                                      color: kWhite,
                                    ),
                                    onPressed: () {
                                      favController.toggleFavorite(city);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            city.isFavorite
                                                ?'${city.city} added to favorites'
                                                :'${city.city} removed from favorites'

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
              }),
            ),

          ],
        ),
      ),
    );
  }
}
