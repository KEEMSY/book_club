import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/dio_provider.dart';
import '../data/review_api.dart';
import '../data/review_models.dart';
import '../data/review_repository.dart';

part 'review_providers.g.dart';

/// retrofit client for the M54 `/books/{id}/reviews` endpoints.
@riverpod
ReviewApi reviewApi(ReviewApiRef ref) {
  return ReviewApi(ref.watch(dioProvider));
}

@riverpod
ReviewRepository reviewRepository(ReviewRepositoryRef ref) {
  return ReviewRepository(ref.watch(reviewApiProvider));
}

/// Aggregate review summary for a book — average, distribution, and the latest
/// page of reviews.
@riverpod
Future<BookReviewSummaryDto> bookReviewSummary(
  BookReviewSummaryRef ref,
  String bookId,
) {
  return ref.watch(reviewRepositoryProvider).getReviews(bookId);
}

/// Drives create / update / delete mutations and exposes their in-flight and
/// error state. Each mutation invalidates [bookReviewSummaryProvider] for the
/// affected book so the section re-fetches the fresh aggregate.
@riverpod
class ReviewNotifier extends _$ReviewNotifier {
  @override
  FutureOr<void> build() {}

  Future<bool> create(String bookId, double rating, String? body) async {
    return _run(
      bookId,
      () => ref.read(reviewRepositoryProvider).create(bookId, rating, body),
    );
  }

  Future<bool> updateReview(
    String bookId, {
    double? rating,
    String? body,
  }) async {
    return _run(
      bookId,
      () => ref
          .read(reviewRepositoryProvider)
          .update(bookId, rating: rating, body: body),
    );
  }

  Future<bool> delete(String bookId) async {
    return _run(
      bookId,
      () => ref.read(reviewRepositoryProvider).delete(bookId),
    );
  }

  /// Runs [action], mirroring its outcome into [state], and invalidates the
  /// summary on success. Returns true when the mutation succeeded.
  Future<bool> _run(String bookId, Future<void> Function() action) async {
    state = const AsyncLoading<void>();
    final AsyncValue<void> result = await AsyncValue.guard<void>(action);
    state = result;
    if (!result.hasError) {
      ref.invalidate(bookReviewSummaryProvider(bookId));
    }
    return !result.hasError;
  }
}
