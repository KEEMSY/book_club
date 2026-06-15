import 'package:freezed_annotation/freezed_annotation.dart';

part 'curation_card.freezed.dart';
part 'curation_card.g.dart';

/// A single AI-generated curation card shown to the user before a reading
/// session starts. [cardType] drives the icon/label displayed in the sheet.
///
/// Known [cardType] values: `intro`, `guide`, `context`, `quote`.
@freezed
abstract class CurationCard with _$CurationCard {
  const factory CurationCard({
    required String id,
    required String bookId,
    required String cardType,
    required String title,
    required String body,
    required int orderIndex,
  }) = _CurationCard;

  factory CurationCard.fromJson(Map<String, dynamic> json) =>
      _$CurationCardFromJson(json);
}
