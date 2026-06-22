import '../domain/search_result.dart';
import 'search_api.dart';

/// Translates the raw search API response into typed domain models.
class SearchRepository {
  SearchRepository(this._api);

  final SearchApi _api;

  Future<SearchResult> search(String query, {String type = 'all'}) async {
    final data = await _api.search(query, type: type);
    return SearchResult.fromJson(data as Map<String, dynamic>);
  }

  /// M69 — returns up to [limit] title/author autocomplete suggestions.
  Future<List<String>> autocomplete(String query, {int limit = 10}) async {
    final data = await _api.autocomplete(query, limit: limit);
    final map = data as Map<String, dynamic>;
    final suggestions = (map['suggestions'] as List<dynamic>?) ?? const [];
    return suggestions.map((e) => e as String).toList();
  }
}
