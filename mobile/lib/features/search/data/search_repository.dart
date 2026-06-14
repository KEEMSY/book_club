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
}
