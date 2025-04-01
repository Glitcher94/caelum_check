import 'package:flutter/material.dart';
import '../../domain/entities/weather.dart';

class WeatherDisplay extends StatelessWidget {
  final Weather weather;

  const WeatherDisplay({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https:${weather.conditionIcon}',
              width: 80,
              height: 80,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${weather.temperature.toStringAsFixed(1)}°C',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                Text(
                  weather.condition,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildWeatherDetails(),
      ],
    );
  }

  Widget _buildWeatherDetails() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildDetailItem(
          icon: Icons.water_drop,
          value: '${weather.humidity}%',
          label: 'Humedad',
        ),
        _buildDetailItem(
          icon: Icons.air,
          value: '${weather.windSpeed} km/h',
          label: 'Viento',
        ),
        _buildDetailItem(
          icon: Icons.compass_calibration,
          value: weather.windDirection,
          label: 'Dirección',
        ),
      ],
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Colors.blue),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

