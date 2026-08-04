import 'package:freezed_annotation/freezed_annotation.dart';

part 'agenda_topic.freezed.dart';
part 'agenda_topic.g.dart';

/// A single discussion question inside an agenda ("논제").
///
/// Mirrors `agenda_topics` from the BC-42 design doc §4.1. [position] is the
/// display order set by the agenda author (host/presenter); reply count and
/// preview are UI-layer aggregates computed from [TopicComment]s, not part
/// of this wire model.
@freezed
abstract class AgendaTopic with _$AgendaTopic {
  const factory AgendaTopic({
    required String id,
    required String agendaId,
    required int position,
    required String prompt,
    required DateTime createdAt,
  }) = _AgendaTopic;

  factory AgendaTopic.fromJson(Map<String, dynamic> json) =>
      _$AgendaTopicFromJson(json);
}
