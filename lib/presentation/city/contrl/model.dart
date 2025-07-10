// TODO Implement this library.
// File: city_model.dart

class CityModel {
  final String city;
  final double temperature;

  CityModel({required this.city, required this.temperature});

  Map<String, dynamic> toJson() => {
    'city': city,
    'temperature': temperature,
  };

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      city: json['city'],
      temperature: (json['temperature'] as num).toDouble(),
    );
  }
}
