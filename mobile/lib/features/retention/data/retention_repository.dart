import 'package:dio/dio.dart';

import '../domain/streak_recovery_status.dart';
import 'retention_api.dart';

/// Typed domain failure surfaced by [RetentionRepository].
class RetentionRepositoryException implements Exception {
  const RetentionRepositoryException({
    required this.code,
    required this.message,
    this.statusCode,
    this.cause,
  });

  final String code;
  final String message;
  final int? statusCode;
  final Object? cause;

  @override
  String toString() =>
      'RetentionRepositoryException(code: $code, statusCode: $statusCode, '
      'message: $message)';
}

/// Wraps [RetentionApi], converts raw JSON to domain objects, and maps Dio
/// errors into typed [RetentionRepositoryException] values.
class RetentionRepository {
  RetentionRepository(this._api);

  final RetentionApi _api;

  /// Fetches the current user's streak recovery eligibility.
  Future<StreakRecoveryStatus> getRecoveryStatus() async {
    try {
      final dynamic raw = await _api.getRecoveryStatus();
      return StreakRecoveryStatus.fromJson(raw as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  /// Consumes one recovery token and restores the user's streak by one day.
  ///
  /// Returns the raw response map so the caller can inspect `recovered_days`
  /// and `recoveries_remaining` if needed.
  Future<Map<String, dynamic>> recoverStreak() async {
    try {
      final dynamic raw = await _api.recoverStreak();
      return raw as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  RetentionRepositoryException _fromDio(DioException err) {
    final int? status = err.response?.statusCode;
    final dynamic data = err.response?.data;
    if (data is Map<String, dynamic>) {
      final dynamic error = data['error'];
      if (error is Map<String, dynamic>) {
        return RetentionRepositoryException(
          code: (error['code'] as String?) ?? 'UNKNOWN',
          message: (error['message'] as String?) ?? '요청을 처리하지 못했습니다.',
          statusCode: status,
          cause: err,
        );
      }
    }
    if (status != null && status >= 500) {
      return RetentionRepositoryException(
        code: 'UPSTREAM_UNAVAILABLE',
        message: '잠시 후 다시 시도해주세요.',
        statusCode: status,
        cause: err,
      );
    }
    return RetentionRepositoryException(
      code: 'NETWORK_ERROR',
      message: '네트워크 오류가 발생했습니다. 잠시 후 다시 시도해주세요.',
      statusCode: status,
      cause: err,
    );
  }
}
