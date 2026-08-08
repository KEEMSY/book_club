import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/dio_provider.dart';
import '../data/book_api.dart';
import '../data/book_models.dart' show DiscoverResponseDto;
import '../data/book_repository.dart';
import '../domain/book.dart';
import '../domain/book_status.dart';

part 'book_providers.g.dart';

/// retrofit client for `/books/*` and `/me/library` — built once per Dio.
@riverpod
BookApi bookApi(BookApiRef ref) {
  final dio = ref.watch(dioProvider);
  return BookApi(dio);
}

/// Thin wrapper that translates the retrofit client into a domain-shaped
/// repository. Notifiers (search, detail, library) consume this provider.
@riverpod
BookRepository bookRepository(BookRepositoryRef ref) {
  return BookRepository(ref.watch(bookApiProvider));
}

/// One-shot "jump to this tab" signal consumed by LibraryScreen.
/// Set before navigating to /library; the screen clears it after reading.
@riverpod
class LibraryPendingTab extends _$LibraryPendingTab {
  @override
  BookStatus? build() => null;

  void set(BookStatus? status) => state = status;
}

@riverpod
Future<DiscoverResponseDto> discoverBooks(DiscoverBooksRef ref) {
  ref.keepAlive();
  return ref.read(bookRepositoryProvider).getDiscover();
}

/// Fetches a single book by id — used by the profile header (BC-84) to
/// resolve a user's `featuredBookId` into title/cover for display.
/// `featuredBookId` is a bare id on `UserProfile`/`AuthUser`; this stays a
/// plain family provider (not baked into the profile fetch) so the profile
/// endpoint doesn't have to join book data server-side.
@riverpod
Future<Book> featuredBook(FeaturedBookRef ref, String bookId) {
  return ref.watch(bookRepositoryProvider).getById(bookId);
}
