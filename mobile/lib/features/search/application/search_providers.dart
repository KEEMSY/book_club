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

/// M69 — book title/author autocomplete suggestions for [query].
///
/// Returns an empty list for queries shorter than 2 characters so the UI can
/// suppress the dropdown until the input is meaningful.
@riverpod
Future<List<String>> autocompleteSuggestions(
  AutocompleteSuggestionsRef ref, {
  required String query,
}) async {
  final trimmed = query.trim();
  if (trimmed.length < 2) return const [];
  return ref.watch(searchRepositoryProvider).autocomplete(trimmed, limit: 5);
}
