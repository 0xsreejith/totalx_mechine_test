/// Base exception for data layer.
abstract class AppException implements Exception {
  final String message;
  AppException(this.message);
  @override
  String toString() => message;
}

class ServerException extends AppException {
  ServerException(String message) : super(message);
}

class CacheException extends AppException {
  CacheException(String message) : super(message);
}
