import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../domain/user_summary.dart';

part 'social_api.g.dart';

/// Typed HTTP bindings for the M7 social endpoints.
///
/// All paths are covered by [AuthInterceptor] — no explicit header config
/// needed. Bodies that the backend expects are passed as plain maps to avoid
/// the freezed/retrofit_generator introspection issue documented in feed_api.dart.
///
/// Endpoints:
///   * `POST   /social/follow/{targetUserId}`
///   * `DELETE /social/follow/{targetUserId}`
///   * `GET    /social/followers`
///   * `GET    /social/following`
///   * `GET    /social/users/{userId}/followers`
///   * `GET    /social/users/{userId}/following`
///   * `POST   /social/block/{targetUserId}`
///   * `DELETE /social/block/{targetUserId}`
///   * `GET    /social/blocks`
///   * `POST   /social/reports/users/{userId}`
@RestApi()
abstract class SocialApi {
  factory SocialApi(Dio dio, {String baseUrl}) = _SocialApi;

  @POST('/social/follow/{targetUserId}')
  Future<void> follow(@Path('targetUserId') String targetUserId);

  @DELETE('/social/follow/{targetUserId}')
  Future<void> unfollow(@Path('targetUserId') String targetUserId);

  @GET('/social/followers')
  Future<UserSummaryPage> getMyFollowers();

  @GET('/social/following')
  Future<UserSummaryPage> getMyFollowing();

  @GET('/social/users/{userId}/followers')
  Future<UserSummaryPage> getUserFollowers(@Path('userId') String userId);

  @GET('/social/users/{userId}/following')
  Future<UserSummaryPage> getUserFollowing(@Path('userId') String userId);

  @POST('/social/block/{targetUserId}')
  Future<void> block(@Path('targetUserId') String targetUserId);

  @DELETE('/social/block/{targetUserId}')
  Future<void> unblock(@Path('targetUserId') String targetUserId);

  /// Users the current account has blocked (BC-82 settings-hub entry).
  @GET('/social/blocks')
  Future<UserSummaryPage> getMyBlocks();

  @POST('/social/reports/users/{userId}')
  Future<void> reportUser(
    @Path('userId') String userId,
    @Body() Map<String, String> body,
  );

  @GET('/social/users/explore')
  Future<UserSummaryPage> exploreUsers({
    @Query('q') String q = '',
    @Query('cursor') String? cursor,
    @Query('limit') int limit = 20,
  });
}
