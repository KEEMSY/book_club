import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_models.freezed.dart';
part 'notification_models.g.dart';

/// Wire representation of a single notification from `GET /notifications`.
///
/// [data] is an open JSON bag — downstream widgets inspect known keys
/// (e.g. `post_id`) without the model layer hard-coding every variant.
///
/// Field names are snake_case-mapped automatically via `build.yaml`
/// `field_rename: snake`, so no `@JsonKey` annotations are needed.
@freezed
class NotificationDto with _$NotificationDto {
  const factory NotificationDto({
    required String id,
    required String ntype,
    required String title,
    required String body,
    @Default({}) Map<String, String> data,
    DateTime? readAt,
    required DateTime createdAt,
  }) = _NotificationDto;

  factory NotificationDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationDtoFromJson(json);
}

/// Cursor-paged envelope for `GET /notifications`.
@freezed
class NotificationListResponse with _$NotificationListResponse {
  const factory NotificationListResponse({
    required List<NotificationDto> items,
    String? nextCursor,
    required int unreadCount,
  }) = _NotificationListResponse;

  factory NotificationListResponse.fromJson(Map<String, dynamic> json) =>
      _$NotificationListResponseFromJson(json);
}

/// Response for `GET /notifications/unread-count`.
@freezed
class UnreadCountResponse with _$UnreadCountResponse {
  const factory UnreadCountResponse({
    required int unreadCount,
  }) = _UnreadCountResponse;

  factory UnreadCountResponse.fromJson(Map<String, dynamic> json) =>
      _$UnreadCountResponseFromJson(json);
}

/// Response for `GET /reports/weekly`. 404 when no report exists for the week.
@freezed
class WeeklyReportResponse with _$WeeklyReportResponse {
  const factory WeeklyReportResponse({
    required String id,
    required String weekStart,
    required int totalSeconds,
    required int sessionCount,
    String? bestDay,
    required int longestSessionSec,
    required DateTime createdAt,
  }) = _WeeklyReportResponse;

  factory WeeklyReportResponse.fromJson(Map<String, dynamic> json) =>
      _$WeeklyReportResponseFromJson(json);
}
