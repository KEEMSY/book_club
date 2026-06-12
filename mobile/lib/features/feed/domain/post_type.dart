/// Discriminator for the post composer / list filter.
///
/// Mirrors the backend `Post.post_type` enum. The first four variants are
/// user-composed post types; the last four are system-generated activity
/// events surfaced as feed cards (M37).
enum PostType {
  highlight,
  thought,
  question,
  discussion,
  // ── M37 activity-event types (system-generated, not user-composed) ──
  chapterMilestone,
  streakMilestone,
  bookCompleted,
  clubJoined;

  /// Wire value used by the backend payload.
  String get wire {
    switch (this) {
      case PostType.highlight:
        return 'highlight';
      case PostType.thought:
        return 'thought';
      case PostType.question:
        return 'question';
      case PostType.discussion:
        return 'discussion';
      case PostType.chapterMilestone:
        return 'chapter_milestone';
      case PostType.streakMilestone:
        return 'streak_milestone';
      case PostType.bookCompleted:
        return 'book_completed';
      case PostType.clubJoined:
        return 'club_joined';
    }
  }

  /// Parses the backend payload. Unknown values default to [thought] — the
  /// most-permissive bucket — so a future post type added backend-first does
  /// not crash the feed list. UI surfaces the raw label only via [koreanLabel].
  static PostType fromWire(String value) {
    switch (value) {
      case 'highlight':
        return PostType.highlight;
      case 'thought':
        return PostType.thought;
      case 'question':
        return PostType.question;
      case 'discussion':
        return PostType.discussion;
      case 'chapter_milestone':
        return PostType.chapterMilestone;
      case 'streak_milestone':
        return PostType.streakMilestone;
      case 'book_completed':
        return PostType.bookCompleted;
      case 'club_joined':
        return PostType.clubJoined;
      default:
        return PostType.thought;
    }
  }

  /// Whether this type is a system-generated activity event rather than a
  /// user-composed post. Activity cards render with a distinct layout that
  /// omits the composer-entry UI elements (image grid, compose CTA).
  bool get isActivity {
    switch (this) {
      case PostType.chapterMilestone:
      case PostType.streakMilestone:
      case PostType.bookCompleted:
      case PostType.clubJoined:
        return true;
      default:
        return false;
    }
  }

  /// Korean label used inside the type chip and the post-card header.
  String get koreanLabel {
    switch (this) {
      case PostType.highlight:
        return '하이라이트';
      case PostType.thought:
        return '감상';
      case PostType.question:
        return '질문';
      case PostType.discussion:
        return '토론';
      case PostType.chapterMilestone:
        return '챕터 완료';
      case PostType.streakMilestone:
        return '스트릭';
      case PostType.bookCompleted:
        return '완독';
      case PostType.clubJoined:
        return '클럽 참여';
    }
  }

  /// Composer hint copy that adapts to the selected type.
  /// Activity types do not appear in the composer, so they return an empty
  /// string as a safe fallback.
  String get composerHint {
    switch (this) {
      case PostType.highlight:
        return '기억하고 싶은 문장을 남겨보세요';
      case PostType.thought:
        return '이 책이 어떻게 느껴졌나요?';
      case PostType.question:
        return '다른 독자들에게 묻고 싶은 게 있나요?';
      case PostType.discussion:
        return '이 책으로 시작하고 싶은 이야기는?';
      case PostType.chapterMilestone:
      case PostType.streakMilestone:
      case PostType.bookCompleted:
      case PostType.clubJoined:
        return '';
    }
  }
}
