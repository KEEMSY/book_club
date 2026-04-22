/// Lifecycle status of a user-owned [UserBook] entry.
///
/// Wire values mirror the backend `UserBookStatus` enum. New members must
/// stay aligned with `backend/app/domains/book/models.py`. Added to the
/// client as a Dart enum (not a raw String) so UI switches type-check.
enum BookStatus {
  reading,
  completed,
  paused,
  dropped;

  /// Parses a backend wire value. Unknown strings default to [reading] so
  /// a future server-side status added ahead of client release does not
  /// crash the library tab. Log callers that hit the fallback.
  static BookStatus fromWire(String value) {
    switch (value) {
      case 'reading':
        return BookStatus.reading;
      case 'completed':
        return BookStatus.completed;
      case 'paused':
        return BookStatus.paused;
      case 'dropped':
        return BookStatus.dropped;
      default:
        return BookStatus.reading;
    }
  }

  String get wire {
    switch (this) {
      case BookStatus.reading:
        return 'reading';
      case BookStatus.completed:
        return 'completed';
      case BookStatus.paused:
        return 'paused';
      case BookStatus.dropped:
        return 'dropped';
    }
  }

  /// Korean label surfaced on status tabs / pills.
  String get label {
    switch (this) {
      case BookStatus.reading:
        return '읽는 중';
      case BookStatus.completed:
        return '완독';
      case BookStatus.paused:
        return '잠시 멈춤';
      case BookStatus.dropped:
        return '포기';
    }
  }

  /// Empty-state copy for the library tab.
  String get emptyMessage {
    switch (this) {
      case BookStatus.reading:
        return '아직 읽는 중인 책이 없어요';
      case BookStatus.completed:
        return '완독한 책이 없어요';
      case BookStatus.paused:
        return '잠시 멈춘 책이 없어요';
      case BookStatus.dropped:
        return '포기한 책이 없어요';
    }
  }
}
