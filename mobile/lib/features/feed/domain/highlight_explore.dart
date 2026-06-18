import 'package:freezed_annotation/freezed_annotation.dart';

part 'highlight_explore.freezed.dart';

/// A publicly shared highlight surfaced in the explore feed (M51).
///
/// Distinct from [Highlight]: it carries the originating book and an
/// aggregate reaction count for ranking, but omits the owner-only note since
/// only the quote is shared publicly.
@freezed
abstract class HighlightExplore with _$HighlightExplore {
  const factory HighlightExplore({
    required String id,
    required String bookId,
    required String bookTitle,
    required String quoteText,
    required DateTime createdAt,
    required int reactionCount,
    String? userId,
    String? bookCoverUrl,
    int? page,
  }) = _HighlightExplore;
}
