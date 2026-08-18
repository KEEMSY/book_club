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
///   * `GET   /notifications?cursor=&limit=`
///   * `POST  /notifications/{id}/read`
///   * `GET   /notifications/unread-count`
///   * `GET   /reports/weekly?week=`
///   * `GET   /me/notification-preferences`
///   * `PATCH /me/notification-preferences`
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

  /// Marks every unread notification as read in a single request.
  @PATCH('/me/notifications/read-all')
  Future<void> markAllRead();

  @GET('/notifications/unread-count')
  Future<UnreadCountResponse> getUnreadCount();

  /// [weekDate] is a Monday ISO date string, e.g. `"2026-04-21"`.
  /// Backend returns 404 when no report has been generated for that week.
  @GET('/reports/weekly')
  Future<WeeklyReportResponse> getWeeklyReport(
    @Query('week') String weekDate,
  );

  /// BC-92: per-type notification opt-in/out toggles.
  @GET('/me/notification-preferences')
  Future<NotificationPreferencesResponse> getNotificationPreferences();

  /// Partial update — [body] is `{"preferences": {type: bool, ...}}`; only
  /// the included keys change server-side.
  @PATCH('/me/notification-preferences')
  Future<NotificationPreferencesResponse> updateNotificationPreferences(
    @Body() Map<String, dynamic> body,
  );
}
