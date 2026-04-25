// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostAuthorDtoImpl _$$PostAuthorDtoImplFromJson(Map<String, dynamic> json) =>
    _$PostAuthorDtoImpl(
      id: json['id'] as String,
      nickname: json['nickname'] as String,
      profileImageUrl: json['profile_image_url'] as String?,
    );

Map<String, dynamic> _$$PostAuthorDtoImplToJson(_$PostAuthorDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nickname': instance.nickname,
      'profile_image_url': instance.profileImageUrl,
    };

_$PostDtoImpl _$$PostDtoImplFromJson(Map<String, dynamic> json) =>
    _$PostDtoImpl(
      id: json['id'] as String,
      bookId: json['book_id'] as String,
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

Map<String, dynamic> _$$PostDtoImplToJson(_$PostDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'book_id': instance.bookId,
      'user': instance.user.toJson(),
      'post_type': instance.postType,
      'content': instance.content,
      'image_urls': instance.imageUrls,
      'reactions': instance.reactions,
      'my_reactions': instance.myReactions,
      'comment_count': instance.commentCount,
      'created_at': instance.createdAt.toIso8601String(),
    };

_$PostPageDtoImpl _$$PostPageDtoImplFromJson(Map<String, dynamic> json) =>
    _$PostPageDtoImpl(
      items: (json['items'] as List<dynamic>)
          .map((e) => PostDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextCursor: json['next_cursor'] as String?,
    );

Map<String, dynamic> _$$PostPageDtoImplToJson(_$PostPageDtoImpl instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'next_cursor': instance.nextCursor,
    };

_$CreatePostRequestImpl _$$CreatePostRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreatePostRequestImpl(
      bookId: json['book_id'] as String,
      postType: json['post_type'] as String,
      content: json['content'] as String,
      imageKeys: (json['image_keys'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$CreatePostRequestImplToJson(
        _$CreatePostRequestImpl instance) =>
    <String, dynamic>{
      'book_id': instance.bookId,
      'post_type': instance.postType,
      'content': instance.content,
      'image_keys': instance.imageKeys,
    };

_$PresignImageRequestImpl _$$PresignImageRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$PresignImageRequestImpl(
      contentType: json['content_type'] as String,
    );

Map<String, dynamic> _$$PresignImageRequestImplToJson(
        _$PresignImageRequestImpl instance) =>
    <String, dynamic>{
      'content_type': instance.contentType,
    };

_$PresignImageResponseImpl _$$PresignImageResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$PresignImageResponseImpl(
      url: json['url'] as String,
      key: json['key'] as String,
      headers: Map<String, String>.from(json['headers'] as Map),
      expiresIn: (json['expires_in'] as num).toInt(),
    );

Map<String, dynamic> _$$PresignImageResponseImplToJson(
        _$PresignImageResponseImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'key': instance.key,
      'headers': instance.headers,
      'expires_in': instance.expiresIn,
    };

_$ReactionRequestImpl _$$ReactionRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$ReactionRequestImpl(
      reactionType: json['reaction_type'] as String,
    );

Map<String, dynamic> _$$ReactionRequestImplToJson(
        _$ReactionRequestImpl instance) =>
    <String, dynamic>{
      'reaction_type': instance.reactionType,
    };

_$ReactionResponseImpl _$$ReactionResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$ReactionResponseImpl(
      state: json['state'] as String,
      counts: Map<String, int>.from(json['counts'] as Map),
    );

Map<String, dynamic> _$$ReactionResponseImplToJson(
        _$ReactionResponseImpl instance) =>
    <String, dynamic>{
      'state': instance.state,
      'counts': instance.counts,
    };

_$CommentDtoImpl _$$CommentDtoImplFromJson(Map<String, dynamic> json) =>
    _$CommentDtoImpl(
      id: json['id'] as String,
      user: PostAuthorDto.fromJson(json['user'] as Map<String, dynamic>),
      content: json['content'] as String,
      parentId: json['parent_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$CommentDtoImplToJson(_$CommentDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.user.toJson(),
      'content': instance.content,
      'parent_id': instance.parentId,
      'created_at': instance.createdAt.toIso8601String(),
    };

_$CommentPageDtoImpl _$$CommentPageDtoImplFromJson(Map<String, dynamic> json) =>
    _$CommentPageDtoImpl(
      items: (json['items'] as List<dynamic>)
          .map((e) => CommentDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextCursor: json['next_cursor'] as String?,
    );

Map<String, dynamic> _$$CommentPageDtoImplToJson(
        _$CommentPageDtoImpl instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'next_cursor': instance.nextCursor,
    };

_$CreateCommentRequestImpl _$$CreateCommentRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateCommentRequestImpl(
      parentId: json['parent_id'] as String?,
      content: json['content'] as String,
    );

Map<String, dynamic> _$$CreateCommentRequestImplToJson(
        _$CreateCommentRequestImpl instance) =>
    <String, dynamic>{
      'parent_id': instance.parentId,
      'content': instance.content,
    };
