class Malta {
  final String city;
  final String cityAscii;
  final double lat;
  final double lng;
  final String country;
  final String iso2;
  final String iso3;
  final String adminName;
  final String capital;
  final int? population;
  final int id;
  double? temperature;
  bool isFavorite;

  // ✅ Optional Weather Info
  String? conditionText;
  String? conditionIcon;
  int? airQualityIndex;
   String? airQualityText;

  Malta({
    required this.city,
    required this.cityAscii,
    required this.lat,
    required this.lng,
    required this.country,
    required this.iso2,
    required this.iso3,
    required this.adminName,
    required this.capital,
    this.population,
    required this.id,
    this.temperature,
    this.conditionText,
    this.conditionIcon,
    this.isFavorite = false,
    this.airQualityIndex,
    this.airQualityText,
  });

  factory Malta.fromJson(Map<String, dynamic> json) {
    final airQualityString = json['airQuality'];
    int? parsedIndex;
    String? parsedText;

    if (airQualityString != null && airQualityString is String && airQualityString.contains(' - ')) {
      final parts = airQualityString.split(' - ');
      parsedIndex = int.tryParse(parts[0]);
      parsedText = parts.length > 1 ? parts[1] : null;
    }

    return Malta(
      city: json['city'],
      cityAscii: json['city_ascii'],
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      country: json['country'],
      iso2: json['iso2'],
      iso3: json['iso3'],
      adminName: json['admin_name'],
      capital: json['capital'],
      population: json['population'] != null ? (json['population'] as num).toInt() : null,
      id: json['id'],
      temperature: (json['temperature'] as num?)?.toDouble(),
      conditionText: json['conditionText'],
      conditionIcon: json['conditionIcon'],
      isFavorite: json['isFavorite'] ?? false,
      airQualityIndex: parsedIndex,
      airQualityText: parsedText,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'city_ascii': cityAscii,
      'lat': lat,
      'lng': lng,
      'country': country,
      'iso2': iso2,
      'iso3': iso3,
      'admin_name': adminName,
      'capital': capital,
      'population': population,
      'id': id,
      'temperature': temperature,
      'conditionText': conditionText,
      'conditionIcon': conditionIcon,
      'isFavorite': isFavorite,
      'airQuality': airQualityIndex != null && airQualityText != null
          ? "$airQualityIndex - $airQualityText"
          : null,
    };
  }

}
