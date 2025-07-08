import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../common/controller/controller.dart';
import '../../../core/routes/routes_name.dart';
import '../../home/view/home_page.dart';

class favorite_city extends StatelessWidget {
  const favorite_city({super.key});

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
                SizedBox(width: 70,),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(onPressed: (){
                    Navigator.pushNamed(context, RoutesName.favorite);
                  }, icon: Icon(Icons.favorite,color: Colors.white,)),
                )
              ],
            ),
            Obx(() {
              if (ctr.favoriteCities.isEmpty) {
                return Center(child: Text("No favorites yet"));
              }

              return ListView.builder(
                itemCount: ctr.favoriteCities.length,
                itemBuilder: (context, index) {
                  final city = ctr.favoriteCities[index];
                  return ListTile(
                    title: Text(city.city),
                    trailing: Icon(Icons.favorite, color: Colors.red),
                    onTap: () {
                      ctr.setSelectedCity(city);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => HomeScreen()),
                      );
                    },
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
