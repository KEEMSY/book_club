import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/highlight_explore.dart';

part 'highlight_models.freezed.dart';
part 'highlight_models.g.dart';

/// Who can see a highlight (M51).
///
/// Wire names match the backend enum, so json_serializable's default
/// name-based encoding round-trips without a custom converter.
enum HighlightVisibility {
  private,
  followers,
  public,
}

/// Mirror of the backend `HighlightPublic` payload including the M51
/// visibility/share fields. Kept separate from `feed_models.dart`'s
/// library-scoped DTO because the social surface needs book context and the
/// share timestamp.
@freezed
abstract class HighlightDto with _$HighlightDto {
  const factory HighlightDto({
    required String id,
    required String userBookId,
    required String bookId,
    required String bookTitle,
    required String quoteText,
    required HighlightVisibility visibility,
    required DateTime createdAt,
    String? bookCoverUrl,
    int? page,
    DateTime? sharedAt,
  }) = _HighlightDto;

  factory HighlightDto.fromJson(Map<String, dynamic> json) =>
      _$HighlightDtoFromJson(json);
}

/// Mirror of `GET /highlights/explore` items.
@freezed
abstract class HighlightExploreDto with _$HighlightExploreDto {
  const HighlightExploreDto._();

  const factory HighlightExploreDto({
    required String id,
    required String userId,
    required String bookId,
    required String bookTitle,
    required String quoteText,
    required DateTime createdAt,
    @Default(0) int reactionCount,
    String? bookCoverUrl,
    int? page,
  }) = _HighlightExploreDto;

  factory HighlightExploreDto.fromJson(Map<String, dynamic> json) =>
      _$HighlightExploreDtoFromJson(json);

  HighlightExplore toDomain() => HighlightExplore(
        id: id,
        userId: userId,
        bookId: bookId,
        bookTitle: bookTitle,
        quoteText: quoteText,
        createdAt: createdAt,
        reactionCount: reactionCount,
        bookCoverUrl: bookCoverUrl,
        page: page,
      );
}

/// Body for `PATCH /me/highlights/{id}/visibility`.
@freezed
abstract class UpdateHighlightVisibilityRequest
    with _$UpdateHighlightVisibilityRequest {
  const factory UpdateHighlightVisibilityRequest({
    required HighlightVisibility visibility,
  }) = _UpdateHighlightVisibilityRequest;

  factory UpdateHighlightVisibilityRequest.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$UpdateHighlightVisibilityRequestFromJson(json);
}
