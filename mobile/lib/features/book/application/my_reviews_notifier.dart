import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/review_models.dart';
import '../data/review_repository.dart';
import 'review_providers.dart';

/// Offset-paginated state for the "내 활동 > 내 리뷰 더보기" screen
/// (BC-83 — `GET /me/reviews`).
class MyReviewsState {
  const MyReviewsState({
    required this.items,
    required this.total,
    required this.hasMore,
    required this.isLoading,
    required this.error,
  });

  const MyReviewsState.initial()
      : items = const <MyReviewItemDto>[],
        total = 0,
        hasMore = false,
        isLoading = false,
        error = null;

  final List<MyReviewItemDto> items;
  final int total;
  final bool hasMore;
  final bool isLoading;
  final Object? error;

  MyReviewsState copyWith({
    List<MyReviewItemDto>? items,
    int? total,
    bool? hasMore,
    bool? isLoading,
    Object? error,
    bool clearError = false,
  }) {
    return MyReviewsState(
      items: items ?? this.items,
      total: total ?? this.total,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Not generated via @riverpod — mirrors [BookSearchNotifier]'s hand-written
/// style for the same reason: explicit `fetchFirst`/`fetchMore` entry points
/// over an offset cursor.
class MyReviewsNotifier extends StateNotifier<MyReviewsState> {
  MyReviewsNotifier(this._repository) : super(const MyReviewsState.initial());

  final ReviewRepository _repository;

  static const int _pageSize = 20;

  Future<void> fetchFirst() async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final MyReviewListResponseDto page =
          await _repository.listMyReviews(limit: _pageSize, offset: 0);
      state = MyReviewsState(
        items: page.items,
        total: page.total,
        hasMore: page.hasMore,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  Future<void> fetchMore() async {
    if (state.isLoading || !state.hasMore) return;
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final MyReviewListResponseDto page = await _repository.listMyReviews(
        limit: _pageSize,
        offset: state.items.length,
      );
      state = state.copyWith(
        items: <MyReviewItemDto>[...state.items, ...page.items],
        total: page.total,
        hasMore: page.hasMore,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }
}

final myReviewsNotifierProvider =
    StateNotifierProvider.autoDispose<MyReviewsNotifier, MyReviewsState>(
  (ref) => MyReviewsNotifier(ref.watch(reviewRepositoryProvider)),
);
