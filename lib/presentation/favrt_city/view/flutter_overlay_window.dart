import 'package:flutter/material.dart';

class WeatherOverlayWidget extends StatelessWidget {
  const WeatherOverlayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: Align(
          alignment: Alignment.topRight,
          child: Container(
            padding: const EdgeInsets.all(10),
            width: 180,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("🌤️ 32°C", style: TextStyle(color: Colors.white, fontSize: 20)),
                Text("Karachi", style: TextStyle(color: Colors.white70, fontSize: 16)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
