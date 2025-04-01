import 'package:caelum/core/errors/failures.dart';
import 'package:caelum/domain/entities/forecast.dart';
import 'package:caelum/domain/entities/location.dart';
import 'package:caelum/domain/repositories/weather_repository.dart';
import 'package:dartz/dartz.dart';

class GetForecast {
  final WeatherRepository repository;

  GetForecast(this.repository);

  Future<Either<Failure, Forecast>> execute(Location location) async {
    return await repository.getForecast(location);
  }

  Future<Either<Failure, Forecast>> executeByCity(String city) async {
    return await repository.getForecastByCity(city);
  }

  Future<Either<Failure, Forecast>> executeByCurrentLocation() async {
    return await repository.getForecastByCurrentLocation();
  }
}

