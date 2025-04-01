import 'package:caelum/core/errors/exceptions.dart';
import 'package:caelum/core/errors/failures.dart';
import 'package:caelum/core/network/network_info.dart';
import 'package:caelum/data/datasources/weather_remote_data_source.dart';
import 'package:caelum/data/models/location_model.dart';
import 'package:caelum/domain/entities/forecast.dart';
import 'package:caelum/domain/entities/location.dart';
import 'package:caelum/domain/repositories/weather_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  WeatherRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Forecast>> getForecast(Location location) async {
    if (await networkInfo.isConnected) {
      try {
        final locationModel = LocationModel(
          latitude: location.latitude,
          longitude: location.longitude,
          name: location.name,
        );
        final forecastModel = await remoteDataSource.getForecast(locationModel);
        return Right(forecastModel);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, Forecast>> getForecastByCity(String city) async {
    if (await networkInfo.isConnected) {
      try {
        final forecastModel = await remoteDataSource.getForecastByCity(city);
        return Right(forecastModel);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }

  @override
  Future<Either<Failure, Forecast>> getForecastByCurrentLocation() async {
    if (await networkInfo.isConnected) {
      try {
        // Obtener la ubicación actual
        final position = await _determinePosition();
        final locationModel = LocationModel(
          latitude: position.latitude,
          longitude: position.longitude,
          name: 'Ubicación actual',
        );
        final forecastModel = await remoteDataSource.getForecast(locationModel);
        return Right(forecastModel);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } on LocationException catch (e) {
        return Left(LocationFailure(message: e.message));
      }
    } else {
      return Left(NetworkFailure(message: 'No hay conexión a internet'));
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationException(
          message: 'Los servicios de ubicación están desactivados');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw LocationException(
            message: 'Los permisos de ubicación fueron denegados');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw LocationException(
          message:
              'Los permisos de ubicación están permanentemente denegados, no podemos solicitar permisos');
    }

    return await Geolocator.getCurrentPosition();
  }
}

