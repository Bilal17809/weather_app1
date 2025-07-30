import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../presentation/animation/animation.dart';
import '../../presentation/animation/text_animation.dart';
import '../city/ctr/e_city_controller.dart';
import '../home/screen/home_screen.dart';

class E_Splash extends StatefulWidget {
  E_Splash({super.key});
  @override
  State<E_Splash> createState() => _E_SplashState();
}

class _E_SplashState extends State<E_Splash> {
  bool showButton = false;
  final cityController = Get.find<E_CityController>();
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          showButton = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF06664F),
      body: SafeArea(
        child: SingleChildScrollView(
          // ✅ prevents overflow
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              AnimatedImageSequence(),
              SizedBox(height: 18),
              TypewriterText(
                text: "Malta Weather",
                speed: Duration(milliseconds: 150), // You can adjust speed
                style: context.textTheme.bodyLarge?.copyWith(
                  fontSize: 40,
                  color: orangeYellow,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TweenAnimationBuilder<Offset>(
                tween: Tween<Offset>(begin: Offset(-1, 0), end: Offset.zero),
                duration: Duration(milliseconds: 900),
                curve: Curves.easeInOutCirc,
                builder: (context, offset, child) {
                  return Transform.translate(
                    offset: offset * 200, // Slide distance
                    child: child,
                  );
                },
                child: Text(
                  "Forecast",
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: orangeYellow,
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                  ),
                ),
              ),

              SizedBox(height: 6),
              TweenAnimationBuilder<Offset>(
                tween: Tween<Offset>(begin: Offset(1, 0), end: Offset.zero),
                duration: Duration(milliseconds: 900),
                curve: Curves.easeOut,
                builder: (context, offset, child) {
                  return Transform.translate(
                    offset: offset * 200,
                    child: child,
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Weather App Leads in Malta",
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: kWhite,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),

                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "for Accurate Forecasts",
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: kWhite,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 87),

              showButton
                  ? ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CurrentLocation(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: orangeYellow,
                      foregroundColor: Color(0xFF002E3F),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        "Get Start",
                        style: context.textTheme.bodyLarge?.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                  : SpinKitThreeBounce(color: kWhite, size: 50.0),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
