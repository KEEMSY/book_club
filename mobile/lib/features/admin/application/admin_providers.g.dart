// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$adminOverviewHash() => r'4472aa4cb8b71f28352f613494721e40d76e6f92';

/// Combined stats + funnel + revenue payload for the console's metrics
/// section. autoDispose: only fetched while the console is visible; the
/// screen's pull-to-refresh / retry action calls `ref.invalidate`.
///
/// Copied from [adminOverview].
@ProviderFor(adminOverview)
final adminOverviewProvider = AutoDisposeFutureProvider<AdminOverview>.internal(
  adminOverview,
  name: r'adminOverviewProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$adminOverviewHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AdminOverviewRef = AutoDisposeFutureProviderRef<AdminOverview>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
