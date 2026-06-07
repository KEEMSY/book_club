// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$weeklyLeaderboardHash() => r'bd12b6d06b399ebc2acd9767efcec7c0ad13ce4c';

/// Fetches the weekly social leaderboard (last 7 days of reading time among
/// followees + self). Auto-disposes when the screen is unmounted.
///
/// Copied from [weeklyLeaderboard].
@ProviderFor(weeklyLeaderboard)
final weeklyLeaderboardProvider =
    AutoDisposeFutureProvider<List<LeaderboardEntry>>.internal(
  weeklyLeaderboard,
  name: r'weeklyLeaderboardProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$weeklyLeaderboardHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WeeklyLeaderboardRef
    = AutoDisposeFutureProviderRef<List<LeaderboardEntry>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
