// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_preferences_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationPreferencesNotifierHash() =>
    r'e0f9b852e73d6cce77cccb22d90f626df76805d2';

/// Manages the notification-preferences toggle screen (BC-92).
///
/// autoDispose so the screen re-fetches fresh state every time it's opened,
/// matching [ReminderList]'s pattern — preferences change rarely and a
/// stale keepAlive cache isn't worth the added complexity.
///
/// Copied from [NotificationPreferencesNotifier].
@ProviderFor(NotificationPreferencesNotifier)
final notificationPreferencesNotifierProvider =
    AutoDisposeAsyncNotifierProvider<NotificationPreferencesNotifier,
        NotificationPreferencesResponse>.internal(
  NotificationPreferencesNotifier.new,
  name: r'notificationPreferencesNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationPreferencesNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NotificationPreferencesNotifier
    = AutoDisposeAsyncNotifier<NotificationPreferencesResponse>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
