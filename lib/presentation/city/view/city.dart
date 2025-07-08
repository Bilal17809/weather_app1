import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather/core/routes/routes_name.dart';
import 'package:weather/data/model/model.dart';
import '../../../common/controller/controller.dart';
import '../../home/view/home_page.dart';
import '../../weather/view/weather.dart';

class City extends StatefulWidget {
  City({super.key});

  @override
  State<City> createState() => _CityState();
}

class _CityState extends State<City> {
  final CityController ctr = Get.put(CityController());
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => weather()),
                    );
                  },
                  child: Icon(Icons.arrow_back, color: Colors.white, size: 30),
                ),
                SizedBox(width: 60),
                Text(
                  "Manage cities",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(width: 70,),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(onPressed: (){
                    Navigator.pushNamed(context, RoutesName.favorite);
                  }, icon: Icon(Icons.favorite_border,color: Colors.white,)),
                )
              ],
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: searchController,
                onChanged: (value) => ctr.filterCities(value),
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
            Expanded(
              child: Obx(() {
                if (ctr.loading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                if (ctr.filteredList.isEmpty) {
                  return Center(
                    child: Text(
                      "No cities found.",
                      style: TextStyle(color: Colors.white, fontSize: 16),
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
                        ),
                        child: InkWell(
                          onTap: () {
                            ctr.setSelectedCity(city);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
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
                                                 style: const TextStyle(
                                                   fontSize: 26,
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
                                                       fontWeight: FontWeight.bold,
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
                                       "null",
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
                                   ctr.toggleFavorite(city,context);
                                 },
                               ),
                             ],
                           )
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
