// city_selection_screen.dart
import 'package:flutter/material.dart';

class CitySelectionScreen extends StatelessWidget {
  final List<String> cities = ['Islamabad', 'Lahore', 'Karachi'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select City')),
      body: ListView.builder(
        itemCount: cities.length,
        itemBuilder: (_, index) {
          return ListTile(
            title: Text(cities[index]),
            onTap: () {
              Navigator.pop(context, cities[index]); // Return selected city
            },
          );
        },
      ),
    );
  }
}
