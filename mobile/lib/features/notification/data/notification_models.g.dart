// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationDtoImpl _$$NotificationDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationDtoImpl(
      id: json['id'] as String,
      ntype: json['ntype'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      data: (json['data'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
      readAt: json['read_at'] == null
          ? null
          : DateTime.parse(json['read_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$NotificationDtoImplToJson(
        _$NotificationDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ntype': instance.ntype,
      'title': instance.title,
      'body': instance.body,
      'data': instance.data,
      'read_at': instance.readAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
    };

_$NotificationListResponseImpl _$$NotificationListResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationListResponseImpl(
      items: (json['items'] as List<dynamic>)
          .map((e) => NotificationDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextCursor: json['next_cursor'] as String?,
      unreadCount: (json['unread_count'] as num).toInt(),
    );

Map<String, dynamic> _$$NotificationListResponseImplToJson(
        _$NotificationListResponseImpl instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'next_cursor': instance.nextCursor,
      'unread_count': instance.unreadCount,
    };

_$UnreadCountResponseImpl _$$UnreadCountResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$UnreadCountResponseImpl(
      unreadCount: (json['unread_count'] as num).toInt(),
    );

Map<String, dynamic> _$$UnreadCountResponseImplToJson(
        _$UnreadCountResponseImpl instance) =>
    <String, dynamic>{
      'unread_count': instance.unreadCount,
    };

_$WeeklyReportResponseImpl _$$WeeklyReportResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$WeeklyReportResponseImpl(
      id: json['id'] as String,
      weekStart: json['week_start'] as String,
      totalSeconds: (json['total_seconds'] as num).toInt(),
      sessionCount: (json['session_count'] as num).toInt(),
      bestDay: json['best_day'] as String?,
      longestSessionSec: (json['longest_session_sec'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$WeeklyReportResponseImplToJson(
        _$WeeklyReportResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'week_start': instance.weekStart,
      'total_seconds': instance.totalSeconds,
      'session_count': instance.sessionCount,
      'best_day': instance.bestDay,
      'longest_session_sec': instance.longestSessionSec,
      'created_at': instance.createdAt.toIso8601String(),
    };
