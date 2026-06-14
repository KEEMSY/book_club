import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_result.freezed.dart';
part 'search_result.g.dart';

// Field names use Dart camelCase conventions. The global build.yaml
// `field_rename: snake` option handles the JSON ↔ Dart mapping automatically,
// so no @JsonKey annotations are needed.

@freezed
abstract class BookSearchItem with _$BookSearchItem {
  const factory BookSearchItem({
    required String id,
    required String title,
    required String author,
    String? thumbnailUrl,
  }) = _BookSearchItem;

  factory BookSearchItem.fromJson(Map<String, dynamic> json) =>
      _$BookSearchItemFromJson(json);
}

@freezed
abstract class UserSearchItem with _$UserSearchItem {
  const factory UserSearchItem({
    required String id,
    required String nickname,
    String? avatarUrl,
  }) = _UserSearchItem;

  factory UserSearchItem.fromJson(Map<String, dynamic> json) =>
      _$UserSearchItemFromJson(json);
}

@freezed
abstract class ClubSearchItem with _$ClubSearchItem {
  const factory ClubSearchItem({
    required String id,
    required String name,
    required int memberCount,
    String? currentBookTitle,
  }) = _ClubSearchItem;

  factory ClubSearchItem.fromJson(Map<String, dynamic> json) =>
      _$ClubSearchItemFromJson(json);
}

@freezed
abstract class SearchResult with _$SearchResult {
  const factory SearchResult({
    required List<BookSearchItem> books,
    required List<UserSearchItem> users,
    required List<ClubSearchItem> clubs,
  }) = _SearchResult;

  factory SearchResult.fromJson(Map<String, dynamic> json) =>
      _$SearchResultFromJson(json);
}
