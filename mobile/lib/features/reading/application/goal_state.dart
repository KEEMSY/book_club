import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/reading_goal.dart';

part 'goal_state.freezed.dart';

/// Sealed state for the goals screen. [loaded] carries the entire active
/// goal list (one per period); per-tab empty states are derived on the UI
/// side with `firstWhereOrNull(period)`.
@freezed
sealed class GoalState with _$GoalState {
  const factory GoalState.initial() = GoalInitial;
  const factory GoalState.loading() = GoalLoading;
  const factory GoalState.loaded({
    required List<GoalProgress> items,
  }) = GoalLoaded;
  const factory GoalState.error({
    required String code,
    required String message,
  }) = GoalError;
}
