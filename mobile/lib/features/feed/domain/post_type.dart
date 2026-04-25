/// Discriminator for the post composer / list filter.
///
/// Mirrors the backend `Post.post_type` enum (`highlight | thought | question
/// | discussion`). UI maps each variant to a Material Symbols icon and a
/// theme-token tint so the section pills stay theme-adaptive.
enum PostType {
  highlight,
  thought,
  question,
  discussion;

  /// Wire value used by the M4 backend payload.
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
      default:
        return PostType.thought;
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
    }
  }

  /// Composer hint copy that adapts to the selected type.
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
    }
  }
}
