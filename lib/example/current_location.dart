import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import 'cityname.dart'; // Screen to select a city

class CurrentLocation extends StatefulWidget {
  const CurrentLocation({super.key});

  @override
  State<CurrentLocation> createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation> {
  String locationText = "Getting location...";
  String temperature = "--°C";
  String condition = "";
  String conditionIcon = "";

  @override
  void initState() {
    super.initState();
    getLocationAndWeather();
  }

  String getCurrentTime() {
    DateTime now = DateTime.now();
    return DateFormat('EEEE, d MMMM').format(now);
  }

  // 🔹 Get location and weather using GPS
  Future<void> getLocationAndWeather() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => locationText = "Location services disabled");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => locationText = "Location permission denied");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() => locationText = "Permission permanently denied");
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks.first;

      String cityName = place.locality ?? "Unknown";

      await fetchWeather(cityName: cityName, lat: position.latitude, lon: position.longitude);
    } catch (e) {
      setState(() => temperature = "Error: $e");
    }
  }

  // 🔹 Fetch weather from WeatherAPI
  Future<void> fetchWeather({required String cityName, double? lat, double? lon}) async {
    try {
      String apiKey = "8e1b9cfeaccc48c4b2b85154230304";
      String query = (lat != null && lon != null) ? "$lat,$lon" : cityName;

      final url = "https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$query&aqi=no";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final tempC = data['current']['temp_c'];
        final conditionText = data['current']['condition']['text'];
        final iconUrl = data['current']['condition']['icon'];

        setState(() {
          locationText = cityName;
          temperature = "$tempC°C";
          condition = conditionText;
          conditionIcon = iconUrl;
        });
      } else {
        setState(() => temperature = "Failed to fetch weather");
      }
    } catch (e) {
      setState(() => temperature = "Error: $e");
    }
  }

  // 🔹 Called when user selects a city like Islamabad
  void fetchWeatherForCity(String cityName) {
    fetchWeather(cityName: cityName);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
        ),

      ),
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              locationText,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Text(
              getCurrentTime(),
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        centerTitle: true,
        actions: [

          IconButton(
            onPressed: () async {
              final selectedCity = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CitySelectionScreen()),
              );

              if (selectedCity != null && selectedCity is String) {
                fetchWeatherForCity(selectedCity);
              }
            },
            icon: const Icon(Icons.add_circle),
          ),
        ],
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (conditionIcon.isNotEmpty)
                Image.network(
                  "https:${conditionIcon.replaceAll('64x64', '128x128')}",
                  width: screenWidth * 0.7, // 50% of screen width
                  height: screenWidth * 0.6,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                ),

              Text(
                temperature,
                style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Center(
                child: Text(
                  condition,
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
