// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_prefs_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dashboardPrefsNotifierHash() =>
    r'396c300f2aa202fc85d8453c486328dc4f27fcaa';

/// Persists and restores which dashboard sections the user wants visible.
///
/// State is loaded once at construction from SharedPreferences; subsequent
/// calls to [update] write through so the choice survives cold restarts.
///
/// Copied from [DashboardPrefsNotifier].
@ProviderFor(DashboardPrefsNotifier)
final dashboardPrefsNotifierProvider = AutoDisposeNotifierProvider<
    DashboardPrefsNotifier, DashboardPrefs>.internal(
  DashboardPrefsNotifier.new,
  name: r'dashboardPrefsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dashboardPrefsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DashboardPrefsNotifier = AutoDisposeNotifier<DashboardPrefs>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
