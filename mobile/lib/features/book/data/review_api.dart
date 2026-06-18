import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'review_models.dart';

part 'review_api.g.dart';

/// Typed HTTP bindings for the M54 book-review router.
///
///   * `POST   /books/{id}/reviews`            — create my review
///   * `PATCH  /books/{id}/reviews/me`         — update my review
///   * `DELETE /books/{id}/reviews/me`         — delete my review
///   * `GET    /books/{id}/reviews`            — aggregate summary + page
///   * `POST   /books/{id}/reviews/{rid}/report` — report a review
///
/// Bearer attachment is handled globally by the auth interceptor. Request
/// bodies stay as `Map<String, dynamic>`; freezed DTOs are converted to JSON
/// at the repository boundary (same workaround as `book_api.dart`).
@RestApi()
abstract class ReviewApi {
  factory ReviewApi(Dio dio, {String baseUrl}) = _ReviewApi;

  @POST('/books/{book_id}/reviews')
  Future<ReviewDto> createReview(
    @Path('book_id') String bookId,
    @Body() Map<String, dynamic> body,
  );

  @PATCH('/books/{book_id}/reviews/me')
  Future<ReviewDto> updateReview(
    @Path('book_id') String bookId,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('/books/{book_id}/reviews/me')
  Future<void> deleteReview(@Path('book_id') String bookId);

  @GET('/books/{book_id}/reviews')
  Future<BookReviewSummaryDto> getReviews(
    @Path('book_id') String bookId, {
    @Query('limit') int limit = 20,
    @Query('offset') int offset = 0,
  });

  @POST('/books/{book_id}/reviews/{review_id}/report')
  Future<void> reportReview(
    @Path('book_id') String bookId,
    @Path('review_id') String reviewId,
  );
}
