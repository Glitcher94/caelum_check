import 'package:equatable/equatable.dart';

class Weather extends Equatable {
  final double temperature;
  final String condition;
  final String conditionIcon;
  final int humidity;
  final double windSpeed;
  final String windDirection;

  const Weather({
    required this.temperature,
    required this.condition,
    required this.conditionIcon,
    required this.humidity,
    required this.windSpeed,
    required this.windDirection,
  });

  @override
  List<Object?> get props => [
        temperature,
        condition,
        conditionIcon,
        humidity,
        windSpeed,
        windDirection,
      ];
}

