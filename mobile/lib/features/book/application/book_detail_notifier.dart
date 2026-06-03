import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/book_repository.dart';
import '../domain/book.dart';
import '../domain/book_status.dart';
import '../domain/user_book.dart';
import 'book_detail_state.dart';
import 'book_providers.dart';

part 'book_detail_notifier.g.dart';

/// Detail screen notifier:
///   * loads a book by id,
///   * tracks the add-to-library CTA state,
///   * translates 409 BOOK_ALREADY_IN_LIBRARY into a LibraryCtaDuplicate
///     so the screen can render the "서재에서 보기" affordance.
///
/// Keyed by book id so each detail screen owns its own state. `autoDispose`
/// so leaving the screen resets CTA state for the next visit.
@Riverpod(keepAlive: false)
class BookDetailNotifier extends _$BookDetailNotifier {
  @override
  BookDetailState build(String bookId) {
    Future.microtask(load);
    return const BookDetailState.loading();
  }

  BookRepository get _repository => ref.read(bookRepositoryProvider);

  Future<void> load() async {
    state = const BookDetailState.loading();
    try {
      final Book book = await _repository.getById(bookId);
      state = BookDetailState.loaded(book: book);
    } on BookRepositoryException catch (e) {
      state = BookDetailState.error(code: e.code, message: e.message);
    }
  }

  Future<UserBook?> addToLibrary() => _addWithStatus(BookStatus.reading);

  Future<UserBook?> addToWishlist() => _addWithStatus(BookStatus.wishlist);

  Future<UserBook?> _addWithStatus(BookStatus status) async {
    final BookDetailState snapshot = state;
    if (snapshot is! BookDetailLoaded) {
      return null;
    }
    if (snapshot.libraryState is LibraryCtaAdding) {
      return null;
    }
    state = snapshot.copyWith(libraryState: const LibraryCtaState.adding());
    try {
      final UserBook added =
          await _repository.addToLibrary(bookId, status: status);
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
