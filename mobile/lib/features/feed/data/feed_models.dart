import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/comment.dart';
import '../domain/feed_comment.dart';
import '../domain/feed_event.dart';
import '../domain/feed_reaction.dart';
import '../domain/highlight.dart';
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
abstract class PostAuthorDto with _$PostAuthorDto {
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
abstract class PostDto with _$PostDto {
  const PostDto._();

  const factory PostDto({
    required String id,
    required String bookId,
    String? bookTitle,
    String? bookCoverUrl,
    required PostAuthorDto user,
    required String postType,
    required String content,
    required List<String> imageUrls,
    required Map<String, int> reactions,
    required List<String> myReactions,
    required int commentCount,
    required DateTime createdAt,
    // Structured payload for M37 activity-event cards. Absent for
    // user-composed posts; the JSON key is `metadata`.
    Map<String, dynamic>? metadata,
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
      bookTitle: bookTitle,
      bookCoverUrl: bookCoverUrl,
      user: user.toDomain(),
      postType: PostType.fromWire(postType),
      content: content,
      imageUrls: imageUrls,
      reactions: typedReactions,
      myReactions: typedMine,
      commentCount: commentCount,
      createdAt: createdAt,
      metadata: metadata,
    );
  }
}

/// Envelope for `GET /books/{book_id}/posts` cursor paging.
@freezed
abstract class PostPageDto with _$PostPageDto {
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
abstract class CreatePostRequest with _$CreatePostRequest {
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
abstract class PresignImageRequest with _$PresignImageRequest {
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
abstract class PresignImageResponse with _$PresignImageResponse {
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
abstract class ReactionRequest with _$ReactionRequest {
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
abstract class ReactionResponse with _$ReactionResponse {
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
abstract class CommentDto with _$CommentDto {
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
abstract class CommentPageDto with _$CommentPageDto {
  const factory CommentPageDto({
    required List<CommentDto> items,
    String? nextCursor,
  }) = _CommentPageDto;

  factory CommentPageDto.fromJson(Map<String, dynamic> json) =>
      _$CommentPageDtoFromJson(json);
}

/// Body for `POST /posts/{id}/comments`.
@freezed
abstract class CreateCommentRequest with _$CreateCommentRequest {
  const factory CreateCommentRequest({
    String? parentId,
    required String content,
  }) = _CreateCommentRequest;

  factory CreateCommentRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateCommentRequestFromJson(json);
}

/// Mirror of `HighlightPublic` from the backend.
@freezed
abstract class HighlightDto with _$HighlightDto {
  const HighlightDto._();

  const factory HighlightDto({
    required String id,
    required String userBookId,
    required String quoteText,
    int? pageNumber,
    String? noteText,
    required DateTime createdAt,
  }) = _HighlightDto;

  factory HighlightDto.fromJson(Map<String, dynamic> json) =>
      _$HighlightDtoFromJson(json);

  Highlight toDomain() => Highlight(
        id: id,
        userBookId: userBookId,
        quoteText: quoteText,
        pageNumber: pageNumber,
        noteText: noteText,
        createdAt: createdAt,
      );
}

/// Paginated list response for highlights.
@freezed
abstract class HighlightPageDto with _$HighlightPageDto {
  const HighlightPageDto._();

  const factory HighlightPageDto({
    required List<HighlightDto> items,
    String? nextCursor,
  }) = _HighlightPageDto;

  factory HighlightPageDto.fromJson(Map<String, dynamic> json) =>
      _$HighlightPageDtoFromJson(json);

  HighlightPage toDomain() => HighlightPage(
        items: items.map((HighlightDto h) => h.toDomain()).toList(),
        nextCursor: nextCursor,
      );
}

/// Body for `POST /me/library/{user_book_id}/highlights`.
@freezed
abstract class CreateHighlightRequest with _$CreateHighlightRequest {
  const factory CreateHighlightRequest({
    required String quoteText,
    int? pageNumber,
    String? noteText,
  }) = _CreateHighlightRequest;

  factory CreateHighlightRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateHighlightRequestFromJson(json);
}

/// Mirror of `BookHighlightGroupPublic` from `GET /me/highlights`.
@freezed
abstract class BookHighlightGroupDto with _$BookHighlightGroupDto {
  const BookHighlightGroupDto._();

  const factory BookHighlightGroupDto({
    required String userBookId,
    required String bookId,
    String? bookTitle,
    String? bookCoverUrl,
    required List<HighlightDto> highlights,
  }) = _BookHighlightGroupDto;

