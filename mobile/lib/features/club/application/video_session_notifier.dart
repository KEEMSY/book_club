import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../data/video_session_api.dart';
import '../data/video_session_repository.dart';
import '../domain/video_session.dart';

final videoSessionApiProvider = Provider<VideoSessionApi>((ref) {
  return VideoSessionApi(ref.watch(dioProvider));
});

final videoSessionRepositoryProvider = Provider<VideoSessionRepository>((ref) {
  return VideoSessionRepository(ref.watch(videoSessionApiProvider));
});

/// Owns a single club's video-call lifecycle, keyed by club id.
///
/// [build] starts (or re-joins) the session via `POST`, so the screen reads the
/// resulting [VideoSession] (with its Agora credentials) straight off the async
/// state. [leave] ends the session via `DELETE` before the screen pops.
class VideoSessionNotifier
    extends AutoDisposeFamilyAsyncNotifier<VideoSession, String> {
  @override
  Future<VideoSession> build(String clubId) {
    return ref.watch(videoSessionRepositoryProvider).startSession(clubId);
  }

  /// Ends the live session. Best-effort: leaving the call should succeed for
  /// the user even if the end request fails (the host can end it again).
  Future<void> leave() async {
    final VideoSession? session = state.valueOrNull;
    if (session == null) return;
    try {
      await ref.read(videoSessionRepositoryProvider).endSession(
            clubId: arg,
            sessionId: session.id,
          );
    } on VideoSessionException {
      // Swallow — the user is leaving regardless.
    }
  }
}

final videoSessionProvider = AutoDisposeAsyncNotifierProvider.family<
    VideoSessionNotifier, VideoSession, String>(VideoSessionNotifier.new);
