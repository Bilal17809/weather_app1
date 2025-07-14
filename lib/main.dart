import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/core/routes/routes.dart';
import 'package:weather/core/routes/routes_name.dart';
import 'package:weather/presentation/city/contrl/favt_controller.dart';
import 'core/common/controller/controller.dart';


Future<void> main()  async {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(FavoriteController());

  Get.put(CityController());

  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),

      initialRoute: RoutesName.splashPage,
      onGenerateRoute: Routes.generateRoute,
      // home:CityController(),
    );
  }
}




