import 'package:freezed_annotation/freezed_annotation.dart';

part 'referral_stats.freezed.dart';

/// Referral statistics for the current user.
///
/// Populated from `GET /me/referral`.
@freezed
abstract class ReferralStats with _$ReferralStats {
  const factory ReferralStats({
    required String code,
    required int invitedCount,
    required int completedCount,
  }) = _ReferralStats;
}
