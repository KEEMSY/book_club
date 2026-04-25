import 'package:freezed_annotation/freezed_annotation.dart';

import '../data/notification_models.dart';

part 'notification_state.freezed.dart';

/// UI state for the notification list screen.
///
/// [hasMore] is `true` when [nextCursor] is non-null — kept as a derived
/// convenience so widgets don't inline the null-check everywhere.
@freezed
class NotificationState with _$NotificationState {
  const factory NotificationState({
    @Default([]) List<NotificationDto> items,
    String? nextCursor,
    @Default(0) int unreadCount,
    @Default(false) bool isLoading,
    @Default(false) bool hasMore,
    String? error,
  }) = _NotificationState;
}
