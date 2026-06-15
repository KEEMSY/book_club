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
