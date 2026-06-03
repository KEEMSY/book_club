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