  factory BookHighlightGroupDto.fromJson(Map<String, dynamic> json) =>
      _$BookHighlightGroupDtoFromJson(json);
}

/// Envelope for `GET /me/highlights`.
@freezed
abstract class AllHighlightsResponseDto with _$AllHighlightsResponseDto {
  const factory AllHighlightsResponseDto({
    required List<BookHighlightGroupDto> groups,
  }) = _AllHighlightsResponseDto;

  factory AllHighlightsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AllHighlightsResponseDtoFromJson(json);
}

// ─────────────────────────────────────────────────────────────────────────────
// M47 — Feed event DTOs
// ─────────────────────────────────────────────────────────────────────────────

/// Wire representation of a single emoji reaction on a feed event.
///
/// Field names are camelCase; build.yaml `field_rename: snake` maps them to
/// the backend's snake_case JSON keys automatically (`userId` ↔ `user_id`).
@freezed
abstract class FeedReactionDto with _$FeedReactionDto {
  const FeedReactionDto._();

  const factory FeedReactionDto({
    required String id,
    required String emoji,
    required String userId,
    required DateTime createdAt,
  }) = _FeedReactionDto;

  factory FeedReactionDto.fromJson(Map<String, dynamic> json) =>
      _$FeedReactionDtoFromJson(json);

  FeedReaction toDomain() => FeedReaction(
        id: id,
        emoji: emoji,
        userId: userId,
        createdAt: createdAt,
      );
}

/// Wire representation of `FeedEventWithReactions`.
@freezed
abstract class FeedEventDto with _$FeedEventDto {
  const FeedEventDto._();

  const factory FeedEventDto({
    required String id,
    required String userId,
    required String eventType,
    required Map<String, dynamic> eventMetadata,
    required List<FeedReactionDto> reactions,
    required int commentCount,
    required DateTime createdAt,
  }) = _FeedEventDto;

  factory FeedEventDto.fromJson(Map<String, dynamic> json) =>
      _$FeedEventDtoFromJson(json);

  FeedEvent toDomain() => FeedEvent(
        id: id,
        userId: userId,
        eventType: eventType,
        eventMetadata: eventMetadata,
        reactions: reactions.map((r) => r.toDomain()).toList(growable: false),
        commentCount: commentCount,
        createdAt: createdAt,
      );
}

/// Paginated envelope for `GET /feed` and `GET /feed/following`.
@freezed
abstract class FeedEventPageDto with _$FeedEventPageDto {
  const factory FeedEventPageDto({
    required List<FeedEventDto> items,
    String? cursor,
  }) = _FeedEventPageDto;

  factory FeedEventPageDto.fromJson(Map<String, dynamic> json) =>
      _$FeedEventPageDtoFromJson(json);
}

/// Response of `POST /feed/{event_id}/reactions`.
@freezed
abstract class FeedReactionToggleDto with _$FeedReactionToggleDto {
  const FeedReactionToggleDto._();

  const factory FeedReactionToggleDto({
    required bool added,
    required String emoji,
    required int reactionCount,
  }) = _FeedReactionToggleDto;

  factory FeedReactionToggleDto.fromJson(Map<String, dynamic> json) =>
      _$FeedReactionToggleDtoFromJson(json);

  FeedReactionToggleResult toDomain() => FeedReactionToggleResult(
        added: added,
        emoji: emoji,
        reactionCount: reactionCount,
      );
}

/// Wire representation of a `FeedCommentPublic` entry (including nested replies).
@freezed
abstract class FeedCommentDto with _$FeedCommentDto {
  const FeedCommentDto._();

  const factory FeedCommentDto({
    required String id,
    required String body,
    required String userId,
    required String eventId,
    String? parentId,
    required DateTime createdAt,
    @Default(<FeedCommentDto>[]) List<FeedCommentDto> replies,
  }) = _FeedCommentDto;

  factory FeedCommentDto.fromJson(Map<String, dynamic> json) =>
      _$FeedCommentDtoFromJson(json);

  FeedComment toDomain() => FeedComment(
        id: id,
        body: body,
        userId: userId,
        eventId: eventId,
        parentId: parentId,
        createdAt: createdAt,
        replies: replies.map((r) => r.toDomain()).toList(growable: false),
      );
}

/// Envelope for `GET /feed/{event_id}/comments`.
@freezed
abstract class FeedCommentListDto with _$FeedCommentListDto {
  const factory FeedCommentListDto({
    required List<FeedCommentDto> comments,
  }) = _FeedCommentListDto;

  factory FeedCommentListDto.fromJson(Map<String, dynamic> json) =>
      _$FeedCommentListDtoFromJson(json);
}
