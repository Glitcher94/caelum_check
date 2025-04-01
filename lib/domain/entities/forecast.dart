import 'package:caelum/domain/entities/current_weather.dart';
import 'package:caelum/domain/entities/daily_weather.dart';
import 'package:caelum/domain/entities/location.dart';
import 'package:equatable/equatable.dart';

class Forecast extends Equatable {
  final Location location;
  final CurrentWeather current;
  final List<DailyWeather> daily;

  const Forecast({
    required this.location,
    required this.current,
    required this.daily,
  });

  @override
  List<Object?> get props => [location, current, daily];
}

