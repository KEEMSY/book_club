import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/grade_summary.dart';

part 'grade_state.freezed.dart';

/// Sealed state for the grade screen and accent color provider.
@freezed
sealed class GradeState with _$GradeState {
  const factory GradeState.initial() = GradeInitial;
  const factory GradeState.loading() = GradeLoading;
  const factory GradeState.loaded({
    required GradeSummary summary,
    @Default(false) bool recentGradeUp,
  }) = GradeLoaded;
  const factory GradeState.error({
    required String code,
    required String message,
  }) = GradeError;
}
