class ServerException implements Exception {
  final String message;

  ServerException({required this.message});
}

class CacheException implements Exception {
  final String message;

  CacheException({required this.message});
}

class LocationException implements Exception {
  final String message;

  LocationException({required this.message});
}

