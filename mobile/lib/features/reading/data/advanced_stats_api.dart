import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'advanced_stats_models.dart';

part 'advanced_stats_api.g.dart';

/// Typed HTTP binding for the Pro-only advanced stats endpoint (M53).
///
/// `Authorization: Bearer` is attached globally by [AuthInterceptor]. The
/// backend returns 403 for non-Pro users; the repository maps that to a typed
/// domain failure.
@RestApi()
abstract class AdvancedStatsApi {
  factory AdvancedStatsApi(Dio dio, {String baseUrl}) = _AdvancedStatsApi;

  @GET('/me/stats/advanced')
  Future<AdvancedStatsDto> getAdvancedStats();
}
