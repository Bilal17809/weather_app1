// lib/widgets/custom_drawer.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';


class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: bgDark),
            child: Text(
              'Weather App',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: Icon(Icons.star_rate),
            title: Text('Rate Us'),
            onTap: () {

            },
          ),
          ListTile(
            leading: Icon(Icons.privacy_tip),
            title: Text('Privacy'),
            onTap: () {

            },
          ),
          ListTile(
            leading: Icon(Icons.apps),
            title: Text('More Apps'),
            onTap: () {

            },
          ),
        ],
      ),
    );
  }
}
