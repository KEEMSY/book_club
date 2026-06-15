// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discovery_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecommendedBookDto _$RecommendedBookDtoFromJson(Map<String, dynamic> json) =>
    _RecommendedBookDto(
      book: BookDto.fromJson(json['book'] as Map<String, dynamic>),
      score: (json['score'] as num).toDouble(),
      reason: json['reason'] as String,
      strategy: json['strategy'] as String,
    );

Map<String, dynamic> _$RecommendedBookDtoToJson(_RecommendedBookDto instance) =>
    <String, dynamic>{
      'book': instance.book.toJson(),
      'score': instance.score,
      'reason': instance.reason,
      'strategy': instance.strategy,
    };

_OnboardingInterestDto _$OnboardingInterestDtoFromJson(
        Map<String, dynamic> json) =>
    _OnboardingInterestDto(
      category: json['category'] as String,
      value: json['value'] as String,
    );

Map<String, dynamic> _$OnboardingInterestDtoToJson(
        _OnboardingInterestDto instance) =>
    <String, dynamic>{
      'category': instance.category,
      'value': instance.value,
    };
