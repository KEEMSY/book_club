import 'package:freezed_annotation/freezed_annotation.dart';

part 'experiment_assignment.freezed.dart';
part 'experiment_assignment.g.dart';

/// A single A/B experiment variant assignment for the current user.
///
/// Returned as part of [UserExperiments] from `GET /me/experiments`.
@freezed
abstract class ExperimentAssignment with _$ExperimentAssignment {
  const factory ExperimentAssignment({
    required String experimentKey,
    required String variant,
    required DateTime assignedAt,
  }) = _ExperimentAssignment;

  factory ExperimentAssignment.fromJson(Map<String, dynamic> json) =>
      _$ExperimentAssignmentFromJson(json);
}
