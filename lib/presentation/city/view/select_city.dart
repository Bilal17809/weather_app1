import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../common/controller/controller.dart';
import '../../../core/routes/routes_name.dart';
import '../../home/view/home_page.dart';

class FavoriteCity extends StatefulWidget {
  const FavoriteCity({super.key});

  @override
  State<FavoriteCity> createState() => _FavoriteCityState();
}

class _FavoriteCityState extends State<FavoriteCity> {
  final CityController ctr = Get.find();
  final TextEditingController searchController = TextEditingController();

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
                    Navigator.pushNamed(context, RoutesName.homePage);
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
            Padding(
              padding: const EdgeInsets.only(left: 10,right: 10),
              child: TextField(
                controller: searchController,
                onChanged:  (value) => ctr.filterFavoriteCities(value),
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: "Search city...",
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.search, color: Color(0xFF009B78)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

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
                    itemCount: ctr.filteredFavoriteCities.length,
                    itemBuilder: (context, index) {
                      final city = ctr.filteredFavoriteCities[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12,left: 10,right: 10),
                        child: Container(
                          height: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFF00A67D),
                                Color(0xFF009072),
                                Color(0xFF02493F),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 6,
                                offset: Offset(4, 4),
                              ),
                            ],
                            // No border for non-favorites
                          ),
                          child: InkWell(
                            onTap: () {
                              ctr.setSelectedCity(city);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => HomeScreen()),
                              );
                            },
                            child:Row(
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
                                                        offset: Offset(2, 1),
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
