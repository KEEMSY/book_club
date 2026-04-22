import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/user_book.dart';

part 'library_state.freezed.dart';

/// Per-tab list state for the library screen.
///
/// Keeping this keyed-by-status (`Map<BookStatus, LibraryListState>`) in the
/// notifier lets tab switches preserve scroll position and avoid redundant
/// network calls. [nextCursor] is null once the server returns no more rows.
@freezed
sealed class LibraryListState with _$LibraryListState {
  const factory LibraryListState.initial() = LibraryListInitial;
  const factory LibraryListState.loading() = LibraryListLoading;
  const factory LibraryListState.loaded({
    required List<UserBook> items,
    String? nextCursor,
    @Default(false) bool isLoadingMore,
  }) = LibraryListLoaded;
  const factory LibraryListState.error({
    required String code,
    required String message,
  }) = LibraryListError;
}
