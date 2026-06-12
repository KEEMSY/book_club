// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'referral_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$referralStatsHash() => r'4a64af5e027a54509dbbcbf8624b62d0a65e1fdb';

/// Fetches the current user's referral stats (code, invited count, completed
/// count).
///
/// autoDispose so the data is re-fetched fresh each time the screen is opened.
///
/// Copied from [referralStats].
@ProviderFor(referralStats)
final referralStatsProvider = AutoDisposeFutureProvider<ReferralStats>.internal(
  referralStats,
  name: r'referralStatsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$referralStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ReferralStatsRef = AutoDisposeFutureProviderRef<ReferralStats>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
