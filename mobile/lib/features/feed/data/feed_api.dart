import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'feed_models.dart';

part 'feed_api.g.dart';

/// Typed HTTP bindings for the M4 feed router plus M47 global event feed.
///
/// All paths sit outside `/auth/*`, so [AuthInterceptor] attaches the bearer
/// automatically. Bodies stay as `Map<String, dynamic>` for the same
/// freezed/retrofit_generator 9.7 introspection issue documented in
/// `auth_api.dart`.
///
/// Endpoints (M4):
///   * `POST /uploads/presign-image`
///   * `GET  /books/{book_id}/posts?cursor=&limit=`
///   * `POST /books/{book_id}/posts`
///   * `DELETE /posts/{id}`
///   * `POST /posts/{id}/reactions`
///   * `GET  /posts/{id}/comments?cursor=&limit=`
///   * `POST /posts/{id}/comments`
///   * `DELETE /comments/{id}`
///   * `POST /me/library/{user_book_id}/highlights`
///   * `GET  /me/library/{user_book_id}/highlights?cursor=&limit=`
///   * `DELETE /me/library/{user_book_id}/highlights/{highlight_id}`
///
/// Endpoints (M47 — global event feed):
///   * `GET    /feed`
///   * `GET    /feed/following`
///   * `POST   /feed/{event_id}/reactions`
///   * `GET    /feed/{event_id}/comments`
///   * `POST   /feed/{event_id}/comments`
///   * `DELETE /feed/comments/{id}`
@RestApi()
abstract class FeedApi {
  factory FeedApi(Dio dio, {String baseUrl}) = _FeedApi;

  @POST('/uploads/presign-image')
  Future<PresignImageResponse> presignImage(
    @Body() Map<String, dynamic> body,
  );

  @GET('/books/{book_id}/posts')
  Future<PostPageDto> listPosts(
    @Path('book_id') String bookId, {
    @Query('cursor') String? cursor,
    @Query('limit') int limit = 20,
  });

  @POST('/books/{book_id}/posts')
  Future<PostDto> createPost(
    @Path('book_id') String bookId,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('/posts/{id}')
  Future<void> deletePost(@Path('id') String postId);

  @POST('/posts/{id}/reactions')
  Future<ReactionResponse> toggleReaction(
    @Path('id') String postId,
    @Body() Map<String, dynamic> body,
  );

  @GET('/posts/{id}/comments')
  Future<CommentPageDto> listComments(
    @Path('id') String postId, {
    @Query('cursor') String? cursor,
    @Query('limit') int limit = 50,
  });

  @POST('/posts/{id}/comments')
  Future<CommentDto> createComment(
    @Path('id') String postId,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('/comments/{id}')
  Future<void> deleteComment(@Path('id') String commentId);

  @POST('/me/library/{user_book_id}/highlights')
  Future<HighlightDto> createHighlight(
    @Path('user_book_id') String userBookId,
    @Body() Map<String, dynamic> body,
  );

  @GET('/me/library/{user_book_id}/highlights')
  Future<HighlightPageDto> listHighlights(
    @Path('user_book_id') String userBookId, {
    @Query('cursor') String? cursor,
    @Query('limit') int limit = 20,
  });

  @DELETE('/me/library/{user_book_id}/highlights/{highlight_id}')
  Future<void> deleteHighlight(
    @Path('user_book_id') String userBookId,
    @Path('highlight_id') String highlightId,
  );

  @PATCH('/me/library/{user_book_id}/highlights/{highlight_id}')
  Future<HighlightDto> updateHighlight(
    @Path('user_book_id') String userBookId,
    @Path('highlight_id') String highlightId,
    @Body() Map<String, dynamic> body,
  );

  @GET('/me/highlights')
  Future<AllHighlightsResponseDto> listAllHighlights();

  // ── M47 global event feed ──────────────────────────────────────────────────

  @GET('/feed')
  Future<FeedEventPageDto> getGlobalFeed({
    @Query('cursor') String? cursor,
    @Query('limit') int limit = 20,
  });

  @GET('/feed/following')
  Future<FeedEventPageDto> getFollowingEventFeed({
    @Query('cursor') String? cursor,
    @Query('limit') int limit = 20,
  });

  @POST('/feed/{event_id}/reactions')
  Future<FeedReactionToggleDto> toggleFeedReaction(
    @Path('event_id') String eventId,
    @Body() Map<String, dynamic> body,
  );

  @GET('/feed/{event_id}/comments')
  Future<FeedCommentListDto> getFeedComments(
    @Path('event_id') String eventId,
  );

  @POST('/feed/{event_id}/comments')
  Future<FeedCommentDto> createFeedComment(
    @Path('event_id') String eventId,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('/feed/comments/{id}')
  Future<void> deleteFeedComment(@Path('id') String commentId);
}
