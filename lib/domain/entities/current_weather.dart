import 'package:equatable/equatable.dart';

class CurrentWeather extends Equatable {
  final double temperature;
  final double feelsLike;
  final String condition;
  final int humidity;
  final double windSpeed;
  final double visibility;
  final DateTime lastUpdated;

  const CurrentWeather({
    required this.temperature,
    required this.feelsLike,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.visibility,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [
        temperature,
        feelsLike,
        condition,
        humidity,
        windSpeed,
        visibility,
        lastUpdated,
      ];
}

