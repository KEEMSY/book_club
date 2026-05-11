import 'package:dio/dio.dart';

import '../../feed/domain/post.dart';
import '../../social/domain/user_summary.dart';
import 'community_api.dart';

/// Typed domain failure surfaced by [CommunityRepository].
class CommunityRepositoryException implements Exception {
  const CommunityRepositoryException({
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
      'CommunityRepositoryException(code: $code, statusCode: $statusCode, '
      'message: $message)';
}

/// Thin wrapper around [CommunityApi] that translates Dio errors into typed
/// [CommunityRepositoryException] values.
class CommunityRepository {
  CommunityRepository(this._api);

  final CommunityApi _api;

  Future<PostPage> getFollowingFeed({String? cursor, int limit = 20}) =>
      _call(() async {
        final dto = await _api.getFollowingFeed(cursor: cursor, limit: limit);
        return PostPage(
          items: dto.items.map((d) => d.toDomain()).toList(),
          nextCursor: dto.nextCursor,
        );
      });

  Future<PostPage> getExploreFeed({
    String sort = 'latest',
    String? postType,
    String? cursor,
    int limit = 20,
  }) =>
      _call(() async {
        final dto = await _api.getExploreFeed(
          sort: sort,
          postType: postType,
          cursor: cursor,
          limit: limit,
        );
        return PostPage(
          items: dto.items.map((d) => d.toDomain()).toList(),
          nextCursor: dto.nextCursor,
        );
      });

  Future<UserProfile> getUserProfile(String userId) =>
      _call(() => _api.getUserProfile(userId));

  Future<PostPage> getUserPosts(
    String userId, {
    String? cursor,
    int limit = 20,
  }) =>
      _call(() async {
        final dto =
            await _api.getUserPosts(userId, cursor: cursor, limit: limit);
        return PostPage(
          items: dto.items.map((d) => d.toDomain()).toList(),
          nextCursor: dto.nextCursor,
        );
      });

  Future<T> _call<T>(Future<T> Function() fn) async {
    try {
      return await fn();
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  CommunityRepositoryException _fromDio(DioException err) {
    final int? status = err.response?.statusCode;
    final dynamic data = err.response?.data;
    if (data is Map<String, dynamic>) {
      final dynamic error = data['error'];
      if (error is Map<String, dynamic>) {
        return CommunityRepositoryException(
          code: (error['code'] as String?) ?? 'UNKNOWN',
          message: (error['message'] as String?) ?? '요청을 처리하지 못했습니다.',
          statusCode: status,
          cause: err,
        );
      }
    }
    if (status != null && status >= 500) {
      return CommunityRepositoryException(
        code: 'UPSTREAM_UNAVAILABLE',
        message: '잠시 후 다시 시도해주세요.',
        statusCode: status,
        cause: err,
      );
    }
    return CommunityRepositoryException(
      code: 'NETWORK_ERROR',
      message: '네트워크 오류가 발생했습니다. 잠시 후 다시 시도해주세요.',
      statusCode: status,
      cause: err,
    );
  }
}
