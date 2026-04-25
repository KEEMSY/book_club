import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/post.dart';

part 'book_feed_state.freezed.dart';

/// Sealed state for the per-book feed list.
///
/// Transitions:
///   - [initial]  — first frame before any fetch dispatches.
///   - [loading]  — first-page fetch in flight.
///   - [loaded]   — items loaded; `nextCursor != null` means more pages.
///   - [error]    — first-page fetch failed; the screen shows retry CTA.
@freezed
sealed class BookFeedState with _$BookFeedState {
  const factory BookFeedState.initial() = BookFeedInitial;
  const factory BookFeedState.loading() = BookFeedLoading;
  const factory BookFeedState.loaded({
    required List<Post> items,
    String? nextCursor,
    @Default(false) bool isLoadingMore,
  }) = BookFeedLoaded;
  const factory BookFeedState.error({
    required String code,
    required String message,
  }) = BookFeedError;
}
