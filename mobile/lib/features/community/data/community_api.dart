import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../feed/data/feed_models.dart';
import '../../social/domain/user_summary.dart';
import '../domain/leaderboard_entry.dart';
import '../domain/my_activity.dart';

part 'community_api.g.dart';

/// Typed HTTP bindings for the community domain.
///
/// Endpoints:
///   * `GET /community/feed?cursor=&limit=`              → following timeline
///   * `GET /community/explore?sort=&cursor=&limit=`     → discover feed
///   * `GET /community/users/{userId}/profile`           → full user profile
///   * `GET /community/users/{userId}/posts?cursor=&limit=` → user's posts
///
/// `GET /me/activity` → "내 활동" summary (BC-80/83) is also bound here even
/// though it carries no `/community` prefix — it was relocated out of the
/// community feature gate by BC-90 (see `CommunityApi.getMyActivity`).
@RestApi()
abstract class CommunityApi {
  factory CommunityApi(Dio dio, {String baseUrl}) = _CommunityApi;

  @GET('/community/feed')
  Future<PostPageDto> getFollowingFeed({
    @Query('cursor') String? cursor,
    @Query('limit') int limit = 20,
  });

  @GET('/community/explore')
  Future<PostPageDto> getExploreFeed({
    @Query('sort') String sort = 'latest',
    @Query('post_type') String? postType,
    @Query('cursor') String? cursor,
    @Query('limit') int limit = 20,
  });

  @GET('/community/users/{userId}/profile')
  Future<UserProfile> getUserProfile(@Path('userId') String userId);

  @GET('/community/users/{userId}/posts')
  Future<PostPageDto> getUserPosts(
    @Path('userId') String userId, {
    @Query('cursor') String? cursor,
    @Query('limit') int limit = 20,
  });

  /// Returns the weekly social leaderboard ranked by reading time in the last
  /// 7 days among the authenticated user's followees (plus the user themselves).
  @GET('/social/leaderboard/weekly')
  Future<List<LeaderboardEntry>> getWeeklyLeaderboard();

  /// "내 활동" summary (BC-80) — counts + a 5-item preview per category.
  /// Backs the BC-83 profile section; each category's full list lives behind
  /// its own domain endpoint: review's `listMyReviews`, feed's
  /// `listMyRecentHighlights`, club's `listMyAgendas`/`myClubsProvider`, and
  /// book's `listLibrary(status: 'reading')`.
  ///
  /// No `/community` prefix — BC-90 relocated this off the community feature
  /// gate (it was `GET /community/me/activity`) so the summary stays visible
  /// while `FeatureFlags.community` is false.
  @GET('/me/activity')
  Future<MyActivitySummary> getMyActivity();
}
