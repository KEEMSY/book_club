import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'book_models.dart';

part 'book_api.g.dart';

/// Typed HTTP bindings for the book router.
///
/// Endpoint shapes come from the M2 backend contract:
///   * `GET /books/search?q=...&page=...&size=...`
///   * `GET /books/{id}`
///   * `POST /me/library` · `PATCH /me/library/{user_book_id}`
///   * `POST /me/library/{user_book_id}/review`
///   * `GET /me/library?status=...&cursor=...&limit=...`
///
/// Bearer attachment is handled globally by [AuthInterceptor] — every path
/// in this file sits outside `/auth/*`, so the interceptor automatically
/// injects the access token.
///
/// **Body typing note:** we keep request bodies as `Map<String, dynamic>`
/// and convert freezed DTOs to JSON at the repository boundary. This is the
/// same workaround used in `auth_api.dart` (retrofit_generator 9.7 cannot
/// currently introspect freezed factories).
@RestApi()
abstract class BookApi {
  factory BookApi(Dio dio, {String baseUrl}) = _BookApi;

  @GET('/books/search')
  Future<BookSearchResponse> search({
    @Query('q') required String q,
    @Query('page') int page = 1,
    @Query('size') int size = 20,
  });

  @GET('/books/{id}')
  Future<BookDto> getById(@Path('id') String id);

  @POST('/me/library')
  Future<UserBookDto> addToLibrary(@Body() Map<String, dynamic> body);

  @PATCH('/me/library/{user_book_id}')
  Future<UserBookDto> updateStatus(
    @Path('user_book_id') String userBookId,
    @Body() Map<String, dynamic> body,
  );

  @POST('/me/library/{user_book_id}/review')
  Future<UserBookDto> submitReview(
    @Path('user_book_id') String userBookId,
    @Body() Map<String, dynamic> body,
  );

  /// Cursor-paginated library listing. [status] and [cursor] are optional;
  /// retrofit omits null query params from the URL.
  @GET('/me/library')
  Future<LibraryPageDto> listLibrary({
    @Query('status') String? status,
    @Query('cursor') String? cursor,
    @Query('limit') int limit = 20,
  });
}
