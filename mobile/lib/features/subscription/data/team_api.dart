import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'team_api.g.dart';

/// Typed HTTP bindings for the B2B team-plan endpoints (M70).
///
/// Methods return `Future<dynamic>` to avoid the freezed/retrofit_generator
/// introspection issue that breaks codegen when a typed freezed class is used
/// as the return type directly — the repository converts the raw JSON into
/// domain objects (same pattern as event_api / subscription_api).
@RestApi()
abstract class TeamApi {
  factory TeamApi(Dio dio) = _TeamApi;

  @POST('/teams')
  Future<dynamic> createTeam(@Body() Map<String, dynamic> body);

  @GET('/teams/{teamId}')
  Future<dynamic> getTeam(@Path('teamId') String teamId);

  @POST('/teams/{teamId}/members')
  Future<dynamic> addMember(
    @Path('teamId') String teamId,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('/teams/{teamId}/members/{userId}')
  Future<dynamic> removeMember(
    @Path('teamId') String teamId,
    @Path('userId') String userId,
  );
}
