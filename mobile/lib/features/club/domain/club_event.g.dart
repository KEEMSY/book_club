// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'club_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AttendeeCount _$AttendeeCountFromJson(Map<String, dynamic> json) =>
    _AttendeeCount(
      going: (json['going'] as num?)?.toInt() ?? 0,
      maybe: (json['maybe'] as num?)?.toInt() ?? 0,
      notGoing: (json['not_going'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$AttendeeCountToJson(_AttendeeCount instance) =>
    <String, dynamic>{
      'going': instance.going,
      'maybe': instance.maybe,
      'not_going': instance.notGoing,
    };

_ClubEvent _$ClubEventFromJson(Map<String, dynamic> json) => _ClubEvent(
      id: json['id'] as String,
      clubId: json['club_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      eventAt: DateTime.parse(json['event_at'] as String),
      location: json['location'] as String?,
      maxAttendees: (json['max_attendees'] as num?)?.toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      attendeeCounts: json['attendee_counts'] == null
          ? const AttendeeCount()
          : AttendeeCount.fromJson(
              json['attendee_counts'] as Map<String, dynamic>),
      myStatus: $enumDecodeNullable(_$RsvpStatusEnumMap, json['my_status']),
    );

Map<String, dynamic> _$ClubEventToJson(_ClubEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'club_id': instance.clubId,
      'title': instance.title,
      'description': instance.description,
      'event_at': instance.eventAt.toIso8601String(),
      'location': instance.location,
      'max_attendees': instance.maxAttendees,
      'created_at': instance.createdAt.toIso8601String(),
      'attendee_counts': instance.attendeeCounts.toJson(),
      'my_status': _$RsvpStatusEnumMap[instance.myStatus],
    };

const _$RsvpStatusEnumMap = {
  RsvpStatus.going: 'going',
  RsvpStatus.maybe: 'maybe',
  RsvpStatus.notGoing: 'not_going',
};
