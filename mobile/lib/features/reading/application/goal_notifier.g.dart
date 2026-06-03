// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$goalNotifierHash() => r'd785710dfca8a857ba99ab17fdd67a8088497a32';

/// Tracks the active goals (weekly · monthly · yearly). Backend returns one
/// active goal per period via `GET /reading/goals/current`; we refresh after
/// every `createGoal()` so the UI reflects the newly-created entry.
///
/// Copied from [GoalNotifier].
@ProviderFor(GoalNotifier)
final goalNotifierProvider =
    AutoDisposeNotifierProvider<GoalNotifier, GoalState>.internal(
  GoalNotifier.new,
  name: r'goalNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$goalNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GoalNotifier = AutoDisposeNotifier<GoalState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
