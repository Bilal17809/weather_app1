import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const RoundedButton({
    super.key,
    required this.child,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final button = Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: child,
    );
    return onTap != null
        ? GestureDetector(onTap: onTap, child: button)
        : button;
  }
}




class AnimatedRoundedButton extends StatefulWidget {
  final Widget child;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const AnimatedRoundedButton({
    super.key,
    required this.child,
    this.backgroundColor,
    this.onTap,
  });

  @override
  State<AnimatedRoundedButton> createState() => _AnimatedRoundedButtonState();
}

class _AnimatedRoundedButtonState extends State<AnimatedRoundedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 2.0), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 2.0, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));
  }

  Future<void> _handleTap() async {
    if (widget.onTap != null) {
      await _controller.forward(from: 0.0); // Play pop animation
      widget.onTap!();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? Colors.transparent,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: widget.child,
        ),
      ),
    );
  }
}

