// lib/services/weather_service.dart
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

import '../../../data/model/city_model.dart';
import '../api/api_service.dart';
 // Adjust path if needed

class WeatherService {




  static Future<Map<String, dynamic>?> getLocationAndWeather() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return {"error": "Location services disabled"};

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return {"error": "Permission denied"};
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return {"error": "Permission permanently denied"};
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      final city = placemarks.first.locality ?? "Unknown";

      return await fetchWeather(
        cityName: city,
        lat: position.latitude,
        lon: position.longitude,

      );
    } catch (e) {
      return {"error": e.toString()};
    }
  }
  // static Future<Map<String, dynamic>?> fetchWeather({
  //   required String cityName,
  //   double? lat,
  //   double? lon,
  // }) async {
  //   try {
  //     final data = await WeatherForecastService.Forecast(lat!, lon!); // make sure lat/lon are not null
  //
  //     return {
  //       "city": cityName,
  //       "temperature": "${data['current']['temp_c']}°C",
  //       "condition": data['current']['condition']['text'],
  //       "icon": data['current']['condition']['icon'],
  //       "lat": lat,
  //       "lng": lon,
  //     };
  //   } catch (e) {
  //     print('🚨 Exception: $e');
  //     return {"error": e.toString()};
  //   }
  // }
  // static Future<Map<String, dynamic>?> fetchWeather({
  //   required String cityName,
  //   double? lat,
  //   double? lon,
  // }) async {
  //   try {
  //     if (lat == null || lon == null) {
  //       throw Exception('Latitude and longitude are required');
  //     }
  //
  //     final data = await WeatherForecastService.Forecast(lat, lon);
  //
  //     // Debug log the raw data
  //     print('🌦 Full weather data: $data');
  //
  //     if (data is! Map ||
  //         data['current'] == null ||
  //         data['current'].isEmpty ||
  //         data['current']['condition'] == null ||
  //         data['forecast'] == null ||
  //         data['forecast']['forecastday'] == null ||
  //         (data['forecast']['forecastday'] as List).isEmpty) {
  //       throw Exception('! Invalid data structure: $data');
  //     }
  //
  //
  //     return {
  //       "city": cityName,
  //       "temperature": "${data['current']['temp_c']}°C",
  //       "condition": data['current']['condition']['text'],
  //       "icon": data['current']['condition']['icon'],
  //       "lat": lat,
  //       "lng": lon,

  //     };
  //   } catch (e) {
  //     print('🚨 Exception in fetchWeather: $e');
  //     return {"error": e.toString()};
  //   }
  // }
  static Future<Map<String, dynamic>?> fetchWeather({
    required String cityName,
    required double lat,
    required double lon,
  }) async {
    try {
      final data = await WeatherForecastService.Forecast(lat, lon);

      print('🌦 Full weather data: $data');

      if (data is! Map ||
          data['current'] == null ||
          data['current'].isEmpty ||
          data['current']['condition'] == null ||
          data['forecast'] == null ||
          data['forecast']['forecastday'] == null ||
          (data['forecast']['forecastday'] as List).isEmpty) {
        throw Exception('Invalid data structure: $data');
      }

      String? airQualityText;
      String? airQualityIndex;
      if (data['current']['air_quality'] != null) {
        final aqi = data['current']['air_quality']['pm2_5'];
        final aqiValue = double.tryParse(aqi.toString()) ?? 0;

        airQualityIndex = aqiValue.toStringAsFixed(0); // Example: "78"

        if (aqiValue <= 50) {
          airQualityText = "Good";
        } else if (aqiValue <= 100) {
          airQualityText = "Moderate";
        } else if (aqiValue <= 150) {
          airQualityText = "Unhealthy for Sensitive Groups";
        } else {
          airQualityText = "Unhealthy";
        }
      }

      return {
        "city": cityName,
        "temperature": "${data['current']['temp_c']}°C",
        "condition": data['current']['condition']['text'],
        "icon": data['current']['condition']['icon'],
        "lat": lat,
        "lng": lon,
        "airQualityIndex": airQualityIndex ?? "N/A",
        "airQualityText": airQualityText ?? "N/A",
      };
    } catch (e) {
      print('🚨 Exception in fetchWeather: $e');
      return {"error": e.toString()};
    }
  }





  static Future<Map<String, dynamic>?> fetchWeatherForCity(Malta city) {
    return fetchWeather(
      cityName: city.city,
      lat: city.lat,
      lon: city.lng,

    );
  }
}
