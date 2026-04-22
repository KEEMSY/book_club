import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../data/book_api.dart';
import '../data/book_repository.dart';

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
