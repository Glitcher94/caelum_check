 import 'package:caelum/core/errors/failures.dart';
import 'package:caelum/domain/entities/forecast.dart';
import 'package:caelum/domain/entities/location.dart';
import 'package:caelum/domain/entities/current_weather.dart';
import 'package:caelum/domain/repositories/weather_repository.dart';
import 'package:caelum/domain/usecases/get_forecast.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Genera los mocks
@GenerateMocks([WeatherRepository])
import 'get_forecast_test.mocks.dart';

void main() {
  late GetForecast usecase;
  late MockWeatherRepository mockWeatherRepository;

  setUp(() {
    mockWeatherRepository = MockWeatherRepository();
    usecase = GetForecast(mockWeatherRepository);
  });

  final tLocation = Location(
    latitude: 40.7128,
    longitude: -74.0060,
    name: 'New York',
  );

  final tForecast = Forecast(
    location: tLocation,
    current: CurrentWeather(
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
    'should get forecast from the repository for the location',
    () async {
      // arrange
      when(mockWeatherRepository.getForecast(any))
          .thenAnswer((_) async => Right(tForecast));
      // act
      final result = await usecase.execute(tLocation);
      // assert
      expect(result, Right(tForecast));
      verify(mockWeatherRepository.getForecast(tLocation));
      verifyNoMoreInteractions(mockWeatherRepository);
    },
  );

  test(
    'should get forecast from the repository for a city name',
    () async {
      // arrange
      when(mockWeatherRepository.getForecastByCity(any))
          .thenAnswer((_) async => Right(tForecast));
      // act
      final result = await usecase.executeByCity('New York');
      // assert
      expect(result, Right(tForecast));
      verify(mockWeatherRepository.getForecastByCity('New York'));
      verifyNoMoreInteractions(mockWeatherRepository);
    },
  );

  test(
    'should get forecast from the repository for current location',
    () async {
      // arrange
      when(mockWeatherRepository.getForecastByCurrentLocation())
          .thenAnswer((_) async => Right(tForecast));
      // act
      final result = await usecase.executeByCurrentLocation();
      // assert
      expect(result, Right(tForecast));
      verify(mockWeatherRepository.getForecastByCurrentLocation());
      verifyNoMoreInteractions(mockWeatherRepository);
    },
  );

  test(
    'should return a failure from the repository',
    () async {
      // arrange
      final failure = ServerFailure(message: 'Error');
      when(mockWeatherRepository.getForecast(any))
          .thenAnswer((_) async => Left(failure));
      // act
      final result = await usecase.execute(tLocation);
      // assert
      expect(result, Left(failure));
      verify(mockWeatherRepository.getForecast(tLocation));
      verifyNoMoreInteractions(mockWeatherRepository);
    },
  );
}


