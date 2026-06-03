import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/dio_provider.dart';
import '../data/book_api.dart';
import '../data/book_models.dart' show DiscoverResponseDto;
import '../data/book_repository.dart';
import '../domain/book_review.dart';
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

@riverpod
Future<List<BookReview>> bookReviews(BookReviewsRef ref, String bookId) {
  return ref.read(bookRepositoryProvider).getBookReviews(bookId);
}
