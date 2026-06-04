import '../../club/application/club_chat_notifier.dart';
import '../domain/club.dart';
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

  Future<Club> createClub({
    required String name,
    String? description,
    String? bookId,
    int maxMembers = 10,
  }) async {
    final data = await _api.createClub({
      'name': name,
      if (description != null) 'description': description,
      if (bookId != null) 'book_id': bookId,
      'max_members': maxMembers,
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

  Future<List<ClubEvent>> listEvents(String clubId) async {
    final data = await _api.listEvents(clubId);
    return (data['items'] as List)
        .map((e) => ClubEvent.fromJson(e as Map<String, dynamic>))
        .toList();
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
}
