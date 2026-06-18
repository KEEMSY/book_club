// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'highlight_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HighlightDto _$HighlightDtoFromJson(Map<String, dynamic> json) =>
    _HighlightDto(
      id: json['id'] as String,
      userBookId: json['user_book_id'] as String,
      bookId: json['book_id'] as String,
      bookTitle: json['book_title'] as String,
      quoteText: json['quote_text'] as String,
      visibility: $enumDecode(_$HighlightVisibilityEnumMap, json['visibility']),
      createdAt: DateTime.parse(json['created_at'] as String),
      bookCoverUrl: json['book_cover_url'] as String?,
      page: (json['page'] as num?)?.toInt(),
      sharedAt: json['shared_at'] == null
          ? null
          : DateTime.parse(json['shared_at'] as String),
    );

Map<String, dynamic> _$HighlightDtoToJson(_HighlightDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_book_id': instance.userBookId,
      'book_id': instance.bookId,
      'book_title': instance.bookTitle,
      'quote_text': instance.quoteText,
      'visibility': _$HighlightVisibilityEnumMap[instance.visibility]!,
      'created_at': instance.createdAt.toIso8601String(),
      'book_cover_url': instance.bookCoverUrl,
      'page': instance.page,
      'shared_at': instance.sharedAt?.toIso8601String(),
    };

const _$HighlightVisibilityEnumMap = {
  HighlightVisibility.private: 'private',
  HighlightVisibility.followers: 'followers',
  HighlightVisibility.public: 'public',
};

_HighlightExploreDto _$HighlightExploreDtoFromJson(Map<String, dynamic> json) =>
    _HighlightExploreDto(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      bookId: json['book_id'] as String,
      bookTitle: json['book_title'] as String,
      quoteText: json['quote_text'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      reactionCount: (json['reaction_count'] as num?)?.toInt() ?? 0,
      bookCoverUrl: json['book_cover_url'] as String?,
      page: (json['page'] as num?)?.toInt(),
    );

Map<String, dynamic> _$HighlightExploreDtoToJson(
        _HighlightExploreDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'book_id': instance.bookId,
      'book_title': instance.bookTitle,
      'quote_text': instance.quoteText,
      'created_at': instance.createdAt.toIso8601String(),
      'reaction_count': instance.reactionCount,
      'book_cover_url': instance.bookCoverUrl,
      'page': instance.page,
    };

_UpdateHighlightVisibilityRequest _$UpdateHighlightVisibilityRequestFromJson(
        Map<String, dynamic> json) =>
    _UpdateHighlightVisibilityRequest(
      visibility: $enumDecode(_$HighlightVisibilityEnumMap, json['visibility']),
    );

Map<String, dynamic> _$UpdateHighlightVisibilityRequestToJson(
        _UpdateHighlightVisibilityRequest instance) =>
    <String, dynamic>{
      'visibility': _$HighlightVisibilityEnumMap[instance.visibility]!,
    };
