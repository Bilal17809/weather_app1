import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


import '../../core/routes/routes_name.dart';
import '../animation/animation.dart';
import '../animation/text_animation.dart';


class Splash extends StatefulWidget {
  Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {


  bool showButton = false;

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
                style: TextStyle(
                  fontSize: 40,
                  color: Color(0xFFF19C1E),
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
                  style: TextStyle(
                    color: Color(0xFFF19C1E),
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
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),

                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "for Accurate Forecasts",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 80,),

              showButton
                  ? ElevatedButton(

                onPressed: () async {
                  await showOverlayIfPermitted();
                  Navigator.pushNamed(context, RoutesName.homePage);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF19C1E),
                  foregroundColor: Color(0xFF002E3F),
                ),
                child: Text(
                  "Get Start",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
                  : SpinKitThreeBounce(color: Colors.white, size: 50.0),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}


Future<void> showOverlayIfPermitted() async {
  final isGranted = await FlutterOverlayWindow.isPermissionGranted();

  if (!isGranted) {
    await FlutterOverlayWindow.requestPermission();
  }

  if (await FlutterOverlayWindow.isPermissionGranted()) {
    await FlutterOverlayWindow.showOverlay(
      height: 160,
      width: 200,
      alignment: OverlayAlignment.topRight,
      flag: OverlayFlag.defaultFlag,
      visibility: NotificationVisibility.visibilityPublic,
    );
  } else {
    // Optional: Show a dialog or toast saying permission is required
    print("❌ Overlay permission not granted by the user.");
  }
}
