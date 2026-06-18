import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences key that records whether the user has completed the
/// first-run onboarding flow.
const String kOnboardingCompleteKey = 'onboarding_complete';

/// Whether the first-run onboarding flow has already been completed.
///
/// Resolved once from [SharedPreferences]. The router pre-warms this on launch
/// (see `main.dart`) so the redirect can read the value synchronously via
/// `valueOrNull` and avoid a spurious `/login` flash. [markOnboardingDone]
/// invalidates the provider so the redirect re-evaluates after the flow ends.
///
/// A plain (kept-alive) [FutureProvider] is intentional: the router reads it
/// with `ref.read(...).valueOrNull` without holding a listener, so an
/// auto-disposed provider would be torn down between the pre-warm and the read
/// and recompute to `loading` (null), spuriously re-showing onboarding.
final onboardingCompletedProvider = FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(kOnboardingCompleteKey) ?? false;
});

/// Persists the onboarding-complete flag and invalidates [onboardingCompletedProvider]
/// so the router redirect picks up the change immediately.
Future<void> markOnboardingDone(WidgetRef ref) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(kOnboardingCompleteKey, true);
  ref.invalidate(onboardingCompletedProvider);
}
