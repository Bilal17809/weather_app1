import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/common/controller/controller.dart';
import '../../../core/common_widgets/textform_field.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_styles.dart';
import '../../favrt_city/controller/favt_controller.dart';
import '../../home/view/home_page.dart';
import 'city_name.dart';
// Replace with your actual HomeScreen import

class CityScreen extends StatefulWidget {
  @override
  State<CityScreen> createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  final CityController ctr = Get.find();
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

            SizedBox(height: 50,),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: CustomTextFormField(
                hintText: "Search city...",
                controller: searchController,
                onChanged: (value) => ctr.filterFavoriteCities(value),
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
