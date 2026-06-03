// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_mode_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appModeNotifierHash() => r'90a051bd56a1e89f862de5c0ab028ef4bda1da00';

/// Top-level mode toggle: 개인 reading context vs. 커뮤니티 social context.
///
/// Persists only for the current session — no disk storage needed because
/// the app always opens in personal mode on cold start.
///
/// Copied from [AppModeNotifier].
@ProviderFor(AppModeNotifier)
final appModeNotifierProvider =
    AutoDisposeNotifierProvider<AppModeNotifier, AppMode>.internal(
  AppModeNotifier.new,
  name: r'appModeNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appModeNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AppModeNotifier = AutoDisposeNotifier<AppMode>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
