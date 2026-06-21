import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_models.freezed.dart';
part 'ai_models.g.dart';

/// Pre-reading prep card from `POST /books/{id}/ai-prep-card`.
///
/// Field names mirror the backend snake_case payload via the global
/// `field_rename: snake` build option (see `build.yaml`).
@freezed
abstract class AiPrepCard with _$AiPrepCard {
  const factory AiPrepCard({
    required String authorIntro,
    required List<String> themeKeywords,
    required List<String> prereadingQuestions,
  }) = _AiPrepCard;

  factory AiPrepCard.fromJson(Map<String, dynamic> json) =>
      _$AiPrepCardFromJson(json);
}

/// A "next book" recommendation embedded in a reflection guide.
@freezed
abstract class AiNextBook with _$AiNextBook {
  const factory AiNextBook({
    required String title,
    required String reason,
  }) = _AiNextBook;

  factory AiNextBook.fromJson(Map<String, dynamic> json) =>
      _$AiNextBookFromJson(json);
}

/// Completion reflection guide from `POST /me/library/{id}/ai-reflection`.
@freezed
abstract class AiReflection with _$AiReflection {
  const factory AiReflection({
    required List<String> insights,
    required String actionPoint,
    required List<AiNextBook> nextBooks,
  }) = _AiReflection;

  factory AiReflection.fromJson(Map<String, dynamic> json) =>
      _$AiReflectionFromJson(json);
}

/// This-month AI usage counts from `GET /me/ai-usage`.
@freezed
abstract class AiUsage with _$AiUsage {
  const factory AiUsage({
    @Default(0) int prepCard,
    @Default(0) int reflection,
    @Default(0) int clubTopics,
  }) = _AiUsage;

  factory AiUsage.fromJson(Map<String, dynamic> json) =>
      _$AiUsageFromJson(json);
}
