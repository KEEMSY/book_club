import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/dio_provider.dart';
import '../data/challenge_api.dart';
import '../data/challenge_models.dart';
import '../data/challenge_repository.dart';

part 'challenge_providers.g.dart';

final challengeApiProvider = Provider<ChallengeApi>((ref) {
  return ChallengeApi(ref.watch(dioProvider));
});

final challengeRepositoryProvider = Provider<ChallengeRepository>((ref) {
  return ChallengeRepository(ref.watch(challengeApiProvider));
});

// ---------------------------------------------------------------------------
// Challenge list providers (status-based)
// ---------------------------------------------------------------------------

final activeChallengesProvider =
    FutureProvider.autoDispose<List<ChallengeDto>>((ref) async {
  final page = await ref
      .watch(challengeRepositoryProvider)
      .listChallenges(status: 'active');
  return page.items;
});

final upcomingChallengesProvider =
    FutureProvider.autoDispose<List<ChallengeDto>>((ref) async {
  final page = await ref
      .watch(challengeRepositoryProvider)
      .listChallenges(status: 'upcoming');
  return page.items;
});

final endedChallengesProvider =
    FutureProvider.autoDispose<List<ChallengeDto>>((ref) async {
  final page = await ref
      .watch(challengeRepositoryProvider)
      .listChallenges(status: 'ended');
  return page.items;
});

final myChallengesProvider =
    FutureProvider.autoDispose<List<MyChallengeDto>>((ref) async {
  final page = await ref.watch(challengeRepositoryProvider).myChallenges();
  return page.items;
});

// ---------------------------------------------------------------------------
// Detail and leaderboard
// ---------------------------------------------------------------------------

final challengeDetailProvider =
    FutureProvider.autoDispose.family<ChallengeDto, String>((ref, id) {
  return ref.watch(challengeRepositoryProvider).getChallenge(id);
});

final leaderboardProvider =
    FutureProvider.autoDispose.family<List<LeaderboardEntryDto>, String>(
  (ref, challengeId) async {
    final page =
        await ref.watch(challengeRepositoryProvider).leaderboard(challengeId);
    return page.items;
  },
);

// ---------------------------------------------------------------------------
// Badge providers
// ---------------------------------------------------------------------------

final badgesProvider = FutureProvider.autoDispose<List<BadgeDto>>((ref) async {
  final page = await ref.watch(challengeRepositoryProvider).listBadges();
  return page.items;
});

final myBadgesProvider =
    FutureProvider.autoDispose<List<BadgeEarnedDto>>((ref) async {
  final page = await ref.watch(challengeRepositoryProvider).myBadges();
  return page.items;
});

// ---------------------------------------------------------------------------
// Pinned badge order notifier
// ---------------------------------------------------------------------------

/// Maximum number of badges a user can pin to their profile display.
const int kMaxPinnedBadges = 6;

/// Manages the ordered list of pinned badge IDs and syncs reorder ops to the
/// server via PATCH /me/badges/reorder.
///
/// Initial state is derived from [myBadgesProvider] — the first [kMaxPinnedBadges]
/// earned badges are treated as the default pin order until the server returns a
/// persisted order.
@riverpod
class BadgePinNotifier extends _$BadgePinNotifier {
  @override
  AsyncValue<List<String>> build() {
    final myAsync = ref.watch(myBadgesProvider);
    return myAsync.whenData(
      (badges) => badges
          .take(kMaxPinnedBadges)
          .map((e) => e.badge.id)
          .toList(),
    );
  }

  /// Reorders the pinned badge list and persists the new order to the server.
  Future<void> reorder(List<String> orderedIds) async {
    assert(orderedIds.length <= kMaxPinnedBadges, 'Too many pinned badges');
    // Optimistic update so the UI reflects the change immediately.
    state = AsyncValue.data(orderedIds);
    try {
      await ref
          .read(challengeRepositoryProvider)
          .reorderBadges(orderedIds);
    } catch (e, st) {
      // Roll back to last known good state on failure.
      state = AsyncValue.error(e, st);
    }
  }
}

// ---------------------------------------------------------------------------
// Join / leave action notifier
// ---------------------------------------------------------------------------

@riverpod
class JoinNotifier extends _$JoinNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> join(String challengeId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(challengeRepositoryProvider).joinChallenge(challengeId),
    );
  }

  Future<void> leave(String challengeId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(challengeRepositoryProvider).leaveChallenge(challengeId),
    );
  }
}
