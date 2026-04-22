import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/book.dart';

part 'book_search_state.freezed.dart';

/// Sealed state union consumed by `SearchScreen`.
///
/// Transitions:
///   - [idle]          — query is empty; show the "start searching" prompt.
///   - [loading]       — first page fetch in flight (debounced).
///   - [loaded]        — results for the current query, plus `hasMore`.
///   - [error]         — backend or upstream failure; screen shows retry CTA.
@freezed
sealed class BookSearchState with _$BookSearchState {
  const factory BookSearchState.idle() = BookSearchIdle;
  const factory BookSearchState.loading() = BookSearchLoading;
  const factory BookSearchState.loaded({
    required String query,
    required List<Book> items,
    required int page,
    required bool hasMore,
    @Default(false) bool isLoadingMore,
  }) = BookSearchLoaded;
  const factory BookSearchState.error({
    required String code,
    required String message,
  }) = BookSearchError;
}
