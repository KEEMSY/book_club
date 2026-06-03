import 'package:book_club/features/book/application/book_detail_notifier.dart';
import 'package:book_club/features/book/application/book_detail_state.dart';
import 'package:book_club/features/book/application/book_providers.dart';
import 'package:book_club/features/book/data/book_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes.dart';

void main() {
  group('BookDetailNotifier', () {
    test('load() transitions through loading → loaded', () async {
      final repo = FakeBookRepository()..getByIdResult = buildBook(id: 'b1');
      final c = ProviderContainer(overrides: [
        bookRepositoryProvider.overrideWithValue(repo),
      ]);
      addTearDown(c.dispose);
      final notifier = c.read(bookDetailNotifierProvider('b1').notifier);
      // initial state is loading and notifier kicks off load immediately
      expect(c.read(bookDetailNotifierProvider('b1')), isA<BookDetailLoading>());
      await Future<void>.delayed(Duration.zero);
      expect(c.read(bookDetailNotifierProvider('b1')), isA<BookDetailLoaded>());
      expect((c.read(bookDetailNotifierProvider('b1')) as BookDetailLoaded).book.id, 'b1');
    });

    test('addToLibrary happy path transitions idle → adding → added', () async {
      final repo = FakeBookRepository()
        ..getByIdResult = buildBook(id: 'b1')
        ..addToLibraryResult = buildUserBook(id: 'ub1');
      final c = ProviderContainer(overrides: [
        bookRepositoryProvider.overrideWithValue(repo),
      ]);
      addTearDown(c.dispose);
      final notifier = c.read(bookDetailNotifierProvider('b1').notifier);
      await Future<void>.delayed(Duration.zero);

      final added = await notifier.addToLibrary();

      expect(added, isNotNull);
      final loaded = c.read(bookDetailNotifierProvider('b1')) as BookDetailLoaded;
      expect(loaded.libraryState, isA<LibraryCtaAdded>());
      expect((loaded.libraryState as LibraryCtaAdded).userBook.id, 'ub1');
      expect(repo.addToLibraryCalls, <String>['b1']);
    });

    test('addToLibrary translates 409 into LibraryCtaDuplicate', () async {
      final repo = FakeBookRepository()
        ..getByIdResult = buildBook(id: 'b1')
        ..addToLibraryError = const BookRepositoryException(
          code: 'BOOK_ALREADY_IN_LIBRARY',
          message: '이미 서재에 있는 책이에요.',
          statusCode: 409,
        );
      final c = ProviderContainer(overrides: [
        bookRepositoryProvider.overrideWithValue(repo),
      ]);
      addTearDown(c.dispose);
      final notifier = c.read(bookDetailNotifierProvider('b1').notifier);
      await Future<void>.delayed(Duration.zero);

      final added = await notifier.addToLibrary();

      expect(added, isNull);
      final loaded = c.read(bookDetailNotifierProvider('b1')) as BookDetailLoaded;
      expect(loaded.libraryState, isA<LibraryCtaDuplicate>());
    });

    test('addToLibrary surfaces non-409 errors as LibraryCtaError', () async {
      final repo = FakeBookRepository()
        ..getByIdResult = buildBook(id: 'b1')
        ..addToLibraryError = const BookRepositoryException(
          code: 'NETWORK_ERROR',
          message: '네트워크 오류가 발생했습니다.',
        );
      final c = ProviderContainer(overrides: [
        bookRepositoryProvider.overrideWithValue(repo),
      ]);
      addTearDown(c.dispose);
      final notifier = c.read(bookDetailNotifierProvider('b1').notifier);
      await Future<void>.delayed(Duration.zero);

      await notifier.addToLibrary();

      final loaded = c.read(bookDetailNotifierProvider('b1')) as BookDetailLoaded;
      expect(loaded.libraryState, isA<LibraryCtaError>());
    });
  });
}
