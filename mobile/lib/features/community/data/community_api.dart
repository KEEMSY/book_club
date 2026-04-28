import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../feed/data/feed_models.dart';
import '../../social/domain/user_summary.dart';

part 'community_api.g.dart';

/// Typed HTTP bindings for the community domain.
///
/// Endpoints:
///   * `GET /community/feed?cursor=&limit=`              → following timeline
///   * `GET /community/explore?sort=&cursor=&limit=`     → discover feed
///   * `GET /community/users/{userId}/profile`           → full user profile
///   * `GET /community/users/{userId}/posts?cursor=&limit=` → user's posts
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
}
