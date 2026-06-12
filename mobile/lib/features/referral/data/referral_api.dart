import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'referral_api.g.dart';

/// Typed HTTP bindings for the referral endpoints.
///
/// Endpoints:
///   * `GET  /me/referral`         — fetch current user's code and stats
///   * `POST /me/referral/apply`   — apply a friend's referral code
///
/// `getMyReferral` returns `dynamic` to avoid the freezed/retrofit_generator
/// introspection issue that breaks codegen when using a typed freezed class
/// directly (same pattern used in feed_api.dart).
@RestApi()
abstract class ReferralApi {
  factory ReferralApi(Dio dio, {String baseUrl}) = _ReferralApi;

  @GET('/me/referral')
  Future<dynamic> getMyReferral();

  @POST('/me/referral/apply')
  Future<void> applyReferral(@Body() Map<String, dynamic> body);
}
