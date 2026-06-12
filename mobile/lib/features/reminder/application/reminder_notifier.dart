import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/reminder_repository.dart';
import '../domain/reading_reminder.dart';
import 'reminder_providers.dart';

part 'reminder_notifier.g.dart';

/// Manages the list of reading reminders for the authenticated user.
///
/// autoDispose so the list is re-fetched fresh every time [ReminderScreen]
/// is opened, matching the pattern used by [ReferralStats].
@riverpod
class ReminderList extends _$ReminderList {
  @override
  Future<List<ReadingReminder>> build() async {
    return ref.read(reminderRepositoryProvider).listReminders();
  }

  /// Creates a new reminder and optimistically appends it to the list.
  Future<void> create({
    required List<int> days,
    required String time,
  }) async {
    final previous = state;
    try {
      final created = await ref
          .read(reminderRepositoryProvider)
          .createReminder(daysOfWeek: days, remindAt: time);
      state = AsyncData([
        ...?previous.valueOrNull,
        created,
      ]);
    } on ReminderRepositoryException {
      // Restore previous state on failure so the UI can show the error.
      state = previous;
      rethrow;
    }
  }

  /// Deletes a reminder by id and removes it from the local list immediately.
  Future<void> delete(String id) async {
    final previous = state;
    state = AsyncData(
      (previous.valueOrNull ?? []).where((r) => r.id != id).toList(),
    );
    try {
      await ref.read(reminderRepositoryProvider).deleteReminder(id);
    } on ReminderRepositoryException {
      state = previous;
      rethrow;
    }
  }

  /// Toggles the [isActive] flag for a reminder.
  ///
  /// Updates optimistically; rolls back on network failure.
  Future<void> toggle(String id, {required bool active}) async {
    final previous = state;
    final current = previous.valueOrNull ?? [];
    final target = current.firstWhere((r) => r.id == id);

    state = AsyncData(
      current.map((r) => r.id == id ? r.copyWith(isActive: active) : r).toList(),
    );

    try {
      await ref.read(reminderRepositoryProvider).updateReminder(
            id: id,
            daysOfWeek: target.daysOfWeek,
            remindAt: target.remindAt,
            isActive: active,
          );
    } on ReminderRepositoryException {
      state = previous;
      rethrow;
    }
  }
}
