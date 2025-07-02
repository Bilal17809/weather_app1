import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather/request.dart';
import 'model/model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home:  CityListScreen(),
    );
  }
}

class CityListScreen extends StatefulWidget {
  @override
  State<CityListScreen> createState() => _CityListScreenState();
}

class _CityListScreenState extends State<CityListScreen> {
  Future<List<MaltaCity>> loadCities() async {
    final String jsonString = await rootBundle.loadString('assets/MaltaWeather.json');
    final List<dynamic> jsonResponse = json.decode(jsonString);
    return jsonResponse.map((item) => MaltaCity.fromJson(item)).toList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cities of Malta')),
      body: FutureBuilder<List<MaltaCity>>(
        future: loadCities(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));

          final cities = snapshot.data!;
          return ListView.builder(
            itemCount: cities.length,
            itemBuilder: (context, index) {
              final city = cities[index];
              return ListTile(
                title: Text(city.city),
                subtitle: FutureBuilder<double?>(
                  future: fetchCityTemperature(city.lat, city.lng),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Loading temperature...");
                    } else if (snapshot.hasError || snapshot.data == null) {
                      return Text("Temperature not available");
                    } else {
                      return Text("Temperature: ${snapshot.data!.toStringAsFixed(1)} °C");
                    }
                  },
                ),
              );

            },
          );
        },
      ),
    );
  }
}