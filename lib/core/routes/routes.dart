import 'package:flutter/material.dart';
import 'package:weather/presentation/city/view/select_city.dart';
import 'package:weather/presentation/weather/view/weather.dart';
import '../../presentation/Splash/SplashPage.dart';
import '../../presentation/Splash/SplashPage1.dart';
import '../../presentation/city/view/city.dart';
import '../../presentation/home/view/home_page.dart';
import 'routes_name.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;

    switch (settings.name) {
      case RoutesName.splashPage:
        return MaterialPageRoute(builder: (_) =>  Splash());
      case RoutesName.homePage:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case RoutesName.weatherpage:
        return MaterialPageRoute(builder: (_)=>weather());
      case RoutesName.citypage:
        return MaterialPageRoute(builder: (_)=>CityScreen());
      case RoutesName.favorite:
        return MaterialPageRoute(builder: (_)=>FavoriteCity());
      case RoutesName.Splash:
        return MaterialPageRoute(builder: (_)=>Splashpage1());
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
