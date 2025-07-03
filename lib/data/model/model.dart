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
  });

  factory Malta.fromJson(Map<String, dynamic> json) {
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
    };
  }
}
