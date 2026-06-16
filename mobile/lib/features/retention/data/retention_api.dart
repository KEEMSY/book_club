import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'retention_api.g.dart';

/// Typed HTTP bindings for the retention endpoints (M46).
///
/// Endpoints:
///   * `GET  /me/streak/recovery-status` — current recovery eligibility
///   * `POST /me/streak/recover`         — consume one recovery token
///
/// Both endpoints require `Authorization: Bearer` attached globally by
/// [AuthInterceptor].
///
/// `recoverStreak` returns `dynamic` to sidestep the freezed/retrofit_generator
/// introspection limitation that affects typed response bodies (same pattern as
/// `referral_api.dart`).
@RestApi()
abstract class RetentionApi {
  factory RetentionApi(Dio dio, {String baseUrl}) = _RetentionApi;

  @GET('/me/streak/recovery-status')
  Future<dynamic> getRecoveryStatus();

  @POST('/me/streak/recover')
  Future<dynamic> recoverStreak();
}
