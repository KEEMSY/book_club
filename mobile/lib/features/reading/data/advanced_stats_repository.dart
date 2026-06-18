import 'package:dio/dio.dart';

import 'advanced_stats_api.dart';
import 'advanced_stats_models.dart';

/// Raised when the advanced stats endpoint rejects a non-Pro user (HTTP 403).
///
/// The screen distinguishes this from generic network failures to show the
/// Pro upsell instead of a retryable error.
class ProRequiredException implements Exception {
  const ProRequiredException();

  @override
  String toString() => 'ProRequiredException()';
}

/// Generic, retryable failure for the advanced stats fetch.
class AdvancedStatsException implements Exception {
  const AdvancedStatsException({required this.message, this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => 'AdvancedStatsException($message)';
}

/// Wraps [AdvancedStatsApi] and maps Dio errors into typed domain failures.
class AdvancedStatsRepository {
  AdvancedStatsRepository(this._api);

  final AdvancedStatsApi _api;

  Future<AdvancedStatsDto> fetchAdvancedStats() async {
    try {
      return await _api.getAdvancedStats();
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        throw const ProRequiredException();
      }
      throw AdvancedStatsException(
        message: '통계를 불러오지 못했습니다. 잠시 후 다시 시도해주세요.',
        cause: e,
      );
    }
  }
}
