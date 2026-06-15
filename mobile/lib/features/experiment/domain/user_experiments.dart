import 'package:freezed_annotation/freezed_annotation.dart';

import 'experiment_assignment.dart';

part 'user_experiments.freezed.dart';
part 'user_experiments.g.dart';

/// All active A/B experiment assignments for the current user.
///
/// Populated from `GET /me/experiments`.
@freezed
abstract class UserExperiments with _$UserExperiments {
  const factory UserExperiments({
    required List<ExperimentAssignment> assignments,
  }) = _UserExperiments;

  factory UserExperiments.fromJson(Map<String, dynamic> json) =>
      _$UserExperimentsFromJson(json);
}

/// Convenience accessors on [UserExperiments].
extension UserExperimentsX on UserExperiments {
  /// Returns the assigned variant string for [experimentKey], or `null` when
  /// the user has no assignment for that experiment.
  String? variantFor(String experimentKey) {
    for (final assignment in assignments) {
      if (assignment.experimentKey == experimentKey) return assignment.variant;
    }
    return null;
  }
}
