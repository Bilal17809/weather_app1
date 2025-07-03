import 'package:flutter/material.dart';


import '../../common/controller/controller.dart';
import '../../presentation/home/view/home_page.dart';
import 'routes_name.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;

    switch (settings.name) {
      // case RoutesName.splashPage:
      //   return MaterialPageRoute(builder: (_) => const SplashPage());
      case RoutesName.homePage:
        return MaterialPageRoute(builder: (_) => HomeScreen());

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
