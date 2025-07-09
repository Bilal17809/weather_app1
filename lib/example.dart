import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:weather/presentation/home/view/home_page.dart';

import '../../../common/controller/controller.dart';
import '../../../core/routes/routes_name.dart';


class FavoriteCity extends StatelessWidget {
  const FavoriteCity({super.key});

  @override
  Widget build(BuildContext context) {
    final CityController ctr = Get.find();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/weather6.png"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Color(0xFF00A67D).withOpacity(0.68),
              BlendMode.srcOver,
            ),
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 40),
            Row(
              children: [
                SizedBox(width: 20),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, RoutesName.citypage);
                  },
                  child: Icon(Icons.arrow_back, color: Colors.white, size: 30),
                ),
                SizedBox(width: 60),
                Text(
                  "Favorite cities",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(width: 70),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RoutesName.citypage);
                    },
                    icon: Icon(
                      Icons.add_circle_sharp,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

            // ✅ Fix: Wrap ListView.builder with Expanded
            Expanded(
              child: Obx(() {
                if (ctr.favoriteCities.isEmpty) {
                  return Center(
                    child: Text(
                      "No favorites yet",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  );
                }

                return Expanded(
                  child: ListView.builder(
                    itemCount: ctr.favoriteCities.length,
                    itemBuilder: (context, index) {
                      final city = ctr.favoriteCities[index];
                      return Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white, width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 5,
                              offset: Offset(2, 4),
                            ),
                          ],
                        ),
                        child: InkWell(
                          onTap: () {
                            ctr.setSelectedCity(city);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => HomeScreen()),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // 🏙 City Name + Population
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 8.0,
                                  left: 10,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          city.city,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(width: 2),
                                        Icon(
                                          Icons.location_pin,
                                          color: Colors.white,
                                          size: 17,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "Population",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                      ),
                                    ),
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
                                                    text: city.temperature != null
                                                        ? city.temperature!
                                                        .toStringAsFixed(1)
                                                        : 'Loading...',
                                                    style: const TextStyle(
                                                      fontSize: 23,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  WidgetSpan(
                                                    child: Transform.translate(
                                                      offset: Offset(2, -10),
                                                      child: Text(
                                                        '°',
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                          FontWeight.bold,
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
                                        Text(
                                          "null", // You can show condition or city.state etc.
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      city.isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      ctr.toggleFavorite(city, context);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
