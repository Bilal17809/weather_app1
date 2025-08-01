import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/common/controller/controller.dart';
import '../../../core/common_widgets/textform_field.dart';
import '../../../core/routes/routes_name.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../contrl/favt_controller.dart';
import 'city_name.dart';
// Replace with your actual HomeScreen import

class CityScreen extends StatefulWidget {
  @override
  State<CityScreen> createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  final CityController ctr =Get.find<CityController>();
  final FavoriteController favController = Get.find<FavoriteController>();
  final TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ctr.filterCities('');
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration:imagebg ,
        child: Column(
          children: [
            SizedBox(height: 30,),
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
                    "Manage cities",
                    style:context.textTheme.bodyLarge?.copyWith(
                      color: kWhite,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    )

                ),
                SizedBox(width: 68),
                // Align(
                //   alignment: Alignment.topRight,
                //   child: IconButton(
                //     onPressed: () {
                //       Navigator.pushNamed(context, RoutesName.citypage);
                //     },
                //     icon: Icon(
                //       Icons.add_circle_sharp,
                //       color: kWhite,
                //       size: 28,
                //     ),
                //   ),
                // ),

              ],
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: CustomTextFormField(
                hintText: "Search city...",
                controller: searchController,
                onChanged:  (value) => ctr.filterCities(value),
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

              )
            ),

            // 📋 City List
            Expanded(
              child: CityName(),
            ),
          ],
        ),
      ),
    );
  }
}
