import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/book_repository.dart';
import '../domain/book_status.dart';
import '../domain/user_book.dart';
import 'book_providers.dart';
import 'library_state.dart';

/// Holds a `Map<BookStatus, LibraryListState>` so switching status tabs
/// preserves previously-loaded pages (Airbnb-style "sticky tabs" feel).
///
/// Each status has its own cursor; loading more on the `reading` tab does
/// not touch the `completed` cache and vice-versa. Refresh is explicit via
/// [refresh] so accidental re-fetch on tab pump does not hit the API.
class LibraryNotifier extends StateNotifier<Map<BookStatus, LibraryListState>> {
  LibraryNotifier(this._repository) : super(_initialMap());

  final BookRepository _repository;

  static Map<BookStatus, LibraryListState> _initialMap() {
    return <BookStatus, LibraryListState>{
      for (final BookStatus status in BookStatus.values)
        status: const LibraryListState.initial(),
    };
  }

  /// Called by the segment tab when the user taps a status. If the tab has
  /// never been loaded we fire a first-page fetch; otherwise we leave the
  /// cached pages in place.
  Future<void> ensureLoaded(BookStatus status) async {
    final LibraryListState current =
        state[status] ?? const LibraryListState.initial();
    if (current is LibraryListInitial) {
      await _loadFirstPage(status);
    }
  }

  /// Drops the cached page and re-fetches the first page for a tab. Used by
  /// the RefreshIndicator.
  Future<void> refresh(BookStatus status) async {
    _update(status, const LibraryListState.loading());
    await _loadFirstPage(status);
  }

  Future<void> loadMore(BookStatus status) async {
    final LibraryListState current =
        state[status] ?? const LibraryListState.initial();
    if (current is! LibraryListLoaded) {
      return;
    }
    if (current.nextCursor == null || current.isLoadingMore) {
      return;
    }
    _update(status, current.copyWith(isLoadingMore: true));
    try {
      final LibraryPage page = await _repository.listLibrary(
        status: status,
        cursor: current.nextCursor,
      );
      final List<UserBook> merged = <UserBook>[
        ...current.items,
        ...page.items,
      ];
      _update(
        status,
        LibraryListState.loaded(
          items: merged,
          nextCursor: page.nextCursor,
        ),
      );
    } on BookRepositoryException {
      // Preserve existing items and drop the spinner.
      _update(status, current.copyWith(isLoadingMore: false));
    }
  }

  /// Updates the locally-cached row for [updated] — used after status /
  /// review mutations so the library doesn't need a second fetch.
  void upsert(UserBook updated) {
    final Map<BookStatus, LibraryListState> next =
        Map<BookStatus, LibraryListState>.from(state);
    next.updateAll((status, list) {
      if (list is! LibraryListLoaded) {
        return list;
      }
      if (status == updated.status) {
        final int index =
            list.items.indexWhere((UserBook item) => item.id == updated.id);
        final List<UserBook> items;
        if (index == -1) {
          items = <UserBook>[updated, ...list.items];
        } else {
          items = List<UserBook>.from(list.items);
          items[index] = updated;
        }
        return list.copyWith(items: items);
      }
      // Row moved to a different tab; remove it from this one.
      final List<UserBook> items =
          list.items.where((UserBook item) => item.id != updated.id).toList();
      if (items.length == list.items.length) {
        return list;
      }
      return list.copyWith(items: items);
    });
    state = next;
  }

  Future<void> _loadFirstPage(BookStatus status) async {
    try {
      final LibraryPage page = await _repository.listLibrary(status: status);
      _update(
        status,
        LibraryListState.loaded(
          items: page.items,
          nextCursor: page.nextCursor,
        ),
      );
    } on BookRepositoryException catch (e) {
      _update(status, LibraryListState.error(code: e.code, message: e.message));
    }
  }

  void _update(BookStatus status, LibraryListState next) {
    state = <BookStatus, LibraryListState>{
      ...state,
      status: next,
    };
  }
}

final libraryNotifierProvider =
    StateNotifierProvider<LibraryNotifier, Map<BookStatus, LibraryListState>>(
  (ref) => LibraryNotifier(ref.watch(bookRepositoryProvider)),
);
