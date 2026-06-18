import 'package:dio/dio.dart';

import 'book_repository.dart' show BookRepositoryException;
import 'review_api.dart';
import 'review_models.dart';

/// Thin wrapper around [ReviewApi] that converts request DTOs to JSON and
/// translates dio errors into [BookRepositoryException] so notifiers can switch
/// on the machine [BookRepositoryException.code] without depending on dio.
///
/// Reuses [BookRepositoryException] (rather than a review-specific type) to
/// keep a single error vocabulary across the book domain.
class ReviewRepository {
  ReviewRepository(this._api);

  final ReviewApi _api;

  Future<ReviewDto> create(String bookId, double rating, String? body) {
    return _call(
      () => _api.createReview(
        bookId,
        CreateReviewRequest(rating: rating, body: body).toJson(),
      ),
    );
  }

  Future<ReviewDto> update(String bookId, {double? rating, String? body}) {
    final Map<String, dynamic> json =
        UpdateReviewRequest(rating: rating, body: body).toJson()
          ..removeWhere((_, value) => value == null);
    return _call(() => _api.updateReview(bookId, json));
  }

  Future<void> delete(String bookId) => _call(() => _api.deleteReview(bookId));

  Future<BookReviewSummaryDto> getReviews(
    String bookId, {
    int limit = 20,
    int offset = 0,
  }) {
    return _call(() => _api.getReviews(bookId, limit: limit, offset: offset));
  }

  Future<void> report(String bookId, String reviewId) =>
      _call(() => _api.reportReview(bookId, reviewId));

  Future<T> _call<T>(Future<T> Function() fn) async {
    try {
      return await fn();
    } on DioException catch (e) {
      throw _fromDio(e);
    }
  }

  BookRepositoryException _fromDio(DioException err) {
    final int? status = err.response?.statusCode;
    final data = err.response?.data;
    if (data is Map<String, dynamic>) {
      final error = data['error'];
      if (error is Map<String, dynamic>) {
        return BookRepositoryException(
          code: (error['code'] as String?) ?? 'UNKNOWN',
          message: (error['message'] as String?) ?? '요청을 처리하지 못했습니다.',
          statusCode: status,
          cause: err,
        );
      }
    }
    return BookRepositoryException(
      code: 'NETWORK_ERROR',
      message: '네트워크 오류가 발생했습니다. 잠시 후 다시 시도해주세요.',
      statusCode: status,
      cause: err,
    );
  }
}
