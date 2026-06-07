import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/leaderboard_entry.dart';
import 'community_providers.dart';

part 'leaderboard_notifier.g.dart';

/// Fetches the weekly social leaderboard (last 7 days of reading time among
/// followees + self). Auto-disposes when the screen is unmounted.
@riverpod
Future<List<LeaderboardEntry>> weeklyLeaderboard(
  WeeklyLeaderboardRef ref,
) {
  return ref.watch(communityRepositoryProvider).getWeeklyLeaderboard();
}
