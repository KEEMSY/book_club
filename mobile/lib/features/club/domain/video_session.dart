import 'package:freezed_annotation/freezed_annotation.dart';

part 'video_session.freezed.dart';
part 'video_session.g.dart';

/// A reading-club video call (M68).
///
/// `POST /clubs/{id}/video-sessions` returns the session plus join credentials
/// ([agoraToken], [channel]); `GET .../active` returns the same shape without
/// the token fields, so both are nullable.
@freezed
abstract class VideoSession with _$VideoSession {
  const factory VideoSession({
    required String id,
    required String clubId,
    required String hostId,
    required String agoraChannel,
    required int maxParticipants,
    required DateTime startedAt,
    DateTime? endedAt,
    String? agoraToken,
    String? channel,
  }) = _VideoSession;

  factory VideoSession.fromJson(Map<String, dynamic> json) =>
      _$VideoSessionFromJson(json);
}
