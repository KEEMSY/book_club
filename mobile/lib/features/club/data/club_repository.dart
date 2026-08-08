import '../../club/application/club_chat_notifier.dart';
import '../domain/club.dart';
import '../domain/club_event.dart' as event_domain;
import '../domain/club_room.dart';
import 'club_api.dart';

class ClubRepository {
  ClubRepository(this._api);

  final ClubApi _api;

  Future<List<Club>> listMyClubs() async {
    final data = await _api.listMyClubs();
    return (data['items'] as List)
        .map((e) => Club.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// 내 활동 > 내 발제문 (BC-80/83), 최신순 페이지네이션.
  Future<MyAgendaPage> listMyAgendas({int limit = 20, int offset = 0}) async {
    final data = await _api.listMyAgendas(limit: limit, offset: offset);
    final map = data as Map<String, dynamic>;
    final items = (map['items'] as List? ?? [])
        .map((e) => MyAgendaItem.fromJson(e as Map<String, dynamic>))
        .toList();
    return MyAgendaPage(
      items: items,
      total: map['total'] as int? ?? items.length,
      hasMore: map['has_more'] as bool? ?? false,
    );
  }

  Future<Club> createClub({
    required String name,
    String? description,
    String? bookId,
    int maxMembers = 10,
    bool isPublic = false,
    String? category,
    List<String> tags = const [],
  }) async {
    final data = await _api.createClub({
      'name': name,
      if (description != null) 'description': description,
      if (bookId != null) 'book_id': bookId,
      'max_members': maxMembers,
      'is_public': isPublic,
      if (category != null) 'category': category,
      if (tags.isNotEmpty) 'tags': tags,
    });
    return Club.fromJson(data);
  }

  Future<Club> getClub(String clubId) async {
    final data = await _api.getClub(clubId);
    return Club.fromJson(data);
  }

  Future<Club> joinClub(String inviteCode) async {
    final data = await _api.joinClub({'invite_code': inviteCode});
    return Club.fromJson(data);
  }

  Future<void> leaveClub(String clubId) => _api.leaveClub(clubId);

  /// Legacy helper used by [_ClubEventsTab] in club_detail_screen.
  Future<List<ClubEvent>> listEventsFull(String clubId) async {
    final data = await _api.listEvents(clubId);
    return (data['items'] as List)
        .map((e) => ClubEvent.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// M30: returns the new freezed [event_domain.ClubEvent] for [ClubEventsScreen].
  Future<List<event_domain.ClubEvent>> listEvents(String clubId) async {
    final data = await _api.listEvents(clubId);
    final items = data['items'] as List? ?? [];
    return items
        .map((e) => _mapToClubEvent(e as Map<String, dynamic>))
        .toList();
  }

  event_domain.ClubEvent _mapToClubEvent(Map<String, dynamic> json) {
    final goingCount = json['going_count'] as int? ?? 0;
    final maybeCount = json['maybe_count'] as int? ?? 0;
    final notGoingCount = json['not_going_count'] as int? ?? 0;

    final countsJson = json['attendee_counts'];
    final event_domain.AttendeeCount counts;
    if (countsJson is Map<String, dynamic>) {
      counts = event_domain.AttendeeCount.fromJson(countsJson);
    } else {
      counts = event_domain.AttendeeCount(
        going: goingCount,
        maybe: maybeCount,
        notGoing: notGoingCount,
      );
    }

    event_domain.RsvpStatus? myStatus;
    final rawRsvp = json['my_rsvp'] as String?;
    if (rawRsvp != null) {
      myStatus = switch (rawRsvp) {
        'going' => event_domain.RsvpStatus.going,
        'maybe' => event_domain.RsvpStatus.maybe,
        'not_going' || 'notGoing' => event_domain.RsvpStatus.notGoing,
        _ => null,
      };
    }

    // Support both 'event_at' and legacy 'scheduled_at' field names.
    final rawEventAt =
        (json['event_at'] ?? json['scheduled_at']) as String? ?? '';

    return event_domain.ClubEvent(
      id: json['id'] as String,
      clubId: json['club_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      eventAt: DateTime.parse(rawEventAt),
      location: json['location'] as String?,
      maxAttendees: json['max_attendees'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
      attendeeCounts: counts,
      myStatus: myStatus,
    );
  }

  Future<event_domain.ClubEvent> createEventV2(
    String clubId, {
    required String title,
    String? description,
    String? location,
    required DateTime eventAt,
    int? maxAttendees,
  }) async {
    final data = await _api.createEvent(clubId, {
      'title': title,
      if (description != null) 'description': description,
      if (location != null) 'location': location,
      'event_at': eventAt.toIso8601String(),
      if (maxAttendees != null) 'max_attendees': maxAttendees,
      // Legacy field kept for backend compat until migration is complete.
      'scheduled_at': eventAt.toIso8601String(),
      'event_type': 'offline',
    });
    return _mapToClubEvent(data as Map<String, dynamic>);
  }

  Future<ClubEvent> createEvent(
    String clubId, {
    required String title,
    String? description,
    required String eventType,
    String? location,
    required DateTime scheduledAt,
  }) async {
    final data = await _api.createEvent(clubId, {
      'title': title,
      if (description != null) 'description': description,
      'event_type': eventType,
      if (location != null) 'location': location,
      'scheduled_at': scheduledAt.toIso8601String(),
    });
    return ClubEvent.fromJson(data);
  }

  Future<void> rsvp(String clubId, String eventId, String status) =>
      _api.rsvp(clubId, eventId, {'status': status});

  /// Fetches historical messages before [cursor]. Returns the messages in
  /// chronological order (oldest first) and an optional [nextCursor] for the
  /// next older page.
  Future<({List<ChatMessage> messages, String? nextCursor})> listMessages(
    String clubId, {
    String? cursor,
  }) async {
    final data = await _api.listMessages(clubId, cursor: cursor);
    final items = (data['items'] as List)
        .whereType<Map<String, dynamic>>()
        .map(ChatMessage.fromJson)
        .toList();
    final nextCursor = data['next_cursor'] as String?;
    return (messages: items, nextCursor: nextCursor);
  }

  Future<void> deleteMessage(String clubId, String messageId) =>
      _api.deleteMessage(clubId, messageId);

  Future<List<ClubRoom>> listRooms(String clubId) async {
    final data = await _api.listRooms(clubId);
    final items = (data as Map<String, dynamic>)['rooms'] as List? ?? [];
    return items
        .map((e) => ClubRoom.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ClubRoom> createRoom(
    String clubId, {
    required String name,
    int progressGate = 0,
  }) async {
    final data = await _api.createRoom(clubId, {
      'name': name,
      'progress_gate': progressGate,
    });
    return ClubRoom.fromJson(data as Map<String, dynamic>);
  }

  Future<void> deleteRoom(String clubId, String roomId) =>
      _api.deleteRoom(clubId, roomId);

  Future<Club> setClubBook(String clubId, {String? bookId}) async {
    final data = await _api.setClubBook(clubId, {'book_id': bookId});
    return Club.fromJson(data as Map<String, dynamic>);
  }

  Future<List<Club>> listPublicClubs({
    String? search,
    String? category,
    String? tag,
    String sort = 'newest',
    String? cursor,
  }) async {
    final data = await _api.listPublicClubs(
      search: search,
      category: category,
      tag: tag,
      sort: sort,
      cursor: cursor,
    );
    final items = (data['items'] as List? ?? []);
    return items.map((e) => Club.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Club>> getRecommendedClubs() async {
    final data = await _api.getRecommendedClubs();
    final items = (data['items'] as List? ?? []);
    return items.map((e) => Club.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Club> joinPublicClub(String clubId) async {
    final data = await _api.joinPublicClub(clubId);
    return Club.fromJson(data as Map<String, dynamic>);
  }
}
