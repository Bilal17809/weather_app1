import 'package:flutter/material.dart';

import 'package:weather/presentation/weather/view/weather.dart';
import '../../presentation/city/view/city.dart';
import '../../presentation/favrt_city/view/favrt_city_page.dart';
import '../../presentation/home/view/home_page.dart';
import '../../presentation/splash/splash_page.dart';
import 'routes_name.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {


    switch (settings.name) {
      case RoutesName.splashPage:
        return MaterialPageRoute(builder: (_) => Splash());
      case RoutesName.homePage:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case RoutesName.weatherpage:
        return MaterialPageRoute(builder: (_)=>weather());
      case RoutesName.citypage:
        return MaterialPageRoute(builder: (_)=>CityScreen());
      case RoutesName.favorite:
        return MaterialPageRoute(builder: (_)=>FavoriteCity());

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
