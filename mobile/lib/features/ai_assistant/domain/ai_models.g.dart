// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AiPrepCard _$AiPrepCardFromJson(Map<String, dynamic> json) => _AiPrepCard(
      authorIntro: json['author_intro'] as String,
      themeKeywords: (json['theme_keywords'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      prereadingQuestions: (json['prereading_questions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$AiPrepCardToJson(_AiPrepCard instance) =>
    <String, dynamic>{
      'author_intro': instance.authorIntro,
      'theme_keywords': instance.themeKeywords,
      'prereading_questions': instance.prereadingQuestions,
    };

_AiNextBook _$AiNextBookFromJson(Map<String, dynamic> json) => _AiNextBook(
      title: json['title'] as String,
      reason: json['reason'] as String,
    );

Map<String, dynamic> _$AiNextBookToJson(_AiNextBook instance) =>
    <String, dynamic>{
      'title': instance.title,
      'reason': instance.reason,
    };

_AiReflection _$AiReflectionFromJson(Map<String, dynamic> json) =>
    _AiReflection(
      insights:
          (json['insights'] as List<dynamic>).map((e) => e as String).toList(),
      actionPoint: json['action_point'] as String,
      nextBooks: (json['next_books'] as List<dynamic>)
          .map((e) => AiNextBook.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AiReflectionToJson(_AiReflection instance) =>
    <String, dynamic>{
      'insights': instance.insights,
      'action_point': instance.actionPoint,
      'next_books': instance.nextBooks.map((e) => e.toJson()).toList(),
    };

_AiUsage _$AiUsageFromJson(Map<String, dynamic> json) => _AiUsage(
      prepCard: (json['prep_card'] as num?)?.toInt() ?? 0,
      reflection: (json['reflection'] as num?)?.toInt() ?? 0,
      clubTopics: (json['club_topics'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$AiUsageToJson(_AiUsage instance) => <String, dynamic>{
      'prep_card': instance.prepCard,
      'reflection': instance.reflection,
      'club_topics': instance.clubTopics,
    };

_AiPreferences _$AiPreferencesFromJson(Map<String, dynamic> json) =>
    _AiPreferences(
      cardStyle: json['card_style'] as String,
    );

Map<String, dynamic> _$AiPreferencesToJson(_AiPreferences instance) =>
    <String, dynamic>{
      'card_style': instance.cardStyle,
    };

_AiAudioIntro _$AiAudioIntroFromJson(Map<String, dynamic> json) =>
    _AiAudioIntro(
      script: json['script'] as String,
      bookId: json['book_id'] as String,
      tokensUsed: (json['tokens_used'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$AiAudioIntroToJson(_AiAudioIntro instance) =>
    <String, dynamic>{
      'script': instance.script,
      'book_id': instance.bookId,
      'tokens_used': instance.tokensUsed,
    };
