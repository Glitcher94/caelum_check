import 'package:caelum/domain/entities/daily_weather.dart';

class DailyWeatherModel extends DailyWeather {
  const DailyWeatherModel({
    required super.date,
    required super.maxTemp,
    required super.minTemp,
    required super.condition,
    required super.chanceOfRain,
  });

  factory DailyWeatherModel.fromJson(Map<String, dynamic> json) {
    return DailyWeatherModel(
      date: DateTime.parse(json['date']),
      maxTemp: json['day'] != null && json['day']['maxtemp_c'] != null
          ? json['day']['maxtemp_c'].toDouble()
          : 0.0,
      minTemp: json['day'] != null && json['day']['mintemp_c'] != null
          ? json['day']['mintemp_c'].toDouble()
          : 0.0,
      condition: json['day'] != null && json['day']['condition'] != null
          ? json['day']['condition']['text']
          : 'Desconocido',
      chanceOfRain: json['day'] != null && json['day']['daily_chance_of_rain'] != null
          ? json['day']['daily_chance_of_rain'].toDouble()
          : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'day': {
        'maxtemp_c': maxTemp,
        'mintemp_c': minTemp,
        'condition': {
          'text': condition,
        },
        'daily_chance_of_rain': chanceOfRain,
      },
    };
  }
}

