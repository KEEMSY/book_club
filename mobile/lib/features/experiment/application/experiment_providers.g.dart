// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'experiment_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$experimentRepositoryHash() =>
    r'd90b728fa6b980099f4c28cb7655e234d2cd03b3';

/// See also [experimentRepository].
@ProviderFor(experimentRepository)
final experimentRepositoryProvider =
    AutoDisposeProvider<ExperimentRepository>.internal(
  experimentRepository,
  name: r'experimentRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$experimentRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ExperimentRepositoryRef = AutoDisposeProviderRef<ExperimentRepository>;
String _$userExperimentsHash() => r'9c6e6f742abf6e200e728009c9a305ed3640a1c4';

/// Fetches the current user's A/B experiment assignments.
///
/// autoDispose so fresh assignments are fetched each time the relevant screen
/// is opened (ensures variant changes propagate without a stale cache).
///
/// Copied from [userExperiments].
@ProviderFor(userExperiments)
final userExperimentsProvider =
    AutoDisposeFutureProvider<UserExperiments>.internal(
  userExperiments,
  name: r'userExperimentsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userExperimentsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserExperimentsRef = AutoDisposeFutureProviderRef<UserExperiments>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
