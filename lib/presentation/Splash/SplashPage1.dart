import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weather/core/routes/routes_name.dart';

class Splashpage1 extends StatefulWidget {
  Splashpage1({super.key});

  @override
  State<Splashpage1> createState() => _Splashpage1State();
}

class _Splashpage1State extends State<Splashpage1> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushNamed(context, RoutesName.splashPage);
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color:  Color(0xFF06664F),
          child: SingleChildScrollView( // ✅ prevents overflow
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                Image.asset(
                  "assets/images/sun.png",
                  width: 300,
                  height: 300,
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
