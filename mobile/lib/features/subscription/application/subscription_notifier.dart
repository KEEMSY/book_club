import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/subscription_status.dart';
import 'subscription_providers.dart';

part 'subscription_notifier.g.dart';

/// Manages the current user's Pro subscription state.
///
/// Kept alive for the duration of the app session so every widget watching
/// isPro reflects the same value without re-fetching.
@Riverpod(keepAlive: true)
class SubscriptionNotifier extends _$SubscriptionNotifier {
  @override
  Future<SubscriptionStatus> build() async {
    return ref.read(subscriptionRepositoryProvider).getStatus();
  }

  /// Verifies a platform purchase receipt against the backend.
  ///
  /// In development the receipt is sent as `"test_receipt"` so the server
  /// can activate Pro without a real App Store / Play Store receipt.
  ///
  /// Returns `true` when the backend confirms `is_pro: true` after
  /// verification, `false` otherwise.
  Future<bool> verify({
    required String platform,
    required String productId,
  }) async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(
      () => ref.read(subscriptionRepositoryProvider).verifyReceipt(
            platform: platform,
            receiptData: 'test_receipt',
            productId: productId,
          ),
    );
    state = result;
    return result.maybeWhen(
      data: (s) => s.isPro,
      orElse: () => false,
    );
  }
}
