import 'package:freezed_annotation/freezed_annotation.dart';

import '../../book/data/book_models.dart';
import '../domain/recommended_book.dart';

part 'discovery_models.freezed.dart';
part 'discovery_models.g.dart';

/// Data-layer mirror of the backend `RecommendedBook` response payload.
///
/// The nested [book] is mapped from `BookPublic`; [score], [reason], and
/// [strategy] are the ML-metadata fields added in M44.
@freezed
abstract class RecommendedBookDto with _$RecommendedBookDto {
  const RecommendedBookDto._();

  const factory RecommendedBookDto({
    required BookDto book,
    required double score,
    required String reason,
    required String strategy,
  }) = _RecommendedBookDto;

  factory RecommendedBookDto.fromJson(Map<String, dynamic> json) =>
      _$RecommendedBookDtoFromJson(json);

  RecommendedBook toDomain() => RecommendedBook(
        id: book.id,
        title: book.title,
        author: book.author,
        coverUrl: book.coverUrl,
        score: score,
        reason: reason,
        strategy: strategy,
      );
}

/// Request body for `POST /me/onboarding/interests`.
@freezed
abstract class OnboardingInterestDto with _$OnboardingInterestDto {
  const factory OnboardingInterestDto({
    required String category,
    required String value,
  }) = _OnboardingInterestDto;

  factory OnboardingInterestDto.fromJson(Map<String, dynamic> json) =>
      _$OnboardingInterestDtoFromJson(json);
}
