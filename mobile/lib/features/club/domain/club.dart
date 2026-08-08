class Club {
  const Club({
    required this.id,
    required this.name,
    this.description,
    required this.ownerId,
    this.bookId,
    this.bookTitle,
    required this.inviteCode,
    required this.maxMembers,
    required this.memberCount,
    required this.createdAt,
    this.isPublic = false,
    this.category,
    this.tags = const [],
  });

  final String id;
  final String name;
  final String? description;
  final String ownerId;
  final String? bookId;
  final String? bookTitle;
  final String inviteCode;
  final int maxMembers;
  final int memberCount;
  final DateTime createdAt;
  final bool isPublic;
  // M48: category and tags for club discovery
  final String? category;
  final List<String> tags;

  factory Club.fromJson(Map<String, dynamic> json) => Club(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String?,
        ownerId: json['owner_id'] as String,
        bookId: json['book_id'] as String?,
        bookTitle: json['book_title'] as String?,
        inviteCode: json['invite_code'] as String,
        maxMembers: json['max_members'] as int,
        memberCount: json['member_count'] as int,
        createdAt: DateTime.parse(json['created_at'] as String),
        isPublic: json['is_public'] as bool? ?? false,
        category: json['category'] as String?,
        tags: (json['tags'] as List?)?.cast<String>() ?? const [],
      );
}

class ClubEvent {
  const ClubEvent({
    required this.id,
    required this.clubId,
    required this.title,
    this.description,
    required this.eventType,
    this.location,
    required this.scheduledAt,
    required this.createdBy,
    required this.createdAt,
    required this.goingCount,
    required this.maybeCount,
    this.myRsvp,
  });

  final String id;
  final String clubId;
  final String title;
  final String? description;
  final String eventType;
  final String? location;
  final DateTime scheduledAt;
  final String createdBy;
  final DateTime createdAt;
  final int goingCount;
  final int maybeCount;
  final String? myRsvp;

  factory ClubEvent.fromJson(Map<String, dynamic> json) => ClubEvent(
        id: json['id'] as String,
        clubId: json['club_id'] as String,
        title: json['title'] as String,
        description: json['description'] as String?,
        eventType: json['event_type'] as String,
        location: json['location'] as String?,
        scheduledAt: DateTime.parse(json['scheduled_at'] as String),
        createdBy: json['created_by'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
        goingCount: json['going_count'] as int? ?? 0,
        maybeCount: json['maybe_count'] as int? ?? 0,
        myRsvp: json['my_rsvp'] as String?,
      );
}

/// A single row in the caller's own agenda list (BC-80/83 —
/// `GET /clubs/me/agendas`) — mirrors the backend's `MyAgendaItem` schema.
/// Carries [clubName]/[sessionTitle] denormalized so the "내 활동" list and
/// its "더보기" screen can render + deep-link without extra lookups.
class MyAgendaItem {
  const MyAgendaItem({
    required this.id,
    required this.clubId,
    required this.clubName,
    required this.sessionId,
    required this.sessionTitle,
    required this.body,
    required this.status,
    this.publishedAt,
    required this.createdAt,
  });

  final String id;
  final String clubId;
  final String clubName;
  final String sessionId;
  final String sessionTitle;
  final String body;
  final String status;
  final DateTime? publishedAt;
  final DateTime createdAt;

  factory MyAgendaItem.fromJson(Map<String, dynamic> json) => MyAgendaItem(
        id: json['id'] as String,
        clubId: json['club_id'] as String,
        clubName: json['club_name'] as String,
        sessionId: json['session_id'] as String,
        sessionTitle: json['session_title'] as String,
        body: json['body'] as String,
        status: json['status'] as String,
        publishedAt: json['published_at'] != null
            ? DateTime.parse(json['published_at'] as String)
            : null,
        createdAt: DateTime.parse(json['created_at'] as String),
      );
}

/// Page of the caller's own agendas, newest first (`GET /clubs/me/agendas`).
class MyAgendaPage {
  const MyAgendaPage({
    required this.items,
    required this.total,
    required this.hasMore,
  });

  final List<MyAgendaItem> items;
  final int total;
  final bool hasMore;
}
