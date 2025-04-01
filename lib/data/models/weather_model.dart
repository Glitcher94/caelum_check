import 'package:caelum/domain/entities/weather.dart';

class WeatherModel extends Weather {
  const WeatherModel({
    required super.temperature,
    required super.condition,
    required super.conditionIcon,
    required super.humidity,
    required super.windSpeed,
    required super.windDirection,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      temperature: json['temp_c'] != null ? json['temp_c'].toDouble() : 0.0,
      condition: json['condition'] != null ? json['condition']['text'] : 'Desconocido',
      conditionIcon: json['condition'] != null ? json['condition']['icon'] : '',
      humidity: json['humidity'] ?? 0,
      windSpeed: json['wind_kph'] != null ? json['wind_kph'].toDouble() : 0.0,
      windDirection: json['wind_dir'] ?? 'N/A',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temp_c': temperature,
      'condition': {
        'text': condition,
        'icon': conditionIcon,
      },
      'humidity': humidity,
      'wind_kph': windSpeed,
      'wind_dir': windDirection,
    };
  }
}

