import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/book_repository.dart';
import '../domain/book.dart';
import 'book_providers.dart';
import 'book_search_state.dart';

/// Per-search configuration. Kept as a top-level constant so tests can
/// override the debounce window with a zero-duration variant.
const Duration kSearchDebounce = Duration(milliseconds: 300);

/// Orchestrates the search UX:
///   * debounces query input by [kSearchDebounce] to avoid hammering Naver.
///   * tracks cursor-style page numbers (server is 1-indexed).
///   * exposes [loadMore] so the list-end trigger can append the next page.
///   * normalises errors into typed [BookSearchError] so the screen stays
///     declarative.
///
/// Not generated via @riverpod — we want explicit [queryChanged]/[loadMore]
/// methods and a stored [Timer] that survives rebuilds (riverpod_generator
/// disposes providers on listener churn).
class BookSearchNotifier extends StateNotifier<BookSearchState> {
  BookSearchNotifier(
    this._repository, {
    Duration? debounce,
  })  : _debounce = debounce ?? kSearchDebounce,
        super(const BookSearchState.idle());

  final BookRepository _repository;
  final Duration _debounce;

  Timer? _debouncer;
  String _currentQuery = '';
  int _requestSeq = 0;

  /// Called by the search field on every keystroke. Empty / whitespace-only
  /// queries reset back to [BookSearchIdle] immediately so the empty-state
  /// prompt reappears without waiting for the debounce window.
  void queryChanged(String raw) {
    final String trimmed = raw.trim();
    _debouncer?.cancel();

    if (trimmed.isEmpty) {
      _currentQuery = '';
      if (state is! BookSearchIdle) {
        state = const BookSearchState.idle();
      }
      return;
    }

    // Skip debounce re-firing when the user hasn't actually changed the
    // query (e.g. whitespace padding or a hardware keyboard echo). This is
    // cheap and keeps the visible spinner from flickering.
    if (trimmed == _currentQuery && state is BookSearchLoaded) {
      return;
    }

    _debouncer = Timer(_debounce, () => _runFirstPage(trimmed));
  }

  /// Forces a first-page fetch without the debounce delay. Used by the
  /// "다시 시도" retry CTA on the error state.
  Future<void> retry() async {
    if (_currentQuery.isEmpty) {
      return;
    }
    _debouncer?.cancel();
    await _runFirstPage(_currentQuery);
  }

  /// Triggered by the list's onEndReached when the user scrolls to the last
  /// visible item. No-op unless we are in [BookSearchLoaded] with more pages.
  Future<void> loadMore() async {
    final BookSearchState snapshot = state;
    if (snapshot is! BookSearchLoaded) {
      return;
    }
    if (!snapshot.hasMore || snapshot.isLoadingMore) {
      return;
    }
    state = snapshot.copyWith(isLoadingMore: true);
    final int nextPage = snapshot.page + 1;
    final int seq = ++_requestSeq;
    try {
      final BookSearchResult result = await _repository.search(
        query: snapshot.query,
        page: nextPage,
      );
      if (seq != _requestSeq) {
        return; // stale response; caller has started a fresh query
      }
      state = BookSearchState.loaded(
        query: snapshot.query,
        items: <Book>[...snapshot.items, ...result.items],
        page: result.page,
        hasMore: result.hasMore,
      );
    } on BookRepositoryException catch (e) {
      if (seq != _requestSeq) {
        return;
      }
      // Keep already-visible results and just drop the spinner. Preserves
      // the scroll position while surfacing the failure subtly.
      state = snapshot.copyWith(isLoadingMore: false);
      // Swallow: the list has a passive retry button at the footer in the
      // error state, and the next scroll tick retries naturally. We don't
      // want a transient pagination failure to wipe the current results.
      assert(() {
        // coverage: ignore-start
        // ignore: avoid_print
        print('BookSearchNotifier loadMore failed: ${e.code}');
        // coverage: ignore-end
        return true;
      }());
    }
  }

  @override
  void dispose() {
    _debouncer?.cancel();
    super.dispose();
  }

  Future<void> _runFirstPage(String query) async {
    _currentQuery = query;
    state = const BookSearchState.loading();
    final int seq = ++_requestSeq;
    try {
      final BookSearchResult result = await _repository.search(
        query: query,
        page: 1,
      );
      if (seq != _requestSeq) {
        return; // a newer keystroke has superseded this request
      }
      state = BookSearchState.loaded(
        query: query,
        items: result.items,
        page: result.page,
        hasMore: result.hasMore,
      );
    } on BookRepositoryException catch (e) {
      if (seq != _requestSeq) {
        return;
      }
      state = BookSearchState.error(code: e.code, message: e.message);
    }
  }
}

final bookSearchNotifierProvider =
    StateNotifierProvider.autoDispose<BookSearchNotifier, BookSearchState>(
  (ref) => BookSearchNotifier(ref.watch(bookRepositoryProvider)),
);
