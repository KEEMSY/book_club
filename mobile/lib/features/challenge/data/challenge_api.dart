import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'challenge_models.dart';

part 'challenge_api.g.dart';

/// Typed HTTP bindings for the challenge and badge domain.
///
/// Endpoints:
///   * `GET /challenges?status=&limit=&cursor=`   → paginated list
///   * `GET /challenges/my`                        → joined challenges
///   * `GET /challenges/{id}`                      → single detail
///   * `POST /challenges/{id}/join`                → join
///   * `DELETE /challenges/{id}/join`              → leave
///   * `GET /challenges/{id}/leaderboard`          → top participants
///   * `GET /badges?category=`                     → badge catalogue
///   * `GET /badges/my`                            → earned badges
///   * `PATCH /me/badges/reorder`                  → update pinned badge order
@RestApi()
abstract class ChallengeApi {
  factory ChallengeApi(Dio dio, {String baseUrl}) = _ChallengeApi;

  @GET('/challenges')
  Future<ChallengePageDto> listChallenges({
    @Query('status') String? status,
    @Query('limit') int limit = 20,
    @Query('cursor') String? cursor,
  });

  @GET('/challenges/my')
  Future<MyChallengePageDto> myChallenges();

  @GET('/challenges/{id}')
  Future<ChallengeDto> getChallenge(@Path('id') String id);

  @POST('/challenges/{id}/join')
  Future<void> joinChallenge(@Path('id') String id);

  @DELETE('/challenges/{id}/join')
  Future<void> leaveChallenge(@Path('id') String id);

  @GET('/challenges/{id}/leaderboard')
  Future<LeaderboardPageDto> leaderboard(
    @Path('id') String id, {
    @Query('limit') int limit = 50,
  });

  @GET('/badges')
  Future<BadgePageDto> listBadges({@Query('category') String? category});

  @GET('/badges/my')
  Future<MyBadgePageDto> myBadges();

  @PATCH('/me/badges/reorder')
  Future<void> reorderBadges(@Body() Map<String, dynamic> body);
}
