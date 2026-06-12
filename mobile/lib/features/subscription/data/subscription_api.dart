import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'subscription_api.g.dart';

/// Typed HTTP bindings for the subscription endpoints.
///
/// Endpoints:
///   * `GET  /me/subscription`         — fetch current subscription status
///   * `POST /me/subscription/verify`  — verify a platform receipt
///
/// Both methods return `dynamic` to avoid the freezed/retrofit_generator
/// introspection issue that breaks codegen when using a typed freezed class
/// directly (same pattern used across the codebase).
@RestApi()
abstract class SubscriptionApi {
  factory SubscriptionApi(Dio dio, {String baseUrl}) = _SubscriptionApi;

  @GET('/me/subscription')
  Future<dynamic> getStatus();

  @POST('/me/subscription/verify')
  Future<dynamic> verifyReceipt(@Body() Map<String, dynamic> body);
}
