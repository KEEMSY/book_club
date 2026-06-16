import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'shield_api.g.dart';

/// Typed HTTP bindings for the shield endpoints.
///
/// Endpoints:
///   * `GET  /me/shields`          — current shield balance
///   * `POST /me/shields/purchase` — purchase shields with a receipt
///
/// Both endpoints require `Authorization: Bearer` attached globally by
/// [AuthInterceptor]. Purchase body stays as `Map<String, dynamic>` to avoid
/// the freezed/retrofit_generator introspection issue documented across the
/// codebase.
@RestApi()
abstract class ShieldApi {
  factory ShieldApi(Dio dio, {String baseUrl}) = _ShieldApi;

  @GET('/me/shields')
  Future<dynamic> getBalance();

  @POST('/me/shields/purchase')
  Future<dynamic> purchase(@Body() Map<String, dynamic> body);
}
