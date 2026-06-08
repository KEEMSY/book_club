import 'package:freezed_annotation/freezed_annotation.dart';

part 'club_room.freezed.dart';
part 'club_room.g.dart';

/// A chapter-gated chat room inside a club.
///
/// [progressGate] is the minimum reading-progress percentage (0–100) a member
/// must have reached before they can enter the room. [canEnter] is resolved
/// server-side based on the current user's progress.
@freezed
abstract class ClubRoom with _$ClubRoom {
  const factory ClubRoom({
    required String id,
    required String clubId,
    required String name,
    /// Minimum progress percentage (0–100) required to enter.
    @Default(0) int progressGate,
    required DateTime createdAt,
    /// True when the current user's reading progress meets [progressGate].
    @Default(true) bool canEnter,
  }) = _ClubRoom;

  factory ClubRoom.fromJson(Map<String, dynamic> json) =>
      _$ClubRoomFromJson(json);
}
