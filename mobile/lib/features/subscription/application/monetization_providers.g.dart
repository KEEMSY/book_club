// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monetization_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$trialStatusHash() => r'f6cf9594a5791adb3bdb49f0a5a0e89ca054fd0b';

/// Current user's Pro trial window (`GET /me/trial-status`).
///
/// autoDispose: the trial banner and paywall only need it while visible, and
/// re-reading is cheap. Invalidate after a successful subscribe to refresh.
///
/// Copied from [trialStatus].
@ProviderFor(trialStatus)
final trialStatusProvider = AutoDisposeFutureProvider<TrialStatus>.internal(
  trialStatus,
  name: r'trialStatusProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$trialStatusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TrialStatusRef = AutoDisposeFutureProviderRef<TrialStatus>;
String _$activePromoHash() => r'50c0b53a43dd648d15b791a94eb26f6fd59b1fd3';

/// Active early-bird promo, or `null` when none is live
/// (`GET /subscriptions/promo`).
///
/// Copied from [activePromo].
@ProviderFor(activePromo)
final activePromoProvider = AutoDisposeFutureProvider<Promo?>.internal(
  activePromo,
  name: r'activePromoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$activePromoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActivePromoRef = AutoDisposeFutureProviderRef<Promo?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
