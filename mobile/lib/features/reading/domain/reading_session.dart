import 'package:freezed_annotation/freezed_annotation.dart';

part 'reading_session.freezed.dart';

/// Source of a [ReadingSession] — `timer` is an official record, `manual`
/// only feeds book-count / personal logs per design §5.1.
enum ReadingSessionSource {
  timer,
  manual;

  static ReadingSessionSource fromWire(String value) {
    switch (value) {
      case 'timer':
        return ReadingSessionSource.timer;
      case 'manual':
        return ReadingSessionSource.manual;
      default:
        return ReadingSessionSource.timer;
    }
  }

  String get wire {
    switch (this) {
      case ReadingSessionSource.timer:
        return 'timer';
      case ReadingSessionSource.manual:
        return 'manual';
    }
  }
}

/// Domain-layer projection of `ReadingSessionPublic`. [endedAt] and
/// [durationSec] are null while the session is still running.
@freezed
class ReadingSession with _$ReadingSession {
  const factory ReadingSession({
    required String id,
    required String userBookId,
    required DateTime startedAt,
    required ReadingSessionSource source,
    DateTime? endedAt,
    int? durationSec,
  }) = _ReadingSession;
}
