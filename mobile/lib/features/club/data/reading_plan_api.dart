import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'reading_plan_api.g.dart';

/// retrofit client for the M52 club reading-plan endpoints.
@RestApi()
abstract class ReadingPlanApi {
  factory ReadingPlanApi(Dio dio) = _ReadingPlanApi;

  @POST('/clubs/{id}/reading-plan')
  Future<dynamic> createPlan(
    @Path('id') String clubId,
    @Body() Map<String, dynamic> body,
  );

  @GET('/clubs/{id}/reading-plan')
  Future<dynamic> getPlan(@Path('id') String clubId);

  @PATCH('/clubs/{id}/members/me/progress')
  Future<dynamic> updateProgress(
    @Path('id') String clubId,
    @Body() Map<String, dynamic> body,
  );

  @GET('/clubs/{id}/progress')
  Future<dynamic> getProgress(@Path('id') String clubId);
}
