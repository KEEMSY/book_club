import 'package:dio/dio.dart';

import 'challenge_api.dart';
import 'challenge_models.dart';

/// Typed domain failure surfaced by [ChallengeRepository].
class ChallengeRepositoryException implements Exception {
  const ChallengeRepositoryException({
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
      'ChallengeRepositoryException(code: $code, statusCode: $statusCode, '
      'message: $message)';
}

/// Thin wrapper around [ChallengeApi] that translates Dio errors into typed
/// [ChallengeRepositoryException] values.
class ChallengeRepository {
  ChallengeRepository(this._api);

  final ChallengeApi _api;

  Future<ChallengePageDto> listChallenges({
    String? status,
    int limit = 20,
    String? cursor,
  }) =>
      _call(
        () => _api.listChallenges(status: status, limit: limit, cursor: cursor),
      );

  Future<MyChallengePageDto> myChallenges() => _call(() => _api.myChallenges());

  Future<ChallengeDto> getChallenge(String id) =>
      _call(() => _api.getChallenge(id));

  Future<void> joinChallenge(String id) => _call(() => _api.joinChallenge(id));

  Future<void> leaveChallenge(String id) =>
      _call(() => _api.leaveChallenge(id));

  Future<LeaderboardPageDto> leaderboard(String id, {int limit = 50}) =>
      _call(() => _api.leaderboard(id, limit: limit));

  Future<BadgePageDto> listBadges({String? category}) =>
      _call(() => _api.listBadges(category: category));

  Future<MyBadgePageDto> myBadges() => _call(() => _api.myBadges());

  /// Persists the pinned-badge display order (max 6 IDs) to the server.
  Future<void> reorderBadges(List<String> badgeIds) => _call(
        () => _api.reorderBadges({'badge_ids': badgeIds}),
      );

  Future<T> _call<T>(Future<T> Function() fn) async {
    try {
      return await fn();
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  ChallengeRepositoryException _fromDio(DioException err) {
    final int? status = err.response?.statusCode;
    final dynamic data = err.response?.data;
    if (data is Map<String, dynamic>) {
      final dynamic error = data['error'];
      if (error is Map<String, dynamic>) {
        return ChallengeRepositoryException(
          code: (error['code'] as String?) ?? 'UNKNOWN',
          message: (error['message'] as String?) ?? '요청을 처리하지 못했습니다.',
          statusCode: status,
          cause: err,
        );
      }
    }
    if (status != null && status >= 500) {
      return ChallengeRepositoryException(
        code: 'UPSTREAM_UNAVAILABLE',
        message: '잠시 후 다시 시도해주세요.',
        statusCode: status,
        cause: err,
      );
    }
    return ChallengeRepositoryException(
      code: 'NETWORK_ERROR',
      message: '네트워크 오류가 발생했습니다. 잠시 후 다시 시도해주세요.',
      statusCode: status,
      cause: err,
    );
  }
}
