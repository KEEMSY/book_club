// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'club_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ClubSession _$ClubSessionFromJson(Map<String, dynamic> json) => _ClubSession(
      id: json['id'] as String,
      clubId: json['club_id'] as String,
      bookId: json['book_id'] as String,
      bookTitle: json['book_title'] as String?,
      title: json['title'] as String,
      scope: json['scope'] as String?,
      presenterId: json['presenter_id'] as String?,
      presenterName: json['presenter_name'] as String?,
      scheduledAt: json['scheduled_at'] == null
          ? null
          : DateTime.parse(json['scheduled_at'] as String),
      status: $enumDecode(_$ClubSessionStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$ClubSessionToJson(_ClubSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'club_id': instance.clubId,
      'book_id': instance.bookId,
      'book_title': instance.bookTitle,
      'title': instance.title,
      'scope': instance.scope,
      'presenter_id': instance.presenterId,
      'presenter_name': instance.presenterName,
      'scheduled_at': instance.scheduledAt?.toIso8601String(),
      'status': _$ClubSessionStatusEnumMap[instance.status]!,
      'created_at': instance.createdAt.toIso8601String(),
    };

const _$ClubSessionStatusEnumMap = {
  ClubSessionStatus.draft: 'draft',
  ClubSessionStatus.open: 'open',
  ClubSessionStatus.closed: 'closed',
};
