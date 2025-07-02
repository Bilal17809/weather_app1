import 'package:flutter/material.dart';

import '../theme/app_styles.dart';

class BackIconButton extends StatelessWidget {
  const BackIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child:Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            decoration: rounderGreyBorderDecoration,
            padding: const EdgeInsets.all(5),
            child: Icon(Icons.arrow_back_ios)),
      )
    );
  }
}



class NotificationIconButton extends StatelessWidget {
  final VoidCallback onTap;

  const NotificationIconButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child:Icon(Icons.notifications_rounded)
    );
  }
}

class MoonIconButton extends StatelessWidget {
  final VoidCallback onTap;

  const MoonIconButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        'images/moon_icon.png',
      ),
    );
  }
}

class TrIconButton extends StatelessWidget {
  final VoidCallback onTap;

  const TrIconButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        'images/try_icon.png',
      ),
    );
  }
}

class compaignIconButton extends StatelessWidget {
  const compaignIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Image.asset(
        'images/Compaigns.svg',
      ),
    );
  }
}


class CardIcon extends StatelessWidget {
  final String icon;
  const CardIcon({
    super.key,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: roundedDecoration,
      padding: const EdgeInsets.all(8),
      child: Center(
        child: Image.asset(
          icon,
          height: 40,
          width: 40,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
