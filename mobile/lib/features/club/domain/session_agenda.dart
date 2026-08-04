import 'package:freezed_annotation/freezed_annotation.dart';

import 'agenda_topic.dart';

part 'session_agenda.freezed.dart';
part 'session_agenda.g.dart';

/// Publication state of an agenda (design doc §4.1 `session_agendas.status`).
enum AgendaStatus {
  @JsonValue('draft')
  draft,
  @JsonValue('published')
  published,
}

/// A discussion prompt ("발제문") written by a session's host or presenter.
///
/// Mirrors `session_agendas` from the BC-42 design doc §4.1, with [topics]
/// embedded the way the session-detail endpoint is expected to return them
/// (agenda + its ordered topic list in one payload) — see BC-45.
@freezed
abstract class SessionAgenda with _$SessionAgenda {
  const factory SessionAgenda({
    required String id,
    required String sessionId,
    required String authorId,
    String? authorName,
    required String body,
    required AgendaStatus status,
    DateTime? publishedAt,
    required DateTime createdAt,
    @Default(<AgendaTopic>[]) List<AgendaTopic> topics,
  }) = _SessionAgenda;

  factory SessionAgenda.fromJson(Map<String, dynamic> json) =>
      _$SessionAgendaFromJson(json);
}
