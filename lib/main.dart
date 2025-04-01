import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:caelum/core/di/injection_container.dart' as di;
import 'package:caelum/presentation/blocs/weather/weather_cubit.dart';
import 'package:caelum/presentation/pages/weather_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:caelum/presentation/pages/map_page.dart'; // Import the MapPage class

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load();
  } catch (e) {
    // Manejo de error silencioso para evitar fallos en producción
  }

  await di.init(); // Inicializa las dependencias

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WeatherCubit>(
          create: (_) => di.sl<WeatherCubit>(),
        ),
        // Aquí puedes agregar más BlocProviders si los necesitas
      ],
      child: MaterialApp(
        title: 'Caelum',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const WeatherPage(),
          '/map': (context) => const MapPage(), // Mantiene tu pantalla principal
        },
      ),
    );
  }
}
