// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streak_recovery_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StreakRecoveryStatus _$StreakRecoveryStatusFromJson(
        Map<String, dynamic> json) =>
    _StreakRecoveryStatus(
      recoveriesUsed: (json['recoveries_used'] as num).toInt(),
      recoveriesRemaining: (json['recoveries_remaining'] as num).toInt(),
      canRecover: json['can_recover'] as bool,
    );

Map<String, dynamic> _$StreakRecoveryStatusToJson(
        _StreakRecoveryStatus instance) =>
    <String, dynamic>{
      'recoveries_used': instance.recoveriesUsed,
      'recoveries_remaining': instance.recoveriesRemaining,
      'can_recover': instance.canRecover,
    };
