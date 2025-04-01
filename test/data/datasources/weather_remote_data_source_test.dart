import 'package:caelum/core/errors/exceptions.dart';
import 'package:caelum/data/datasources/weather_remote_data_source.dart';
import 'package:caelum/data/models/forecast_model.dart';
import 'package:caelum/data/models/location_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../fixtures/fixture_reader.dart';

// Genera los mocks
@GenerateMocks([http.Client])
import 'weather_remote_data_source_test.mocks.dart';

void main() {
  late WeatherRemoteDataSourceImpl dataSource;
  late MockClient mockHttpClient;

  setUp(() async {
    dotenv.testLoad(fileInput: '''
    WEATHER_API_KEY=test_api_key
    '''); // Simula el archivo .env
    mockHttpClient = MockClient();
    dataSource = WeatherRemoteDataSourceImpl(
      client: mockHttpClient,
    );
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('weather.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getForecast', () {
    final tLocationModel = LocationModel(
      latitude: 40.7128,
      longitude: -74.0060,
      name: 'New York',
    );

    test(
      'should perform a GET request on a URL with location being the endpoint and with application/json header',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        await dataSource.getForecast(tLocationModel);
        // assert
        verify(mockHttpClient.get(
          Uri.parse('https://api.weatherapi.com/v1/forecast.json?key=test_api_key&q=${tLocationModel.latitude},${tLocationModel.longitude}&days=5&aqi=no&alerts=no'),
        ));
      },
    );

    test(
      'should return ForecastModel when the response code is 200 (success)',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await dataSource.getForecast(tLocationModel);
        // assert
        expect(result, isA<ForecastModel>());
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = dataSource.getForecast;
        // assert
        expect(() => call(tLocationModel), throwsA(isA<ServerException>()));
      },
    );
  });
}

