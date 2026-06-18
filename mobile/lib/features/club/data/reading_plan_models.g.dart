// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_plan_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReadingPlanDto _$ReadingPlanDtoFromJson(Map<String, dynamic> json) =>
    _ReadingPlanDto(
      id: json['id'] as String,
      clubId: json['club_id'] as String,
      bookId: json['book_id'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      weeklyPages: (json['weekly_pages'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$ReadingPlanDtoToJson(_ReadingPlanDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'club_id': instance.clubId,
      'book_id': instance.bookId,
      'start_date': instance.startDate.toIso8601String(),
      'end_date': instance.endDate.toIso8601String(),
      'weekly_pages': instance.weeklyPages,
      'created_at': instance.createdAt.toIso8601String(),
    };

_CreateReadingPlanRequest _$CreateReadingPlanRequestFromJson(
        Map<String, dynamic> json) =>
    _CreateReadingPlanRequest(
      bookId: json['book_id'] as String,
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String,
    );

Map<String, dynamic> _$CreateReadingPlanRequestToJson(
        _CreateReadingPlanRequest instance) =>
    <String, dynamic>{
      'book_id': instance.bookId,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
    };

_UpdateProgressRequest _$UpdateProgressRequestFromJson(
        Map<String, dynamic> json) =>
    _UpdateProgressRequest(
      currentPage: (json['current_page'] as num).toInt(),
    );

Map<String, dynamic> _$UpdateProgressRequestToJson(
        _UpdateProgressRequest instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
    };

_MemberProgressDto _$MemberProgressDtoFromJson(Map<String, dynamic> json) =>
    _MemberProgressDto(
      userId: json['user_id'] as String,
      nickname: json['nickname'] as String,
      currentPage: (json['current_page'] as num).toInt(),
      progressPct: (json['progress_pct'] as num).toDouble(),
      lastPageUpdatedAt: json['last_page_updated_at'] == null
          ? null
          : DateTime.parse(json['last_page_updated_at'] as String),
    );

Map<String, dynamic> _$MemberProgressDtoToJson(_MemberProgressDto instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'nickname': instance.nickname,
      'current_page': instance.currentPage,
      'progress_pct': instance.progressPct,
      'last_page_updated_at': instance.lastPageUpdatedAt?.toIso8601String(),
    };

_ClubProgressDto _$ClubProgressDtoFromJson(Map<String, dynamic> json) =>
    _ClubProgressDto(
      plan: json['plan'] == null
          ? null
          : ReadingPlanDto.fromJson(json['plan'] as Map<String, dynamic>),
      members: (json['members'] as List<dynamic>?)
              ?.map(
                  (e) => MemberProgressDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ClubProgressDtoToJson(_ClubProgressDto instance) =>
    <String, dynamic>{
      'plan': instance.plan?.toJson(),
      'members': instance.members.map((e) => e.toJson()).toList(),
    };
