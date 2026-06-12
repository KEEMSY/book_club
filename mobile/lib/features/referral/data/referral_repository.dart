import 'package:dio/dio.dart';

import '../domain/referral_stats.dart';
import 'referral_api.dart';

/// Typed domain failure surfaced by [ReferralRepository].
class ReferralRepositoryException implements Exception {
  const ReferralRepositoryException({
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
      'ReferralRepositoryException(code: $code, statusCode: $statusCode, '
      'message: $message)';
}

/// Wraps [ReferralApi], converts raw JSON to domain objects, and maps Dio
/// errors into typed [ReferralRepositoryException] values.
class ReferralRepository {
  ReferralRepository(this._api);

  final ReferralApi _api;

  /// Fetches the current user's referral code and invitation stats.
  Future<ReferralStats> getMyReferral() async {
    try {
      final dynamic raw = await _api.getMyReferral();
      final Map<String, dynamic> data = raw as Map<String, dynamic>;
      return ReferralStats(
        code: data['code'] as String,
        invitedCount: data['invited_count'] as int,
        completedCount: data['completed_count'] as int,
      );
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  /// Applies a referral [code] received from a friend's invite link.
  Future<void> applyReferral(String code) async {
    try {
      await _api.applyReferral({'code': code});
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  ReferralRepositoryException _fromDio(DioException err) {
    final int? status = err.response?.statusCode;
    final dynamic data = err.response?.data;
    if (data is Map<String, dynamic>) {
      final dynamic error = data['error'];
      if (error is Map<String, dynamic>) {
        return ReferralRepositoryException(
          code: (error['code'] as String?) ?? 'UNKNOWN',
          message: (error['message'] as String?) ?? '요청을 처리하지 못했습니다.',
          statusCode: status,
          cause: err,
        );
      }
    }
    if (status != null && status >= 500) {
      return ReferralRepositoryException(
        code: 'UPSTREAM_UNAVAILABLE',
        message: '잠시 후 다시 시도해주세요.',
        statusCode: status,
        cause: err,
      );
    }
    return ReferralRepositoryException(
      code: 'NETWORK_ERROR',
      message: '네트워크 오류가 발생했습니다. 잠시 후 다시 시도해주세요.',
      statusCode: status,
      cause: err,
    );
  }
}
