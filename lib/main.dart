import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

import 'package:get/get.dart';
import 'package:weather/core/routes/routes.dart';
import 'package:weather/core/routes/routes_name.dart';
import 'package:weather/presentation/city/contrl/favt_controller.dart';

import 'package:weather/presentation/favrt_city/view/flutter_overlay_window.dart'; // Your overlay widget
import 'core/common/controller/controller.dart';
Future<void> requestOverlayPermission() async {
  if (!await FlutterOverlayWindow.isPermissionGranted()) {
    await FlutterOverlayWindow.requestPermission();
  }
}
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Request overlay permission
  await requestOverlayPermission();


  // Initialize GetX controllers
  Get.put(FavoriteController());

  Get.put(CityController());

  runApp(const MyApp());
}

/// Request permission for overlay


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {





  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      initialRoute: RoutesName.splashPage,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}

/// This function is required by `flutter_overlay_window` to run overlay UI

