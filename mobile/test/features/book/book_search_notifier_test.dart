import 'package:book_club/features/book/application/book_search_notifier.dart';
import 'package:book_club/features/book/application/book_search_state.dart';
import 'package:book_club/features/book/data/book_repository.dart';
import 'package:book_club/features/book/domain/book.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes.dart';

void main() {
  group('BookSearchNotifier', () {
    test('empty query keeps state idle', () async {
      final repo = FakeBookRepository();
      final notifier =
          BookSearchNotifier(repo, debounce: const Duration(milliseconds: 10));

      notifier.queryChanged('   ');
      await Future<void>.delayed(const Duration(milliseconds: 30));

      expect(notifier.state, isA<BookSearchIdle>());
      expect(repo.searchCalls, isEmpty);
    });

    test('debounces keystrokes into a single request', () async {
      final repo = FakeBookRepository()
        ..defaultSearchResult = buildSearchResult();

      final notifier =
          BookSearchNotifier(repo, debounce: const Duration(milliseconds: 20));
      notifier.queryChanged('달');
      notifier.queryChanged('달러');
      notifier.queryChanged('달러구트');
      await Future<void>.delayed(const Duration(milliseconds: 60));

      // Only the final query should have reached the repository.
      expect(repo.searchCalls.length, 1);
      expect(repo.searchCalls.single.query, '달러구트');
      expect(notifier.state, isA<BookSearchLoaded>());
    });

    test('loadMore appends the next page and respects hasMore', () async {
      final repo = FakeBookRepository()
        ..searchQueue.addAll(<BookSearchResult>[
          buildSearchResult(
            items: <Book>[buildBook(id: 'b1', title: 'First')],
            hasMore: true,
          ),
          buildSearchResult(
            items: <Book>[buildBook(id: 'b2', title: 'Second')],
            page: 2,
            hasMore: false,
          ),
        ]);

      final notifier =
          BookSearchNotifier(repo, debounce: const Duration(milliseconds: 5));
      notifier.queryChanged('foo');
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(notifier.state, isA<BookSearchLoaded>());
      expect((notifier.state as BookSearchLoaded).items.length, 1);
      expect((notifier.state as BookSearchLoaded).hasMore, isTrue);

      await notifier.loadMore();
      final loaded = notifier.state as BookSearchLoaded;
      expect(loaded.items.length, 2);
      expect(loaded.items.map((b) => b.id), <String>['b1', 'b2']);
      expect(loaded.hasMore, isFalse);

      // Calling loadMore once hasMore is false is a no-op.
      final callsBefore = repo.searchCalls.length;
      await notifier.loadMore();
      expect(repo.searchCalls.length, callsBefore);
    });

    test('surfaces UPSTREAM_UNAVAILABLE on 502', () async {
      final repo = FakeBookRepository()
        ..searchErrors.add(
          const BookRepositoryException(
            code: 'UPSTREAM_UNAVAILABLE',
            message: '잠시 후 다시 시도해주세요.',
            statusCode: 502,
          ),
        );
      final notifier =
          BookSearchNotifier(repo, debounce: const Duration(milliseconds: 5));

      notifier.queryChanged('네트워크');
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(notifier.state, isA<BookSearchError>());
      final err = notifier.state as BookSearchError;
      expect(err.code, 'UPSTREAM_UNAVAILABLE');
    });

    test('retry re-runs the last non-empty query', () async {
      final repo = FakeBookRepository()
        ..searchErrors.add(
          const BookRepositoryException(
            code: 'UPSTREAM_UNAVAILABLE',
            message: '잠시 후 다시 시도해주세요.',
          ),
        )
        ..searchQueue.add(buildSearchResult());

      final notifier =
          BookSearchNotifier(repo, debounce: const Duration(milliseconds: 5));
      notifier.queryChanged('달러구트');
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(notifier.state, isA<BookSearchError>());

      await notifier.retry();
      expect(notifier.state, isA<BookSearchLoaded>());
      expect(repo.searchCalls.length, 2);
    });
  });
}
