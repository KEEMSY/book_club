import 'package:flutter_tts/flutter_tts.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/ai_repository.dart';
import '../domain/ai_models.dart';
import 'ai_providers.dart';

part 'ai_audio_intro_service.g.dart';

/// Fetches the Claude-generated reading intro for a book and speaks it with the
/// device's built-in TTS engine (M67 audio reading coach). No external TTS API
/// is used — the script comes from the backend, the voice from the OS.
class AiAudioIntroService {
  AiAudioIntroService(this._repo, {FlutterTts? tts})
      : _tts = tts ?? FlutterTts();

  final AiRepository _repo;
  final FlutterTts _tts;

  /// Requests the intro script for [bookId] and plays it aloud in Korean.
  ///
  /// Returns the spoken script so the caller can surface it; throws
  /// [AiRepositoryException] when the request fails (rate limit, no key, …).
  Future<String> playIntro(String bookId) async {
    final AiAudioIntro intro = await _repo.getAudioIntro(bookId);
    await _tts.setLanguage('ko-KR');
    await _tts.speak(intro.script);
    return intro.script;
  }

  /// Stops any in-progress playback (e.g. when the sheet/screen is dismissed).
  Future<void> stop() => _tts.stop();
}

/// Session-scoped audio coach — one TTS engine reused across plays.
@Riverpod(keepAlive: true)
AiAudioIntroService aiAudioIntroService(AiAudioIntroServiceRef ref) {
  return AiAudioIntroService(ref.watch(aiRepositoryProvider));
}
