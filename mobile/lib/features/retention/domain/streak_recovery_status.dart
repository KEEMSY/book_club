import 'package:freezed_annotation/freezed_annotation.dart';

part 'streak_recovery_status.freezed.dart';
part 'streak_recovery_status.g.dart';

/// Recovery eligibility returned by `GET /me/streak/recovery-status`.
///
/// A user may recover a broken streak up to a fixed number of times.
/// [canRecover] is `true` only when at least one recovery token remains.
@freezed
abstract class StreakRecoveryStatus with _$StreakRecoveryStatus {
  const factory StreakRecoveryStatus({
    required int recoveriesUsed,
    required int recoveriesRemaining,
    required bool canRecover,
  }) = _StreakRecoveryStatus;

  factory StreakRecoveryStatus.fromJson(Map<String, dynamic> json) =>
      _$StreakRecoveryStatusFromJson(json);
}
