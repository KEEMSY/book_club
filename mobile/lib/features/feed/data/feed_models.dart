import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/comment.dart';
import '../domain/post.dart';
import '../domain/post_author.dart';
import '../domain/post_type.dart';
import '../domain/reaction_type.dart';

part 'feed_models.freezed.dart';
part 'feed_models.g.dart';

/// Mirror of the embedded `user` object inside `PostPublic` and
/// `CommentPublic`. Kept as its own DTO so both domain models can share the
/// same JSON parser without duplicating field-rename annotations.
@freezed
class PostAuthorDto with _$PostAuthorDto {
  const PostAuthorDto._();

  const factory PostAuthorDto({
    required String id,
    required String nickname,
    String? profileImageUrl,
  }) = _PostAuthorDto;

  factory PostAuthorDto.fromJson(Map<String, dynamic> json) =>
      _$PostAuthorDtoFromJson(json);

  PostAuthor toDomain() => PostAuthor(
        id: id,
        nickname: nickname,
        profileImageUrl: profileImageUrl,
      );
}

/// Mirror of `PostPublic`. [reactions] is a `Map<String, int>` on the wire
/// because backend keys are wire enum values; conversion to typed
/// [ReactionType] keys happens inside [PostDto.toDomain].
@freezed
class PostDto with _$PostDto {
  const PostDto._();

  const factory PostDto({
    required String id,
    required String bookId,
    required PostAuthorDto user,
    required String postType,
    required String content,
    required List<String> imageUrls,
    required Map<String, int> reactions,
    required List<String> myReactions,
    required int commentCount,
    required DateTime createdAt,
  }) = _PostDto;

  factory PostDto.fromJson(Map<String, dynamic> json) =>
      _$PostDtoFromJson(json);

  Post toDomain() {
    final Map<ReactionType, int> typedReactions = <ReactionType, int>{};
    reactions.forEach((String wire, int count) {
      typedReactions[ReactionType.fromWire(wire)] = count;
    });
    final Set<ReactionType> typedMine =
        myReactions.map(ReactionType.fromWire).toSet();
    return Post(
      id: id,
      bookId: bookId,
      user: user.toDomain(),
      postType: PostType.fromWire(postType),
      content: content,
      imageUrls: imageUrls,
      reactions: typedReactions,
      myReactions: typedMine,
      commentCount: commentCount,
      createdAt: createdAt,
    );
  }
}

/// Envelope for `GET /books/{book_id}/posts` cursor paging.
@freezed
class PostPageDto with _$PostPageDto {
  const factory PostPageDto({
    required List<PostDto> items,
    String? nextCursor,
  }) = _PostPageDto;

  factory PostPageDto.fromJson(Map<String, dynamic> json) =>
      _$PostPageDtoFromJson(json);
}

/// Body for `POST /books/{book_id}/posts`. [bookId] is duplicated in the body
/// per the M4 contract (also in the path) — backend validates equality.
@freezed
class CreatePostRequest with _$CreatePostRequest {
  const factory CreatePostRequest({
    required String bookId,
    required String postType,
    required String content,
    required List<String> imageKeys,
  }) = _CreatePostRequest;

  factory CreatePostRequest.fromJson(Map<String, dynamic> json) =>
      _$CreatePostRequestFromJson(json);
}

/// Body for `POST /uploads/presign-image`. Only the content type is sent;
/// the server picks the bucket key + signed URL.
@freezed
class PresignImageRequest with _$PresignImageRequest {
  const factory PresignImageRequest({
    required String contentType,
  }) = _PresignImageRequest;

  factory PresignImageRequest.fromJson(Map<String, dynamic> json) =>
      _$PresignImageRequestFromJson(json);
}

/// Response of `POST /uploads/presign-image`. [headers] is the exact set the
/// client must echo on the subsequent PUT (R2 signs both the URL and the
/// `Content-Type` header).
@freezed
class PresignImageResponse with _$PresignImageResponse {
  const factory PresignImageResponse({
    required String url,
    required String key,
    required Map<String, String> headers,
    required int expiresIn,
  }) = _PresignImageResponse;

  factory PresignImageResponse.fromJson(Map<String, dynamic> json) =>
      _$PresignImageResponseFromJson(json);
}

/// Body for `POST /posts/{id}/reactions`.
@freezed
class ReactionRequest with _$ReactionRequest {
  const factory ReactionRequest({
    required String reactionType,
  }) = _ReactionRequest;

  factory ReactionRequest.fromJson(Map<String, dynamic> json) =>
      _$ReactionRequestFromJson(json);
}

/// Response of `POST /posts/{id}/reactions`. [counts] always carries every
/// reaction type the post currently has — zero counts may be omitted by the
/// server, so the repository fills missing keys with 0 before returning.
@freezed
class ReactionResponse with _$ReactionResponse {
  const ReactionResponse._();

  const factory ReactionResponse({
    required String state,
    required Map<String, int> counts,
  }) = _ReactionResponse;

  factory ReactionResponse.fromJson(Map<String, dynamic> json) =>
      _$ReactionResponseFromJson(json);

  ReactionToggleResult toDomain() {
    final Map<ReactionType, int> typed = <ReactionType, int>{};
    counts.forEach((String wire, int count) {
      typed[ReactionType.fromWire(wire)] = count;
    });
    return ReactionToggleResult(
      state: ReactionToggleState.fromWire(state),
      counts: typed,
    );
  }
}

/// Mirror of `CommentPublic`.
@freezed
class CommentDto with _$CommentDto {
  const CommentDto._();

  const factory CommentDto({
    required String id,
    required PostAuthorDto user,
    required String content,
    String? parentId,
    required DateTime createdAt,
  }) = _CommentDto;

  factory CommentDto.fromJson(Map<String, dynamic> json) =>
      _$CommentDtoFromJson(json);

  Comment toDomain() => Comment(
        id: id,
        user: user.toDomain(),
        content: content,
        parentId: parentId,
        createdAt: createdAt,
      );
}

/// Envelope for `GET /posts/{id}/comments`.
@freezed
class CommentPageDto with _$CommentPageDto {
  const factory CommentPageDto({
    required List<CommentDto> items,
    String? nextCursor,
  }) = _CommentPageDto;

  factory CommentPageDto.fromJson(Map<String, dynamic> json) =>
      _$CommentPageDtoFromJson(json);
}

/// Body for `POST /posts/{id}/comments`.
@freezed
class CreateCommentRequest with _$CreateCommentRequest {
  const factory CreateCommentRequest({
    String? parentId,
    required String content,
  }) = _CreateCommentRequest;

  factory CreateCommentRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateCommentRequestFromJson(json);
}
