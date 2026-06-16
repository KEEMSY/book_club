// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'global_feed_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$globalFeedNotifierHash() =>
    r'3b882812de53f29e85b4ffe20c6c7198a258a490';

/// Notifier for [FeedTab.global] — `GET /feed`.
///
/// Copied from [GlobalFeedNotifier].
@ProviderFor(GlobalFeedNotifier)
final globalFeedNotifierProvider =
    AutoDisposeNotifierProvider<GlobalFeedNotifier, GlobalFeedState>.internal(
  GlobalFeedNotifier.new,
  name: r'globalFeedNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$globalFeedNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GlobalFeedNotifier = AutoDisposeNotifier<GlobalFeedState>;
String _$followingEventFeedNotifierHash() =>
    r'ff45654a0ca0d0b81864cdb8ce1634d8b485d2d8';

/// Notifier for [FeedTab.following] — `GET /feed/following`.
///
/// Copied from [FollowingEventFeedNotifier].
@ProviderFor(FollowingEventFeedNotifier)
final followingEventFeedNotifierProvider = AutoDisposeNotifierProvider<
    FollowingEventFeedNotifier, GlobalFeedState>.internal(
  FollowingEventFeedNotifier.new,
  name: r'followingEventFeedNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$followingEventFeedNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FollowingEventFeedNotifier = AutoDisposeNotifier<GlobalFeedState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
