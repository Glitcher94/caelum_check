import 'package:caelum/domain/entities/current_weather.dart';

class CurrentWeatherModel extends CurrentWeather {
  const CurrentWeatherModel({
    required super.temperature,
    required super.feelsLike,
    required super.condition,
    required super.humidity,
    required super.windSpeed,
    required super.visibility,
    required super.lastUpdated,
  });

  factory CurrentWeatherModel.fromJson(Map<String, dynamic> json) {
    return CurrentWeatherModel(
      temperature: json['temp_c'] != null ? json['temp_c'].toDouble() : 0.0,
      feelsLike: json['feelslike_c'] != null ? json['feelslike_c'].toDouble() : 0.0,
      condition: json['condition'] != null ? json['condition']['text'] : 'Desconocido',
      humidity: json['humidity'] ?? 0,
      windSpeed: json['wind_kph'] != null ? json['wind_kph'].toDouble() : 0.0,
      visibility: json['vis_km'] != null ? json['vis_km'].toDouble() : 0.0,
      lastUpdated: json['last_updated'] != null
          ? DateTime.parse(json['last_updated'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temp_c': temperature,
      'feelslike_c': feelsLike,
      'condition': {
        'text': condition,
      },
      'humidity': humidity,
      'wind_kph': windSpeed,
      'vis_km': visibility,
      'last_updated': lastUpdated.toIso8601String(),
    };
  }
}

