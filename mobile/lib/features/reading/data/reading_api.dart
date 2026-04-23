import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'reading_models.dart';

part 'reading_api.g.dart';

/// Typed HTTP bindings for the reading router (M3 backend contract).
///
/// Endpoints:
///   * `POST /reading/sessions/start`
///   * `POST /reading/sessions/{id}/end`
///   * `POST /reading/sessions/manual`
///   * `GET  /reading/heatmap?from=&to=`
///   * `GET  /reading/grade`
///   * `POST /reading/goals`
///   * `GET  /reading/goals/current`
///
/// All endpoints require `Authorization: Bearer` which is attached globally
/// by [AuthInterceptor]. Bodies stay as `Map<String, dynamic>` for the same
/// freezed/retrofit_generator 9.7 introspection issue documented in
/// `auth_api.dart` / `book_api.dart`.
@RestApi()
abstract class ReadingApi {
  factory ReadingApi(Dio dio, {String baseUrl}) = _ReadingApi;

  @POST('/reading/sessions/start')
  Future<ReadingSessionDto> startSession(@Body() Map<String, dynamic> body);

  @POST('/reading/sessions/{id}/end')
  Future<SessionCompletionDto> endSession(
    @Path('id') String sessionId,
    @Body() Map<String, dynamic> body,
  );

  @POST('/reading/sessions/manual')
  Future<ReadingSessionDto> logManualSession(@Body() Map<String, dynamic> body);

  @GET('/reading/heatmap')
  Future<HeatmapResponseDto> getHeatmap({
    @Query('from') required String from,
    @Query('to') required String to,
  });

  @GET('/reading/grade')
  Future<GradeSummaryDto> getGrade();

  @POST('/reading/goals')
  Future<GoalDto> createGoal(@Body() Map<String, dynamic> body);

  @GET('/reading/goals/current')
  Future<List<GoalProgressDto>> getCurrentGoals();
}
