// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dio_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dioHash() => r'6b34ff505be05af4fb5e9b4c92570bfe4a4b39db';

/// See also [dio].
@ProviderFor(dio)
final dioProvider = AutoDisposeProvider<Dio>.internal(
  dio,
  name: r'dioProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$dioHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DioRef = AutoDisposeProviderRef<Dio>;
String _$sessionExpiredBroadcastHash() =>
    r'ca91c9d792ac4d5dccaa7388ba98fdb75e30ab98';

/// Signal surface the RefreshInterceptor writes to when it drops tokens.
/// The auth feature reads this through a Provider and forces the notifier
/// to [AuthState.unauthenticated]. Kept here so core/network stays free of
/// direct auth-feature imports.
///
/// Copied from [SessionExpiredBroadcast].
@ProviderFor(SessionExpiredBroadcast)
final sessionExpiredBroadcastProvider =
    AutoDisposeNotifierProvider<SessionExpiredBroadcast, int>.internal(
  SessionExpiredBroadcast.new,
  name: r'sessionExpiredBroadcastProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sessionExpiredBroadcastHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SessionExpiredBroadcast = AutoDisposeNotifier<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
