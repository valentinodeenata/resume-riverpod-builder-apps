import 'package:equatable/equatable.dart';

/// Base class for all domain-layer failures.
///
/// Using sealed classes ensures every failure type is handled
/// exhaustively in switch expressions throughout the presentation layer.
sealed class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Failures originating from Firebase or any remote source.
final class ServerFailure extends Failure {
  const ServerFailure([super.message = 'An unexpected server error occurred.']);
}

/// Failures from local cache / SharedPreferences.
final class CacheFailure extends Failure {
  const CacheFailure([super.message = 'A local cache error occurred.']);
}

/// Failures when the device has no internet connectivity.
final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection.']);
}

/// Failures relating to authentication state.
final class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed.']);
}

/// Failures when a requested resource does not exist.
final class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'The requested resource was not found.']);
}

/// Failures for business-rule violations (e.g. resume limit exceeded).
final class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
