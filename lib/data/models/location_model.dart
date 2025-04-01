import 'package:caelum/domain/entities/location.dart';

class LocationModel extends Location {
  const LocationModel({
    required super.latitude,
    required super.longitude,
    required super.name,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: json['lat'] != null ? json['lat'].toDouble() : 0.0,
      longitude: json['lon'] != null ? json['lon'].toDouble() : 0.0,
      name: json['name'] ?? 'Desconocido',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': latitude,
      'lon': longitude,
      'name': name,
    };
  }
}

