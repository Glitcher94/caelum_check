 
import 'package:caelum/core/errors/exceptions.dart';
import 'package:caelum/core/errors/failures.dart';
import 'package:caelum/core/network/network_info.dart';
import 'package:caelum/data/datasources/weather_remote_data_source.dart';
import 'package:caelum/data/models/current_weather_model.dart';
import 'package:caelum/data/models/forecast_model.dart';
import 'package:caelum/data/models/location_model.dart';
import 'package:caelum/data/repositories/weather_repository_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Genera los mocks
@GenerateMocks([WeatherRemoteDataSource, NetworkInfo, GeolocatorPlatform])
import 'weather_repository_impl_test.mocks.dart';

void main() {
  late WeatherRepositoryImpl repository;
  late MockWeatherRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockWeatherRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = WeatherRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('getForecast', () {
    final tLocationModel = LocationModel(
      latitude: 40.7128,
      longitude: -74.0060,
      name: 'New York',
    );

    final tForecastModel = ForecastModel(
      location: tLocationModel,
      current: CurrentWeatherModel(
        temperature: 20.0,
        feelsLike: 19.0,
        condition: 'Sunny',
        humidity: 50,
        windSpeed: 10.0,
        visibility: 10.0,
        lastUpdated: DateTime.now(),
      ),
      daily: [],
    );

    test(
      'should check if the device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockRemoteDataSource.getForecast(any))
            .thenAnswer((_) async => tForecastModel);
        // act
        repository.getForecast(tLocationModel);
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getForecast(any))
              .thenAnswer((_) async => tForecastModel);
          // act
          final result = await repository.getForecast(tLocationModel);
          // assert
          verify(mockRemoteDataSource.getForecast(tLocationModel));
          expect(result, equals(Right(tForecastModel)));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.getForecast(any))
              .thenThrow(ServerException(message: 'Failed to connect to server'));
          // act
          final result = await repository.getForecast(tLocationModel);
          // assert
          verify(mockRemoteDataSource.getForecast(tLocationModel));
          expect(result, equals(Left(ServerFailure(message: 'Failed to connect to server'))));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return network failure when the device is offline',
        () async {
          // act
          final result = await repository.getForecast(tLocationModel);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          expect(result, equals(Left(NetworkFailure(message: 'No hay conexión a internet'))));
        },
      );
    });
  });

  // Puedes añadir pruebas similares para getForecastByCity y getForecastByCurrentLocation
}

