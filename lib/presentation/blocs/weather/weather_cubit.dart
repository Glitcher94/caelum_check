import 'package:bloc/bloc.dart';
import 'package:caelum/core/errors/failures.dart';
import 'package:caelum/domain/entities/location.dart';
import 'package:caelum/domain/usecases/get_forecast.dart';
import 'package:caelum/presentation/blocs/weather/weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final GetForecast getForecast;

  WeatherCubit({required this.getForecast}) : super(WeatherInitial());

  Future<void> getForecastByLocation(Location location) async {
    emit(WeatherLoading());
    final result = await getForecast.execute(location);
    result.fold(
      (failure) => emit(WeatherError(_mapFailureToMessage(failure))),
      (forecast) => emit(WeatherLoaded(forecast)),
    );
  }

  Future<void> getForecastByCity(String city) async {
    emit(WeatherLoading());
    final result = await getForecast.executeByCity(city);
    result.fold(
      (failure) => emit(WeatherError(_mapFailureToMessage(failure))),
      (forecast) => emit(WeatherLoaded(forecast)),
    );
  }

  Future<void> getForecastByCurrentLocation() async {
    emit(WeatherLoading());
    final result = await getForecast.executeByCurrentLocation();
    result.fold(
      (failure) => emit(WeatherError(_mapFailureToMessage(failure))),
      (forecast) => emit(WeatherLoaded(forecast)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure) {
      case ServerFailure _:
        return failure.message;
      case NetworkFailure _:
        return 'No hay conexión a internet. Por favor, verifica tu conexión.';
      case LocationFailure _:
        return 'No se pudo obtener tu ubicación: ${failure.message}';
      default:
        return 'Error inesperado. Por favor, intenta de nuevo.';
    }
  }
}


