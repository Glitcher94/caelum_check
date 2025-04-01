import 'package:caelum/core/errors/failures.dart';
import 'package:caelum/domain/entities/forecast.dart';
import 'package:caelum/domain/entities/location.dart';
import 'package:dartz/dartz.dart';

abstract class WeatherRepository {
  Future<Either<Failure, Forecast>> getForecast(Location location);
  Future<Either<Failure, Forecast>> getForecastByCity(String city);
  Future<Either<Failure, Forecast>> getForecastByCurrentLocation();
}

