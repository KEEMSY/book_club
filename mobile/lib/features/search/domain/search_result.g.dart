// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BookSearchItem _$BookSearchItemFromJson(Map<String, dynamic> json) =>
    _BookSearchItem(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      thumbnailUrl: json['thumbnail_url'] as String?,
    );

Map<String, dynamic> _$BookSearchItemToJson(_BookSearchItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'author': instance.author,
      'thumbnail_url': instance.thumbnailUrl,
    };

_UserSearchItem _$UserSearchItemFromJson(Map<String, dynamic> json) =>
    _UserSearchItem(
      id: json['id'] as String,
      nickname: json['nickname'] as String,
      avatarUrl: json['avatar_url'] as String?,
    );

Map<String, dynamic> _$UserSearchItemToJson(_UserSearchItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nickname': instance.nickname,
      'avatar_url': instance.avatarUrl,
    };

_ClubSearchItem _$ClubSearchItemFromJson(Map<String, dynamic> json) =>
    _ClubSearchItem(
      id: json['id'] as String,
      name: json['name'] as String,
      memberCount: (json['member_count'] as num).toInt(),
      currentBookTitle: json['current_book_title'] as String?,
    );

Map<String, dynamic> _$ClubSearchItemToJson(_ClubSearchItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'member_count': instance.memberCount,
      'current_book_title': instance.currentBookTitle,
    };

_SearchResult _$SearchResultFromJson(Map<String, dynamic> json) =>
    _SearchResult(
      books: (json['books'] as List<dynamic>)
          .map((e) => BookSearchItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      users: (json['users'] as List<dynamic>)
          .map((e) => UserSearchItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      clubs: (json['clubs'] as List<dynamic>)
          .map((e) => ClubSearchItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SearchResultToJson(_SearchResult instance) =>
    <String, dynamic>{
      'books': instance.books.map((e) => e.toJson()).toList(),
      'users': instance.users.map((e) => e.toJson()).toList(),
      'clubs': instance.clubs.map((e) => e.toJson()).toList(),
    };
