import 'package:ad_english_dictionary/presentations/ai_dictionary/view/ai_dictionary_page.dart';
import 'package:ad_english_dictionary/presentations/splash/view/splash_page.dart';
import 'package:flutter/material.dart';
import '../../presentations/home/view/home_page.dart';
import 'routes_name.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;

    switch (settings.name) {
      case RoutesName.splashPage:
      //   return MaterialPageRoute(builder: (_) => const SplashPage());
      // case RoutesName.homePage:
      //   return MaterialPageRoute(builder: (_) => const HomePage());
      // case RoutesName.aiDictionaryPage:
      //   return MaterialPageRoute(builder: (_) => const AiDictionaryPage());
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
