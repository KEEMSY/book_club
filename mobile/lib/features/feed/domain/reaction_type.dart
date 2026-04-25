/// 5-way reaction set — server enforces exactly these values.
///
/// Backend response `reactions` is a `Map<reactionType, count>`; the mobile
/// side iterates [ReactionType.values] in display order so the bar render is
/// deterministic regardless of map iteration order on the wire.
enum ReactionType {
  idea,
  fire,
  think,
  clap,
  heart;

  String get wire {
    switch (this) {
      case ReactionType.idea:
        return 'idea';
      case ReactionType.fire:
        return 'fire';
      case ReactionType.think:
        return 'think';
      case ReactionType.clap:
        return 'clap';
      case ReactionType.heart:
        return 'heart';
    }
  }

  /// Parses the backend payload. Unknown values fall back to [idea] so a new
  /// reaction added backend-first cannot crash the feed render path. The
  /// fallback never enters the toggle path because the composer only sends
  /// values from this enum.
  static ReactionType fromWire(String value) {
    switch (value) {
      case 'idea':
        return ReactionType.idea;
      case 'fire':
        return ReactionType.fire;
      case 'think':
        return ReactionType.think;
      case 'clap':
        return ReactionType.clap;
      case 'heart':
        return ReactionType.heart;
      default:
        return ReactionType.idea;
    }
  }
}
