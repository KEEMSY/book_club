import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'feed_models.dart';

part 'feed_api.g.dart';

/// Typed HTTP bindings for the M4 feed router.
///
/// All paths sit outside `/auth/*`, so [AuthInterceptor] attaches the bearer
/// automatically. Bodies stay as `Map<String, dynamic>` for the same
/// freezed/retrofit_generator 9.7 introspection issue documented in
/// `auth_api.dart`.
///
/// Endpoints:
///   * `POST /uploads/presign-image`
///   * `GET  /books/{book_id}/posts?cursor=&limit=`
///   * `POST /books/{book_id}/posts`
///   * `DELETE /posts/{id}`
///   * `POST /posts/{id}/reactions`
///   * `GET  /posts/{id}/comments?cursor=&limit=`
///   * `POST /posts/{id}/comments`
///   * `DELETE /comments/{id}`
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
}
