// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$reminderListHash() => r'988335e3cb1dca5905dc62e93ec7c0233652c595';

/// Manages the list of reading reminders for the authenticated user.
///
/// autoDispose so the list is re-fetched fresh every time [ReminderScreen]
/// is opened, matching the pattern used by [ReferralStats].
///
/// Copied from [ReminderList].
@ProviderFor(ReminderList)
final reminderListProvider = AutoDisposeAsyncNotifierProvider<ReminderList,
    List<ReadingReminder>>.internal(
  ReminderList.new,
  name: r'reminderListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$reminderListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ReminderList = AutoDisposeAsyncNotifier<List<ReadingReminder>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
