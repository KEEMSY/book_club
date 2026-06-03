// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$badgePinNotifierHash() => r'6359b28b24b68b525d169a2cfeb015a9fe3dc85b';

/// Manages the ordered list of pinned badge IDs and syncs reorder ops to the
/// server via PATCH /me/badges/reorder.
///
/// Initial state is derived from [myBadgesProvider] — the first [kMaxPinnedBadges]
/// earned badges are treated as the default pin order until the server returns a
/// persisted order.
///
/// Copied from [BadgePinNotifier].
@ProviderFor(BadgePinNotifier)
final badgePinNotifierProvider = AutoDisposeNotifierProvider<BadgePinNotifier,
    AsyncValue<List<String>>>.internal(
  BadgePinNotifier.new,
  name: r'badgePinNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$badgePinNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BadgePinNotifier = AutoDisposeNotifier<AsyncValue<List<String>>>;
String _$joinNotifierHash() => r'd157d16f0ae94b8a4fc0f1bc86a514b107f89799';

/// See also [JoinNotifier].
@ProviderFor(JoinNotifier)
final joinNotifierProvider =
    AutoDisposeNotifierProvider<JoinNotifier, AsyncValue<void>>.internal(
  JoinNotifier.new,
  name: r'joinNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$joinNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$JoinNotifier = AutoDisposeNotifier<AsyncValue<void>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
