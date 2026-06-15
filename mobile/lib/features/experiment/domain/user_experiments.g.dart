// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_experiments.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserExperiments _$UserExperimentsFromJson(Map<String, dynamic> json) =>
    _UserExperiments(
      assignments: (json['assignments'] as List<dynamic>)
          .map((e) => ExperimentAssignment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserExperimentsToJson(_UserExperiments instance) =>
    <String, dynamic>{
      'assignments': instance.assignments.map((e) => e.toJson()).toList(),
    };
