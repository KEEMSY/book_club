import 'package:book_club/features/reading/application/in_app_review_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_review_platform_interface/in_app_review_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Counts how often the native review sheet is requested so the gating logic
/// can be asserted without a real platform channel.
class _FakeInAppReviewPlatform extends InAppReviewPlatform {
  _FakeInAppReviewPlatform({this.available = true});

  final bool available;
  int requestCount = 0;

  @override
  Future<bool> isAvailable() async => available;

  @override
  Future<void> requestReview() async => requestCount++;
}

void main() {
  late _FakeInAppReviewPlatform platform;
  const service = InAppReviewService();

  setUp(() {
    platform = _FakeInAppReviewPlatform();
    InAppReviewPlatform.instance = platform;
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  Future<void> completeSessions(int n) async {
    final prefs = await SharedPreferences.getInstance();
    for (var i = 0; i < n; i++) {
      await service.onSessionCompleted(prefs);
    }
  }

  test('does not request before the 5-session threshold', () async {
    await completeSessions(4);
    expect(platform.requestCount, 0);
  });

  test('requests on the 5th completed session', () async {
    await completeSessions(5);
    expect(platform.requestCount, 1);
  });

  test('resets the counter after a successful request', () async {
    final prefs = await SharedPreferences.getInstance();
    await completeSessions(5);
    expect(prefs.getInt('session_complete_count'), 0);
  });

  test('caps at one request per day', () async {
    await completeSessions(10); // two thresholds within the same day
    expect(platform.requestCount, 1);
  });

  test('never requests more than 3 times across the install', () async {
    // Simulate three prior requests on different past days, then a fresh run.
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('review_request_count', 3);
    await completeSessions(5);
    expect(platform.requestCount, 0);
  });

  test('skips the request when the OS reports it unavailable', () async {
    InAppReviewPlatform.instance =
        _FakeInAppReviewPlatform(available: false);
    final prefs = await SharedPreferences.getInstance();
    // Counter still advances so we do not retry availability every session.
    await completeSessions(5);
    expect(prefs.getInt('session_complete_count'), 5);
  });
}
