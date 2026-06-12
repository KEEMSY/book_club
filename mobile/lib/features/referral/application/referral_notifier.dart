import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/referral_stats.dart';
import 'referral_providers.dart';

part 'referral_notifier.g.dart';

/// Fetches the current user's referral stats (code, invited count, completed
/// count).
///
/// autoDispose so the data is re-fetched fresh each time the screen is opened.
@riverpod
Future<ReferralStats> referralStats(ReferralStatsRef ref) async {
  final repo = ref.read(referralRepositoryProvider);
  return repo.getMyReferral();
}

/// Handles applying a referral code entered by the user.
///
/// Exposes [AsyncValue<void>] so the screen can show loading / error states.
class ApplyReferralNotifier extends AutoDisposeNotifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> apply(String code) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(referralRepositoryProvider).applyReferral(code),
    );
  }
}

final applyReferralProvider =
    AutoDisposeNotifierProvider<ApplyReferralNotifier, AsyncValue<void>>(
  ApplyReferralNotifier.new,
);
