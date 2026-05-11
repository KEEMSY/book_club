import 'package:freezed_annotation/freezed_annotation.dart';

part 'highlight.freezed.dart';

@freezed
class Highlight with _$Highlight {
  const factory Highlight({
    required String id,
    required String userBookId,
    required String quoteText,
    int? pageNumber,
    String? noteText,
    required DateTime createdAt,
  }) = _Highlight;
}

@freezed
class HighlightPage with _$HighlightPage {
  const factory HighlightPage({
    required List<Highlight> items,
    String? nextCursor,
  }) = _HighlightPage;
}
