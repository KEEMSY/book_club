import 'package:book_club/core/config/feature_flags.dart';
import 'package:book_club/features/subscription/application/subscription_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // BC-41: subscription is deferred (feature flag off), so its endpoint is
  // unmounted (404). The notifier's build() must short-circuit to a free
  // status WITHOUT reading the repository/dio — if the gate were removed it
  // would hit the real network here and the test would error.
  test('subscription off: notifier returns free status without a network call',
      () async {
    expect(FeatureFlags.subscription, isFalse);

    final container = ProviderContainer();
    addTearDown(container.dispose);

    final status = await container.read(subscriptionNotifierProvider.future);

    expect(status.isPro, isFalse);
    expect(status.proExpiresAt, isNull);
  });
}
