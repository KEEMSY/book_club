import 'package:freezed_annotation/freezed_annotation.dart';

part 'reading_reminder.freezed.dart';

/// A single personalized reading reminder entry owned by the current user.
///
/// [daysOfWeek] uses 0-based Monday indexing: 0=Mon, 1=Tue, … 6=Sun.
/// [remindAt] is a 24-hour time string matching the backend format "HH:MM:SS".
@freezed
abstract class ReadingReminder with _$ReadingReminder {
  const factory ReadingReminder({
    required String id,
    required List<int> daysOfWeek,
    required String remindAt,
    @Default(true) bool isActive,
    required DateTime createdAt,
  }) = _ReadingReminder;
}
