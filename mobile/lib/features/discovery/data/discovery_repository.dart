import '../domain/recommended_book.dart';
import 'discovery_api.dart';
import 'discovery_models.dart';

class DiscoveryRepository {
  DiscoveryRepository(this._api);

  final DiscoveryApi _api;

  Future<List<RecommendedBook>> getRecommendations({
    String? strategy,
    int? limit,
  }) async {
    final dtos = await _api.getRecommendations(
      strategy: strategy,
      limit: limit,
    );
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  /// M69 — fetch one curation channel's books.
  ///
  /// The backend returns a `{channel, items}` envelope; each item carries only
  /// id/title/author/cover_url/reason, so we map onto [RecommendedBook] with a
  /// neutral score and the channel name as the strategy tag.
  Future<List<RecommendedBook>> getBookRecommendations({
    required String channel,
    int limit = 10,
  }) async {
    final data = await _api.getBookRecommendations(
      channel: channel,
      limit: limit,
    );
    final map = data as Map<String, dynamic>;
    final items = (map['items'] as List<dynamic>?) ?? const [];
    return items
        .map((e) => e as Map<String, dynamic>)
        .map(
          (j) => RecommendedBook(
            id: j['id'] as String,
            title: j['title'] as String,
            author: j['author'] as String,
            coverUrl: j['cover_url'] as String?,
            score: 0,
            reason: (j['reason'] as String?) ?? '',
            strategy: channel,
          ),
        )
        .toList();
  }

  Future<void> saveOnboardingInterests(
    List<OnboardingInterestDto> interests,
  ) async {
    await _api.saveOnboardingInterests({
      'interests': interests.map((i) => i.toJson()).toList(),
    });
  }

  Future<List<OnboardingInterestDto>> getOnboardingInterests() {
    return _api.getOnboardingInterests();
  }
}
