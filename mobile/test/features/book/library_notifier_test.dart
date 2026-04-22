import 'package:book_club/features/book/application/library_notifier.dart';
import 'package:book_club/features/book/application/library_state.dart';
import 'package:book_club/features/book/data/book_repository.dart';
import 'package:book_club/features/book/domain/book_status.dart';
import 'package:book_club/features/book/domain/user_book.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes.dart';

void main() {
  group('LibraryNotifier', () {
    test('ensureLoaded fires first page for a status, caches subsequent calls',
        () async {
      final repo = FakeBookRepository()
        ..libraryQueue.add(
          LibraryPage(
            items: <UserBook>[buildUserBook(id: 'ub1')],
            nextCursor: null,
          ),
        );
      final notifier = LibraryNotifier(repo);

      await notifier.ensureLoaded(BookStatus.reading);
      expect(repo.libraryCalls.length, 1);
      expect(repo.libraryCalls.single.status, BookStatus.reading);
      expect(notifier.state[BookStatus.reading], isA<LibraryListLoaded>());

      // Second ensureLoaded should be a cache hit.
      await notifier.ensureLoaded(BookStatus.reading);
      expect(repo.libraryCalls.length, 1);
    });

    test('status filter passes the right wire value', () async {
      final repo = FakeBookRepository()
        ..libraryQueue.add(const LibraryPage(items: <UserBook>[]));
      final notifier = LibraryNotifier(repo);

      await notifier.ensureLoaded(BookStatus.completed);

      expect(repo.libraryCalls.single.status, BookStatus.completed);
    });

    test('loadMore appends the next cursor page', () async {
      final repo = FakeBookRepository()
        ..libraryQueue.addAll(<LibraryPage>[
          LibraryPage(
            items: <UserBook>[buildUserBook(id: 'ub1')],
            nextCursor: '2026-04-20T00:00:00+00:00',
          ),
          LibraryPage(
            items: <UserBook>[buildUserBook(id: 'ub2')],
            nextCursor: null,
          ),
        ]);
      final notifier = LibraryNotifier(repo);

      await notifier.ensureLoaded(BookStatus.reading);
      await notifier.loadMore(BookStatus.reading);

      final loaded = notifier.state[BookStatus.reading] as LibraryListLoaded;
      expect(loaded.items.map((u) => u.id), <String>['ub1', 'ub2']);
      expect(loaded.nextCursor, isNull);
      expect(repo.libraryCalls.length, 2);
      expect(repo.libraryCalls.last.cursor, '2026-04-20T00:00:00+00:00');
    });

    test('upsert updates a row without moving tabs when status unchanged',
        () async {
      final repo = FakeBookRepository()
        ..libraryQueue.add(
          LibraryPage(
            items: <UserBook>[
              buildUserBook(id: 'ub1', rating: null, oneLineReview: null),
            ],
            nextCursor: null,
          ),
        );
      final notifier = LibraryNotifier(repo);
      await notifier.ensureLoaded(BookStatus.reading);

      final updated = buildUserBook(
        id: 'ub1',
        status: BookStatus.reading,
        oneLineReview: '좋았다',
        rating: 5,
      );
      notifier.upsert(updated);

      final loaded = notifier.state[BookStatus.reading] as LibraryListLoaded;
      expect(loaded.items.single.oneLineReview, '좋았다');
      expect(loaded.items.single.rating, 5);
    });

    test('upsert removes a row from its old tab when status changes', () async {
      final repo = FakeBookRepository()
        ..libraryQueue.add(
          LibraryPage(
            items: <UserBook>[
              buildUserBook(id: 'ub1', status: BookStatus.reading),
            ],
            nextCursor: null,
          ),
        )
        ..libraryQueue.add(const LibraryPage(items: <UserBook>[]));
      final notifier = LibraryNotifier(repo);
      await notifier.ensureLoaded(BookStatus.reading);
      await notifier.ensureLoaded(BookStatus.completed);

      final updated = buildUserBook(
        id: 'ub1',
        status: BookStatus.completed,
        rating: 4,
      );
      notifier.upsert(updated);

      final readingTab =
          notifier.state[BookStatus.reading] as LibraryListLoaded;
      final completedTab =
          notifier.state[BookStatus.completed] as LibraryListLoaded;
      expect(readingTab.items, isEmpty);
      expect(completedTab.items.map((u) => u.id), <String>['ub1']);
    });
  });
}
