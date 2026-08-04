// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_agenda.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SessionAgenda _$SessionAgendaFromJson(Map<String, dynamic> json) =>
    _SessionAgenda(
      id: json['id'] as String,
      sessionId: json['session_id'] as String,
      authorId: json['author_id'] as String,
      authorName: json['author_name'] as String?,
      body: json['body'] as String,
      status: $enumDecode(_$AgendaStatusEnumMap, json['status']),
      publishedAt: json['published_at'] == null
          ? null
          : DateTime.parse(json['published_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      topics: (json['topics'] as List<dynamic>?)
              ?.map((e) => AgendaTopic.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <AgendaTopic>[],
    );

Map<String, dynamic> _$SessionAgendaToJson(_SessionAgenda instance) =>
    <String, dynamic>{
      'id': instance.id,
      'session_id': instance.sessionId,
      'author_id': instance.authorId,
      'author_name': instance.authorName,
      'body': instance.body,
      'status': _$AgendaStatusEnumMap[instance.status]!,
      'published_at': instance.publishedAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'topics': instance.topics.map((e) => e.toJson()).toList(),
    };

const _$AgendaStatusEnumMap = {
  AgendaStatus.draft: 'draft',
  AgendaStatus.published: 'published',
};
