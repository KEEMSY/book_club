import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_models.freezed.dart';
part 'review_models.g.dart';

/// Data-layer mirror of the backend `ReviewResponse` payload (M54).
///
/// [rating] is a float on a 0.5-step scale (1.0 .. 5.0). [authorNickname] and
/// [authorProfileImageUrl] are optional: the list endpoint enriches reviews
/// with author info, but the create/update single-review responses may omit
/// them, so the UI falls back to a placeholder when absent.
@freezed
abstract class ReviewDto with _$ReviewDto {
  const factory ReviewDto({
    required String id,
    required String userId,
    required String bookId,
    required double rating,
    String? body,
    @Default(0) int reportCount,
    String? authorNickname,
    String? authorProfileImageUrl,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ReviewDto;

  factory ReviewDto.fromJson(Map<String, dynamic> json) =>
      _$ReviewDtoFromJson(json);
}

/// Aggregate view returned by `GET /books/{id}/reviews`.
///
/// [distribution] maps a star bucket ("1".."5") to its count; buckets with no
/// reviews may be omitted by the backend, so consumers default missing keys to
/// zero.
@freezed
abstract class BookReviewSummaryDto with _$BookReviewSummaryDto {
  const factory BookReviewSummaryDto({
    @Default(0.0) double averageRating,
    @Default(0) int ratingCount,
    @Default(<String, int>{}) Map<String, int> distribution,
    @Default(<ReviewDto>[]) List<ReviewDto> reviews,
  }) = _BookReviewSummaryDto;

  factory BookReviewSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$BookReviewSummaryDtoFromJson(json);
}

/// Request body for `POST /books/{id}/reviews`.
@freezed
abstract class CreateReviewRequest with _$CreateReviewRequest {
  const factory CreateReviewRequest({
    required double rating,
    String? body,
  }) = _CreateReviewRequest;

  factory CreateReviewRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateReviewRequestFromJson(json);
}

/// Request body for `PATCH /books/{id}/reviews/me`. Both fields are optional;
/// the repository strips null entries before sending so a partial update never
/// clobbers the unspecified field.
@freezed
abstract class UpdateReviewRequest with _$UpdateReviewRequest {
  const factory UpdateReviewRequest({
    double? rating,
    String? body,
  }) = _UpdateReviewRequest;

  factory UpdateReviewRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateReviewRequestFromJson(json);
}
