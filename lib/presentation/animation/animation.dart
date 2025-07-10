import 'package:flutter/material.dart';

class AnimatedImageSequence extends StatefulWidget {
  const AnimatedImageSequence({super.key});

  @override
  State<AnimatedImageSequence> createState() => _AnimatedImageSequenceState();
}

class _AnimatedImageSequenceState extends State<AnimatedImageSequence>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  Animation<Offset>? _animation; // 👈 Make this nullable

  int currentIndex = 0;
  final List<String> images = [
    'assets/images/heavy-rain.png',
    'assets/images/sun.png',
    'assets/images/storm.png',
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 900),
    );

    _startSequence();
  }

  Future<void> _startSequence() async {
    for (int i = 0; i < images.length; i++) {
      setState(() {
        currentIndex = i;
        _animation = Tween<Offset>(
          begin: Offset(1, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
      });

      _controller.reset();
      _controller.forward();

      await Future.delayed(Duration(seconds: 3));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_animation == null) {
      // Prevent crash until animation is ready
      return SizedBox.shrink();
    }

    return SlideTransition(
      position: _animation!,
      child: Image.asset(
        images[currentIndex],
        width:300,
        height: 300,
      ),
    );
  }
}