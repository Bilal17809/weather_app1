import 'package:flutter/material.dart';

import '../../example/Splash/splash_page.dart';
import '../../example/city/view/cityname.dart';
import '../../example/home/screen/home_screen.dart';
import '../../example/weather/screen/weather_screen.dart';

import 'routes_name.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {


    switch (settings.name) {
      case RoutesName.splashPage:
        return MaterialPageRoute(builder: (_) => E_Splash());
      case RoutesName.homePage:
        return MaterialPageRoute(builder: (_) => CurrentLocation());
      case RoutesName.weatherpage:
        return MaterialPageRoute(builder: (_)=>SelectedDayDetailsWidget());
      case RoutesName.citypage:
        return MaterialPageRoute(builder: (_)=>CitySelectionScreen());
      // case RoutesName.favorite:
      //   return MaterialPageRoute(builder: (_)=>FavoriteCity());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for "${settings.name}"'),
            ),
          ),
        );
    }
  }
}
