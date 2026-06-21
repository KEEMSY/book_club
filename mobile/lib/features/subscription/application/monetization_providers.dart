import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/promo.dart';
import '../domain/trial_status.dart';
import 'subscription_providers.dart';

part 'monetization_providers.g.dart';

/// Current user's Pro trial window (`GET /me/trial-status`).
///
/// autoDispose: the trial banner and paywall only need it while visible, and
/// re-reading is cheap. Invalidate after a successful subscribe to refresh.
@riverpod
Future<TrialStatus> trialStatus(TrialStatusRef ref) {
  return ref.watch(subscriptionRepositoryProvider).getTrialStatus();
}

/// Active early-bird promo, or `null` when none is live
/// (`GET /subscriptions/promo`).
@riverpod
Future<Promo?> activePromo(ActivePromoRef ref) {
  return ref.watch(subscriptionRepositoryProvider).getActivePromo();
}
