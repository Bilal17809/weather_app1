import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/theme/app_colors.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Drawer(
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.15,
                color: bgDark,
                child: Center(
                  child: Text(
                    'Weather App',
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.star_rate),
                title: Text('Rate Us'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.privacy_tip),
                title: Text('Privacy'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.apps),
                title: Text('More Apps'),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
