/// DTOs for the challenge and badge API endpoints.
///
/// Manual fromJson factories are used instead of json_serializable to avoid
/// regenerating the freezed build graph for this domain. The JSON wire format
/// is stable (backend schema) so manual parsing is the safer bet here.
library;

// ---------------------------------------------------------------------------
// Badge
// ---------------------------------------------------------------------------

class BadgeDto {
  const BadgeDto({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    this.iconUrl,
  });

  final String id;
  final String name;
  final String description;

  /// "reading" | "challenge" | "social"
  final String category;
  final String? iconUrl;

  factory BadgeDto.fromJson(Map<String, dynamic> json) {
    return BadgeDto(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      iconUrl: json['icon_url'] as String?,
    );
  }
}

// ---------------------------------------------------------------------------
// Challenge
// ---------------------------------------------------------------------------

class ChallengeDto {
  const ChallengeDto({
    required this.id,
    required this.title,
    this.description,
    required this.challengeType,
    required this.targetValue,
    this.genreFilter,
    required this.startsAt,
    required this.endsAt,
    required this.participantCount,
    required this.isJoined,
    this.myProgress,
    this.achievedAt,
    this.badge,
    this.isLimited = false,
    this.limitedEndsAt,
    this.daysRemaining,
  });

  final String id;
  final String title;
  final String? description;

  /// "books_count" | "reading_time" | "streak" | "genre"
  final String challengeType;
  final int targetValue;
  final String? genreFilter;
  final DateTime startsAt;
  final DateTime endsAt;
  final int participantCount;
  final bool isJoined;
  final int? myProgress;
  final DateTime? achievedAt;
  final BadgeDto? badge;

  /// True when the challenge is a time-limited, scarce event.
  final bool isLimited;

  /// Server-provided end timestamp for limited challenges.
  final DateTime? limitedEndsAt;

  /// Remaining days until a limited challenge ends (null when not limited).
  final int? daysRemaining;

  factory ChallengeDto.fromJson(Map<String, dynamic> json) {
    final badgeJson = json['badge'] as Map<String, dynamic>?;
    return ChallengeDto(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      challengeType: json['challenge_type'] as String,
      targetValue: json['target_value'] as int,
      genreFilter: json['genre_filter'] as String?,
      startsAt: DateTime.parse(json['starts_at'] as String),
      endsAt: DateTime.parse(json['ends_at'] as String),
      participantCount: json['participant_count'] as int,
      isJoined: json['is_joined'] as bool,
      myProgress: json['my_progress'] as int?,
      achievedAt: json['achieved_at'] != null
          ? DateTime.parse(json['achieved_at'] as String)
          : null,
      badge: badgeJson != null ? BadgeDto.fromJson(badgeJson) : null,
      isLimited: (json['is_limited'] as bool?) ?? false,
      limitedEndsAt:
          json['ends_at'] != null && ((json['is_limited'] as bool?) ?? false)
              ? DateTime.tryParse(json['ends_at'] as String)
              : null,
      daysRemaining: json['days_remaining'] as int?,
    );
  }
}

// ---------------------------------------------------------------------------
// Leaderboard
// ---------------------------------------------------------------------------

class LeaderboardEntryDto {
  const LeaderboardEntryDto({
    required this.rank,
    required this.userId,
    this.nickname,
    this.profileImageUrl,
    required this.currentValue,
    this.achievedAt,
  });

  final int rank;
  final String userId;
  final String? nickname;
  final String? profileImageUrl;
  final int currentValue;
  final DateTime? achievedAt;

  factory LeaderboardEntryDto.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntryDto(
      rank: json['rank'] as int,
      userId: json['user_id'] as String,
      nickname: json['nickname'] as String?,
      profileImageUrl: json['profile_image_url'] as String?,
      currentValue: json['current_value'] as int,
      achievedAt: json['achieved_at'] != null
          ? DateTime.parse(json['achieved_at'] as String)
          : null,
    );
  }
}

// ---------------------------------------------------------------------------
// My challenge item
// ---------------------------------------------------------------------------

class MyChallengeDto {
  const MyChallengeDto({
    required this.challenge,
    required this.joinedAt,
    required this.currentValue,
    this.achievedAt,
  });

  final ChallengeDto challenge;
  final DateTime joinedAt;
  final int currentValue;
  final DateTime? achievedAt;

  factory MyChallengeDto.fromJson(Map<String, dynamic> json) {
    return MyChallengeDto(
      challenge:
          ChallengeDto.fromJson(json['challenge'] as Map<String, dynamic>),
      joinedAt: DateTime.parse(json['joined_at'] as String),
      currentValue: json['current_value'] as int,
      achievedAt: json['achieved_at'] != null
          ? DateTime.parse(json['achieved_at'] as String)
          : null,
    );
  }
}

// ---------------------------------------------------------------------------
// Badge earned item
// ---------------------------------------------------------------------------

class BadgeEarnedDto {
  const BadgeEarnedDto({
    required this.badge,
    required this.earnedAt,
    this.isExclusive = false,
  });

  final BadgeDto badge;
  final DateTime earnedAt;

  /// True when the badge was earned via a time-limited exclusive challenge.
  /// Derived from badge_id prefix "badge_id_exclusive" in the API response.
  final bool isExclusive;

  factory BadgeEarnedDto.fromJson(Map<String, dynamic> json) {
    final badge = BadgeDto.fromJson(json['badge'] as Map<String, dynamic>);
    // The API signals exclusivity when the badge id starts with "badge_id_exclusive"
    // or when the response carries an explicit "is_exclusive" field.
    final bool isExclusive = (json['is_exclusive'] as bool?) ??
        badge.id.startsWith('badge_id_exclusive');
    return BadgeEarnedDto(
      badge: badge,
      earnedAt: DateTime.parse(json['earned_at'] as String),
      isExclusive: isExclusive,
    );
  }
}

// ---------------------------------------------------------------------------
// Page / list wrappers
// ---------------------------------------------------------------------------

class ChallengePageDto {
  const ChallengePageDto({required this.items, this.nextCursor});

  final List<ChallengeDto> items;
  final String? nextCursor;

  factory ChallengePageDto.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>;
    return ChallengePageDto(
      items: rawItems
          .map((e) => ChallengeDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextCursor: json['next_cursor'] as String?,
    );
  }
}

class LeaderboardPageDto {
  const LeaderboardPageDto({required this.items});

  final List<LeaderboardEntryDto> items;

  factory LeaderboardPageDto.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>;
    return LeaderboardPageDto(
      items: rawItems
          .map((e) => LeaderboardEntryDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class MyChallengePageDto {
  const MyChallengePageDto({required this.items});

  final List<MyChallengeDto> items;

  factory MyChallengePageDto.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>;
    return MyChallengePageDto(
      items: rawItems
          .map((e) => MyChallengeDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class BadgePageDto {
  const BadgePageDto({required this.items});

  final List<BadgeDto> items;

  factory BadgePageDto.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>;
    return BadgePageDto(
      items: rawItems
          .map((e) => BadgeDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class MyBadgePageDto {
  const MyBadgePageDto({required this.items});

  final List<BadgeEarnedDto> items;

  factory MyBadgePageDto.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>;
    return MyBadgePageDto(
      items: rawItems
          .map((e) => BadgeEarnedDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
