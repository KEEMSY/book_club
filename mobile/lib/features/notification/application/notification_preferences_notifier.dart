import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/notification_models.dart';
import '../data/notification_repository.dart';

part 'notification_preferences_notifier.g.dart';

/// Manages the notification-preferences toggle screen (BC-92).
///
/// autoDispose so the screen re-fetches fresh state every time it's opened,
/// matching [ReminderList]'s pattern — preferences change rarely and a
/// stale keepAlive cache isn't worth the added complexity.
@riverpod
class NotificationPreferencesNotifier
    extends _$NotificationPreferencesNotifier {
  @override
  Future<NotificationPreferencesResponse> build() {
    return ref
        .read(notificationRepositoryProvider)
        .getNotificationPreferences();
  }

  /// Toggles a single toggleable notification [type].
  ///
  /// Applies the change optimistically so the switch responds instantly,
  /// then confirms with a partial PATCH. On failure the previous state is
  /// restored and the exception is rethrown so the screen can roll the
  /// switch back visually and surface a snackbar.
  Future<void> toggle(String type, {required bool value}) async {
    final previous = state;
    final current = previous.valueOrNull;
    if (current == null) return;

    state = AsyncData(
      current.copyWith(
        preferences: <String, bool>{...current.preferences, type: value},
      ),
    );

    try {
      final updated = await ref
          .read(notificationRepositoryProvider)
          .updateNotificationPreferences(<String, bool>{type: value});
      state = AsyncData(updated);
    } on NotificationRepositoryException {
      state = previous;
      rethrow;
    }
  }
}
