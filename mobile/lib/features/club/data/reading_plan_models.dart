import 'package:freezed_annotation/freezed_annotation.dart';

part 'reading_plan_models.freezed.dart';
part 'reading_plan_models.g.dart';

/// Mirror of the backend reading-plan payload (M52).
///
/// Field names stay camelCase; the global `field_rename: snake` build config
/// maps them to the backend's snake_case keys without per-field annotations.
@freezed
abstract class ReadingPlanDto with _$ReadingPlanDto {
  const factory ReadingPlanDto({
    required String id,
    required String clubId,
    required String bookId,
    required DateTime startDate,
    required DateTime endDate,
    required int weeklyPages,
    required DateTime createdAt,
  }) = _ReadingPlanDto;

  factory ReadingPlanDto.fromJson(Map<String, dynamic> json) =>
      _$ReadingPlanDtoFromJson(json);
}

/// Body for `POST /clubs/{id}/reading-plan`.
///
/// Dates are serialized as `yyyy-MM-dd` strings to match the backend's
/// date-only columns.
@freezed
abstract class CreateReadingPlanRequest with _$CreateReadingPlanRequest {
  const factory CreateReadingPlanRequest({
    required String bookId,
    required String startDate,
    required String endDate,
  }) = _CreateReadingPlanRequest;

  factory CreateReadingPlanRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateReadingPlanRequestFromJson(json);
}

/// Body for `PATCH /clubs/{id}/members/me/progress`.
@freezed
abstract class UpdateProgressRequest with _$UpdateProgressRequest {
  const factory UpdateProgressRequest({
    required int currentPage,
  }) = _UpdateProgressRequest;

  factory UpdateProgressRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateProgressRequestFromJson(json);
}

/// One member's progress entry inside `GET /clubs/{id}/progress`.
@freezed
abstract class MemberProgressDto with _$MemberProgressDto {
  const factory MemberProgressDto({
    required String userId,
    required String nickname,
    required int currentPage,
    required double progressPct,
    DateTime? lastPageUpdatedAt,
  }) = _MemberProgressDto;

  factory MemberProgressDto.fromJson(Map<String, dynamic> json) =>
      _$MemberProgressDtoFromJson(json);
}

/// Mirror of `GET /clubs/{id}/progress`.
@freezed
abstract class ClubProgressDto with _$ClubProgressDto {
  const factory ClubProgressDto({
    ReadingPlanDto? plan,
    @Default([]) List<MemberProgressDto> members,
  }) = _ClubProgressDto;

  factory ClubProgressDto.fromJson(Map<String, dynamic> json) =>
      _$ClubProgressDtoFromJson(json);
}
