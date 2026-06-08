import 'package:freezed_annotation/freezed_annotation.dart';

part 'club_event.freezed.dart';
part 'club_event.g.dart';

enum RsvpStatus {
  @JsonValue('going')
  going,
  @JsonValue('maybe')
  maybe,
  @JsonValue('not_going')
  notGoing,
}

@freezed
abstract class AttendeeCount with _$AttendeeCount {
  const factory AttendeeCount({
    @Default(0) int going,
    @Default(0) int maybe,
    @Default(0) int notGoing,
  }) = _AttendeeCount;

  factory AttendeeCount.fromJson(Map<String, dynamic> json) =>
      _$AttendeeCountFromJson(json);
}

@freezed
abstract class ClubEvent with _$ClubEvent {
  const factory ClubEvent({
    required String id,
    required String clubId,
    required String title,
    String? description,
    required DateTime eventAt,
    String? location,
    int? maxAttendees,
    required DateTime createdAt,
    @Default(AttendeeCount()) AttendeeCount attendeeCounts,
    RsvpStatus? myStatus,
  }) = _ClubEvent;

  factory ClubEvent.fromJson(Map<String, dynamic> json) =>
      _$ClubEventFromJson(json);
}
