import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caelum/presentation/blocs/weather/weather_cubit.dart';
import 'package:caelum/presentation/blocs/weather/weather_state.dart';
import 'package:caelum/presentation/widgets/search_bar.dart';
import 'package:caelum/presentation/widgets/location_button.dart';
import 'package:caelum/presentation/widgets/forecast_display.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String mapboxToken = dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? '';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Caelum - Pronóstico del Tiempo'),
        elevation: 0,
      ),
      body: BlocBuilder<WeatherCubit, WeatherState>(
        builder: (context, state) {
          return Stack(
            children: [
              _buildBackground(),
              Column(
                children: [
                  CustomSearchBar(
                    controller: _searchController,
                    onSubmitted: (query) {
                      if (query.isNotEmpty) {
                        context.read<WeatherCubit>().getForecastByCity(query);
                      }
                    },
                  ),
                  Expanded(child: _buildContent(state)),
                ],
              ),
            ],
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Primer botón usando BlocBuilder (tu código actual)
          BlocBuilder<WeatherCubit, WeatherState>(
            builder: (context, state) {
              return LocationButton(
                isLoading: state is WeatherLoading,
                onPressed: () {
                  context.read<WeatherCubit>().getForecastByCurrentLocation();
                },
              );
            },
          ),
          const SizedBox(height: 16), // Espaciado entre botones
          // Segundo botón que navega al mapa (nuevo código)
          FloatingActionButton(
            heroTag: 'map',
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/map',
              ); // Navega a la pantalla del mapa
            },
            child: const Icon(Icons.map),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue.shade300, Colors.blue.shade700],
        ),
      ),
    );
  }

  Widget _buildContent(WeatherState state) {
    if (state is WeatherInitial) {
      return const Center(
        child: Text(
          'Busca una ciudad o usa tu ubicación actual',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      );
    } else if (state is WeatherLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    } else if (state is WeatherLoaded) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: ForecastDisplay(forecast: state.forecast),
      );
    } else if (state is WeatherError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade300, size: 48),
            const SizedBox(height: 16),
            Text(
              state.message,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<WeatherCubit>().getForecastByCurrentLocation();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
              ),
              child: const Text('Intentar con ubicación actual'),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
