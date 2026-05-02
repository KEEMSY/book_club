// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GradeStatsImpl _$$GradeStatsImplFromJson(Map<String, dynamic> json) =>
    _$GradeStatsImpl(
      grade: (json['grade'] as num).toInt(),
      tier: (json['tier'] as num).toInt(),
      totalBooks: (json['total_books'] as num).toInt(),
      totalSeconds: (json['total_seconds'] as num).toInt(),
      streakDays: (json['streak_days'] as num).toInt(),
    );

Map<String, dynamic> _$$GradeStatsImplToJson(_$GradeStatsImpl instance) =>
    <String, dynamic>{
      'grade': instance.grade,
      'tier': instance.tier,
      'total_books': instance.totalBooks,
      'total_seconds': instance.totalSeconds,
      'streak_days': instance.streakDays,
    };

_$BadgeSummaryImpl _$$BadgeSummaryImplFromJson(Map<String, dynamic> json) =>
    _$BadgeSummaryImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      iconUrl: json['icon_url'] as String,
      category: json['category'] as String,
      earnedAt: DateTime.parse(json['earned_at'] as String),
    );

Map<String, dynamic> _$$BadgeSummaryImplToJson(_$BadgeSummaryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon_url': instance.iconUrl,
      'category': instance.category,
      'earned_at': instance.earnedAt.toIso8601String(),
    };

_$HighlightSummaryImpl _$$HighlightSummaryImplFromJson(
        Map<String, dynamic> json) =>
    _$HighlightSummaryImpl(
      id: json['id'] as String,
      quoteText: json['quote_text'] as String,
      bookTitle: json['book_title'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$HighlightSummaryImplToJson(
        _$HighlightSummaryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quote_text': instance.quoteText,
      'book_title': instance.bookTitle,
      'created_at': instance.createdAt.toIso8601String(),
    };

_$UserSummaryImpl _$$UserSummaryImplFromJson(Map<String, dynamic> json) =>
    _$UserSummaryImpl(
      id: json['id'] as String,
      nickname: json['nickname'] as String,
      profileImageUrl: json['profile_image_url'] as String?,
      bio: json['bio'] as String?,
      isFollowing: json['is_following'] as bool,
    );

Map<String, dynamic> _$$UserSummaryImplToJson(_$UserSummaryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nickname': instance.nickname,
      'profile_image_url': instance.profileImageUrl,
      'bio': instance.bio,
      'is_following': instance.isFollowing,
    };

_$UserSummaryPageImpl _$$UserSummaryPageImplFromJson(
        Map<String, dynamic> json) =>
    _$UserSummaryPageImpl(
      items: (json['items'] as List<dynamic>)
          .map((e) => UserSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextCursor: json['next_cursor'] as String?,
    );

Map<String, dynamic> _$$UserSummaryPageImplToJson(
        _$UserSummaryPageImpl instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'next_cursor': instance.nextCursor,
    };

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      id: json['id'] as String,
      nickname: json['nickname'] as String,
      profileImageUrl: json['profile_image_url'] as String?,
      bio: json['bio'] as String?,
      followerCount: (json['follower_count'] as num).toInt(),
      followingCount: (json['following_count'] as num).toInt(),
      isFollowing: json['is_following'] as bool,
      isMe: json['is_me'] as bool,
      gradeStats: json['grade_stats'] == null
          ? null
          : GradeStats.fromJson(json['grade_stats'] as Map<String, dynamic>),
      badges: (json['badges'] as List<dynamic>?)
              ?.map((e) => BadgeSummary.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      recentHighlights: (json['recent_highlights'] as List<dynamic>?)
              ?.map((e) => HighlightSummary.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nickname': instance.nickname,
      'profile_image_url': instance.profileImageUrl,
      'bio': instance.bio,
      'follower_count': instance.followerCount,
      'following_count': instance.followingCount,
      'is_following': instance.isFollowing,
      'is_me': instance.isMe,
      'grade_stats': instance.gradeStats?.toJson(),
      'badges': instance.badges.map((e) => e.toJson()).toList(),
      'recent_highlights':
          instance.recentHighlights.map((e) => e.toJson()).toList(),
    };
