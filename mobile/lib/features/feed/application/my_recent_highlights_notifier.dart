import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/feed_models.dart';
import '../data/feed_repository.dart';
import 'feed_providers.dart';

/// Offset-paginated state for the "내 활동 > 내 하이라이트 더보기" screen
/// (BC-83 — `GET /me/highlights/recent`).
class MyRecentHighlightsState {
  const MyRecentHighlightsState({
    required this.items,
    required this.total,
    required this.hasMore,
    required this.isLoading,
    required this.error,
  });

  const MyRecentHighlightsState.initial()
      : items = const <MyHighlightItemDto>[],
        total = 0,
        hasMore = false,
        isLoading = false,
        error = null;

  final List<MyHighlightItemDto> items;
  final int total;
  final bool hasMore;
  final bool isLoading;
  final Object? error;

  MyRecentHighlightsState copyWith({
    List<MyHighlightItemDto>? items,
    int? total,
    bool? hasMore,
    bool? isLoading,
    Object? error,
    bool clearError = false,
  }) {
    return MyRecentHighlightsState(
      items: items ?? this.items,
      total: total ?? this.total,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Not generated via @riverpod (mirrors [BookSearchNotifier]'s hand-written
/// style) — explicit `fetchFirst`/`fetchMore` over an offset cursor.
class MyRecentHighlightsNotifier
    extends StateNotifier<MyRecentHighlightsState> {
  MyRecentHighlightsNotifier(this._repository)
      : super(const MyRecentHighlightsState.initial());

  final FeedRepository _repository;

  static const int _pageSize = 20;

  Future<void> fetchFirst() async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final MyHighlightListResponseDto page =
          await _repository.listMyRecentHighlights(limit: _pageSize, offset: 0);
      state = MyRecentHighlightsState(
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
      final MyHighlightListResponseDto page =
          await _repository.listMyRecentHighlights(
        limit: _pageSize,
        offset: state.items.length,
      );
      state = state.copyWith(
        items: <MyHighlightItemDto>[...state.items, ...page.items],
        total: page.total,
        hasMore: page.hasMore,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }
}

final myRecentHighlightsNotifierProvider = StateNotifierProvider.autoDispose<
    MyRecentHighlightsNotifier, MyRecentHighlightsState>(
  (ref) => MyRecentHighlightsNotifier(ref.watch(feedRepositoryProvider)),
);
