// import 'package:flutter/material.dart';
// import 'package:flutter_overlay_window/flutter_overlay_window.dart';
// import 'package:get/get.dart';
//
// import 'core/routes/routes.dart';
// import 'core/routes/routes_name.dart';
// import 'core/common/controller/controller.dart';
// import 'core/common/controller/current_weather_controller.dart';
// import 'package:weather/presentation/city/contrl/favt_controller.dart';
// import 'package:weather/presentation/daily_forecast/contrl/daily_contrl.dart';
// import 'package:weather/presentation/hourly_forecast/contrl/hourly_contrl.dart';
//
// import 'example/home_screen.dart';
//
// /// Request permission to draw overlay window
// // Future<void> requestOverlayPermission() async {
// //   if (!await FlutterOverlayWindow.isPermissionGranted()) {
// //     await FlutterOverlayWindow.requestPermission();
// //   }
// // }
//
// Future<void> main() async {
//   // WidgetsFlutterBinding.ensureInitialized();
//   //
//   // print('🔃 Requesting overlay permission...');
//   //
//   // print('✅ Overlay permission done');
//   //
//   // print('📦 Registering controllers...');
//   // Get.put<FavoriteController>(FavoriteController());
//   // Get.put<CityController>(CityController());
//   // Get.put<CurrentWeatherController>(CurrentWeatherController());
//   // Get.put<DailyForecastController>(DailyForecastController());
//   // Get.put<HourlyForecastController>(HourlyForecastController());
//   // print('✅ All controllers registered');
//
//   runApp(const MyApp());
// }
//
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Weather App',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
//         useMaterial3: true,
//       ),
//       home:const CurrentLocation(),
//       // initialRoute: RoutesName.splashPage,
//       // onGenerateRoute: Routes.generateRoute,
//     );
//   }
// }
//
// /// This function is required by `flutter_overlay_window` to run overlay UI
// // @pragma("vm:entry-point")
// // void overlayMain() {
// //   runApp(const MaterialApp(
// //     debugShowCheckedModeBanner: false,
// //     home: Scaffold(
// //       body: Center(
// //         child: Text(
// //           'Overlay Window',
// //           style: TextStyle(fontSize: 24),
// //         ),
// //       ),
// //     ),
// //   ));
// // }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart'; // ✅ correct import

import 'core/routes/routes.dart';
import 'core/routes/routes_name.dart';
import 'example/Splash/splash_page.dart';
import 'example/city/ctr/e_city_controller.dart';
import 'example/daily/controller/daily_controller.dart';
import 'example/home/screen/home_screen.dart';
import 'example/hourly/ctr/e_hourly_controler.dart';
import 'example/weather/controller/e_weather_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ Required

  await initializeDateFormatting('en_US', null); // ✅ Fixes the locale error

  // ✅ Initialize controllers after binding is ready
  Get.put(E_DailyForecastController());
  Get.put(E_HourlyForecastController());
  Get.put(E_CityController());
  Get.put(SelectedDayWeatherController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: RoutesName.splashPage,
      onGenerateRoute: Routes.generateRoute,
      // home: E_Splash(), // Make sure E_Splash() doesn't fail
    );
  }
}
