// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agenda_topic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AgendaTopic _$AgendaTopicFromJson(Map<String, dynamic> json) => _AgendaTopic(
      id: json['id'] as String,
      agendaId: json['agenda_id'] as String,
      position: (json['position'] as num).toInt(),
      prompt: json['prompt'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$AgendaTopicToJson(_AgendaTopic instance) =>
    <String, dynamic>{
      'id': instance.id,
      'agenda_id': instance.agendaId,
      'position': instance.position,
      'prompt': instance.prompt,
      'created_at': instance.createdAt.toIso8601String(),
    };
