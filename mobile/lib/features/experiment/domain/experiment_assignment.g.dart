// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'experiment_assignment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExperimentAssignment _$ExperimentAssignmentFromJson(
        Map<String, dynamic> json) =>
    _ExperimentAssignment(
      experimentKey: json['experiment_key'] as String,
      variant: json['variant'] as String,
      assignedAt: DateTime.parse(json['assigned_at'] as String),
    );

Map<String, dynamic> _$ExperimentAssignmentToJson(
        _ExperimentAssignment instance) =>
    <String, dynamic>{
      'experiment_key': instance.experimentKey,
      'variant': instance.variant,
      'assigned_at': instance.assignedAt.toIso8601String(),
    };
