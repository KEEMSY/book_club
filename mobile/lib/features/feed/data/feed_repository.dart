import 'package:dio/dio.dart';

import '../domain/comment.dart';
import '../domain/post.dart';
import '../domain/post_type.dart';
import '../domain/reaction_type.dart';
import 'feed_api.dart';
import 'feed_models.dart';
import 'image_uploader.dart';

/// Typed domain failure surfaced by [FeedRepository].
///
/// Mirrors the `BookRepositoryException` shape so notifiers can stay
/// framework-agnostic. Known [code] values from the M4 backend contract:
///   * `COMMENT_DEPTH_EXCEEDED` (409 — replying to a reply)
///   * `POST_NOT_FOUND` (404)
///   * `COMMENT_NOT_FOUND` (404)
///   * `POST_CONTENT_REQUIRED` (400)
///   * `IMAGE_LIMIT_EXCEEDED` (400)
///   * `UPSTREAM_UNAVAILABLE` (5xx)
class FeedRepositoryException implements Exception {
  const FeedRepositoryException({
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
      'FeedRepositoryException(code: $code, statusCode: $statusCode, '
      'message: $message)';
}

/// Thin wrapper around [FeedApi] + [ImageUploader] that:
///   * converts freezed request DTOs into JSON maps at the boundary,
///   * flattens response DTOs into pure domain types,
///   * translates dio errors into [FeedRepositoryException].
class FeedRepository {
  FeedRepository({required FeedApi api, required ImageUploader uploader})
      : _api = api,
        _uploader = uploader;

  final FeedApi _api;
  final ImageUploader _uploader;

  Future<PostPage> listPosts({
    required String bookId,
    String? cursor,
    int limit = 20,
  }) async {
    final PostPageDto resp = await _call(
      () => _api.listPosts(bookId, cursor: cursor, limit: limit),
    );
    return PostPage(
      items: resp.items.map((dto) => dto.toDomain()).toList(growable: false),
      nextCursor: resp.nextCursor,
    );
  }

  Future<Post> createPost({
    required String bookId,
    required PostType postType,
    required String content,
    required List<String> imageKeys,
  }) async {
    final PostDto dto = await _call(
      () => _api.createPost(
        bookId,
        CreatePostRequest(
          bookId: bookId,
          postType: postType.wire,
          content: content,
          imageKeys: imageKeys,
        ).toJson(),
      ),
    );
    return dto.toDomain();
  }

  Future<void> deletePost(String postId) async {
    await _call(() => _api.deletePost(postId));
  }

  /// Toggles a reaction on/off. The server is authoritative on resulting
  /// state — callers should reconcile [Post.reactions] / [Post.myReactions]
  /// from the returned [ReactionToggleResult] rather than guessing locally.
  Future<ReactionToggleResult> toggleReaction({
    required String postId,
    required ReactionType reactionType,
  }) async {
    final ReactionResponse resp = await _call(
      () => _api.toggleReaction(
        postId,
        ReactionRequest(reactionType: reactionType.wire).toJson(),
      ),
    );
    return resp.toDomain();
  }

  Future<CommentPage> listComments({
    required String postId,
    String? cursor,
    int limit = 50,
  }) async {
    final CommentPageDto resp = await _call(
      () => _api.listComments(postId, cursor: cursor, limit: limit),
    );
    return CommentPage(
      items: resp.items.map((dto) => dto.toDomain()).toList(growable: false),
      nextCursor: resp.nextCursor,
    );
  }

  Future<Comment> createComment({
    required String postId,
    required String content,
    String? parentId,
  }) async {
    final CommentDto dto = await _call(
      () => _api.createComment(
        postId,
        CreateCommentRequest(parentId: parentId, content: content).toJson(),
      ),
    );
    return dto.toDomain();
  }

  Future<void> deleteComment(String commentId) async {
    await _call(() => _api.deleteComment(commentId));
  }

  /// Orchestrates presign → PUT → key. Surfaced through the repository so
  /// notifiers don't depend on [ImageUploader] directly.
  Future<String> uploadImage(PickedImage image) async {
    return _uploader.upload(image);
  }

  Future<T> _call<T>(Future<T> Function() fn) async {
    try {
      return await fn();
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  FeedRepositoryException _fromDio(DioException err) {
    final int? status = err.response?.statusCode;
    final dynamic data = err.response?.data;
    if (data is Map<String, dynamic>) {
      final dynamic error = data['error'];
      if (error is Map<String, dynamic>) {
        return FeedRepositoryException(
          code: (error['code'] as String?) ?? 'UNKNOWN',
          message: (error['message'] as String?) ?? '요청을 처리하지 못했습니다.',
          statusCode: status,
          cause: err,
        );
      }
    }
    if (status != null && status >= 500) {
      return FeedRepositoryException(
        code: 'UPSTREAM_UNAVAILABLE',
        message: '잠시 후 다시 시도해주세요.',
        statusCode: status,
        cause: err,
      );
    }
    return FeedRepositoryException(
      code: 'NETWORK_ERROR',
      message: '네트워크 오류가 발생했습니다. 잠시 후 다시 시도해주세요.',
      statusCode: status,
      cause: err,
    );
  }
}
