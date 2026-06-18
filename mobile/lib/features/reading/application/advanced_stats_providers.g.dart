// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'advanced_stats_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$advancedStatsApiHash() => r'db2f387af5f741afd5f99cebc4427aa57db6703b';

/// See also [advancedStatsApi].
@ProviderFor(advancedStatsApi)
final advancedStatsApiProvider = AutoDisposeProvider<AdvancedStatsApi>.internal(
  advancedStatsApi,
  name: r'advancedStatsApiProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$advancedStatsApiHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AdvancedStatsApiRef = AutoDisposeProviderRef<AdvancedStatsApi>;
String _$advancedStatsRepositoryHash() =>
    r'ac05a83adf3b9482176245e6bebab70beb5ca0af';

/// See also [advancedStatsRepository].
@ProviderFor(advancedStatsRepository)
final advancedStatsRepositoryProvider =
    AutoDisposeProvider<AdvancedStatsRepository>.internal(
  advancedStatsRepository,
  name: r'advancedStatsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$advancedStatsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AdvancedStatsRepositoryRef
    = AutoDisposeProviderRef<AdvancedStatsRepository>;
String _$advancedStatsHash() => r'4cb6a088fd7bf466071ef89d7ad080ed9432841f';

/// Fetches the Pro-only advanced stats payload.
///
/// autoDispose (default) — an occasional-visit screen; releasing the cache on
/// exit keeps idle memory low and re-checks Pro entitlement on each visit.
///
/// Copied from [AdvancedStats].
@ProviderFor(AdvancedStats)
final advancedStatsProvider =
    AutoDisposeAsyncNotifierProvider<AdvancedStats, AdvancedStatsDto>.internal(
  AdvancedStats.new,
  name: r'advancedStatsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$advancedStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AdvancedStats = AutoDisposeAsyncNotifier<AdvancedStatsDto>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
