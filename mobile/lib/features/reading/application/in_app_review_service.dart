import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Decides when to surface the OS-native in-app review sheet (M61).
///
/// The native sheet (StoreKit on iOS, Play In-App Review on Android) is itself
/// rate-limited by the OS, and a request fired at a bad moment is silently
/// burned. So we gate on top of it: only ask after the user has felt enough
/// value (5 completed reading sessions), never more than once a day, and never
/// more than [_maxRequests] times across the install's lifetime.
///
/// [SharedPreferences] is passed in rather than fetched internally so the
/// gating logic stays unit-testable without a platform channel. The native
/// sheet itself is reached via [InAppReview.instance], whose backing platform
/// interface can be swapped with a fake in tests.
class InAppReviewService {
  const InAppReviewService();

  static const _countKey = 'session_complete_count';
  static const _lastRequestKey = 'last_review_request_date';
  static const _totalRequestKey = 'review_request_count';

  /// Completed sessions required before the first prompt (and between prompts).
  static const _triggerCount = 5;

  /// Hard ceiling on prompts per install — beyond this we never ask again.
  static const _maxRequests = 3;

  /// Records a completed reading session and requests a review when the
  /// session count crosses the [_triggerCount] threshold and the daily /
  /// lifetime caps allow it. Counting resets on each successful prompt so the
  /// next request needs another full run of [_triggerCount] sessions.
  Future<void> onSessionCompleted(SharedPreferences prefs) async {
    final int count = (prefs.getInt(_countKey) ?? 0) + 1;
    await prefs.setInt(_countKey, count);

    if (count < _triggerCount) return;
    if (!_canRequest(prefs)) return;

    final InAppReview review = InAppReview.instance;
    if (!await review.isAvailable()) return;
    await review.requestReview();

    await prefs.setInt(_countKey, 0);
    await prefs.setString(_lastRequestKey, _todayKey());
    await prefs.setInt(_totalRequestKey, (prefs.getInt(_totalRequestKey) ?? 0) + 1);
  }

  bool _canRequest(SharedPreferences prefs) {
    if ((prefs.getInt(_totalRequestKey) ?? 0) >= _maxRequests) return false;
    return prefs.getString(_lastRequestKey) != _todayKey();
  }

  /// `YYYY-MM-DD` in the device's local zone — granular to the day so the daily
  /// cap survives cold restarts without storing a full timestamp.
  String _todayKey() {
    final DateTime now = DateTime.now();
    final String month = now.month.toString().padLeft(2, '0');
    final String day = now.day.toString().padLeft(2, '0');
    return '${now.year}-$month-$day';
  }
}
