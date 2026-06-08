// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'club_room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ClubRoom _$ClubRoomFromJson(Map<String, dynamic> json) => _ClubRoom(
      id: json['id'] as String,
      clubId: json['club_id'] as String,
      name: json['name'] as String,
      progressGate: (json['progress_gate'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      canEnter: json['can_enter'] as bool? ?? true,
    );

Map<String, dynamic> _$ClubRoomToJson(_ClubRoom instance) => <String, dynamic>{
      'id': instance.id,
      'club_id': instance.clubId,
      'name': instance.name,
      'progress_gate': instance.progressGate,
      'created_at': instance.createdAt.toIso8601String(),
      'can_enter': instance.canEnter,
    };
