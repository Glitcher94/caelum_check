import 'dart:convert';
import 'package:caelum/core/errors/exceptions.dart';
import 'package:caelum/data/models/forecast_model.dart';
import 'package:caelum/data/models/location_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';


abstract class WeatherRemoteDataSource {
  Future<ForecastModel> getForecast(LocationModel location);
  Future<ForecastModel> getForecastByCity(String city);
  Future<LocationModel> getLocationByCity(String city);
}

class WeatherRemoteDataSourceImpl implements WeatherRemoteDataSource {
  final http.Client client;
  final String apiKey = dotenv.env['WEATHER_API_KEY'] ?? '';

  WeatherRemoteDataSourceImpl({
    required this.client,
  });

  @override
  Future<ForecastModel> getForecast(LocationModel location) async {
    final url = Uri.parse(
        'https://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=${location.latitude},${location.longitude}&days=5&aqi=no&alerts=no');
    
    final response = await client.get(url);
    
    if (response.statusCode == 200) {
      return ForecastModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException(
        message: 'Error al obtener el pronóstico: ${response.statusCode}',
      );
    }
  }

  @override
  Future<ForecastModel> getForecastByCity(String city) async {
    final url = Uri.parse(
        'https://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$city&days=5&aqi=no&alerts=no');
    
    final response = await client.get(url);
    
    if (response.statusCode == 200) {
      return ForecastModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException(
        message: 'Error al obtener el pronóstico para $city: ${response.statusCode}',
      );
    }
  }

  @override
  Future<LocationModel> getLocationByCity(String city) async {
    final url = Uri.parse(
        'https://api.weatherapi.com/v1/search.json?key=$apiKey&q=$city');
    
    final response = await client.get(url);
    
    if (response.statusCode == 200) {
      final List<dynamic> locations = json.decode(response.body);
      if (locations.isNotEmpty) {
        return LocationModel(
          latitude: double.parse(locations[0]['lat']),
          longitude: double.parse(locations[0]['lon']),
          name: locations[0]['name'],
        );
      } else {
        throw ServerException(message: 'No se encontró la ubicación para $city');
      }
    } else {
      throw ServerException(
        message: 'Error al buscar la ubicación: ${response.statusCode}',
      );
    }
  }
}

