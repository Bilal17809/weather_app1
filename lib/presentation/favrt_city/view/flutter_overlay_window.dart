import 'package:flutter/material.dart';

void overlayMain() {
  runApp(const MaterialApp(home: OverlayWidget()));
}

class OverlayWidget extends StatelessWidget {
  const OverlayWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 200,
        height: 200,
        color: Colors.blue.withOpacity(0.8),
        child: const Center(child: Text("🌦️ Weather", style: TextStyle(color: Colors.white))),
      ),
    );
  }
}
