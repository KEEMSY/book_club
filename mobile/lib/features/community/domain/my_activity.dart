import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_activity.freezed.dart';
part 'my_activity.g.dart';

/// Per-category totals backing the "내 활동" (my activity) dashboard header.
///
/// Mirrors `ActivityCountsPublic` (BC-80 — `backend/app/domains/community/
/// schemas.py`). Each count is the *total* row count for that category; the
/// summary response itself only carries a 5-item preview per category, so
/// "더보기" screens re-fetch the full page from the category's own endpoint.
@freezed
abstract class ActivityCounts with _$ActivityCounts {
  const factory ActivityCounts({
    required int reviews,
    required int highlights,
    required int agendas,
    required int clubs,
    required int readingBooks,
  }) = _ActivityCounts;

  factory ActivityCounts.fromJson(Map<String, dynamic> json) =>
      _$ActivityCountsFromJson(json);
}

/// Preview row for the "내 리뷰" category (mirrors `ActivityReviewItemPublic`).
@freezed
abstract class ActivityReviewItem with _$ActivityReviewItem {
  const factory ActivityReviewItem({
    required String id,
    required String bookId,
    String? bookTitle,
    String? bookCoverUrl,
    required double rating,
    String? body,
    required DateTime createdAt,
  }) = _ActivityReviewItem;

  factory ActivityReviewItem.fromJson(Map<String, dynamic> json) =>
      _$ActivityReviewItemFromJson(json);
}

/// Preview row for the "내 하이라이트" category (mirrors
/// `ActivityHighlightItemPublic`).
@freezed
abstract class ActivityHighlightItem with _$ActivityHighlightItem {
  const factory ActivityHighlightItem({
    required String id,
    required String bookId,
    String? bookTitle,
    String? bookCoverUrl,
    required String quoteText,
    required DateTime createdAt,
  }) = _ActivityHighlightItem;

  factory ActivityHighlightItem.fromJson(Map<String, dynamic> json) =>
      _$ActivityHighlightItemFromJson(json);
}

/// Preview row for the "내 발제문" category (mirrors
/// `ActivityAgendaItemPublic`). [clubId] + [sessionId] are enough to deep-link
/// into `AppRoutes.sessionDetail`.
@freezed
abstract class ActivityAgendaItem with _$ActivityAgendaItem {
  const factory ActivityAgendaItem({
    required String id,
    required String clubId,
    required String clubName,
    required String sessionId,
    required String sessionTitle,
    required String status,
    DateTime? publishedAt,
    required DateTime createdAt,
  }) = _ActivityAgendaItem;

  factory ActivityAgendaItem.fromJson(Map<String, dynamic> json) =>
      _$ActivityAgendaItemFromJson(json);
}

/// Preview row for the "참여 모임" category (mirrors `ActivityClubItemPublic`).
@freezed
abstract class ActivityClubItem with _$ActivityClubItem {
  const factory ActivityClubItem({
    required String id,
    required String name,
    required DateTime createdAt,
  }) = _ActivityClubItem;

  factory ActivityClubItem.fromJson(Map<String, dynamic> json) =>
      _$ActivityClubItemFromJson(json);
}

/// Preview row for the "읽는 중" category (mirrors `ActivityBookItemPublic`).
@freezed
abstract class ActivityBookItem with _$ActivityBookItem {
  const factory ActivityBookItem({
    required String userBookId,
    required String bookId,
    required String title,
    String? coverUrl,
    required int currentChapter,
    DateTime? startedAt,
  }) = _ActivityBookItem;

  factory ActivityBookItem.fromJson(Map<String, dynamic> json) =>
      _$ActivityBookItemFromJson(json);
}

/// `GET /community/me/activity` response (BC-80) — counts plus a newest-first
/// 5-item preview per category. Backs the BC-83 "내 활동" profile section.
@freezed
abstract class MyActivitySummary with _$MyActivitySummary {
  const factory MyActivitySummary({
    required ActivityCounts counts,
    @Default(<ActivityReviewItem>[]) List<ActivityReviewItem> reviews,
    @Default(<ActivityHighlightItem>[]) List<ActivityHighlightItem> highlights,
    @Default(<ActivityAgendaItem>[]) List<ActivityAgendaItem> agendas,
    @Default(<ActivityClubItem>[]) List<ActivityClubItem> clubs,
    @Default(<ActivityBookItem>[]) List<ActivityBookItem> readingBooks,
  }) = _MyActivitySummary;

  factory MyActivitySummary.fromJson(Map<String, dynamic> json) =>
      _$MyActivitySummaryFromJson(json);
}
