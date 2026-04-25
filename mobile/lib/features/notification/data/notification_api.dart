import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'notification_models.dart';

part 'notification_api.g.dart';

/// Typed HTTP bindings for M5 notification + weekly-report endpoints.
///
/// All paths are intercepted by [AuthInterceptor] which attaches the bearer
/// token — no additional header config needed here.
///
/// Endpoints:
///   * `GET  /notifications?cursor=&limit=`
///   * `POST /notifications/{id}/read`
///   * `GET  /notifications/unread-count`
///   * `GET  /reports/weekly?week=`
@RestApi()
abstract class NotificationApi {
  factory NotificationApi(Dio dio, {String baseUrl}) = _NotificationApi;

  @GET('/notifications')
  Future<NotificationListResponse> getNotifications({
    @Query('cursor') String? cursor,
    @Query('limit') int? limit,
  });

  @POST('/notifications/{id}/read')
  Future<void> markRead(@Path('id') String id);

  @GET('/notifications/unread-count')
  Future<UnreadCountResponse> getUnreadCount();

  /// [weekDate] is a Monday ISO date string, e.g. `"2026-04-21"`.
  /// Backend returns 404 when no report has been generated for that week.
  @GET('/reports/weekly')
  Future<WeeklyReportResponse> getWeeklyReport(
    @Query('week') String weekDate,
  );
}
