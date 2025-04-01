import 'package:flutter/material.dart';
import 'package:caelum/domain/entities/forecast.dart';
import 'package:intl/intl.dart';

class ForecastDisplay extends StatelessWidget {
  final Forecast forecast;

  const ForecastDisplay({
    super.key,
    required this.forecast,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCurrentWeather(context),
        const SizedBox(height: 24),
        _buildDailyForecast(context),
      ],
    );
  }

  Widget _buildCurrentWeather(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      forecast.location.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      '${forecast.current.temperature.toStringAsFixed(1)}°C',
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      forecast.current.condition,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
                Icon(
                  _getWeatherIcon(forecast.current.condition),
                  size: 64,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWeatherDetail(
                  context,
                  Icons.water_drop,
                  '${forecast.current.humidity}%',
                  'Humedad',
                ),
                _buildWeatherDetail(
                  context,
                  Icons.air,
                  '${forecast.current.windSpeed} km/h',
                  'Viento',
                ),
                _buildWeatherDetail(
                  context,
                  Icons.visibility,
                  '${forecast.current.visibility} km',
                  'Visibilidad',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyForecast(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Pronóstico de 5 días',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: forecast.daily.length,
            itemBuilder: (context, index) {
              final day = forecast.daily[index];
              return Card(
                margin: EdgeInsets.only(
                  left: index == 0 ? 16 : 8,
                  right: index == forecast.daily.length - 1 ? 16 : 0,
                ),
                child: Container(
                  width: 100,
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('E').format(day.date),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Icon(
                        _getWeatherIcon(day.condition),
                        color: Theme.of(context).primaryColor,
                      ),
                      Text(
                        '${day.maxTemp.toStringAsFixed(0)}°',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        '${day.minTemp.toStringAsFixed(0)}°',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherDetail(
    BuildContext context,
    IconData icon,
    String value,
    String label,
  ) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  IconData _getWeatherIcon(String condition) {
    condition = condition.toLowerCase();
    if (condition.contains('clear') || condition.contains('sunny')) {
      return Icons.wb_sunny;
    } else if (condition.contains('cloud')) {
      return Icons.cloud;
    } else if (condition.contains('rain') || condition.contains('shower')) {
      return Icons.water;
    } else if (condition.contains('snow')) {
      return Icons.ac_unit;
    } else if (condition.contains('thunder') || condition.contains('storm')) {
      return Icons.flash_on;
    } else if (condition.contains('fog') || condition.contains('mist')) {
      return Icons.cloud;
    } else {
      return Icons.wb_sunny;
    }
  }
}

