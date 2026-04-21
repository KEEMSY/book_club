/// Sealed hierarchy for all app-facing exceptions.
///
/// Dio errors are mapped into one of these subclasses by
/// `core/network/error_interceptor.dart`. UI layers should match on the
/// subclass to decide whether to retry, redirect to login, or surface a
/// generic error state.
sealed class AppException implements Exception {
  const AppException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => '$runtimeType(message: $message)';
}

/// Offline, DNS, timeout, TLS — anything that prevented a request from
/// reaching the server or returning a response.
class NetworkError extends AppException {
  const NetworkError(super.message, {super.cause});
}

/// 401 / 403 — the session token is missing, expired, or rejected.
/// Router guards should redirect to `/login` on this.
class AuthError extends AppException {
  const AuthError(super.message, {super.cause});
}

/// 5xx — the backend returned an error response. Includes the status code
/// so callers can present differentiated UI if desired.
class ServerError extends AppException {
  const ServerError(super.message, {this.statusCode, super.cause});

  final int? statusCode;
}

/// Anything that does not fit the buckets above.
class UnknownError extends AppException {
  const UnknownError(super.message, {super.cause});
}
