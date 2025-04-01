import 'package:caelum/data/datasources/weather_remote_data_source.dart';
import 'package:caelum/data/repositories/weather_repository_impl.dart';
import 'package:caelum/domain/repositories/weather_repository.dart';
import 'package:caelum/domain/usecases/get_forecast.dart';
import 'package:caelum/presentation/blocs/weather/weather_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:caelum/core/network/network_info.dart';
import 'package:geolocator/geolocator.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Blocs
  sl.registerFactory(
    () => WeatherCubit(getForecast: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetForecast(sl()));

  // Repositories
  sl.registerLazySingleton<WeatherRepository>(
    () => WeatherRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<WeatherRemoteDataSource>(
    () => WeatherRemoteDataSourceImpl(
      client: sl(),
    ),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );

  // External
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
  sl.registerLazySingleton(() => GeolocatorPlatform.instance);
}

