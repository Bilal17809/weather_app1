class CityModel {
  final String city;
  final double temperature;
  final double lat;
  final double lon;
  final String? conditionText; // ✅ Optional condition
  bool isFavorite; // ✅ Favorite flag

  CityModel({
    required this.city,
    required this.temperature,
    required this.lat,
    required this.lon,
    this.conditionText,
    this.isFavorite = false,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      city: json['city'],
      temperature: (json['temperature'] as num).toDouble(),
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      conditionText: json['conditionText'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'city': city,
    'temperature': temperature,
    'lat': lat,
    'lon': lon,
    'conditionText': conditionText,
    'isFavorite': isFavorite,
  };
}
