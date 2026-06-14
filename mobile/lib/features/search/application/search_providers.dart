import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/dio_provider.dart';
import '../data/search_api.dart';
import '../data/search_repository.dart';
import '../domain/search_result.dart';

part 'search_providers.g.dart';

@riverpod
SearchRepository searchRepository(SearchRepositoryRef ref) {
  return SearchRepository(SearchApi(ref.watch(dioProvider)));
}

/// Returns the unified search result for [query].
///
/// Returns `null` when the query is blank so the screen can distinguish
/// "user has not typed anything yet" from "the search returned no results".
@riverpod
Future<SearchResult?> searchResults(
  SearchResultsRef ref, {
  required String query,
}) async {
  if (query.trim().isEmpty) return null;
  return ref.watch(searchRepositoryProvider).search(query);
}
