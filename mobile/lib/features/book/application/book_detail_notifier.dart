import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/book_repository.dart';
import '../domain/book.dart';
import '../domain/user_book.dart';
import 'book_detail_state.dart';
import 'book_providers.dart';

/// Detail screen notifier:
///   * loads a book by id,
///   * tracks the add-to-library CTA state,
///   * translates 409 BOOK_ALREADY_IN_LIBRARY into a LibraryCtaDuplicate
///     so the screen can render the "서재에서 보기" affordance.
class BookDetailNotifier extends StateNotifier<BookDetailState> {
  BookDetailNotifier(this._repository, this.bookId)
      : super(const BookDetailState.loading()) {
    load();
  }

  final BookRepository _repository;
  final String bookId;

  Future<void> load() async {
    state = const BookDetailState.loading();
    try {
      final Book book = await _repository.getById(bookId);
      state = BookDetailState.loaded(book: book);
    } on BookRepositoryException catch (e) {
      state = BookDetailState.error(code: e.code, message: e.message);
    }
  }

  Future<UserBook?> addToLibrary() async {
    final BookDetailState snapshot = state;
    if (snapshot is! BookDetailLoaded) {
      return null;
    }
    if (snapshot.libraryState is LibraryCtaAdding) {
      return null;
    }
    state = snapshot.copyWith(libraryState: const LibraryCtaState.adding());
    try {
      final UserBook added = await _repository.addToLibrary(bookId);
      state = snapshot.copyWith(
        libraryState: LibraryCtaState.added(userBook: added),
      );
      return added;
    } on BookRepositoryException catch (e) {
      if (e.code == 'BOOK_ALREADY_IN_LIBRARY') {
        state = snapshot.copyWith(
          libraryState: const LibraryCtaState.duplicate(),
        );
        return null;
      }
      state = snapshot.copyWith(
        libraryState: LibraryCtaState.error(code: e.code, message: e.message),
      );
      return null;
    }
  }
}

/// Keyed by book id so each detail screen owns its own state. `autoDispose`
/// so leaving the screen resets CTA state for the next visit.
final bookDetailNotifierProvider = StateNotifierProvider.autoDispose
    .family<BookDetailNotifier, BookDetailState, String>((ref, bookId) {
  return BookDetailNotifier(ref.watch(bookRepositoryProvider), bookId);
});
