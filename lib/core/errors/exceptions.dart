class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'Server Error']);
}

class CacheException implements Exception {
  final String message;
  CacheException([this.message = 'Cache Error']);
}

class DatabaseException implements Exception {
  final String message;
  DatabaseException([this.message = 'Database Error']);
}

class ValidationException implements Exception {
  final String message;
  ValidationException(this.message);
}
