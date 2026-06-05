// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_stats_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$readingStatsHash() => r'0b4b2138b1750ebc9288ee6b39a01e660fbfb5cb';

/// Fetches the full reading analytics summary from `GET /me/reading-stats`.
///
/// autoDispose — the stats screen is an occasional visit; releasing the cache
/// on exit keeps idle memory low.
///
/// Copied from [readingStats].
@ProviderFor(readingStats)
final readingStatsProvider = AutoDisposeFutureProvider<ReadingStats>.internal(
  readingStats,
  name: r'readingStatsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$readingStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ReadingStatsRef = AutoDisposeFutureProviderRef<ReadingStats>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
