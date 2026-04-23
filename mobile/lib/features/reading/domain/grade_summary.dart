import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/theme/grade_theme.dart';

part 'grade_summary.freezed.dart';

/// Remaining distance to the next grade (books + seconds). Null when the user
/// has reached grade 5 (서재 마스터).
@freezed
class NextGradeThresholds with _$NextGradeThresholds {
  const factory NextGradeThresholds({
    required int targetBooks,
    required int targetSeconds,
  }) = _NextGradeThresholds;
}

/// Domain-layer projection of `GradeSummaryPublic`.
///
/// [grade] is the raw 1..5 integer from the backend. Call [readerGrade] to
/// map it onto the Flutter [ReaderGrade] enum used by `GradeTheme`.
@freezed
class GradeSummary with _$GradeSummary {
  const GradeSummary._();

  const factory GradeSummary({
    required int grade,
    required int totalBooks,
    required int totalSeconds,
    required int streakDays,
    required int longestStreak,
    NextGradeThresholds? nextGradeThresholds,
  }) = _GradeSummary;

  ReaderGrade get readerGrade {
    switch (grade) {
      case 2:
        return ReaderGrade.explorer;
      case 3:
        return ReaderGrade.devoted;
      case 4:
        return ReaderGrade.passionate;
      case 5:
        return ReaderGrade.master;
      case 1:
      default:
        return ReaderGrade.sprout;
    }
  }
}
