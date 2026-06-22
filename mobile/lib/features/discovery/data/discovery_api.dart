import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'discovery_models.dart';

part 'discovery_api.g.dart';

@RestApi()
abstract class DiscoveryApi {
  factory DiscoveryApi(Dio dio) = _DiscoveryApi;

  /// M44 — ML recommendation endpoint.
  /// [strategy]: "collaborative" | "similar_readers" | "taste_match"
  @GET('/me/recommendations')
  Future<List<RecommendedBookDto>> getRecommendations({
    @Query('strategy') String? strategy,
    @Query('limit') int? limit,
  });

  /// M69 — channel-based curation recommendations.
  /// [channel]: "taste_match" | "trending" | "club_picks" | "ai_picks".
  /// Returns a `{channel, items: [...]}` envelope parsed in the repository.
  @GET('/me/book-recommendations')
  Future<dynamic> getBookRecommendations({
    @Query('channel') String? channel,
    @Query('limit') int? limit,
  });

  /// M44 — persist genre/author interest selections after first-run picker.
  @POST('/me/onboarding/interests')
  Future<void> saveOnboardingInterests(@Body() Map<String, dynamic> body);

  /// M44 — fetch previously saved onboarding interests for the current user.
  @GET('/me/onboarding/interests')
  Future<List<OnboardingInterestDto>> getOnboardingInterests();
}
