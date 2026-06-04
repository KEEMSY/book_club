import 'package:freezed_annotation/freezed_annotation.dart';

import '../data/notification_models.dart';

part 'notification_state.freezed.dart';

/// UI state for the notification list screen.
///
/// [hasMore] is `true` when [nextCursor] is non-null — kept as a derived
/// convenience so widgets don't inline the null-check everywhere.
/// [wsConnected] reflects live WebSocket connectivity so the screen can
/// surface a subtle indicator when real-time delivery is unavailable.
@freezed
abstract class NotificationState with _$NotificationState {
  const factory NotificationState({
    @Default([]) List<NotificationDto> items,
    String? nextCursor,
    @Default(0) int unreadCount,
    @Default(false) bool isLoading,
    @Default(false) bool hasMore,
    @Default(false) bool wsConnected,
    String? error,
  }) = _NotificationState;
}
