 import 'package:bloc_test/bloc_test.dart';
import 'package:caelum/core/errors/failures.dart';
import 'package:caelum/domain/entities/current_weather.dart';
import 'package:caelum/domain/entities/forecast.dart';
import 'package:caelum/domain/entities/location.dart';
import 'package:caelum/domain/usecases/get_forecast.dart';
import 'package:caelum/presentation/blocs/weather/weather_cubit.dart';
import 'package:caelum/presentation/blocs/weather/weather_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Genera los mocks
@GenerateMocks([GetForecast])
import 'weather_cubit_test.mocks.dart';

void main() {
  late WeatherCubit cubit;
  late MockGetForecast mockGetForecast;

  setUp(() {
    mockGetForecast = MockGetForecast();
    cubit = WeatherCubit(getForecast: mockGetForecast);
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state should be WeatherInitial', () {
    expect(cubit.state, equals(WeatherInitial()));
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

  group('getForecastByLocation', () {
    blocTest<WeatherCubit, WeatherState>(
      'should emit [WeatherLoading, WeatherLoaded] when data is gotten successfully',
      build: () {
        when(mockGetForecast.execute(any))
            .thenAnswer((_) async => Right(tForecast));
        return cubit;
      },
      act: (cubit) => cubit.getForecastByLocation(tLocation),
      expect: () => [
        WeatherLoading(),
        WeatherLoaded(tForecast),
      ],
      verify: (cubit) {
        verify(mockGetForecast.execute(tLocation));
      },
    );

    blocTest<WeatherCubit, WeatherState>(
      'should emit [WeatherLoading, WeatherError] when getting data fails',
      build: () {
        when(mockGetForecast.execute(any))
            .thenAnswer((_) async => Left(ServerFailure(message: 'Server error')));
        return cubit;
      },
      act: (cubit) => cubit.getForecastByLocation(tLocation),
      expect: () => [
        WeatherLoading(),
        WeatherError('Server error'),
      ],
      verify: (cubit) {
        verify(mockGetForecast.execute(tLocation));
      },
    );
  });

  group('getForecastByCity', () {
    blocTest<WeatherCubit, WeatherState>(
      'should emit [WeatherLoading, WeatherLoaded] when data is gotten successfully',
      build: () {
        when(mockGetForecast.executeByCity(any))
            .thenAnswer((_) async => Right(tForecast));
        return cubit;
      },
      act: (cubit) => cubit.getForecastByCity('New York'),
      expect: () => [
        WeatherLoading(),
        WeatherLoaded(tForecast),
      ],
      verify: (cubit) {
        verify(mockGetForecast.executeByCity('New York'));
      },
    );

    blocTest<WeatherCubit, WeatherState>(
      'should emit [WeatherLoading, WeatherError] when getting data fails',
      build: () {
        when(mockGetForecast.executeByCity(any))
            .thenAnswer((_) async => Left(ServerFailure(message: 'Server error')));
        return cubit;
      },
      act: (cubit) => cubit.getForecastByCity('New York'),
      expect: () => [
        WeatherLoading(),
        WeatherError('Server error'),
      ],
      verify: (cubit) {
        verify(mockGetForecast.executeByCity('New York'));
      },
    );
  });

  group('getForecastByCurrentLocation', () {
    blocTest<WeatherCubit, WeatherState>(
      'should emit [WeatherLoading, WeatherLoaded] when data is gotten successfully',
      build: () {
        when(mockGetForecast.executeByCurrentLocation())
            .thenAnswer((_) async => Right(tForecast));
        return cubit;
      },
      act: (cubit) => cubit.getForecastByCurrentLocation(),
      expect: () => [
        WeatherLoading(),
        WeatherLoaded(tForecast),
      ],
      verify: (cubit) {
        verify(mockGetForecast.executeByCurrentLocation());
      },
    );

    blocTest<WeatherCubit, WeatherState>(
      'should emit [WeatherLoading, WeatherError] when getting data fails',
      build: () {
        when(mockGetForecast.executeByCurrentLocation())
            .thenAnswer((_) async => Left(ServerFailure(message: 'Server error')));
        return cubit;
      },
      act: (cubit) => cubit.getForecastByCurrentLocation(),
      expect: () => [
        WeatherLoading(),
        WeatherError('Server error'),
      ],
      verify: (cubit) {
        verify(mockGetForecast.executeByCurrentLocation());
      },
    );
  });
}


