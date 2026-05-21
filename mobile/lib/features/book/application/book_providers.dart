import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../data/book_api.dart';
import '../data/book_models.dart' show DiscoverResponseDto;
import '../data/book_repository.dart';
import '../domain/book_review.dart';
import '../domain/book_status.dart';

/// retrofit client for `/books/*` and `/me/library` — built once per Dio.
final bookApiProvider = Provider<BookApi>((ref) {
  final dio = ref.watch(dioProvider);
  return BookApi(dio);
});

/// Thin wrapper that translates the retrofit client into a domain-shaped
/// repository. Notifiers (search, detail, library) consume this provider.
final bookRepositoryProvider = Provider<BookRepository>((ref) {
  return BookRepository(ref.watch(bookApiProvider));
});

/// One-shot "jump to this tab" signal consumed by LibraryScreen.
/// Set before navigating to /library; the screen clears it after reading.
final libraryPendingTabProvider = StateProvider<BookStatus?>((ref) => null);

final discoverBooksProvider =
    FutureProvider.autoDispose<DiscoverResponseDto>((ref) async {
  return ref.read(bookRepositoryProvider).getDiscover();
});

final bookReviewsProvider =
    FutureProvider.autoDispose.family<List<BookReview>, String>(
  (ref, bookId) => ref.read(bookRepositoryProvider).getBookReviews(bookId),
);
