// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationNotifierHash() =>
    r'd0e7d1c94f85f58fd01e8acb23fe74f4b00afc30';

/// Manages the notification list with cursor-based pagination.
///
/// [load] always replaces the list with the first page so pull-to-refresh
/// and the initial mount both reset cleanly.
/// [loadMore] appends the next page only when [NotificationState.hasMore].
/// [markRead] optimistically patches the local item to avoid a full reload
/// that would scroll-jump the user.
///
/// Copied from [NotificationNotifier].
@ProviderFor(NotificationNotifier)
final notificationNotifierProvider = AutoDisposeNotifierProvider<
    NotificationNotifier, NotificationState>.internal(
  NotificationNotifier.new,
  name: r'notificationNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NotificationNotifier = AutoDisposeNotifier<NotificationState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
