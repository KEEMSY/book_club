// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PostAuthorDto _$PostAuthorDtoFromJson(Map<String, dynamic> json) {
  return _PostAuthorDto.fromJson(json);
}

/// @nodoc
mixin _$PostAuthorDto {
  String get id => throw _privateConstructorUsedError;
  String get nickname => throw _privateConstructorUsedError;
  String? get profileImageUrl => throw _privateConstructorUsedError;

  /// Serializes this PostAuthorDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PostAuthorDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostAuthorDtoCopyWith<PostAuthorDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostAuthorDtoCopyWith<$Res> {
  factory $PostAuthorDtoCopyWith(
          PostAuthorDto value, $Res Function(PostAuthorDto) then) =
      _$PostAuthorDtoCopyWithImpl<$Res, PostAuthorDto>;
  @useResult
  $Res call({String id, String nickname, String? profileImageUrl});
}

/// @nodoc
class _$PostAuthorDtoCopyWithImpl<$Res, $Val extends PostAuthorDto>
    implements $PostAuthorDtoCopyWith<$Res> {
  _$PostAuthorDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PostAuthorDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nickname = null,
    Object? profileImageUrl = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PostAuthorDtoImplCopyWith<$Res>
    implements $PostAuthorDtoCopyWith<$Res> {
  factory _$$PostAuthorDtoImplCopyWith(
          _$PostAuthorDtoImpl value, $Res Function(_$PostAuthorDtoImpl) then) =
      __$$PostAuthorDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String nickname, String? profileImageUrl});
}

