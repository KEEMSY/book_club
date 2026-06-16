// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'retention_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$streakRecoveryStatusHash() =>
    r'4209b572d350737c2eb53e682c7d766c84c1719a';

/// Fetches the current user's streak recovery eligibility.
///
/// autoDispose so the status is re-fetched each time it becomes relevant
/// (e.g. after a recovery action or a fresh dashboard load).
///
/// Copied from [streakRecoveryStatus].
@ProviderFor(streakRecoveryStatus)
final streakRecoveryStatusProvider =
    AutoDisposeFutureProvider<StreakRecoveryStatus>.internal(
  streakRecoveryStatus,
  name: r'streakRecoveryStatusProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$streakRecoveryStatusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StreakRecoveryStatusRef
    = AutoDisposeFutureProviderRef<StreakRecoveryStatus>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
