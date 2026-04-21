import 'package:dio/dio.dart';

import '../error/app_exception.dart';

/// Maps [DioException] into a typed [AppException] so the rest of the app
/// does not depend on dio's types.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final mapped = _mapToAppException(err);
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: mapped,
        stackTrace: err.stackTrace,
      ),
    );
  }

  AppException _mapToAppException(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return NetworkError(err.message ?? 'network error', cause: err);
      case DioExceptionType.badCertificate:
        return NetworkError(
          err.message ?? 'bad certificate',
          cause: err,
        );
      case DioExceptionType.cancel:
        return NetworkError(err.message ?? 'request cancelled', cause: err);
      case DioExceptionType.badResponse:
        final status = err.response?.statusCode ?? 0;
        if (status == 401 || status == 403) {
          return AuthError(
            'auth failed (status: $status)',
            cause: err,
          );
        }
        if (status >= 500) {
          return ServerError(
            'server error (status: $status)',
            statusCode: status,
            cause: err,
          );
        }
        return ServerError(
          'bad response (status: $status)',
          statusCode: status,
          cause: err,
        );
      case DioExceptionType.unknown:
        return UnknownError(err.message ?? 'unknown error', cause: err);
    }
  }
}
