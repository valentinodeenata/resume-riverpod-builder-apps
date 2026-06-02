/// Data-layer exceptions that get mapped to [Failure]s in repositories.
library;

class ServerException implements Exception {
  const ServerException([this.message = 'A server error occurred.']);
  final String message;
}

class CacheException implements Exception {
  const CacheException([this.message = 'A cache error occurred.']);
  final String message;
}

class NetworkException implements Exception {
  const NetworkException([this.message = 'No internet connection.']);
  final String message;
}

class AuthException implements Exception {
  const AuthException([this.message = 'Authentication failed.']);
  final String message;
}

class NotFoundException implements Exception {
  const NotFoundException([this.message = 'Resource not found.']);
  final String message;
}
