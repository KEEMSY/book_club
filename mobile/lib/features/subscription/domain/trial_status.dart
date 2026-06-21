import 'package:freezed_annotation/freezed_annotation.dart';

part 'trial_status.freezed.dart';
part 'trial_status.g.dart';

/// New-signup Pro trial window state, from `GET /me/trial-status`.
///
/// Field names mirror the backend snake_case payload via the global
/// `field_rename: snake` build option (see `build.yaml`).
@freezed
abstract class TrialStatus with _$TrialStatus {
  const factory TrialStatus({
    @Default(false) bool isInTrial,
    DateTime? trialEndsAt,
    @Default(0) int daysRemaining,
  }) = _TrialStatus;

  factory TrialStatus.fromJson(Map<String, dynamic> json) =>
      _$TrialStatusFromJson(json);
}
