import 'package:equatable/equatable.dart';

class DailyWeather extends Equatable {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final String condition;
  final double chanceOfRain;

  const DailyWeather({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.condition,
    required this.chanceOfRain,
  });

  @override
  List<Object?> get props => [date, maxTemp, minTemp, condition, chanceOfRain];
}

