import 'package:dio/dio.dart';

import '../domain/user_summary.dart';
import 'social_api.dart';

/// Typed domain failure surfaced by [SocialRepository].
///
/// Known [code] values from the M7 backend contract:
///   * `ALREADY_FOLLOWING` (409)
///   * `NOT_FOLLOWING` (409)
///   * `SELF_ACTION` (400 — cannot follow/block yourself)
///   * `USER_NOT_FOUND` (404)
///   * `UPSTREAM_UNAVAILABLE` (5xx)
class SocialRepositoryException implements Exception {
  const SocialRepositoryException({
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
      'SocialRepositoryException(code: $code, statusCode: $statusCode, '
      'message: $message)';
}

/// Thin wrapper around [SocialApi] that translates Dio errors into typed
/// [SocialRepositoryException] values and keeps notifiers free of network
/// concerns.
class SocialRepository {
  SocialRepository(this._api);

  final SocialApi _api;

  Future<void> follow(String targetUserId) =>
      _call(() => _api.follow(targetUserId));

  Future<void> unfollow(String targetUserId) =>
      _call(() => _api.unfollow(targetUserId));

  Future<UserSummaryPage> getMyFollowers() =>
      _call(() => _api.getMyFollowers());

  Future<UserSummaryPage> getMyFollowing() =>
      _call(() => _api.getMyFollowing());

  Future<UserSummaryPage> getUserFollowers(String userId) =>
      _call(() => _api.getUserFollowers(userId));

  Future<UserSummaryPage> getUserFollowing(String userId) =>
      _call(() => _api.getUserFollowing(userId));

  Future<void> block(String targetUserId) =>
      _call(() => _api.block(targetUserId));

  Future<void> unblock(String targetUserId) =>
      _call(() => _api.unblock(targetUserId));

  Future<UserSummaryPage> getMyBlocks() => _call(() => _api.getMyBlocks());

  Future<void> reportUser(String userId, {required String reason}) =>
      _call(() => _api.reportUser(userId, {'reason': reason}));

  Future<UserSummaryPage> exploreUsers({
    required String q,
    String? cursor,
    int limit = 20,
  }) =>
      _call(() => _api.exploreUsers(q: q, cursor: cursor, limit: limit));

  Future<T> _call<T>(Future<T> Function() fn) async {
    try {
      return await fn();
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  SocialRepositoryException _fromDio(DioException err) {
    final int? status = err.response?.statusCode;
    final dynamic data = err.response?.data;
    if (data is Map<String, dynamic>) {
      final dynamic error = data['error'];
      if (error is Map<String, dynamic>) {
        return SocialRepositoryException(
          code: (error['code'] as String?) ?? 'UNKNOWN',
          message: (error['message'] as String?) ?? '요청을 처리하지 못했습니다.',
          statusCode: status,
          cause: err,
        );
      }
    }
    if (status != null && status >= 500) {
      return SocialRepositoryException(
        code: 'UPSTREAM_UNAVAILABLE',
        message: '잠시 후 다시 시도해주세요.',
        statusCode: status,
        cause: err,
      );
    }
    return SocialRepositoryException(
      code: 'NETWORK_ERROR',
      message: '네트워크 오류가 발생했습니다. 잠시 후 다시 시도해주세요.',
      statusCode: status,
      cause: err,
    );
  }
}
