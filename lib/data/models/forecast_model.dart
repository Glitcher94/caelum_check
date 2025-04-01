import 'package:caelum/data/models/current_weather_model.dart';
import 'package:caelum/data/models/daily_weather_model.dart';
import 'package:caelum/data/models/location_model.dart';
import 'package:caelum/domain/entities/forecast.dart';

class ForecastModel extends Forecast {
  const ForecastModel({
    required LocationModel location,
    required CurrentWeatherModel current,
    required List<DailyWeatherModel> daily,
  }) : super(
          location: location,
          current: current,
          daily: daily,
        );

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    final location = LocationModel.fromJson(json['location']);
    final current = CurrentWeatherModel.fromJson(json['current']);
    
    final List<DailyWeatherModel> daily = [];
    if (json['forecast'] != null && json['forecast']['forecastday'] != null) {
      final forecastDays = json['forecast']['forecastday'] as List;
      for (var day in forecastDays) {
        daily.add(DailyWeatherModel.fromJson(day));
      }
    }

    return ForecastModel(
      location: location,
      current: current,
      daily: daily,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': (location as LocationModel).toJson(),
      'current': (current as CurrentWeatherModel).toJson(),
      'forecast': {
        'forecastday': (daily as List<DailyWeatherModel>)
            .map((day) => day.toJson())
            .toList(),
      },
    };
  }
}

