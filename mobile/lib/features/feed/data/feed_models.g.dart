// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PostAuthorDto _$PostAuthorDtoFromJson(Map<String, dynamic> json) =>
    _PostAuthorDto(
      id: json['id'] as String,
      nickname: json['nickname'] as String,
      profileImageUrl: json['profile_image_url'] as String?,
    );

Map<String, dynamic> _$PostAuthorDtoToJson(_PostAuthorDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nickname': instance.nickname,
      'profile_image_url': instance.profileImageUrl,
    };

_PostDto _$PostDtoFromJson(Map<String, dynamic> json) => _PostDto(
      id: json['id'] as String,
      bookId: json['book_id'] as String,
      bookTitle: json['book_title'] as String?,
      bookCoverUrl: json['book_cover_url'] as String?,
      user: PostAuthorDto.fromJson(json['user'] as Map<String, dynamic>),
      postType: json['post_type'] as String,
      content: json['content'] as String,
      imageUrls: (json['image_urls'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      reactions: Map<String, int>.from(json['reactions'] as Map),
      myReactions: (json['my_reactions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      commentCount: (json['comment_count'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$PostDtoToJson(_PostDto instance) => <String, dynamic>{
      'id': instance.id,
      'book_id': instance.bookId,
      'book_title': instance.bookTitle,
      'book_cover_url': instance.bookCoverUrl,
      'user': instance.user.toJson(),
      'post_type': instance.postType,
      'content': instance.content,
      'image_urls': instance.imageUrls,
      'reactions': instance.reactions,
      'my_reactions': instance.myReactions,
      'comment_count': instance.commentCount,
      'created_at': instance.createdAt.toIso8601String(),
    };

_PostPageDto _$PostPageDtoFromJson(Map<String, dynamic> json) => _PostPageDto(
      items: (json['items'] as List<dynamic>)
          .map((e) => PostDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextCursor: json['next_cursor'] as String?,
    );

Map<String, dynamic> _$PostPageDtoToJson(_PostPageDto instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'next_cursor': instance.nextCursor,
    };

_CreatePostRequest _$CreatePostRequestFromJson(Map<String, dynamic> json) =>
    _CreatePostRequest(
      bookId: json['book_id'] as String,
      postType: json['post_type'] as String,
      content: json['content'] as String,
      imageKeys: (json['image_keys'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$CreatePostRequestToJson(_CreatePostRequest instance) =>
    <String, dynamic>{
      'book_id': instance.bookId,
      'post_type': instance.postType,
      'content': instance.content,
      'image_keys': instance.imageKeys,
    };

_PresignImageRequest _$PresignImageRequestFromJson(Map<String, dynamic> json) =>
    _PresignImageRequest(
      contentType: json['content_type'] as String,
    );

Map<String, dynamic> _$PresignImageRequestToJson(
        _PresignImageRequest instance) =>
    <String, dynamic>{
      'content_type': instance.contentType,
    };

_PresignImageResponse _$PresignImageResponseFromJson(
        Map<String, dynamic> json) =>
    _PresignImageResponse(
      url: json['url'] as String,
      key: json['key'] as String,
      headers: Map<String, String>.from(json['headers'] as Map),
      expiresIn: (json['expires_in'] as num).toInt(),
    );

Map<String, dynamic> _$PresignImageResponseToJson(
        _PresignImageResponse instance) =>
    <String, dynamic>{
      'url': instance.url,
      'key': instance.key,
      'headers': instance.headers,
      'expires_in': instance.expiresIn,
    };

_ReactionRequest _$ReactionRequestFromJson(Map<String, dynamic> json) =>
    _ReactionRequest(
      reactionType: json['reaction_type'] as String,
    );

Map<String, dynamic> _$ReactionRequestToJson(_ReactionRequest instance) =>
    <String, dynamic>{
      'reaction_type': instance.reactionType,
    };

_ReactionResponse _$ReactionResponseFromJson(Map<String, dynamic> json) =>
    _ReactionResponse(
      state: json['state'] as String,
      counts: Map<String, int>.from(json['counts'] as Map),
    );

Map<String, dynamic> _$ReactionResponseToJson(_ReactionResponse instance) =>
    <String, dynamic>{
      'state': instance.state,
      'counts': instance.counts,
    };

_CommentDto _$CommentDtoFromJson(Map<String, dynamic> json) => _CommentDto(
      id: json['id'] as String,
      user: PostAuthorDto.fromJson(json['user'] as Map<String, dynamic>),
      content: json['content'] as String,
      parentId: json['parent_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$CommentDtoToJson(_CommentDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.user.toJson(),
      'content': instance.content,
      'parent_id': instance.parentId,
      'created_at': instance.createdAt.toIso8601String(),
    };

_CommentPageDto _$CommentPageDtoFromJson(Map<String, dynamic> json) =>
    _CommentPageDto(
      items: (json['items'] as List<dynamic>)
          .map((e) => CommentDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextCursor: json['next_cursor'] as String?,
    );

Map<String, dynamic> _$CommentPageDtoToJson(_CommentPageDto instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'next_cursor': instance.nextCursor,
    };

_CreateCommentRequest _$CreateCommentRequestFromJson(
        Map<String, dynamic> json) =>
    _CreateCommentRequest(
      parentId: json['parent_id'] as String?,
      content: json['content'] as String,
    );

Map<String, dynamic> _$CreateCommentRequestToJson(
        _CreateCommentRequest instance) =>
    <String, dynamic>{
      'parent_id': instance.parentId,
      'content': instance.content,
    };

_HighlightDto _$HighlightDtoFromJson(Map<String, dynamic> json) =>
    _HighlightDto(
      id: json['id'] as String,
      userBookId: json['user_book_id'] as String,
      quoteText: json['quote_text'] as String,
      pageNumber: (json['page_number'] as num?)?.toInt(),
      noteText: json['note_text'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$HighlightDtoToJson(_HighlightDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_book_id': instance.userBookId,
      'quote_text': instance.quoteText,
      'page_number': instance.pageNumber,
      'note_text': instance.noteText,
      'created_at': instance.createdAt.toIso8601String(),
    };

_HighlightPageDto _$HighlightPageDtoFromJson(Map<String, dynamic> json) =>
    _HighlightPageDto(
      items: (json['items'] as List<dynamic>)
          .map((e) => HighlightDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextCursor: json['next_cursor'] as String?,
    );

Map<String, dynamic> _$HighlightPageDtoToJson(_HighlightPageDto instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'next_cursor': instance.nextCursor,
    };

_CreateHighlightRequest _$CreateHighlightRequestFromJson(
        Map<String, dynamic> json) =>
    _CreateHighlightRequest(
      quoteText: json['quote_text'] as String,
      pageNumber: (json['page_number'] as num?)?.toInt(),
      noteText: json['note_text'] as String?,
    );

Map<String, dynamic> _$CreateHighlightRequestToJson(
        _CreateHighlightRequest instance) =>
    <String, dynamic>{
      'quote_text': instance.quoteText,
      'page_number': instance.pageNumber,
      'note_text': instance.noteText,
    };

_BookHighlightGroupDto _$BookHighlightGroupDtoFromJson(
        Map<String, dynamic> json) =>
    _BookHighlightGroupDto(
      userBookId: json['user_book_id'] as String,
      bookId: json['book_id'] as String,
      bookTitle: json['book_title'] as String?,
      bookCoverUrl: json['book_cover_url'] as String?,
      highlights: (json['highlights'] as List<dynamic>)
          .map((e) => HighlightDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BookHighlightGroupDtoToJson(
        _BookHighlightGroupDto instance) =>
    <String, dynamic>{
      'user_book_id': instance.userBookId,
      'book_id': instance.bookId,
      'book_title': instance.bookTitle,
      'book_cover_url': instance.bookCoverUrl,
      'highlights': instance.highlights.map((e) => e.toJson()).toList(),
    };

_AllHighlightsResponseDto _$AllHighlightsResponseDtoFromJson(
        Map<String, dynamic> json) =>
    _AllHighlightsResponseDto(
      groups: (json['groups'] as List<dynamic>)
          .map((e) => BookHighlightGroupDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AllHighlightsResponseDtoToJson(
        _AllHighlightsResponseDto instance) =>
    <String, dynamic>{
      'groups': instance.groups.map((e) => e.toJson()).toList(),
    };
