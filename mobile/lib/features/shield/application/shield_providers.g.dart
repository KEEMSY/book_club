// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shield_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$shieldBalanceHash() => r'b67260c7f92ccd7fab9c2b839194993d4945df63';

/// Fetches the current user's streak shield balance.
///
/// autoDispose ensures the balance is re-fetched each time the sheet is
/// opened, keeping the display consistent with the server state.
///
/// Copied from [shieldBalance].
@ProviderFor(shieldBalance)
final shieldBalanceProvider = AutoDisposeFutureProvider<int>.internal(
  shieldBalance,
  name: r'shieldBalanceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$shieldBalanceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ShieldBalanceRef = AutoDisposeFutureProviderRef<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
