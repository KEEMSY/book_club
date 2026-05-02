import '../domain/recommended_book.dart';
import 'discovery_api.dart';

class DiscoveryRepository {
  DiscoveryRepository(this._api);

  final DiscoveryApi _api;

  Future<List<RecommendedBook>> getRecommendations() async {
    final data = await _api.getRecommendations();
    final items = data['items'] as List<dynamic>;
    return items
        .map((e) => RecommendedBook.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
