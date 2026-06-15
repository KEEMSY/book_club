import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'experiment_api.g.dart';

/// Typed HTTP bindings for the A/B experiment endpoints.
///
/// All response methods return [dynamic] to avoid the freezed/retrofit_generator
/// introspection issue that breaks codegen when a typed freezed class is used
/// directly as the return type (same pattern as referral_api.dart).
///
/// Endpoints:
///   * `GET  /me/experiments`             — fetch current user's assignments
///   * `POST /me/experiments/conversion`  — record a conversion event
@RestApi()
abstract class ExperimentApi {
  factory ExperimentApi(Dio dio, {String baseUrl}) = _ExperimentApi;

  @GET('/me/experiments')
  Future<dynamic> getMyExperiments();

  @POST('/me/experiments/conversion')
  Future<void> recordConversion(@Body() Map<String, String> body);
}
