import 'package:freezed_annotation/freezed_annotation.dart';

part 'club_session.freezed.dart';
part 'club_session.g.dart';

/// Lifecycle of a club session (BC-42 §4.1 `club_sessions.status`).
///
/// `draft` — created but not yet visible to members as an active round.
/// `open` — accepting/hosting discussion for its agenda.
/// `closed` — discussion wrapped up; still readable, no longer active.
enum ClubSessionStatus {
  @JsonValue('draft')
  draft,
  @JsonValue('open')
  open,
  @JsonValue('closed')
  closed,
}

/// A single discussion round ("회차") within a club, scoped to one book.
///
/// Mirrors `club_sessions` from the BC-42 design doc
/// (`docs/plans/2026-08-04-club-agenda-discussion-design.md` §4.1). The
/// paid-tier hook columns (`access_tier`, `price_cents`) are intentionally
/// omitted here — this epic reads/writes neither (§4.2).
@freezed
abstract class ClubSession with _$ClubSession {
  const factory ClubSession({
    required String id,
    required String clubId,
    required String bookId,

    /// Denormalized for list/detail display, same convention as
    /// [Club.bookTitle] — avoids a second round-trip per session card.
    String? bookTitle,
    required String title,

    /// Free-text chapter/page range (design doc: "챕터/페이지 범위").
    String? scope,
    String? presenterId,
    String? presenterName,
    DateTime? scheduledAt,
    required ClubSessionStatus status,
    required DateTime createdAt,
  }) = _ClubSession;

  factory ClubSession.fromJson(Map<String, dynamic> json) =>
      _$ClubSessionFromJson(json);
}
