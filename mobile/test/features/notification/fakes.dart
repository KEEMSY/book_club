import 'package:book_club/features/notification/data/notification_models.dart';
import 'package:book_club/features/notification/data/notification_repository.dart';

/// Fake [NotificationRepository] for notification-feature tests.
///
/// Only the BC-92 preference methods are exercised today; the inbox methods
/// throw [UnimplementedError] so a test that accidentally hits them fails
/// loudly instead of silently returning a placeholder value.
class FakeNotificationRepository implements NotificationRepository {
  NotificationPreferencesResponse? preferencesResult;
  Object? preferencesError;
  int getPreferencesCalls = 0;

  NotificationPreferencesResponse? updateResult;
  Object? updateError;
  final List<Map<String, bool>> updateCalls = <Map<String, bool>>[];

  @override
  Future<NotificationPreferencesResponse> getNotificationPreferences() async {
    getPreferencesCalls++;
    if (preferencesError != null) throw preferencesError!;
    return preferencesResult!;
  }

  @override
  Future<NotificationPreferencesResponse> updateNotificationPreferences(
    Map<String, bool> preferences,
  ) async {
    updateCalls.add(preferences);
    if (updateError != null) throw updateError!;
    return updateResult ?? preferencesResult!;
  }

  @override
  Future<NotificationListResponse> getNotifications({
    String? cursor,
    int limit = 20,
  }) {
    throw UnimplementedError('not used by BC-92 tests');
  }

  @override
  Future<void> markRead(String id) {
    throw UnimplementedError('not used by BC-92 tests');
  }

  @override
  Future<void> markAllRead() {
    throw UnimplementedError('not used by BC-92 tests');
  }

  @override
  Future<int> getUnreadCount() {
    throw UnimplementedError('not used by BC-92 tests');
  }

  @override
  Future<WeeklyReportResponse?> getWeeklyReport(String weekDate) {
    throw UnimplementedError('not used by BC-92 tests');
  }
}
