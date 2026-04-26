import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../social/domain/user_summary.dart';

part 'community_api.g.dart';

/// Typed HTTP bindings for the M7 community read endpoints.
///
/// Full feed endpoints (explore, following feed) are wired in M8.
/// Only the profile lookup is needed for M7 user profile screens.
///
/// Endpoints:
///   * `GET /community/users/{userId}/profile` → [UserProfile]
@RestApi()
abstract class CommunityApi {
  factory CommunityApi(Dio dio, {String baseUrl}) = _CommunityApi;

  @GET('/community/users/{userId}/profile')
  Future<UserProfile> getUserProfile(@Path('userId') String userId);
}
