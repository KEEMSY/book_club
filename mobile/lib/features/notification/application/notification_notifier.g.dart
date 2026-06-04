// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationNotifierHash() =>
    r'7ec77220342533212535b34e02ada177e677da45';

/// Manages the notification list with cursor-based pagination and a
/// persistent WebSocket connection for real-time delivery.
///
/// Lifecycle:
///   • [build] opens /ws/me immediately so the badge stays live without
///     requiring the full notification screen to be mounted.
///   • WS events of type `notification` are prepended to [items] and
///     increment [unreadCount] so the bell badge updates instantly.
///   • [load] / [loadMore] back-fill from the REST endpoint.
///   • [markRead] / [markAllRead] optimistically patch local state.
///   • [ref.onDispose] tears down the WS cleanly.
///
/// Copied from [NotificationNotifier].
@ProviderFor(NotificationNotifier)
final notificationNotifierProvider =
    NotifierProvider<NotificationNotifier, NotificationState>.internal(
  NotificationNotifier.new,
  name: r'notificationNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NotificationNotifier = Notifier<NotificationState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