/// @nodoc
class __$$PostAuthorDtoImplCopyWithImpl<$Res>
    extends _$PostAuthorDtoCopyWithImpl<$Res, _$PostAuthorDtoImpl>
    implements _$$PostAuthorDtoImplCopyWith<$Res> {
  __$$PostAuthorDtoImplCopyWithImpl(
      _$PostAuthorDtoImpl _value, $Res Function(_$PostAuthorDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of PostAuthorDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nickname = null,
    Object? profileImageUrl = freezed,
  }) {
    return _then(_$PostAuthorDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PostAuthorDtoImpl extends _PostAuthorDto {
  const _$PostAuthorDtoImpl(
      {required this.id, required this.nickname, this.profileImageUrl})
      : super._();

  factory _$PostAuthorDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostAuthorDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String nickname;
  @override
  final String? profileImageUrl;

  @override
  String toString() {
    return 'PostAuthorDto(id: $id, nickname: $nickname, profileImageUrl: $profileImageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostAuthorDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, nickname, profileImageUrl);

  /// Create a copy of PostAuthorDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostAuthorDtoImplCopyWith<_$PostAuthorDtoImpl> get copyWith =>
      __$$PostAuthorDtoImplCopyWithImpl<_$PostAuthorDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PostAuthorDtoImplToJson(
      this,
    );
  }
}

abstract class _PostAuthorDto extends PostAuthorDto {
  const factory _PostAuthorDto(
      {required final String id,
      required final String nickname,
      final String? profileImageUrl}) = _$PostAuthorDtoImpl;
  const _PostAuthorDto._() : super._();

  factory _PostAuthorDto.fromJson(Map<String, dynamic> json) =
      _$PostAuthorDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get nickname;
  @override
  String? get profileImageUrl;

  /// Create a copy of PostAuthorDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostAuthorDtoImplCopyWith<_$PostAuthorDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PostDto _$PostDtoFromJson(Map<String, dynamic> json) {
  return _PostDto.fromJson(json);
}

/// @nodoc
mixin _$PostDto {
  String get id => throw _privateConstructorUsedError;
  String get bookId => throw _privateConstructorUsedError;
  PostAuthorDto get user => throw _privateConstructorUsedError;
  String get postType => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  List<String> get imageUrls => throw _privateConstructorUsedError;
  Map<String, int> get reactions => throw _privateConstructorUsedError;
  List<String> get myReactions => throw _privateConstructorUsedError;
  int get commentCount => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this PostDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PostDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostDtoCopyWith<PostDto> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostDtoCopyWith<$Res> {
  factory $PostDtoCopyWith(PostDto value, $Res Function(PostDto) then) =
      _$PostDtoCopyWithImpl<$Res, PostDto>;
  @useResult
  $Res call(
      {String id,
      String bookId,
      PostAuthorDto user,
      String postType,
      String content,
      List<String> imageUrls,
      Map<String, int> reactions,
      List<String> myReactions,
      int commentCount,
      DateTime createdAt});

  $PostAuthorDtoCopyWith<$Res> get user;
}

/// @nodoc
class _$PostDtoCopyWithImpl<$Res, $Val extends PostDto>
    implements $PostDtoCopyWith<$Res> {
  _$PostDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PostDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bookId = null,
    Object? user = null,
    Object? postType = null,
    Object? content = null,
    Object? imageUrls = null,
    Object? reactions = null,
    Object? myReactions = null,
    Object? commentCount = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      bookId: null == bookId
          ? _value.bookId
          : bookId // ignore: cast_nullable_to_non_nullable
              as String,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as PostAuthorDto,
      postType: null == postType
          ? _value.postType
          : postType // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrls: null == imageUrls
          ? _value.imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      reactions: null == reactions
          ? _value.reactions
          : reactions // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      myReactions: null == myReactions
          ? _value.myReactions
          : myReactions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      commentCount: null == commentCount
          ? _value.commentCount
          : commentCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  /// Create a copy of PostDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PostAuthorDtoCopyWith<$Res> get user {
    return $PostAuthorDtoCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PostDtoImplCopyWith<$Res> implements $PostDtoCopyWith<$Res> {
  factory _$$PostDtoImplCopyWith(
          _$PostDtoImpl value, $Res Function(_$PostDtoImpl) then) =
      __$$PostDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String bookId,
      PostAuthorDto user,
      String postType,
      String content,
      List<String> imageUrls,
      Map<String, int> reactions,
      List<String> myReactions,
      int commentCount,
      DateTime createdAt});

  @override
  $PostAuthorDtoCopyWith<$Res> get user;
}

/// @nodoc
class __$$PostDtoImplCopyWithImpl<$Res>
    extends _$PostDtoCopyWithImpl<$Res, _$PostDtoImpl>
    implements _$$PostDtoImplCopyWith<$Res> {
  __$$PostDtoImplCopyWithImpl(
      _$PostDtoImpl _value, $Res Function(_$PostDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of PostDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bookId = null,
    Object? user = null,
    Object? postType = null,
    Object? content = null,
    Object? imageUrls = null,
    Object? reactions = null,
    Object? myReactions = null,
    Object? commentCount = null,
    Object? createdAt = null,
  }) {
    return _then(_$PostDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      bookId: null == bookId
          ? _value.bookId
          : bookId // ignore: cast_nullable_to_non_nullable
              as String,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as PostAuthorDto,
      postType: null == postType
          ? _value.postType
          : postType // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrls: null == imageUrls
          ? _value._imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      reactions: null == reactions
          ? _value._reactions
          : reactions // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      myReactions: null == myReactions
          ? _value._myReactions
          : myReactions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      commentCount: null == commentCount
          ? _value.commentCount
          : commentCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PostDtoImpl extends _PostDto {
  const _$PostDtoImpl(
      {required this.id,
      required this.bookId,
      required this.user,
      required this.postType,
      required this.content,
      required final List<String> imageUrls,
      required final Map<String, int> reactions,
      required final List<String> myReactions,
      required this.commentCount,
      required this.createdAt})
      : _imageUrls = imageUrls,
        _reactions = reactions,
        _myReactions = myReactions,
        super._();

  factory _$PostDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String bookId;
  @override
  final PostAuthorDto user;
  @override
  final String postType;
  @override
  final String content;
  final List<String> _imageUrls;
  @override
  List<String> get imageUrls {
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageUrls);
  }

  final Map<String, int> _reactions;
  @override
  Map<String, int> get reactions {
    if (_reactions is EqualUnmodifiableMapView) return _reactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_reactions);
  }

  final List<String> _myReactions;
  @override
  List<String> get myReactions {
    if (_myReactions is EqualUnmodifiableListView) return _myReactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_myReactions);
  }

  @override
  final int commentCount;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'PostDto(id: $id, bookId: $bookId, user: $user, postType: $postType, content: $content, imageUrls: $imageUrls, reactions: $reactions, myReactions: $myReactions, commentCount: $commentCount, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.bookId, bookId) || other.bookId == bookId) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.postType, postType) ||
                other.postType == postType) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality()
                .equals(other._imageUrls, _imageUrls) &&
            const DeepCollectionEquality()
                .equals(other._reactions, _reactions) &&
            const DeepCollectionEquality()
                .equals(other._myReactions, _myReactions) &&
            (identical(other.commentCount, commentCount) ||
                other.commentCount == commentCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      bookId,
      user,
      postType,
      content,
      const DeepCollectionEquality().hash(_imageUrls),
      const DeepCollectionEquality().hash(_reactions),
      const DeepCollectionEquality().hash(_myReactions),
      commentCount,
      createdAt);

  /// Create a copy of PostDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostDtoImplCopyWith<_$PostDtoImpl> get copyWith =>
      __$$PostDtoImplCopyWithImpl<_$PostDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PostDtoImplToJson(
      this,
    );
  }
}

abstract class _PostDto extends PostDto {
  const factory _PostDto(
      {required final String id,
      required final String bookId,
      required final PostAuthorDto user,
      required final String postType,
      required final String content,
      required final List<String> imageUrls,
      required final Map<String, int> reactions,
      required final List<String> myReactions,
      required final int commentCount,
      required final DateTime createdAt}) = _$PostDtoImpl;
  const _PostDto._() : super._();

  factory _PostDto.fromJson(Map<String, dynamic> json) = _$PostDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get bookId;
  @override
  PostAuthorDto get user;
  @override
  String get postType;
  @override
  String get content;
  @override
  List<String> get imageUrls;
  @override
  Map<String, int> get reactions;
  @override
  List<String> get myReactions;
  @override
  int get commentCount;
  @override
  DateTime get createdAt;

  /// Create a copy of PostDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostDtoImplCopyWith<_$PostDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PostPageDto _$PostPageDtoFromJson(Map<String, dynamic> json) {
  return _PostPageDto.fromJson(json);
}

/// @nodoc
mixin _$PostPageDto {
  List<PostDto> get items => throw _privateConstructorUsedError;
  String? get nextCursor => throw _privateConstructorUsedError;

  /// Serializes this PostPageDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PostPageDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostPageDtoCopyWith<PostPageDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostPageDtoCopyWith<$Res> {
  factory $PostPageDtoCopyWith(
          PostPageDto value, $Res Function(PostPageDto) then) =
      _$PostPageDtoCopyWithImpl<$Res, PostPageDto>;
  @useResult
  $Res call({List<PostDto> items, String? nextCursor});
}

/// @nodoc
class _$PostPageDtoCopyWithImpl<$Res, $Val extends PostPageDto>
    implements $PostPageDtoCopyWith<$Res> {
  _$PostPageDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PostPageDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? nextCursor = freezed,
  }) {
    return _then(_value.copyWith(
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<PostDto>,
      nextCursor: freezed == nextCursor
          ? _value.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PostPageDtoImplCopyWith<$Res>
    implements $PostPageDtoCopyWith<$Res> {
  factory _$$PostPageDtoImplCopyWith(
          _$PostPageDtoImpl value, $Res Function(_$PostPageDtoImpl) then) =
      __$$PostPageDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<PostDto> items, String? nextCursor});
}

/// @nodoc
class __$$PostPageDtoImplCopyWithImpl<$Res>
    extends _$PostPageDtoCopyWithImpl<$Res, _$PostPageDtoImpl>
    implements _$$PostPageDtoImplCopyWith<$Res> {
  __$$PostPageDtoImplCopyWithImpl(
      _$PostPageDtoImpl _value, $Res Function(_$PostPageDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of PostPageDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? nextCursor = freezed,
  }) {
    return _then(_$PostPageDtoImpl(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<PostDto>,
      nextCursor: freezed == nextCursor
          ? _value.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PostPageDtoImpl implements _PostPageDto {
  const _$PostPageDtoImpl({required final List<PostDto> items, this.nextCursor})
      : _items = items;

  factory _$PostPageDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PostPageDtoImplFromJson(json);

  final List<PostDto> _items;
  @override
  List<PostDto> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final String? nextCursor;

  @override
  String toString() {
    return 'PostPageDto(items: $items, nextCursor: $nextCursor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostPageDtoImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_items), nextCursor);

  /// Create a copy of PostPageDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostPageDtoImplCopyWith<_$PostPageDtoImpl> get copyWith =>
      __$$PostPageDtoImplCopyWithImpl<_$PostPageDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PostPageDtoImplToJson(
      this,
    );
  }
}

abstract class _PostPageDto implements PostPageDto {
  const factory _PostPageDto(
      {required final List<PostDto> items,
      final String? nextCursor}) = _$PostPageDtoImpl;

  factory _PostPageDto.fromJson(Map<String, dynamic> json) =
      _$PostPageDtoImpl.fromJson;

  @override
  List<PostDto> get items;
  @override
  String? get nextCursor;

  /// Create a copy of PostPageDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostPageDtoImplCopyWith<_$PostPageDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreatePostRequest _$CreatePostRequestFromJson(Map<String, dynamic> json) {
  return _CreatePostRequest.fromJson(json);
}

/// @nodoc
mixin _$CreatePostRequest {
  String get bookId => throw _privateConstructorUsedError;
  String get postType => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  List<String> get imageKeys => throw _privateConstructorUsedError;

  /// Serializes this CreatePostRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreatePostRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreatePostRequestCopyWith<CreatePostRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreatePostRequestCopyWith<$Res> {
  factory $CreatePostRequestCopyWith(
          CreatePostRequest value, $Res Function(CreatePostRequest) then) =
      _$CreatePostRequestCopyWithImpl<$Res, CreatePostRequest>;
  @useResult
  $Res call(
      {String bookId, String postType, String content, List<String> imageKeys});
}

/// @nodoc
class _$CreatePostRequestCopyWithImpl<$Res, $Val extends CreatePostRequest>
    implements $CreatePostRequestCopyWith<$Res> {
  _$CreatePostRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreatePostRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookId = null,
    Object? postType = null,
    Object? content = null,
    Object? imageKeys = null,
  }) {
    return _then(_value.copyWith(
      bookId: null == bookId
          ? _value.bookId
          : bookId // ignore: cast_nullable_to_non_nullable
              as String,
      postType: null == postType
          ? _value.postType
          : postType // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      imageKeys: null == imageKeys
          ? _value.imageKeys
          : imageKeys // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreatePostRequestImplCopyWith<$Res>
    implements $CreatePostRequestCopyWith<$Res> {
  factory _$$CreatePostRequestImplCopyWith(_$CreatePostRequestImpl value,
          $Res Function(_$CreatePostRequestImpl) then) =
      __$$CreatePostRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String bookId, String postType, String content, List<String> imageKeys});
}

/// @nodoc
class __$$CreatePostRequestImplCopyWithImpl<$Res>
    extends _$CreatePostRequestCopyWithImpl<$Res, _$CreatePostRequestImpl>
    implements _$$CreatePostRequestImplCopyWith<$Res> {
  __$$CreatePostRequestImplCopyWithImpl(_$CreatePostRequestImpl _value,
      $Res Function(_$CreatePostRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreatePostRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookId = null,
    Object? postType = null,
    Object? content = null,
    Object? imageKeys = null,
  }) {
    return _then(_$CreatePostRequestImpl(
      bookId: null == bookId
          ? _value.bookId
          : bookId // ignore: cast_nullable_to_non_nullable
              as String,
      postType: null == postType
          ? _value.postType
          : postType // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      imageKeys: null == imageKeys
          ? _value._imageKeys
          : imageKeys // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreatePostRequestImpl implements _CreatePostRequest {
  const _$CreatePostRequestImpl(
      {required this.bookId,
      required this.postType,
      required this.content,
      required final List<String> imageKeys})
      : _imageKeys = imageKeys;

  factory _$CreatePostRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreatePostRequestImplFromJson(json);

  @override
  final String bookId;
  @override
  final String postType;
  @override
  final String content;
  final List<String> _imageKeys;
  @override
  List<String> get imageKeys {
    if (_imageKeys is EqualUnmodifiableListView) return _imageKeys;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageKeys);
  }

  @override
  String toString() {
    return 'CreatePostRequest(bookId: $bookId, postType: $postType, content: $content, imageKeys: $imageKeys)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreatePostRequestImpl &&
            (identical(other.bookId, bookId) || other.bookId == bookId) &&
            (identical(other.postType, postType) ||
                other.postType == postType) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality()
                .equals(other._imageKeys, _imageKeys));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, bookId, postType, content,
      const DeepCollectionEquality().hash(_imageKeys));

  /// Create a copy of CreatePostRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreatePostRequestImplCopyWith<_$CreatePostRequestImpl> get copyWith =>
      __$$CreatePostRequestImplCopyWithImpl<_$CreatePostRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreatePostRequestImplToJson(
      this,
    );
  }
}

abstract class _CreatePostRequest implements CreatePostRequest {
  const factory _CreatePostRequest(
      {required final String bookId,
      required final String postType,
      required final String content,
      required final List<String> imageKeys}) = _$CreatePostRequestImpl;

  factory _CreatePostRequest.fromJson(Map<String, dynamic> json) =
      _$CreatePostRequestImpl.fromJson;

  @override
  String get bookId;
  @override
  String get postType;
  @override
  String get content;
  @override
  List<String> get imageKeys;

  /// Create a copy of CreatePostRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreatePostRequestImplCopyWith<_$CreatePostRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PresignImageRequest _$PresignImageRequestFromJson(Map<String, dynamic> json) {
  return _PresignImageRequest.fromJson(json);
}

/// @nodoc
mixin _$PresignImageRequest {
  String get contentType => throw _privateConstructorUsedError;

  /// Serializes this PresignImageRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PresignImageRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PresignImageRequestCopyWith<PresignImageRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PresignImageRequestCopyWith<$Res> {
  factory $PresignImageRequestCopyWith(
          PresignImageRequest value, $Res Function(PresignImageRequest) then) =
      _$PresignImageRequestCopyWithImpl<$Res, PresignImageRequest>;
  @useResult
  $Res call({String contentType});
}

/// @nodoc
class _$PresignImageRequestCopyWithImpl<$Res, $Val extends PresignImageRequest>
    implements $PresignImageRequestCopyWith<$Res> {
  _$PresignImageRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PresignImageRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contentType = null,
  }) {
    return _then(_value.copyWith(
      contentType: null == contentType
          ? _value.contentType
          : contentType // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PresignImageRequestImplCopyWith<$Res>
    implements $PresignImageRequestCopyWith<$Res> {
  factory _$$PresignImageRequestImplCopyWith(_$PresignImageRequestImpl value,
          $Res Function(_$PresignImageRequestImpl) then) =
      __$$PresignImageRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String contentType});
}

/// @nodoc
class __$$PresignImageRequestImplCopyWithImpl<$Res>
    extends _$PresignImageRequestCopyWithImpl<$Res, _$PresignImageRequestImpl>
    implements _$$PresignImageRequestImplCopyWith<$Res> {
  __$$PresignImageRequestImplCopyWithImpl(_$PresignImageRequestImpl _value,
      $Res Function(_$PresignImageRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of PresignImageRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contentType = null,
  }) {
    return _then(_$PresignImageRequestImpl(
      contentType: null == contentType
          ? _value.contentType
          : contentType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PresignImageRequestImpl implements _PresignImageRequest {
  const _$PresignImageRequestImpl({required this.contentType});

  factory _$PresignImageRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$PresignImageRequestImplFromJson(json);

  @override
  final String contentType;

  @override
  String toString() {
    return 'PresignImageRequest(contentType: $contentType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PresignImageRequestImpl &&
            (identical(other.contentType, contentType) ||
                other.contentType == contentType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, contentType);

  /// Create a copy of PresignImageRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PresignImageRequestImplCopyWith<_$PresignImageRequestImpl> get copyWith =>
      __$$PresignImageRequestImplCopyWithImpl<_$PresignImageRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PresignImageRequestImplToJson(
      this,
    );
  }
}

abstract class _PresignImageRequest implements PresignImageRequest {
  const factory _PresignImageRequest({required final String contentType}) =
      _$PresignImageRequestImpl;

  factory _PresignImageRequest.fromJson(Map<String, dynamic> json) =
      _$PresignImageRequestImpl.fromJson;

  @override
  String get contentType;

  /// Create a copy of PresignImageRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PresignImageRequestImplCopyWith<_$PresignImageRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PresignImageResponse _$PresignImageResponseFromJson(Map<String, dynamic> json) {
  return _PresignImageResponse.fromJson(json);
}

/// @nodoc
mixin _$PresignImageResponse {
  String get url => throw _privateConstructorUsedError;
  String get key => throw _privateConstructorUsedError;
  Map<String, String> get headers => throw _privateConstructorUsedError;
  int get expiresIn => throw _privateConstructorUsedError;

  /// Serializes this PresignImageResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PresignImageResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PresignImageResponseCopyWith<PresignImageResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PresignImageResponseCopyWith<$Res> {
  factory $PresignImageResponseCopyWith(PresignImageResponse value,
          $Res Function(PresignImageResponse) then) =
      _$PresignImageResponseCopyWithImpl<$Res, PresignImageResponse>;
  @useResult
  $Res call(
      {String url, String key, Map<String, String> headers, int expiresIn});
}

/// @nodoc
class _$PresignImageResponseCopyWithImpl<$Res,
        $Val extends PresignImageResponse>
    implements $PresignImageResponseCopyWith<$Res> {
  _$PresignImageResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PresignImageResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? key = null,
    Object? headers = null,
    Object? expiresIn = null,
  }) {
    return _then(_value.copyWith(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      headers: null == headers
          ? _value.headers
          : headers // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      expiresIn: null == expiresIn
          ? _value.expiresIn
          : expiresIn // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PresignImageResponseImplCopyWith<$Res>
    implements $PresignImageResponseCopyWith<$Res> {
  factory _$$PresignImageResponseImplCopyWith(_$PresignImageResponseImpl value,
          $Res Function(_$PresignImageResponseImpl) then) =
      __$$PresignImageResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String url, String key, Map<String, String> headers, int expiresIn});
}

/// @nodoc
class __$$PresignImageResponseImplCopyWithImpl<$Res>
    extends _$PresignImageResponseCopyWithImpl<$Res, _$PresignImageResponseImpl>
    implements _$$PresignImageResponseImplCopyWith<$Res> {
  __$$PresignImageResponseImplCopyWithImpl(_$PresignImageResponseImpl _value,
      $Res Function(_$PresignImageResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of PresignImageResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? url = null,
    Object? key = null,
    Object? headers = null,
    Object? expiresIn = null,
  }) {
    return _then(_$PresignImageResponseImpl(
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      headers: null == headers
          ? _value._headers
          : headers // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      expiresIn: null == expiresIn
          ? _value.expiresIn
          : expiresIn // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PresignImageResponseImpl implements _PresignImageResponse {
  const _$PresignImageResponseImpl(
      {required this.url,
      required this.key,
      required final Map<String, String> headers,
      required this.expiresIn})
      : _headers = headers;

  factory _$PresignImageResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PresignImageResponseImplFromJson(json);

  @override
  final String url;
  @override
  final String key;
  final Map<String, String> _headers;
  @override
  Map<String, String> get headers {
    if (_headers is EqualUnmodifiableMapView) return _headers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_headers);
  }

  @override
  final int expiresIn;

  @override
  String toString() {
    return 'PresignImageResponse(url: $url, key: $key, headers: $headers, expiresIn: $expiresIn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PresignImageResponseImpl &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.key, key) || other.key == key) &&
            const DeepCollectionEquality().equals(other._headers, _headers) &&
            (identical(other.expiresIn, expiresIn) ||
                other.expiresIn == expiresIn));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, url, key,
      const DeepCollectionEquality().hash(_headers), expiresIn);

  /// Create a copy of PresignImageResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PresignImageResponseImplCopyWith<_$PresignImageResponseImpl>
      get copyWith =>
          __$$PresignImageResponseImplCopyWithImpl<_$PresignImageResponseImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PresignImageResponseImplToJson(
      this,
    );
  }
}

abstract class _PresignImageResponse implements PresignImageResponse {
  const factory _PresignImageResponse(
      {required final String url,
      required final String key,
      required final Map<String, String> headers,
      required final int expiresIn}) = _$PresignImageResponseImpl;

  factory _PresignImageResponse.fromJson(Map<String, dynamic> json) =
      _$PresignImageResponseImpl.fromJson;

  @override
  String get url;
  @override
  String get key;
  @override
  Map<String, String> get headers;
  @override
  int get expiresIn;

  /// Create a copy of PresignImageResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PresignImageResponseImplCopyWith<_$PresignImageResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

ReactionRequest _$ReactionRequestFromJson(Map<String, dynamic> json) {
  return _ReactionRequest.fromJson(json);
}

/// @nodoc
mixin _$ReactionRequest {
  String get reactionType => throw _privateConstructorUsedError;

  /// Serializes this ReactionRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReactionRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReactionRequestCopyWith<ReactionRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReactionRequestCopyWith<$Res> {
  factory $ReactionRequestCopyWith(
          ReactionRequest value, $Res Function(ReactionRequest) then) =
      _$ReactionRequestCopyWithImpl<$Res, ReactionRequest>;
  @useResult
  $Res call({String reactionType});
}

/// @nodoc
class _$ReactionRequestCopyWithImpl<$Res, $Val extends ReactionRequest>
    implements $ReactionRequestCopyWith<$Res> {
  _$ReactionRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReactionRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reactionType = null,
  }) {
    return _then(_value.copyWith(
      reactionType: null == reactionType
          ? _value.reactionType
          : reactionType // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReactionRequestImplCopyWith<$Res>
    implements $ReactionRequestCopyWith<$Res> {
  factory _$$ReactionRequestImplCopyWith(_$ReactionRequestImpl value,
          $Res Function(_$ReactionRequestImpl) then) =
      __$$ReactionRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String reactionType});
}

/// @nodoc
class __$$ReactionRequestImplCopyWithImpl<$Res>
    extends _$ReactionRequestCopyWithImpl<$Res, _$ReactionRequestImpl>
    implements _$$ReactionRequestImplCopyWith<$Res> {
  __$$ReactionRequestImplCopyWithImpl(
      _$ReactionRequestImpl _value, $Res Function(_$ReactionRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReactionRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reactionType = null,
  }) {
    return _then(_$ReactionRequestImpl(
      reactionType: null == reactionType
          ? _value.reactionType
          : reactionType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReactionRequestImpl implements _ReactionRequest {
  const _$ReactionRequestImpl({required this.reactionType});

  factory _$ReactionRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReactionRequestImplFromJson(json);

  @override
  final String reactionType;

  @override
  String toString() {
    return 'ReactionRequest(reactionType: $reactionType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReactionRequestImpl &&
            (identical(other.reactionType, reactionType) ||
                other.reactionType == reactionType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, reactionType);

  /// Create a copy of ReactionRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReactionRequestImplCopyWith<_$ReactionRequestImpl> get copyWith =>
      __$$ReactionRequestImplCopyWithImpl<_$ReactionRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReactionRequestImplToJson(
      this,
    );
  }
}

abstract class _ReactionRequest implements ReactionRequest {
  const factory _ReactionRequest({required final String reactionType}) =
      _$ReactionRequestImpl;

  factory _ReactionRequest.fromJson(Map<String, dynamic> json) =
      _$ReactionRequestImpl.fromJson;

  @override
  String get reactionType;

  /// Create a copy of ReactionRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReactionRequestImplCopyWith<_$ReactionRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReactionResponse _$ReactionResponseFromJson(Map<String, dynamic> json) {
  return _ReactionResponse.fromJson(json);
}

/// @nodoc
mixin _$ReactionResponse {
  String get state => throw _privateConstructorUsedError;
  Map<String, int> get counts => throw _privateConstructorUsedError;

  /// Serializes this ReactionResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReactionResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReactionResponseCopyWith<ReactionResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReactionResponseCopyWith<$Res> {
  factory $ReactionResponseCopyWith(
          ReactionResponse value, $Res Function(ReactionResponse) then) =
      _$ReactionResponseCopyWithImpl<$Res, ReactionResponse>;
  @useResult
  $Res call({String state, Map<String, int> counts});
}

/// @nodoc
class _$ReactionResponseCopyWithImpl<$Res, $Val extends ReactionResponse>
    implements $ReactionResponseCopyWith<$Res> {
  _$ReactionResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReactionResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? state = null,
    Object? counts = null,
  }) {
    return _then(_value.copyWith(
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      counts: null == counts
          ? _value.counts
          : counts // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReactionResponseImplCopyWith<$Res>
    implements $ReactionResponseCopyWith<$Res> {
  factory _$$ReactionResponseImplCopyWith(_$ReactionResponseImpl value,
          $Res Function(_$ReactionResponseImpl) then) =
      __$$ReactionResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String state, Map<String, int> counts});
}

/// @nodoc
class __$$ReactionResponseImplCopyWithImpl<$Res>
    extends _$ReactionResponseCopyWithImpl<$Res, _$ReactionResponseImpl>
    implements _$$ReactionResponseImplCopyWith<$Res> {
  __$$ReactionResponseImplCopyWithImpl(_$ReactionResponseImpl _value,
      $Res Function(_$ReactionResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReactionResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? state = null,
    Object? counts = null,
  }) {
    return _then(_$ReactionResponseImpl(
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      counts: null == counts
          ? _value._counts
          : counts // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReactionResponseImpl extends _ReactionResponse {
  const _$ReactionResponseImpl(
      {required this.state, required final Map<String, int> counts})
      : _counts = counts,
        super._();

  factory _$ReactionResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReactionResponseImplFromJson(json);

  @override
  final String state;
  final Map<String, int> _counts;
  @override
  Map<String, int> get counts {
    if (_counts is EqualUnmodifiableMapView) return _counts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_counts);
  }

  @override
  String toString() {
    return 'ReactionResponse(state: $state, counts: $counts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReactionResponseImpl &&
            (identical(other.state, state) || other.state == state) &&
            const DeepCollectionEquality().equals(other._counts, _counts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, state, const DeepCollectionEquality().hash(_counts));

  /// Create a copy of ReactionResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReactionResponseImplCopyWith<_$ReactionResponseImpl> get copyWith =>
      __$$ReactionResponseImplCopyWithImpl<_$ReactionResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReactionResponseImplToJson(
      this,
    );
  }
}

abstract class _ReactionResponse extends ReactionResponse {
  const factory _ReactionResponse(
      {required final String state,
      required final Map<String, int> counts}) = _$ReactionResponseImpl;
  const _ReactionResponse._() : super._();

  factory _ReactionResponse.fromJson(Map<String, dynamic> json) =
      _$ReactionResponseImpl.fromJson;

  @override
  String get state;
  @override
  Map<String, int> get counts;

  /// Create a copy of ReactionResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReactionResponseImplCopyWith<_$ReactionResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CommentDto _$CommentDtoFromJson(Map<String, dynamic> json) {
  return _CommentDto.fromJson(json);
}

/// @nodoc
mixin _$CommentDto {
  String get id => throw _privateConstructorUsedError;
  PostAuthorDto get user => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String? get parentId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this CommentDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CommentDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommentDtoCopyWith<CommentDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentDtoCopyWith<$Res> {
  factory $CommentDtoCopyWith(
          CommentDto value, $Res Function(CommentDto) then) =
      _$CommentDtoCopyWithImpl<$Res, CommentDto>;
  @useResult
  $Res call(
      {String id,
      PostAuthorDto user,
      String content,
      String? parentId,
      DateTime createdAt});

  $PostAuthorDtoCopyWith<$Res> get user;
}

/// @nodoc
class _$CommentDtoCopyWithImpl<$Res, $Val extends CommentDto>
    implements $CommentDtoCopyWith<$Res> {
  _$CommentDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CommentDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? user = null,
    Object? content = null,
    Object? parentId = freezed,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as PostAuthorDto,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  /// Create a copy of CommentDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PostAuthorDtoCopyWith<$Res> get user {
    return $PostAuthorDtoCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CommentDtoImplCopyWith<$Res>
    implements $CommentDtoCopyWith<$Res> {
  factory _$$CommentDtoImplCopyWith(
          _$CommentDtoImpl value, $Res Function(_$CommentDtoImpl) then) =
      __$$CommentDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      PostAuthorDto user,
      String content,
      String? parentId,
      DateTime createdAt});

  @override
  $PostAuthorDtoCopyWith<$Res> get user;
}

/// @nodoc
class __$$CommentDtoImplCopyWithImpl<$Res>
    extends _$CommentDtoCopyWithImpl<$Res, _$CommentDtoImpl>
    implements _$$CommentDtoImplCopyWith<$Res> {
  __$$CommentDtoImplCopyWithImpl(
      _$CommentDtoImpl _value, $Res Function(_$CommentDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CommentDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? user = null,
    Object? content = null,
    Object? parentId = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$CommentDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as PostAuthorDto,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CommentDtoImpl extends _CommentDto {
  const _$CommentDtoImpl(
      {required this.id,
      required this.user,
      required this.content,
      this.parentId,
      required this.createdAt})
      : super._();

  factory _$CommentDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommentDtoImplFromJson(json);

  @override
  final String id;
  @override
  final PostAuthorDto user;
  @override
  final String content;
  @override
  final String? parentId;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'CommentDto(id: $id, user: $user, content: $content, parentId: $parentId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommentDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, user, content, parentId, createdAt);

  /// Create a copy of CommentDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommentDtoImplCopyWith<_$CommentDtoImpl> get copyWith =>
      __$$CommentDtoImplCopyWithImpl<_$CommentDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommentDtoImplToJson(
      this,
    );
  }
}

abstract class _CommentDto extends CommentDto {
  const factory _CommentDto(
      {required final String id,
      required final PostAuthorDto user,
      required final String content,
      final String? parentId,
      required final DateTime createdAt}) = _$CommentDtoImpl;
  const _CommentDto._() : super._();

  factory _CommentDto.fromJson(Map<String, dynamic> json) =
      _$CommentDtoImpl.fromJson;

  @override
  String get id;
  @override
  PostAuthorDto get user;
  @override
  String get content;
  @override
  String? get parentId;
  @override
  DateTime get createdAt;

  /// Create a copy of CommentDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommentDtoImplCopyWith<_$CommentDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CommentPageDto _$CommentPageDtoFromJson(Map<String, dynamic> json) {
  return _CommentPageDto.fromJson(json);
}

/// @nodoc
mixin _$CommentPageDto {
  List<CommentDto> get items => throw _privateConstructorUsedError;
  String? get nextCursor => throw _privateConstructorUsedError;

  /// Serializes this CommentPageDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CommentPageDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CommentPageDtoCopyWith<CommentPageDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentPageDtoCopyWith<$Res> {
  factory $CommentPageDtoCopyWith(
          CommentPageDto value, $Res Function(CommentPageDto) then) =
      _$CommentPageDtoCopyWithImpl<$Res, CommentPageDto>;
  @useResult
  $Res call({List<CommentDto> items, String? nextCursor});
}

/// @nodoc
class _$CommentPageDtoCopyWithImpl<$Res, $Val extends CommentPageDto>
    implements $CommentPageDtoCopyWith<$Res> {
  _$CommentPageDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CommentPageDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? nextCursor = freezed,
  }) {
    return _then(_value.copyWith(
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<CommentDto>,
      nextCursor: freezed == nextCursor
          ? _value.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CommentPageDtoImplCopyWith<$Res>
    implements $CommentPageDtoCopyWith<$Res> {
  factory _$$CommentPageDtoImplCopyWith(_$CommentPageDtoImpl value,
          $Res Function(_$CommentPageDtoImpl) then) =
      __$$CommentPageDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<CommentDto> items, String? nextCursor});
}

/// @nodoc
class __$$CommentPageDtoImplCopyWithImpl<$Res>
    extends _$CommentPageDtoCopyWithImpl<$Res, _$CommentPageDtoImpl>
    implements _$$CommentPageDtoImplCopyWith<$Res> {
  __$$CommentPageDtoImplCopyWithImpl(
      _$CommentPageDtoImpl _value, $Res Function(_$CommentPageDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CommentPageDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? nextCursor = freezed,
  }) {
    return _then(_$CommentPageDtoImpl(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<CommentDto>,
      nextCursor: freezed == nextCursor
          ? _value.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CommentPageDtoImpl implements _CommentPageDto {
  const _$CommentPageDtoImpl(
      {required final List<CommentDto> items, this.nextCursor})
      : _items = items;

  factory _$CommentPageDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommentPageDtoImplFromJson(json);

  final List<CommentDto> _items;
  @override
  List<CommentDto> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final String? nextCursor;

  @override
  String toString() {
    return 'CommentPageDto(items: $items, nextCursor: $nextCursor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommentPageDtoImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_items), nextCursor);

  /// Create a copy of CommentPageDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommentPageDtoImplCopyWith<_$CommentPageDtoImpl> get copyWith =>
      __$$CommentPageDtoImplCopyWithImpl<_$CommentPageDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommentPageDtoImplToJson(
      this,
    );
  }
}

abstract class _CommentPageDto implements CommentPageDto {
  const factory _CommentPageDto(
      {required final List<CommentDto> items,
      final String? nextCursor}) = _$CommentPageDtoImpl;

  factory _CommentPageDto.fromJson(Map<String, dynamic> json) =
      _$CommentPageDtoImpl.fromJson;

  @override
  List<CommentDto> get items;
  @override
  String? get nextCursor;

  /// Create a copy of CommentPageDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommentPageDtoImplCopyWith<_$CommentPageDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateCommentRequest _$CreateCommentRequestFromJson(Map<String, dynamic> json) {
  return _CreateCommentRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateCommentRequest {
  String? get parentId => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;

  /// Serializes this CreateCommentRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateCommentRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateCommentRequestCopyWith<CreateCommentRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateCommentRequestCopyWith<$Res> {
  factory $CreateCommentRequestCopyWith(CreateCommentRequest value,
          $Res Function(CreateCommentRequest) then) =
      _$CreateCommentRequestCopyWithImpl<$Res, CreateCommentRequest>;
  @useResult
  $Res call({String? parentId, String content});
}

/// @nodoc
class _$CreateCommentRequestCopyWithImpl<$Res,
        $Val extends CreateCommentRequest>
    implements $CreateCommentRequestCopyWith<$Res> {
  _$CreateCommentRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateCommentRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? parentId = freezed,
    Object? content = null,
  }) {
    return _then(_value.copyWith(
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateCommentRequestImplCopyWith<$Res>
    implements $CreateCommentRequestCopyWith<$Res> {
  factory _$$CreateCommentRequestImplCopyWith(_$CreateCommentRequestImpl value,
          $Res Function(_$CreateCommentRequestImpl) then) =
      __$$CreateCommentRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? parentId, String content});
}

/// @nodoc
class __$$CreateCommentRequestImplCopyWithImpl<$Res>
    extends _$CreateCommentRequestCopyWithImpl<$Res, _$CreateCommentRequestImpl>
    implements _$$CreateCommentRequestImplCopyWith<$Res> {
  __$$CreateCommentRequestImplCopyWithImpl(_$CreateCommentRequestImpl _value,
      $Res Function(_$CreateCommentRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateCommentRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? parentId = freezed,
    Object? content = null,
  }) {
    return _then(_$CreateCommentRequestImpl(
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateCommentRequestImpl implements _CreateCommentRequest {
  const _$CreateCommentRequestImpl({this.parentId, required this.content});

  factory _$CreateCommentRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateCommentRequestImplFromJson(json);

  @override
  final String? parentId;
  @override
  final String content;

  @override
  String toString() {
    return 'CreateCommentRequest(parentId: $parentId, content: $content)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateCommentRequestImpl &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.content, content) || other.content == content));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, parentId, content);

  /// Create a copy of CreateCommentRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateCommentRequestImplCopyWith<_$CreateCommentRequestImpl>
      get copyWith =>
          __$$CreateCommentRequestImplCopyWithImpl<_$CreateCommentRequestImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateCommentRequestImplToJson(
      this,
    );
  }
}

abstract class _CreateCommentRequest implements CreateCommentRequest {
  const factory _CreateCommentRequest(
      {final String? parentId,
      required final String content}) = _$CreateCommentRequestImpl;

  factory _CreateCommentRequest.fromJson(Map<String, dynamic> json) =
      _$CreateCommentRequestImpl.fromJson;

  @override
  String? get parentId;
  @override
  String get content;

  /// Create a copy of CreateCommentRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateCommentRequestImplCopyWith<_$CreateCommentRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
