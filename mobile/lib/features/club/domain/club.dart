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
