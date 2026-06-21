// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trial_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TrialStatus _$TrialStatusFromJson(Map<String, dynamic> json) => _TrialStatus(
      isInTrial: json['is_in_trial'] as bool? ?? false,
      trialEndsAt: json['trial_ends_at'] == null
          ? null
          : DateTime.parse(json['trial_ends_at'] as String),
      daysRemaining: (json['days_remaining'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$TrialStatusToJson(_TrialStatus instance) =>
    <String, dynamic>{
      'is_in_trial': instance.isInTrial,
      'trial_ends_at': instance.trialEndsAt?.toIso8601String(),
      'days_remaining': instance.daysRemaining,
    };
