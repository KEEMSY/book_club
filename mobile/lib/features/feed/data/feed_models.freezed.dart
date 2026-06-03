// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PostAuthorDto {
  String get id;
  String get nickname;
  String? get profileImageUrl;

  /// Create a copy of PostAuthorDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PostAuthorDtoCopyWith<PostAuthorDto> get copyWith =>
      _$PostAuthorDtoCopyWithImpl<PostAuthorDto>(
          this as PostAuthorDto, _$identity);

  /// Serializes this PostAuthorDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PostAuthorDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, nickname, profileImageUrl);

  @override
  String toString() {
    return 'PostAuthorDto(id: $id, nickname: $nickname, profileImageUrl: $profileImageUrl)';
  }
}

/// @nodoc
abstract mixin class $PostAuthorDtoCopyWith<$Res> {
  factory $PostAuthorDtoCopyWith(
          PostAuthorDto value, $Res Function(PostAuthorDto) _then) =
      _$PostAuthorDtoCopyWithImpl;
  @useResult
  $Res call({String id, String nickname, String? profileImageUrl});
}

/// @nodoc
class _$PostAuthorDtoCopyWithImpl<$Res>
    implements $PostAuthorDtoCopyWith<$Res> {
  _$PostAuthorDtoCopyWithImpl(this._self, this._then);

  final PostAuthorDto _self;
  final $Res Function(PostAuthorDto) _then;

  /// Create a copy of PostAuthorDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nickname = null,
    Object? profileImageUrl = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      profileImageUrl: freezed == profileImageUrl
          ? _self.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [PostAuthorDto].
extension PostAuthorDtoPatterns on PostAuthorDto {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_PostAuthorDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PostAuthorDto() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_PostAuthorDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PostAuthorDto():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_PostAuthorDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PostAuthorDto() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String id, String nickname, String? profileImageUrl)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PostAuthorDto() when $default != null:
        return $default(_that.id, _that.nickname, _that.profileImageUrl);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String id, String nickname, String? profileImageUrl)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PostAuthorDto():
        return $default(_that.id, _that.nickname, _that.profileImageUrl);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String id, String nickname, String? profileImageUrl)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PostAuthorDto() when $default != null:
        return $default(_that.id, _that.nickname, _that.profileImageUrl);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _PostAuthorDto extends PostAuthorDto {
  const _PostAuthorDto(
      {required this.id, required this.nickname, this.profileImageUrl})
      : super._();
  factory _PostAuthorDto.fromJson(Map<String, dynamic> json) =>
      _$PostAuthorDtoFromJson(json);

  @override
  final String id;
  @override
  final String nickname;
  @override
  final String? profileImageUrl;

  /// Create a copy of PostAuthorDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PostAuthorDtoCopyWith<_PostAuthorDto> get copyWith =>
      __$PostAuthorDtoCopyWithImpl<_PostAuthorDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PostAuthorDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PostAuthorDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, nickname, profileImageUrl);

  @override
  String toString() {
    return 'PostAuthorDto(id: $id, nickname: $nickname, profileImageUrl: $profileImageUrl)';
  }
}

/// @nodoc
abstract mixin class _$PostAuthorDtoCopyWith<$Res>
    implements $PostAuthorDtoCopyWith<$Res> {
  factory _$PostAuthorDtoCopyWith(
          _PostAuthorDto value, $Res Function(_PostAuthorDto) _then) =
      __$PostAuthorDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String id, String nickname, String? profileImageUrl});
}

/// @nodoc
class __$PostAuthorDtoCopyWithImpl<$Res>
    implements _$PostAuthorDtoCopyWith<$Res> {
  __$PostAuthorDtoCopyWithImpl(this._self, this._then);

  final _PostAuthorDto _self;
  final $Res Function(_PostAuthorDto) _then;

  /// Create a copy of PostAuthorDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? nickname = null,
    Object? profileImageUrl = freezed,
  }) {
    return _then(_PostAuthorDto(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      profileImageUrl: freezed == profileImageUrl
          ? _self.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$PostDto {
  String get id;
  String get bookId;
  String? get bookTitle;
  String? get bookCoverUrl;
  PostAuthorDto get user;
  String get postType;
  String get content;
  List<String> get imageUrls;
  Map<String, int> get reactions;
  List<String> get myReactions;
  int get commentCount;
  DateTime get createdAt;

  /// Create a copy of PostDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PostDtoCopyWith<PostDto> get copyWith =>
      _$PostDtoCopyWithImpl<PostDto>(this as PostDto, _$identity);

  /// Serializes this PostDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PostDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.bookId, bookId) || other.bookId == bookId) &&
            (identical(other.bookTitle, bookTitle) ||
                other.bookTitle == bookTitle) &&
            (identical(other.bookCoverUrl, bookCoverUrl) ||
                other.bookCoverUrl == bookCoverUrl) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.postType, postType) ||
                other.postType == postType) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality().equals(other.imageUrls, imageUrls) &&
            const DeepCollectionEquality().equals(other.reactions, reactions) &&
            const DeepCollectionEquality()
                .equals(other.myReactions, myReactions) &&
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
      bookTitle,
      bookCoverUrl,
      user,
      postType,
      content,
      const DeepCollectionEquality().hash(imageUrls),
      const DeepCollectionEquality().hash(reactions),
      const DeepCollectionEquality().hash(myReactions),
      commentCount,
      createdAt);

  @override
  String toString() {
    return 'PostDto(id: $id, bookId: $bookId, bookTitle: $bookTitle, bookCoverUrl: $bookCoverUrl, user: $user, postType: $postType, content: $content, imageUrls: $imageUrls, reactions: $reactions, myReactions: $myReactions, commentCount: $commentCount, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $PostDtoCopyWith<$Res> {
  factory $PostDtoCopyWith(PostDto value, $Res Function(PostDto) _then) =
      _$PostDtoCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String bookId,
      String? bookTitle,
      String? bookCoverUrl,
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
class _$PostDtoCopyWithImpl<$Res> implements $PostDtoCopyWith<$Res> {
  _$PostDtoCopyWithImpl(this._self, this._then);

  final PostDto _self;
  final $Res Function(PostDto) _then;

  /// Create a copy of PostDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bookId = null,
    Object? bookTitle = freezed,
    Object? bookCoverUrl = freezed,
    Object? user = null,
    Object? postType = null,
    Object? content = null,
    Object? imageUrls = null,
    Object? reactions = null,
    Object? myReactions = null,
    Object? commentCount = null,
    Object? createdAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      bookId: null == bookId
          ? _self.bookId
          : bookId // ignore: cast_nullable_to_non_nullable
              as String,
      bookTitle: freezed == bookTitle
          ? _self.bookTitle
          : bookTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      bookCoverUrl: freezed == bookCoverUrl
          ? _self.bookCoverUrl
          : bookCoverUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      user: null == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as PostAuthorDto,
      postType: null == postType
          ? _self.postType
          : postType // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrls: null == imageUrls
          ? _self.imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      reactions: null == reactions
          ? _self.reactions
          : reactions // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      myReactions: null == myReactions
          ? _self.myReactions
          : myReactions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      commentCount: null == commentCount
          ? _self.commentCount
          : commentCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }

  /// Create a copy of PostDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PostAuthorDtoCopyWith<$Res> get user {
    return $PostAuthorDtoCopyWith<$Res>(_self.user, (value) {
      return _then(_self.copyWith(user: value));
    });
  }
}

/// Adds pattern-matching-related methods to [PostDto].
extension PostDtoPatterns on PostDto {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_PostDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PostDto() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_PostDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PostDto():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_PostDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PostDto() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            String bookId,
            String? bookTitle,
            String? bookCoverUrl,
            PostAuthorDto user,
            String postType,
            String content,
            List<String> imageUrls,
            Map<String, int> reactions,
            List<String> myReactions,
            int commentCount,
            DateTime createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PostDto() when $default != null:
        return $default(
            _that.id,
            _that.bookId,
            _that.bookTitle,
            _that.bookCoverUrl,
            _that.user,
            _that.postType,
            _that.content,
            _that.imageUrls,
            _that.reactions,
            _that.myReactions,
            _that.commentCount,
            _that.createdAt);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            String bookId,
            String? bookTitle,
            String? bookCoverUrl,
            PostAuthorDto user,
            String postType,
            String content,
            List<String> imageUrls,
            Map<String, int> reactions,
            List<String> myReactions,
            int commentCount,
            DateTime createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PostDto():
        return $default(
            _that.id,
            _that.bookId,
            _that.bookTitle,
            _that.bookCoverUrl,
            _that.user,
            _that.postType,
            _that.content,
            _that.imageUrls,
            _that.reactions,
            _that.myReactions,
            _that.commentCount,
            _that.createdAt);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            String bookId,
            String? bookTitle,
            String? bookCoverUrl,
            PostAuthorDto user,
            String postType,
            String content,
            List<String> imageUrls,
            Map<String, int> reactions,
            List<String> myReactions,
            int commentCount,
            DateTime createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PostDto() when $default != null:
        return $default(
            _that.id,
            _that.bookId,
            _that.bookTitle,
            _that.bookCoverUrl,
            _that.user,
            _that.postType,
            _that.content,
            _that.imageUrls,
            _that.reactions,
            _that.myReactions,
            _that.commentCount,
            _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _PostDto extends PostDto {
  const _PostDto(
      {required this.id,
      required this.bookId,
      this.bookTitle,
      this.bookCoverUrl,
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
  factory _PostDto.fromJson(Map<String, dynamic> json) =>
      _$PostDtoFromJson(json);

  @override
  final String id;
  @override
  final String bookId;
  @override
  final String? bookTitle;
  @override
  final String? bookCoverUrl;
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

  /// Create a copy of PostDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PostDtoCopyWith<_PostDto> get copyWith =>
      __$PostDtoCopyWithImpl<_PostDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PostDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PostDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.bookId, bookId) || other.bookId == bookId) &&
            (identical(other.bookTitle, bookTitle) ||
                other.bookTitle == bookTitle) &&
            (identical(other.bookCoverUrl, bookCoverUrl) ||
                other.bookCoverUrl == bookCoverUrl) &&
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
      bookTitle,
      bookCoverUrl,
      user,
      postType,
      content,
      const DeepCollectionEquality().hash(_imageUrls),
      const DeepCollectionEquality().hash(_reactions),
      const DeepCollectionEquality().hash(_myReactions),
      commentCount,
      createdAt);

  @override
  String toString() {
    return 'PostDto(id: $id, bookId: $bookId, bookTitle: $bookTitle, bookCoverUrl: $bookCoverUrl, user: $user, postType: $postType, content: $content, imageUrls: $imageUrls, reactions: $reactions, myReactions: $myReactions, commentCount: $commentCount, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$PostDtoCopyWith<$Res> implements $PostDtoCopyWith<$Res> {
  factory _$PostDtoCopyWith(_PostDto value, $Res Function(_PostDto) _then) =
      __$PostDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String bookId,
      String? bookTitle,
      String? bookCoverUrl,
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
class __$PostDtoCopyWithImpl<$Res> implements _$PostDtoCopyWith<$Res> {
  __$PostDtoCopyWithImpl(this._self, this._then);

  final _PostDto _self;
  final $Res Function(_PostDto) _then;

  /// Create a copy of PostDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? bookId = null,
    Object? bookTitle = freezed,
    Object? bookCoverUrl = freezed,
    Object? user = null,
    Object? postType = null,
    Object? content = null,
    Object? imageUrls = null,
    Object? reactions = null,
    Object? myReactions = null,
    Object? commentCount = null,
    Object? createdAt = null,
  }) {
    return _then(_PostDto(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      bookId: null == bookId
          ? _self.bookId
          : bookId // ignore: cast_nullable_to_non_nullable
              as String,
      bookTitle: freezed == bookTitle
          ? _self.bookTitle
          : bookTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      bookCoverUrl: freezed == bookCoverUrl
          ? _self.bookCoverUrl
          : bookCoverUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      user: null == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as PostAuthorDto,
      postType: null == postType
          ? _self.postType
          : postType // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrls: null == imageUrls
          ? _self._imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      reactions: null == reactions
          ? _self._reactions
          : reactions // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      myReactions: null == myReactions
          ? _self._myReactions
          : myReactions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      commentCount: null == commentCount
          ? _self.commentCount
          : commentCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }

  /// Create a copy of PostDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PostAuthorDtoCopyWith<$Res> get user {
    return $PostAuthorDtoCopyWith<$Res>(_self.user, (value) {
      return _then(_self.copyWith(user: value));
    });
  }
}

/// @nodoc
mixin _$PostPageDto {
  List<PostDto> get items;
  String? get nextCursor;

  /// Create a copy of PostPageDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PostPageDtoCopyWith<PostPageDto> get copyWith =>
      _$PostPageDtoCopyWithImpl<PostPageDto>(this as PostPageDto, _$identity);

  /// Serializes this PostPageDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PostPageDto &&
            const DeepCollectionEquality().equals(other.items, items) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(items), nextCursor);

  @override
  String toString() {
    return 'PostPageDto(items: $items, nextCursor: $nextCursor)';
  }
}

/// @nodoc
abstract mixin class $PostPageDtoCopyWith<$Res> {
  factory $PostPageDtoCopyWith(
          PostPageDto value, $Res Function(PostPageDto) _then) =
      _$PostPageDtoCopyWithImpl;
  @useResult
  $Res call({List<PostDto> items, String? nextCursor});
}

/// @nodoc
class _$PostPageDtoCopyWithImpl<$Res> implements $PostPageDtoCopyWith<$Res> {
  _$PostPageDtoCopyWithImpl(this._self, this._then);

  final PostPageDto _self;
  final $Res Function(PostPageDto) _then;

  /// Create a copy of PostPageDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? nextCursor = freezed,
  }) {
    return _then(_self.copyWith(
      items: null == items
          ? _self.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<PostDto>,
      nextCursor: freezed == nextCursor
          ? _self.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [PostPageDto].
extension PostPageDtoPatterns on PostPageDto {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_PostPageDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PostPageDto() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_PostPageDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PostPageDto():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_PostPageDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PostPageDto() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(List<PostDto> items, String? nextCursor)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PostPageDto() when $default != null:
        return $default(_that.items, _that.nextCursor);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(List<PostDto> items, String? nextCursor) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PostPageDto():
        return $default(_that.items, _that.nextCursor);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(List<PostDto> items, String? nextCursor)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PostPageDto() when $default != null:
        return $default(_that.items, _that.nextCursor);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _PostPageDto implements PostPageDto {
  const _PostPageDto({required final List<PostDto> items, this.nextCursor})
      : _items = items;
  factory _PostPageDto.fromJson(Map<String, dynamic> json) =>
      _$PostPageDtoFromJson(json);

  final List<PostDto> _items;
  @override
  List<PostDto> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final String? nextCursor;

  /// Create a copy of PostPageDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PostPageDtoCopyWith<_PostPageDto> get copyWith =>
      __$PostPageDtoCopyWithImpl<_PostPageDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PostPageDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PostPageDto &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_items), nextCursor);

  @override
  String toString() {
    return 'PostPageDto(items: $items, nextCursor: $nextCursor)';
  }
}

/// @nodoc
abstract mixin class _$PostPageDtoCopyWith<$Res>
    implements $PostPageDtoCopyWith<$Res> {
  factory _$PostPageDtoCopyWith(
          _PostPageDto value, $Res Function(_PostPageDto) _then) =
      __$PostPageDtoCopyWithImpl;
  @override
  @useResult
  $Res call({List<PostDto> items, String? nextCursor});
}

/// @nodoc
class __$PostPageDtoCopyWithImpl<$Res> implements _$PostPageDtoCopyWith<$Res> {
  __$PostPageDtoCopyWithImpl(this._self, this._then);

  final _PostPageDto _self;
  final $Res Function(_PostPageDto) _then;

  /// Create a copy of PostPageDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? items = null,
    Object? nextCursor = freezed,
  }) {
    return _then(_PostPageDto(
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<PostDto>,
      nextCursor: freezed == nextCursor
          ? _self.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$CreatePostRequest {
  String get bookId;
  String get postType;
  String get content;
  List<String> get imageKeys;

  /// Create a copy of CreatePostRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CreatePostRequestCopyWith<CreatePostRequest> get copyWith =>
      _$CreatePostRequestCopyWithImpl<CreatePostRequest>(
          this as CreatePostRequest, _$identity);

  /// Serializes this CreatePostRequest to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CreatePostRequest &&
            (identical(other.bookId, bookId) || other.bookId == bookId) &&
            (identical(other.postType, postType) ||
                other.postType == postType) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality().equals(other.imageKeys, imageKeys));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, bookId, postType, content,
      const DeepCollectionEquality().hash(imageKeys));

  @override
  String toString() {
    return 'CreatePostRequest(bookId: $bookId, postType: $postType, content: $content, imageKeys: $imageKeys)';
  }
}

/// @nodoc
abstract mixin class $CreatePostRequestCopyWith<$Res> {
  factory $CreatePostRequestCopyWith(
          CreatePostRequest value, $Res Function(CreatePostRequest) _then) =
      _$CreatePostRequestCopyWithImpl;
  @useResult
  $Res call(
      {String bookId, String postType, String content, List<String> imageKeys});
}

/// @nodoc
class _$CreatePostRequestCopyWithImpl<$Res>
    implements $CreatePostRequestCopyWith<$Res> {
  _$CreatePostRequestCopyWithImpl(this._self, this._then);

  final CreatePostRequest _self;
  final $Res Function(CreatePostRequest) _then;

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
    return _then(_self.copyWith(
      bookId: null == bookId
          ? _self.bookId
          : bookId // ignore: cast_nullable_to_non_nullable
              as String,
      postType: null == postType
          ? _self.postType
          : postType // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      imageKeys: null == imageKeys
          ? _self.imageKeys
          : imageKeys // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// Adds pattern-matching-related methods to [CreatePostRequest].
extension CreatePostRequestPatterns on CreatePostRequest {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_CreatePostRequest value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CreatePostRequest() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_CreatePostRequest value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreatePostRequest():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_CreatePostRequest value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreatePostRequest() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String bookId, String postType, String content,
            List<String> imageKeys)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CreatePostRequest() when $default != null:
        return $default(
            _that.bookId, _that.postType, _that.content, _that.imageKeys);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String bookId, String postType, String content,
            List<String> imageKeys)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreatePostRequest():
        return $default(
            _that.bookId, _that.postType, _that.content, _that.imageKeys);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String bookId, String postType, String content,
            List<String> imageKeys)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreatePostRequest() when $default != null:
        return $default(
            _that.bookId, _that.postType, _that.content, _that.imageKeys);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CreatePostRequest implements CreatePostRequest {
  const _CreatePostRequest(
      {required this.bookId,
      required this.postType,
      required this.content,
      required final List<String> imageKeys})
      : _imageKeys = imageKeys;
  factory _CreatePostRequest.fromJson(Map<String, dynamic> json) =>
      _$CreatePostRequestFromJson(json);

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

  /// Create a copy of CreatePostRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CreatePostRequestCopyWith<_CreatePostRequest> get copyWith =>
      __$CreatePostRequestCopyWithImpl<_CreatePostRequest>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CreatePostRequestToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CreatePostRequest &&
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

  @override
  String toString() {
    return 'CreatePostRequest(bookId: $bookId, postType: $postType, content: $content, imageKeys: $imageKeys)';
  }
}

/// @nodoc
abstract mixin class _$CreatePostRequestCopyWith<$Res>
    implements $CreatePostRequestCopyWith<$Res> {
  factory _$CreatePostRequestCopyWith(
          _CreatePostRequest value, $Res Function(_CreatePostRequest) _then) =
      __$CreatePostRequestCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String bookId, String postType, String content, List<String> imageKeys});
}

/// @nodoc
class __$CreatePostRequestCopyWithImpl<$Res>
    implements _$CreatePostRequestCopyWith<$Res> {
  __$CreatePostRequestCopyWithImpl(this._self, this._then);

  final _CreatePostRequest _self;
  final $Res Function(_CreatePostRequest) _then;

  /// Create a copy of CreatePostRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? bookId = null,
    Object? postType = null,
    Object? content = null,
    Object? imageKeys = null,
  }) {
    return _then(_CreatePostRequest(
      bookId: null == bookId
          ? _self.bookId
          : bookId // ignore: cast_nullable_to_non_nullable
              as String,
      postType: null == postType
          ? _self.postType
          : postType // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      imageKeys: null == imageKeys
          ? _self._imageKeys
          : imageKeys // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
mixin _$PresignImageRequest {
  String get contentType;

  /// Create a copy of PresignImageRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PresignImageRequestCopyWith<PresignImageRequest> get copyWith =>
      _$PresignImageRequestCopyWithImpl<PresignImageRequest>(
          this as PresignImageRequest, _$identity);

  /// Serializes this PresignImageRequest to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PresignImageRequest &&
            (identical(other.contentType, contentType) ||
                other.contentType == contentType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, contentType);

  @override
  String toString() {
    return 'PresignImageRequest(contentType: $contentType)';
  }
}

/// @nodoc
abstract mixin class $PresignImageRequestCopyWith<$Res> {
  factory $PresignImageRequestCopyWith(
          PresignImageRequest value, $Res Function(PresignImageRequest) _then) =
      _$PresignImageRequestCopyWithImpl;
  @useResult
  $Res call({String contentType});
}

/// @nodoc
class _$PresignImageRequestCopyWithImpl<$Res>
    implements $PresignImageRequestCopyWith<$Res> {
  _$PresignImageRequestCopyWithImpl(this._self, this._then);

  final PresignImageRequest _self;
  final $Res Function(PresignImageRequest) _then;

  /// Create a copy of PresignImageRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contentType = null,
  }) {
    return _then(_self.copyWith(
      contentType: null == contentType
          ? _self.contentType
          : contentType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [PresignImageRequest].
extension PresignImageRequestPatterns on PresignImageRequest {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_PresignImageRequest value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PresignImageRequest() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_PresignImageRequest value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PresignImageRequest():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_PresignImageRequest value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PresignImageRequest() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String contentType)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PresignImageRequest() when $default != null:
        return $default(_that.contentType);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String contentType) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PresignImageRequest():
        return $default(_that.contentType);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String contentType)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PresignImageRequest() when $default != null:
        return $default(_that.contentType);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _PresignImageRequest implements PresignImageRequest {
  const _PresignImageRequest({required this.contentType});
  factory _PresignImageRequest.fromJson(Map<String, dynamic> json) =>
      _$PresignImageRequestFromJson(json);

  @override
  final String contentType;

  /// Create a copy of PresignImageRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PresignImageRequestCopyWith<_PresignImageRequest> get copyWith =>
      __$PresignImageRequestCopyWithImpl<_PresignImageRequest>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PresignImageRequestToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PresignImageRequest &&
            (identical(other.contentType, contentType) ||
                other.contentType == contentType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, contentType);

  @override
  String toString() {
    return 'PresignImageRequest(contentType: $contentType)';
  }
}

/// @nodoc
abstract mixin class _$PresignImageRequestCopyWith<$Res>
    implements $PresignImageRequestCopyWith<$Res> {
  factory _$PresignImageRequestCopyWith(_PresignImageRequest value,
          $Res Function(_PresignImageRequest) _then) =
      __$PresignImageRequestCopyWithImpl;
  @override
  @useResult
  $Res call({String contentType});
}

/// @nodoc
class __$PresignImageRequestCopyWithImpl<$Res>
    implements _$PresignImageRequestCopyWith<$Res> {
  __$PresignImageRequestCopyWithImpl(this._self, this._then);

  final _PresignImageRequest _self;
  final $Res Function(_PresignImageRequest) _then;

  /// Create a copy of PresignImageRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? contentType = null,
  }) {
    return _then(_PresignImageRequest(
      contentType: null == contentType
          ? _self.contentType
          : contentType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$PresignImageResponse {
  String get url;
  String get key;
  Map<String, String> get headers;
  int get expiresIn;

  /// Create a copy of PresignImageResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PresignImageResponseCopyWith<PresignImageResponse> get copyWith =>
      _$PresignImageResponseCopyWithImpl<PresignImageResponse>(
          this as PresignImageResponse, _$identity);

  /// Serializes this PresignImageResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PresignImageResponse &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.key, key) || other.key == key) &&
            const DeepCollectionEquality().equals(other.headers, headers) &&
            (identical(other.expiresIn, expiresIn) ||
                other.expiresIn == expiresIn));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, url, key,
      const DeepCollectionEquality().hash(headers), expiresIn);

  @override
  String toString() {
    return 'PresignImageResponse(url: $url, key: $key, headers: $headers, expiresIn: $expiresIn)';
  }
}

/// @nodoc
abstract mixin class $PresignImageResponseCopyWith<$Res> {
  factory $PresignImageResponseCopyWith(PresignImageResponse value,
          $Res Function(PresignImageResponse) _then) =
      _$PresignImageResponseCopyWithImpl;
  @useResult
  $Res call(
      {String url, String key, Map<String, String> headers, int expiresIn});
}

/// @nodoc
class _$PresignImageResponseCopyWithImpl<$Res>
    implements $PresignImageResponseCopyWith<$Res> {
  _$PresignImageResponseCopyWithImpl(this._self, this._then);

  final PresignImageResponse _self;
  final $Res Function(PresignImageResponse) _then;

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
    return _then(_self.copyWith(
      url: null == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      key: null == key
          ? _self.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      headers: null == headers
          ? _self.headers
          : headers // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      expiresIn: null == expiresIn
          ? _self.expiresIn
          : expiresIn // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [PresignImageResponse].
extension PresignImageResponsePatterns on PresignImageResponse {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_PresignImageResponse value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PresignImageResponse() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_PresignImageResponse value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PresignImageResponse():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_PresignImageResponse value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PresignImageResponse() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String url, String key, Map<String, String> headers, int expiresIn)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PresignImageResponse() when $default != null:
        return $default(_that.url, _that.key, _that.headers, _that.expiresIn);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String url, String key, Map<String, String> headers, int expiresIn)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PresignImageResponse():
        return $default(_that.url, _that.key, _that.headers, _that.expiresIn);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String url, String key, Map<String, String> headers, int expiresIn)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PresignImageResponse() when $default != null:
        return $default(_that.url, _that.key, _that.headers, _that.expiresIn);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _PresignImageResponse implements PresignImageResponse {
  const _PresignImageResponse(
      {required this.url,
      required this.key,
      required final Map<String, String> headers,
      required this.expiresIn})
      : _headers = headers;
  factory _PresignImageResponse.fromJson(Map<String, dynamic> json) =>
      _$PresignImageResponseFromJson(json);

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

  /// Create a copy of PresignImageResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PresignImageResponseCopyWith<_PresignImageResponse> get copyWith =>
      __$PresignImageResponseCopyWithImpl<_PresignImageResponse>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PresignImageResponseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PresignImageResponse &&
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

  @override
  String toString() {
    return 'PresignImageResponse(url: $url, key: $key, headers: $headers, expiresIn: $expiresIn)';
  }
}

/// @nodoc
abstract mixin class _$PresignImageResponseCopyWith<$Res>
    implements $PresignImageResponseCopyWith<$Res> {
  factory _$PresignImageResponseCopyWith(_PresignImageResponse value,
          $Res Function(_PresignImageResponse) _then) =
      __$PresignImageResponseCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String url, String key, Map<String, String> headers, int expiresIn});
}

/// @nodoc
class __$PresignImageResponseCopyWithImpl<$Res>
    implements _$PresignImageResponseCopyWith<$Res> {
  __$PresignImageResponseCopyWithImpl(this._self, this._then);

  final _PresignImageResponse _self;
  final $Res Function(_PresignImageResponse) _then;

  /// Create a copy of PresignImageResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? url = null,
    Object? key = null,
    Object? headers = null,
    Object? expiresIn = null,
  }) {
    return _then(_PresignImageResponse(
      url: null == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      key: null == key
          ? _self.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      headers: null == headers
          ? _self._headers
          : headers // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      expiresIn: null == expiresIn
          ? _self.expiresIn
          : expiresIn // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$ReactionRequest {
  String get reactionType;

  /// Create a copy of ReactionRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReactionRequestCopyWith<ReactionRequest> get copyWith =>
      _$ReactionRequestCopyWithImpl<ReactionRequest>(
          this as ReactionRequest, _$identity);

  /// Serializes this ReactionRequest to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReactionRequest &&
            (identical(other.reactionType, reactionType) ||
                other.reactionType == reactionType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, reactionType);

  @override
  String toString() {
    return 'ReactionRequest(reactionType: $reactionType)';
  }
}

/// @nodoc
abstract mixin class $ReactionRequestCopyWith<$Res> {
  factory $ReactionRequestCopyWith(
          ReactionRequest value, $Res Function(ReactionRequest) _then) =
      _$ReactionRequestCopyWithImpl;
  @useResult
  $Res call({String reactionType});
}

/// @nodoc
class _$ReactionRequestCopyWithImpl<$Res>
    implements $ReactionRequestCopyWith<$Res> {
  _$ReactionRequestCopyWithImpl(this._self, this._then);

  final ReactionRequest _self;
  final $Res Function(ReactionRequest) _then;

  /// Create a copy of ReactionRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reactionType = null,
  }) {
    return _then(_self.copyWith(
      reactionType: null == reactionType
          ? _self.reactionType
          : reactionType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [ReactionRequest].
extension ReactionRequestPatterns on ReactionRequest {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ReactionRequest value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ReactionRequest() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ReactionRequest value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReactionRequest():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ReactionRequest value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReactionRequest() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String reactionType)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ReactionRequest() when $default != null:
        return $default(_that.reactionType);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String reactionType) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReactionRequest():
        return $default(_that.reactionType);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String reactionType)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReactionRequest() when $default != null:
        return $default(_that.reactionType);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ReactionRequest implements ReactionRequest {
  const _ReactionRequest({required this.reactionType});
  factory _ReactionRequest.fromJson(Map<String, dynamic> json) =>
      _$ReactionRequestFromJson(json);

  @override
  final String reactionType;

  /// Create a copy of ReactionRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ReactionRequestCopyWith<_ReactionRequest> get copyWith =>
      __$ReactionRequestCopyWithImpl<_ReactionRequest>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ReactionRequestToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ReactionRequest &&
            (identical(other.reactionType, reactionType) ||
                other.reactionType == reactionType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, reactionType);

  @override
  String toString() {
    return 'ReactionRequest(reactionType: $reactionType)';
  }
}

/// @nodoc
abstract mixin class _$ReactionRequestCopyWith<$Res>
    implements $ReactionRequestCopyWith<$Res> {
  factory _$ReactionRequestCopyWith(
          _ReactionRequest value, $Res Function(_ReactionRequest) _then) =
      __$ReactionRequestCopyWithImpl;
  @override
  @useResult
  $Res call({String reactionType});
}

/// @nodoc
class __$ReactionRequestCopyWithImpl<$Res>
    implements _$ReactionRequestCopyWith<$Res> {
  __$ReactionRequestCopyWithImpl(this._self, this._then);

  final _ReactionRequest _self;
  final $Res Function(_ReactionRequest) _then;

  /// Create a copy of ReactionRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? reactionType = null,
  }) {
    return _then(_ReactionRequest(
      reactionType: null == reactionType
          ? _self.reactionType
          : reactionType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$ReactionResponse {
  String get state;
  Map<String, int> get counts;

  /// Create a copy of ReactionResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReactionResponseCopyWith<ReactionResponse> get copyWith =>
      _$ReactionResponseCopyWithImpl<ReactionResponse>(
          this as ReactionResponse, _$identity);

  /// Serializes this ReactionResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReactionResponse &&
            (identical(other.state, state) || other.state == state) &&
            const DeepCollectionEquality().equals(other.counts, counts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, state, const DeepCollectionEquality().hash(counts));

  @override
  String toString() {
    return 'ReactionResponse(state: $state, counts: $counts)';
  }
}

/// @nodoc
abstract mixin class $ReactionResponseCopyWith<$Res> {
  factory $ReactionResponseCopyWith(
          ReactionResponse value, $Res Function(ReactionResponse) _then) =
      _$ReactionResponseCopyWithImpl;
  @useResult
  $Res call({String state, Map<String, int> counts});
}

/// @nodoc
class _$ReactionResponseCopyWithImpl<$Res>
    implements $ReactionResponseCopyWith<$Res> {
  _$ReactionResponseCopyWithImpl(this._self, this._then);

  final ReactionResponse _self;
  final $Res Function(ReactionResponse) _then;

  /// Create a copy of ReactionResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? state = null,
    Object? counts = null,
  }) {
    return _then(_self.copyWith(
      state: null == state
          ? _self.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      counts: null == counts
          ? _self.counts
          : counts // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
    ));
  }
}

/// Adds pattern-matching-related methods to [ReactionResponse].
extension ReactionResponsePatterns on ReactionResponse {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ReactionResponse value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ReactionResponse() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ReactionResponse value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReactionResponse():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ReactionResponse value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReactionResponse() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String state, Map<String, int> counts)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ReactionResponse() when $default != null:
        return $default(_that.state, _that.counts);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String state, Map<String, int> counts) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReactionResponse():
        return $default(_that.state, _that.counts);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String state, Map<String, int> counts)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReactionResponse() when $default != null:
        return $default(_that.state, _that.counts);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ReactionResponse extends ReactionResponse {
  const _ReactionResponse(
      {required this.state, required final Map<String, int> counts})
      : _counts = counts,
        super._();
  factory _ReactionResponse.fromJson(Map<String, dynamic> json) =>
      _$ReactionResponseFromJson(json);

  @override
  final String state;
  final Map<String, int> _counts;
  @override
  Map<String, int> get counts {
    if (_counts is EqualUnmodifiableMapView) return _counts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_counts);
  }

  /// Create a copy of ReactionResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ReactionResponseCopyWith<_ReactionResponse> get copyWith =>
      __$ReactionResponseCopyWithImpl<_ReactionResponse>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ReactionResponseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ReactionResponse &&
            (identical(other.state, state) || other.state == state) &&
            const DeepCollectionEquality().equals(other._counts, _counts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, state, const DeepCollectionEquality().hash(_counts));

  @override
  String toString() {
    return 'ReactionResponse(state: $state, counts: $counts)';
  }
}

/// @nodoc
abstract mixin class _$ReactionResponseCopyWith<$Res>
    implements $ReactionResponseCopyWith<$Res> {
  factory _$ReactionResponseCopyWith(
          _ReactionResponse value, $Res Function(_ReactionResponse) _then) =
      __$ReactionResponseCopyWithImpl;
  @override
  @useResult
  $Res call({String state, Map<String, int> counts});
}

/// @nodoc
class __$ReactionResponseCopyWithImpl<$Res>
    implements _$ReactionResponseCopyWith<$Res> {
  __$ReactionResponseCopyWithImpl(this._self, this._then);

  final _ReactionResponse _self;
  final $Res Function(_ReactionResponse) _then;

  /// Create a copy of ReactionResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? state = null,
    Object? counts = null,
  }) {
    return _then(_ReactionResponse(
      state: null == state
          ? _self.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      counts: null == counts
          ? _self._counts
          : counts // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
    ));
  }
}

/// @nodoc
mixin _$CommentDto {
  String get id;
  PostAuthorDto get user;
  String get content;
  String? get parentId;
  DateTime get createdAt;

  /// Create a copy of CommentDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CommentDtoCopyWith<CommentDto> get copyWith =>
      _$CommentDtoCopyWithImpl<CommentDto>(this as CommentDto, _$identity);

  /// Serializes this CommentDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CommentDto &&
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

  @override
  String toString() {
    return 'CommentDto(id: $id, user: $user, content: $content, parentId: $parentId, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $CommentDtoCopyWith<$Res> {
  factory $CommentDtoCopyWith(
          CommentDto value, $Res Function(CommentDto) _then) =
      _$CommentDtoCopyWithImpl;
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
class _$CommentDtoCopyWithImpl<$Res> implements $CommentDtoCopyWith<$Res> {
  _$CommentDtoCopyWithImpl(this._self, this._then);

  final CommentDto _self;
  final $Res Function(CommentDto) _then;

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
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      user: null == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as PostAuthorDto,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: freezed == parentId
          ? _self.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }

  /// Create a copy of CommentDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PostAuthorDtoCopyWith<$Res> get user {
    return $PostAuthorDtoCopyWith<$Res>(_self.user, (value) {
      return _then(_self.copyWith(user: value));
    });
  }
}

/// Adds pattern-matching-related methods to [CommentDto].
extension CommentDtoPatterns on CommentDto {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_CommentDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CommentDto() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_CommentDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CommentDto():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_CommentDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CommentDto() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String id, PostAuthorDto user, String content,
            String? parentId, DateTime createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CommentDto() when $default != null:
        return $default(_that.id, _that.user, _that.content, _that.parentId,
            _that.createdAt);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String id, PostAuthorDto user, String content,
            String? parentId, DateTime createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CommentDto():
        return $default(_that.id, _that.user, _that.content, _that.parentId,
            _that.createdAt);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String id, PostAuthorDto user, String content,
            String? parentId, DateTime createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CommentDto() when $default != null:
        return $default(_that.id, _that.user, _that.content, _that.parentId,
            _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CommentDto extends CommentDto {
  const _CommentDto(
      {required this.id,
      required this.user,
      required this.content,
      this.parentId,
      required this.createdAt})
      : super._();
  factory _CommentDto.fromJson(Map<String, dynamic> json) =>
      _$CommentDtoFromJson(json);

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

  /// Create a copy of CommentDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CommentDtoCopyWith<_CommentDto> get copyWith =>
      __$CommentDtoCopyWithImpl<_CommentDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CommentDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CommentDto &&
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

  @override
  String toString() {
    return 'CommentDto(id: $id, user: $user, content: $content, parentId: $parentId, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$CommentDtoCopyWith<$Res>
    implements $CommentDtoCopyWith<$Res> {
  factory _$CommentDtoCopyWith(
          _CommentDto value, $Res Function(_CommentDto) _then) =
      __$CommentDtoCopyWithImpl;
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
class __$CommentDtoCopyWithImpl<$Res> implements _$CommentDtoCopyWith<$Res> {
  __$CommentDtoCopyWithImpl(this._self, this._then);

  final _CommentDto _self;
  final $Res Function(_CommentDto) _then;

  /// Create a copy of CommentDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? user = null,
    Object? content = null,
    Object? parentId = freezed,
    Object? createdAt = null,
  }) {
    return _then(_CommentDto(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      user: null == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as PostAuthorDto,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: freezed == parentId
          ? _self.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }

  /// Create a copy of CommentDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PostAuthorDtoCopyWith<$Res> get user {
    return $PostAuthorDtoCopyWith<$Res>(_self.user, (value) {
      return _then(_self.copyWith(user: value));
    });
  }
}

/// @nodoc
mixin _$CommentPageDto {
  List<CommentDto> get items;
  String? get nextCursor;

  /// Create a copy of CommentPageDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CommentPageDtoCopyWith<CommentPageDto> get copyWith =>
      _$CommentPageDtoCopyWithImpl<CommentPageDto>(
          this as CommentPageDto, _$identity);

  /// Serializes this CommentPageDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CommentPageDto &&
            const DeepCollectionEquality().equals(other.items, items) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(items), nextCursor);

  @override
  String toString() {
    return 'CommentPageDto(items: $items, nextCursor: $nextCursor)';
  }
}

/// @nodoc
abstract mixin class $CommentPageDtoCopyWith<$Res> {
  factory $CommentPageDtoCopyWith(
          CommentPageDto value, $Res Function(CommentPageDto) _then) =
      _$CommentPageDtoCopyWithImpl;
  @useResult
  $Res call({List<CommentDto> items, String? nextCursor});
}

/// @nodoc
class _$CommentPageDtoCopyWithImpl<$Res>
    implements $CommentPageDtoCopyWith<$Res> {
  _$CommentPageDtoCopyWithImpl(this._self, this._then);

  final CommentPageDto _self;
  final $Res Function(CommentPageDto) _then;

  /// Create a copy of CommentPageDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? nextCursor = freezed,
  }) {
    return _then(_self.copyWith(
      items: null == items
          ? _self.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<CommentDto>,
      nextCursor: freezed == nextCursor
          ? _self.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [CommentPageDto].
extension CommentPageDtoPatterns on CommentPageDto {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_CommentPageDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CommentPageDto() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_CommentPageDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CommentPageDto():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_CommentPageDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CommentPageDto() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(List<CommentDto> items, String? nextCursor)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CommentPageDto() when $default != null:
        return $default(_that.items, _that.nextCursor);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(List<CommentDto> items, String? nextCursor) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CommentPageDto():
        return $default(_that.items, _that.nextCursor);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(List<CommentDto> items, String? nextCursor)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CommentPageDto() when $default != null:
        return $default(_that.items, _that.nextCursor);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CommentPageDto implements CommentPageDto {
  const _CommentPageDto(
      {required final List<CommentDto> items, this.nextCursor})
      : _items = items;
  factory _CommentPageDto.fromJson(Map<String, dynamic> json) =>
      _$CommentPageDtoFromJson(json);

  final List<CommentDto> _items;
  @override
  List<CommentDto> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final String? nextCursor;

  /// Create a copy of CommentPageDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CommentPageDtoCopyWith<_CommentPageDto> get copyWith =>
      __$CommentPageDtoCopyWithImpl<_CommentPageDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CommentPageDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CommentPageDto &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_items), nextCursor);

  @override
  String toString() {
    return 'CommentPageDto(items: $items, nextCursor: $nextCursor)';
  }
}

/// @nodoc
abstract mixin class _$CommentPageDtoCopyWith<$Res>
    implements $CommentPageDtoCopyWith<$Res> {
  factory _$CommentPageDtoCopyWith(
          _CommentPageDto value, $Res Function(_CommentPageDto) _then) =
      __$CommentPageDtoCopyWithImpl;
  @override
  @useResult
  $Res call({List<CommentDto> items, String? nextCursor});
}

/// @nodoc
class __$CommentPageDtoCopyWithImpl<$Res>
    implements _$CommentPageDtoCopyWith<$Res> {
  __$CommentPageDtoCopyWithImpl(this._self, this._then);

  final _CommentPageDto _self;
  final $Res Function(_CommentPageDto) _then;

  /// Create a copy of CommentPageDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? items = null,
    Object? nextCursor = freezed,
  }) {
    return _then(_CommentPageDto(
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<CommentDto>,
      nextCursor: freezed == nextCursor
          ? _self.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$CreateCommentRequest {
  String? get parentId;
  String get content;

  /// Create a copy of CreateCommentRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CreateCommentRequestCopyWith<CreateCommentRequest> get copyWith =>
      _$CreateCommentRequestCopyWithImpl<CreateCommentRequest>(
          this as CreateCommentRequest, _$identity);

  /// Serializes this CreateCommentRequest to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CreateCommentRequest &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.content, content) || other.content == content));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, parentId, content);

  @override
  String toString() {
    return 'CreateCommentRequest(parentId: $parentId, content: $content)';
  }
}

/// @nodoc
abstract mixin class $CreateCommentRequestCopyWith<$Res> {
  factory $CreateCommentRequestCopyWith(CreateCommentRequest value,
          $Res Function(CreateCommentRequest) _then) =
      _$CreateCommentRequestCopyWithImpl;
  @useResult
  $Res call({String? parentId, String content});
}

/// @nodoc
class _$CreateCommentRequestCopyWithImpl<$Res>
    implements $CreateCommentRequestCopyWith<$Res> {
  _$CreateCommentRequestCopyWithImpl(this._self, this._then);

  final CreateCommentRequest _self;
  final $Res Function(CreateCommentRequest) _then;

  /// Create a copy of CreateCommentRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? parentId = freezed,
    Object? content = null,
  }) {
    return _then(_self.copyWith(
      parentId: freezed == parentId
          ? _self.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [CreateCommentRequest].
extension CreateCommentRequestPatterns on CreateCommentRequest {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_CreateCommentRequest value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CreateCommentRequest() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_CreateCommentRequest value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreateCommentRequest():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_CreateCommentRequest value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreateCommentRequest() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String? parentId, String content)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CreateCommentRequest() when $default != null:
        return $default(_that.parentId, _that.content);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String? parentId, String content) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreateCommentRequest():
        return $default(_that.parentId, _that.content);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String? parentId, String content)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreateCommentRequest() when $default != null:
        return $default(_that.parentId, _that.content);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CreateCommentRequest implements CreateCommentRequest {
  const _CreateCommentRequest({this.parentId, required this.content});
  factory _CreateCommentRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateCommentRequestFromJson(json);

  @override
  final String? parentId;
  @override
  final String content;

  /// Create a copy of CreateCommentRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CreateCommentRequestCopyWith<_CreateCommentRequest> get copyWith =>
      __$CreateCommentRequestCopyWithImpl<_CreateCommentRequest>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CreateCommentRequestToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CreateCommentRequest &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.content, content) || other.content == content));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, parentId, content);

  @override
  String toString() {
    return 'CreateCommentRequest(parentId: $parentId, content: $content)';
  }
}

/// @nodoc
abstract mixin class _$CreateCommentRequestCopyWith<$Res>
    implements $CreateCommentRequestCopyWith<$Res> {
  factory _$CreateCommentRequestCopyWith(_CreateCommentRequest value,
          $Res Function(_CreateCommentRequest) _then) =
      __$CreateCommentRequestCopyWithImpl;
  @override
  @useResult
  $Res call({String? parentId, String content});
}

/// @nodoc
class __$CreateCommentRequestCopyWithImpl<$Res>
    implements _$CreateCommentRequestCopyWith<$Res> {
  __$CreateCommentRequestCopyWithImpl(this._self, this._then);

  final _CreateCommentRequest _self;
  final $Res Function(_CreateCommentRequest) _then;

  /// Create a copy of CreateCommentRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? parentId = freezed,
    Object? content = null,
  }) {
    return _then(_CreateCommentRequest(
      parentId: freezed == parentId
          ? _self.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$HighlightDto {
  String get id;
  String get userBookId;
  String get quoteText;
  int? get pageNumber;
  String? get noteText;
  DateTime get createdAt;

  /// Create a copy of HighlightDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HighlightDtoCopyWith<HighlightDto> get copyWith =>
      _$HighlightDtoCopyWithImpl<HighlightDto>(
          this as HighlightDto, _$identity);

  /// Serializes this HighlightDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HighlightDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userBookId, userBookId) ||
                other.userBookId == userBookId) &&
            (identical(other.quoteText, quoteText) ||
                other.quoteText == quoteText) &&
            (identical(other.pageNumber, pageNumber) ||
                other.pageNumber == pageNumber) &&
            (identical(other.noteText, noteText) ||
                other.noteText == noteText) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, userBookId, quoteText, pageNumber, noteText, createdAt);

  @override
  String toString() {
    return 'HighlightDto(id: $id, userBookId: $userBookId, quoteText: $quoteText, pageNumber: $pageNumber, noteText: $noteText, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $HighlightDtoCopyWith<$Res> {
  factory $HighlightDtoCopyWith(
          HighlightDto value, $Res Function(HighlightDto) _then) =
      _$HighlightDtoCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String userBookId,
      String quoteText,
      int? pageNumber,
      String? noteText,
      DateTime createdAt});
}

/// @nodoc
class _$HighlightDtoCopyWithImpl<$Res> implements $HighlightDtoCopyWith<$Res> {
  _$HighlightDtoCopyWithImpl(this._self, this._then);

  final HighlightDto _self;
  final $Res Function(HighlightDto) _then;

  /// Create a copy of HighlightDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userBookId = null,
    Object? quoteText = null,
    Object? pageNumber = freezed,
    Object? noteText = freezed,
    Object? createdAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userBookId: null == userBookId
          ? _self.userBookId
          : userBookId // ignore: cast_nullable_to_non_nullable
              as String,
      quoteText: null == quoteText
          ? _self.quoteText
          : quoteText // ignore: cast_nullable_to_non_nullable
              as String,
      pageNumber: freezed == pageNumber
          ? _self.pageNumber
          : pageNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      noteText: freezed == noteText
          ? _self.noteText
          : noteText // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [HighlightDto].
extension HighlightDtoPatterns on HighlightDto {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_HighlightDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HighlightDto() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_HighlightDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HighlightDto():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_HighlightDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HighlightDto() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String id, String userBookId, String quoteText,
            int? pageNumber, String? noteText, DateTime createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HighlightDto() when $default != null:
        return $default(_that.id, _that.userBookId, _that.quoteText,
            _that.pageNumber, _that.noteText, _that.createdAt);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String id, String userBookId, String quoteText,
            int? pageNumber, String? noteText, DateTime createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HighlightDto():
        return $default(_that.id, _that.userBookId, _that.quoteText,
            _that.pageNumber, _that.noteText, _that.createdAt);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String id, String userBookId, String quoteText,
            int? pageNumber, String? noteText, DateTime createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HighlightDto() when $default != null:
        return $default(_that.id, _that.userBookId, _that.quoteText,
            _that.pageNumber, _that.noteText, _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _HighlightDto extends HighlightDto {
  const _HighlightDto(
      {required this.id,
      required this.userBookId,
      required this.quoteText,
      this.pageNumber,
      this.noteText,
      required this.createdAt})
      : super._();
  factory _HighlightDto.fromJson(Map<String, dynamic> json) =>
      _$HighlightDtoFromJson(json);

  @override
  final String id;
  @override
  final String userBookId;
  @override
  final String quoteText;
  @override
  final int? pageNumber;
  @override
  final String? noteText;
  @override
  final DateTime createdAt;

  /// Create a copy of HighlightDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$HighlightDtoCopyWith<_HighlightDto> get copyWith =>
      __$HighlightDtoCopyWithImpl<_HighlightDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$HighlightDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _HighlightDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userBookId, userBookId) ||
                other.userBookId == userBookId) &&
            (identical(other.quoteText, quoteText) ||
                other.quoteText == quoteText) &&
            (identical(other.pageNumber, pageNumber) ||
                other.pageNumber == pageNumber) &&
            (identical(other.noteText, noteText) ||
                other.noteText == noteText) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, userBookId, quoteText, pageNumber, noteText, createdAt);

  @override
  String toString() {
    return 'HighlightDto(id: $id, userBookId: $userBookId, quoteText: $quoteText, pageNumber: $pageNumber, noteText: $noteText, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$HighlightDtoCopyWith<$Res>
    implements $HighlightDtoCopyWith<$Res> {
  factory _$HighlightDtoCopyWith(
          _HighlightDto value, $Res Function(_HighlightDto) _then) =
      __$HighlightDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String userBookId,
      String quoteText,
      int? pageNumber,
      String? noteText,
      DateTime createdAt});
}

/// @nodoc
class __$HighlightDtoCopyWithImpl<$Res>
    implements _$HighlightDtoCopyWith<$Res> {
  __$HighlightDtoCopyWithImpl(this._self, this._then);

  final _HighlightDto _self;
  final $Res Function(_HighlightDto) _then;

  /// Create a copy of HighlightDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? userBookId = null,
    Object? quoteText = null,
    Object? pageNumber = freezed,
    Object? noteText = freezed,
    Object? createdAt = null,
  }) {
    return _then(_HighlightDto(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userBookId: null == userBookId
          ? _self.userBookId
          : userBookId // ignore: cast_nullable_to_non_nullable
              as String,
      quoteText: null == quoteText
          ? _self.quoteText
          : quoteText // ignore: cast_nullable_to_non_nullable
              as String,
      pageNumber: freezed == pageNumber
          ? _self.pageNumber
          : pageNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      noteText: freezed == noteText
          ? _self.noteText
          : noteText // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
mixin _$HighlightPageDto {
  List<HighlightDto> get items;
  String? get nextCursor;

  /// Create a copy of HighlightPageDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HighlightPageDtoCopyWith<HighlightPageDto> get copyWith =>
      _$HighlightPageDtoCopyWithImpl<HighlightPageDto>(
          this as HighlightPageDto, _$identity);

  /// Serializes this HighlightPageDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HighlightPageDto &&
            const DeepCollectionEquality().equals(other.items, items) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(items), nextCursor);

  @override
  String toString() {
    return 'HighlightPageDto(items: $items, nextCursor: $nextCursor)';
  }
}

/// @nodoc
abstract mixin class $HighlightPageDtoCopyWith<$Res> {
  factory $HighlightPageDtoCopyWith(
          HighlightPageDto value, $Res Function(HighlightPageDto) _then) =
      _$HighlightPageDtoCopyWithImpl;
  @useResult
  $Res call({List<HighlightDto> items, String? nextCursor});
}

/// @nodoc
class _$HighlightPageDtoCopyWithImpl<$Res>
    implements $HighlightPageDtoCopyWith<$Res> {
  _$HighlightPageDtoCopyWithImpl(this._self, this._then);

  final HighlightPageDto _self;
  final $Res Function(HighlightPageDto) _then;

  /// Create a copy of HighlightPageDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? nextCursor = freezed,
  }) {
    return _then(_self.copyWith(
      items: null == items
          ? _self.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<HighlightDto>,
      nextCursor: freezed == nextCursor
          ? _self.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [HighlightPageDto].
extension HighlightPageDtoPatterns on HighlightPageDto {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_HighlightPageDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HighlightPageDto() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_HighlightPageDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HighlightPageDto():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_HighlightPageDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HighlightPageDto() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(List<HighlightDto> items, String? nextCursor)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HighlightPageDto() when $default != null:
        return $default(_that.items, _that.nextCursor);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(List<HighlightDto> items, String? nextCursor) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HighlightPageDto():
        return $default(_that.items, _that.nextCursor);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(List<HighlightDto> items, String? nextCursor)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HighlightPageDto() when $default != null:
        return $default(_that.items, _that.nextCursor);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _HighlightPageDto extends HighlightPageDto {
  const _HighlightPageDto(
      {required final List<HighlightDto> items, this.nextCursor})
      : _items = items,
        super._();
  factory _HighlightPageDto.fromJson(Map<String, dynamic> json) =>
      _$HighlightPageDtoFromJson(json);

  final List<HighlightDto> _items;
  @override
  List<HighlightDto> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final String? nextCursor;

  /// Create a copy of HighlightPageDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$HighlightPageDtoCopyWith<_HighlightPageDto> get copyWith =>
      __$HighlightPageDtoCopyWithImpl<_HighlightPageDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$HighlightPageDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _HighlightPageDto &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_items), nextCursor);

  @override
  String toString() {
    return 'HighlightPageDto(items: $items, nextCursor: $nextCursor)';
  }
}

/// @nodoc
abstract mixin class _$HighlightPageDtoCopyWith<$Res>
    implements $HighlightPageDtoCopyWith<$Res> {
  factory _$HighlightPageDtoCopyWith(
          _HighlightPageDto value, $Res Function(_HighlightPageDto) _then) =
      __$HighlightPageDtoCopyWithImpl;
  @override
  @useResult
  $Res call({List<HighlightDto> items, String? nextCursor});
}

/// @nodoc
class __$HighlightPageDtoCopyWithImpl<$Res>
    implements _$HighlightPageDtoCopyWith<$Res> {
  __$HighlightPageDtoCopyWithImpl(this._self, this._then);

  final _HighlightPageDto _self;
  final $Res Function(_HighlightPageDto) _then;

  /// Create a copy of HighlightPageDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? items = null,
    Object? nextCursor = freezed,
  }) {
    return _then(_HighlightPageDto(
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<HighlightDto>,
      nextCursor: freezed == nextCursor
          ? _self.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$CreateHighlightRequest {
  String get quoteText;
  int? get pageNumber;
  String? get noteText;

  /// Create a copy of CreateHighlightRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CreateHighlightRequestCopyWith<CreateHighlightRequest> get copyWith =>
      _$CreateHighlightRequestCopyWithImpl<CreateHighlightRequest>(
          this as CreateHighlightRequest, _$identity);

  /// Serializes this CreateHighlightRequest to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CreateHighlightRequest &&
            (identical(other.quoteText, quoteText) ||
                other.quoteText == quoteText) &&
            (identical(other.pageNumber, pageNumber) ||
                other.pageNumber == pageNumber) &&
            (identical(other.noteText, noteText) ||
                other.noteText == noteText));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, quoteText, pageNumber, noteText);

  @override
  String toString() {
    return 'CreateHighlightRequest(quoteText: $quoteText, pageNumber: $pageNumber, noteText: $noteText)';
  }
}

/// @nodoc
abstract mixin class $CreateHighlightRequestCopyWith<$Res> {
  factory $CreateHighlightRequestCopyWith(CreateHighlightRequest value,
          $Res Function(CreateHighlightRequest) _then) =
      _$CreateHighlightRequestCopyWithImpl;
  @useResult
  $Res call({String quoteText, int? pageNumber, String? noteText});
}

/// @nodoc
class _$CreateHighlightRequestCopyWithImpl<$Res>
    implements $CreateHighlightRequestCopyWith<$Res> {
  _$CreateHighlightRequestCopyWithImpl(this._self, this._then);

  final CreateHighlightRequest _self;
  final $Res Function(CreateHighlightRequest) _then;

  /// Create a copy of CreateHighlightRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? quoteText = null,
    Object? pageNumber = freezed,
    Object? noteText = freezed,
  }) {
    return _then(_self.copyWith(
      quoteText: null == quoteText
          ? _self.quoteText
          : quoteText // ignore: cast_nullable_to_non_nullable
              as String,
      pageNumber: freezed == pageNumber
          ? _self.pageNumber
          : pageNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      noteText: freezed == noteText
          ? _self.noteText
          : noteText // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [CreateHighlightRequest].
extension CreateHighlightRequestPatterns on CreateHighlightRequest {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_CreateHighlightRequest value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CreateHighlightRequest() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_CreateHighlightRequest value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreateHighlightRequest():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_CreateHighlightRequest value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreateHighlightRequest() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String quoteText, int? pageNumber, String? noteText)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CreateHighlightRequest() when $default != null:
        return $default(_that.quoteText, _that.pageNumber, _that.noteText);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String quoteText, int? pageNumber, String? noteText)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreateHighlightRequest():
        return $default(_that.quoteText, _that.pageNumber, _that.noteText);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String quoteText, int? pageNumber, String? noteText)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreateHighlightRequest() when $default != null:
        return $default(_that.quoteText, _that.pageNumber, _that.noteText);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CreateHighlightRequest implements CreateHighlightRequest {
  const _CreateHighlightRequest(
      {required this.quoteText, this.pageNumber, this.noteText});
  factory _CreateHighlightRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateHighlightRequestFromJson(json);

  @override
  final String quoteText;
  @override
  final int? pageNumber;
  @override
  final String? noteText;

  /// Create a copy of CreateHighlightRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CreateHighlightRequestCopyWith<_CreateHighlightRequest> get copyWith =>
      __$CreateHighlightRequestCopyWithImpl<_CreateHighlightRequest>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CreateHighlightRequestToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CreateHighlightRequest &&
            (identical(other.quoteText, quoteText) ||
                other.quoteText == quoteText) &&
            (identical(other.pageNumber, pageNumber) ||
                other.pageNumber == pageNumber) &&
            (identical(other.noteText, noteText) ||
                other.noteText == noteText));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, quoteText, pageNumber, noteText);

  @override
  String toString() {
    return 'CreateHighlightRequest(quoteText: $quoteText, pageNumber: $pageNumber, noteText: $noteText)';
  }
}

/// @nodoc
abstract mixin class _$CreateHighlightRequestCopyWith<$Res>
    implements $CreateHighlightRequestCopyWith<$Res> {
  factory _$CreateHighlightRequestCopyWith(_CreateHighlightRequest value,
          $Res Function(_CreateHighlightRequest) _then) =
      __$CreateHighlightRequestCopyWithImpl;
  @override
  @useResult
  $Res call({String quoteText, int? pageNumber, String? noteText});
}

/// @nodoc
class __$CreateHighlightRequestCopyWithImpl<$Res>
    implements _$CreateHighlightRequestCopyWith<$Res> {
  __$CreateHighlightRequestCopyWithImpl(this._self, this._then);

  final _CreateHighlightRequest _self;
  final $Res Function(_CreateHighlightRequest) _then;

  /// Create a copy of CreateHighlightRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? quoteText = null,
    Object? pageNumber = freezed,
    Object? noteText = freezed,
  }) {
    return _then(_CreateHighlightRequest(
      quoteText: null == quoteText
          ? _self.quoteText
          : quoteText // ignore: cast_nullable_to_non_nullable
              as String,
      pageNumber: freezed == pageNumber
          ? _self.pageNumber
          : pageNumber // ignore: cast_nullable_to_non_nullable
              as int?,
      noteText: freezed == noteText
          ? _self.noteText
          : noteText // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$BookHighlightGroupDto {
  String get userBookId;
  String get bookId;
  String? get bookTitle;
  String? get bookCoverUrl;
  List<HighlightDto> get highlights;

  /// Create a copy of BookHighlightGroupDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BookHighlightGroupDtoCopyWith<BookHighlightGroupDto> get copyWith =>
      _$BookHighlightGroupDtoCopyWithImpl<BookHighlightGroupDto>(
          this as BookHighlightGroupDto, _$identity);

  /// Serializes this BookHighlightGroupDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BookHighlightGroupDto &&
            (identical(other.userBookId, userBookId) ||
                other.userBookId == userBookId) &&
            (identical(other.bookId, bookId) || other.bookId == bookId) &&
            (identical(other.bookTitle, bookTitle) ||
                other.bookTitle == bookTitle) &&
            (identical(other.bookCoverUrl, bookCoverUrl) ||
                other.bookCoverUrl == bookCoverUrl) &&
            const DeepCollectionEquality()
                .equals(other.highlights, highlights));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userBookId, bookId, bookTitle,
      bookCoverUrl, const DeepCollectionEquality().hash(highlights));

  @override
  String toString() {
    return 'BookHighlightGroupDto(userBookId: $userBookId, bookId: $bookId, bookTitle: $bookTitle, bookCoverUrl: $bookCoverUrl, highlights: $highlights)';
  }
}

/// @nodoc
abstract mixin class $BookHighlightGroupDtoCopyWith<$Res> {
  factory $BookHighlightGroupDtoCopyWith(BookHighlightGroupDto value,
          $Res Function(BookHighlightGroupDto) _then) =
      _$BookHighlightGroupDtoCopyWithImpl;
  @useResult
  $Res call(
      {String userBookId,
      String bookId,
      String? bookTitle,
      String? bookCoverUrl,
      List<HighlightDto> highlights});
}

/// @nodoc
class _$BookHighlightGroupDtoCopyWithImpl<$Res>
    implements $BookHighlightGroupDtoCopyWith<$Res> {
  _$BookHighlightGroupDtoCopyWithImpl(this._self, this._then);

  final BookHighlightGroupDto _self;
  final $Res Function(BookHighlightGroupDto) _then;

  /// Create a copy of BookHighlightGroupDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userBookId = null,
    Object? bookId = null,
    Object? bookTitle = freezed,
    Object? bookCoverUrl = freezed,
    Object? highlights = null,
  }) {
    return _then(_self.copyWith(
      userBookId: null == userBookId
          ? _self.userBookId
          : userBookId // ignore: cast_nullable_to_non_nullable
              as String,
      bookId: null == bookId
          ? _self.bookId
          : bookId // ignore: cast_nullable_to_non_nullable
              as String,
      bookTitle: freezed == bookTitle
          ? _self.bookTitle
          : bookTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      bookCoverUrl: freezed == bookCoverUrl
          ? _self.bookCoverUrl
          : bookCoverUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      highlights: null == highlights
          ? _self.highlights
          : highlights // ignore: cast_nullable_to_non_nullable
              as List<HighlightDto>,
    ));
  }
}

/// Adds pattern-matching-related methods to [BookHighlightGroupDto].
extension BookHighlightGroupDtoPatterns on BookHighlightGroupDto {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_BookHighlightGroupDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BookHighlightGroupDto() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_BookHighlightGroupDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BookHighlightGroupDto():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_BookHighlightGroupDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BookHighlightGroupDto() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(String userBookId, String bookId, String? bookTitle,
            String? bookCoverUrl, List<HighlightDto> highlights)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BookHighlightGroupDto() when $default != null:
        return $default(_that.userBookId, _that.bookId, _that.bookTitle,
            _that.bookCoverUrl, _that.highlights);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(String userBookId, String bookId, String? bookTitle,
            String? bookCoverUrl, List<HighlightDto> highlights)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BookHighlightGroupDto():
        return $default(_that.userBookId, _that.bookId, _that.bookTitle,
            _that.bookCoverUrl, _that.highlights);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(String userBookId, String bookId, String? bookTitle,
            String? bookCoverUrl, List<HighlightDto> highlights)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BookHighlightGroupDto() when $default != null:
        return $default(_that.userBookId, _that.bookId, _that.bookTitle,
            _that.bookCoverUrl, _that.highlights);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _BookHighlightGroupDto extends BookHighlightGroupDto {
  const _BookHighlightGroupDto(
      {required this.userBookId,
      required this.bookId,
      this.bookTitle,
      this.bookCoverUrl,
      required final List<HighlightDto> highlights})
      : _highlights = highlights,
        super._();
  factory _BookHighlightGroupDto.fromJson(Map<String, dynamic> json) =>
      _$BookHighlightGroupDtoFromJson(json);

  @override
  final String userBookId;
  @override
  final String bookId;
  @override
  final String? bookTitle;
  @override
  final String? bookCoverUrl;
  final List<HighlightDto> _highlights;
  @override
  List<HighlightDto> get highlights {
    if (_highlights is EqualUnmodifiableListView) return _highlights;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_highlights);
  }

  /// Create a copy of BookHighlightGroupDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BookHighlightGroupDtoCopyWith<_BookHighlightGroupDto> get copyWith =>
      __$BookHighlightGroupDtoCopyWithImpl<_BookHighlightGroupDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BookHighlightGroupDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BookHighlightGroupDto &&
            (identical(other.userBookId, userBookId) ||
                other.userBookId == userBookId) &&
            (identical(other.bookId, bookId) || other.bookId == bookId) &&
            (identical(other.bookTitle, bookTitle) ||
                other.bookTitle == bookTitle) &&
            (identical(other.bookCoverUrl, bookCoverUrl) ||
                other.bookCoverUrl == bookCoverUrl) &&
            const DeepCollectionEquality()
                .equals(other._highlights, _highlights));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userBookId, bookId, bookTitle,
      bookCoverUrl, const DeepCollectionEquality().hash(_highlights));

  @override
  String toString() {
    return 'BookHighlightGroupDto(userBookId: $userBookId, bookId: $bookId, bookTitle: $bookTitle, bookCoverUrl: $bookCoverUrl, highlights: $highlights)';
  }
}

/// @nodoc
abstract mixin class _$BookHighlightGroupDtoCopyWith<$Res>
    implements $BookHighlightGroupDtoCopyWith<$Res> {
  factory _$BookHighlightGroupDtoCopyWith(_BookHighlightGroupDto value,
          $Res Function(_BookHighlightGroupDto) _then) =
      __$BookHighlightGroupDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String userBookId,
      String bookId,
      String? bookTitle,
      String? bookCoverUrl,
      List<HighlightDto> highlights});
}

/// @nodoc
class __$BookHighlightGroupDtoCopyWithImpl<$Res>
    implements _$BookHighlightGroupDtoCopyWith<$Res> {
  __$BookHighlightGroupDtoCopyWithImpl(this._self, this._then);

  final _BookHighlightGroupDto _self;
  final $Res Function(_BookHighlightGroupDto) _then;

  /// Create a copy of BookHighlightGroupDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? userBookId = null,
    Object? bookId = null,
    Object? bookTitle = freezed,
    Object? bookCoverUrl = freezed,
    Object? highlights = null,
  }) {
    return _then(_BookHighlightGroupDto(
      userBookId: null == userBookId
          ? _self.userBookId
          : userBookId // ignore: cast_nullable_to_non_nullable
              as String,
      bookId: null == bookId
          ? _self.bookId
          : bookId // ignore: cast_nullable_to_non_nullable
              as String,
      bookTitle: freezed == bookTitle
          ? _self.bookTitle
          : bookTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      bookCoverUrl: freezed == bookCoverUrl
          ? _self.bookCoverUrl
          : bookCoverUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      highlights: null == highlights
          ? _self._highlights
          : highlights // ignore: cast_nullable_to_non_nullable
              as List<HighlightDto>,
    ));
  }
}

/// @nodoc
mixin _$AllHighlightsResponseDto {
  List<BookHighlightGroupDto> get groups;

  /// Create a copy of AllHighlightsResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AllHighlightsResponseDtoCopyWith<AllHighlightsResponseDto> get copyWith =>
      _$AllHighlightsResponseDtoCopyWithImpl<AllHighlightsResponseDto>(
          this as AllHighlightsResponseDto, _$identity);

  /// Serializes this AllHighlightsResponseDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AllHighlightsResponseDto &&
            const DeepCollectionEquality().equals(other.groups, groups));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(groups));

  @override
  String toString() {
    return 'AllHighlightsResponseDto(groups: $groups)';
  }
}

/// @nodoc
abstract mixin class $AllHighlightsResponseDtoCopyWith<$Res> {
  factory $AllHighlightsResponseDtoCopyWith(AllHighlightsResponseDto value,
          $Res Function(AllHighlightsResponseDto) _then) =
      _$AllHighlightsResponseDtoCopyWithImpl;
  @useResult
  $Res call({List<BookHighlightGroupDto> groups});
}

/// @nodoc
class _$AllHighlightsResponseDtoCopyWithImpl<$Res>
    implements $AllHighlightsResponseDtoCopyWith<$Res> {
  _$AllHighlightsResponseDtoCopyWithImpl(this._self, this._then);

  final AllHighlightsResponseDto _self;
  final $Res Function(AllHighlightsResponseDto) _then;

  /// Create a copy of AllHighlightsResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groups = null,
  }) {
    return _then(_self.copyWith(
      groups: null == groups
          ? _self.groups
          : groups // ignore: cast_nullable_to_non_nullable
              as List<BookHighlightGroupDto>,
    ));
  }
}

/// Adds pattern-matching-related methods to [AllHighlightsResponseDto].
extension AllHighlightsResponseDtoPatterns on AllHighlightsResponseDto {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_AllHighlightsResponseDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AllHighlightsResponseDto() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_AllHighlightsResponseDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AllHighlightsResponseDto():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_AllHighlightsResponseDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AllHighlightsResponseDto() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(List<BookHighlightGroupDto> groups)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AllHighlightsResponseDto() when $default != null:
        return $default(_that.groups);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(List<BookHighlightGroupDto> groups) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AllHighlightsResponseDto():
        return $default(_that.groups);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(List<BookHighlightGroupDto> groups)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AllHighlightsResponseDto() when $default != null:
        return $default(_that.groups);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AllHighlightsResponseDto implements AllHighlightsResponseDto {
  const _AllHighlightsResponseDto(
      {required final List<BookHighlightGroupDto> groups})
      : _groups = groups;
  factory _AllHighlightsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AllHighlightsResponseDtoFromJson(json);

  final List<BookHighlightGroupDto> _groups;
  @override
  List<BookHighlightGroupDto> get groups {
    if (_groups is EqualUnmodifiableListView) return _groups;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_groups);
  }

  /// Create a copy of AllHighlightsResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AllHighlightsResponseDtoCopyWith<_AllHighlightsResponseDto> get copyWith =>
      __$AllHighlightsResponseDtoCopyWithImpl<_AllHighlightsResponseDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AllHighlightsResponseDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AllHighlightsResponseDto &&
            const DeepCollectionEquality().equals(other._groups, _groups));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_groups));

  @override
  String toString() {
    return 'AllHighlightsResponseDto(groups: $groups)';
  }
}

/// @nodoc
abstract mixin class _$AllHighlightsResponseDtoCopyWith<$Res>
    implements $AllHighlightsResponseDtoCopyWith<$Res> {
  factory _$AllHighlightsResponseDtoCopyWith(_AllHighlightsResponseDto value,
          $Res Function(_AllHighlightsResponseDto) _then) =
      __$AllHighlightsResponseDtoCopyWithImpl;
  @override
  @useResult
  $Res call({List<BookHighlightGroupDto> groups});
}

/// @nodoc
class __$AllHighlightsResponseDtoCopyWithImpl<$Res>
    implements _$AllHighlightsResponseDtoCopyWith<$Res> {
  __$AllHighlightsResponseDtoCopyWithImpl(this._self, this._then);

  final _AllHighlightsResponseDto _self;
  final $Res Function(_AllHighlightsResponseDto) _then;

  /// Create a copy of AllHighlightsResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? groups = null,
  }) {
    return _then(_AllHighlightsResponseDto(
      groups: null == groups
          ? _self._groups
          : groups // ignore: cast_nullable_to_non_nullable
              as List<BookHighlightGroupDto>,
    ));
  }
}

// dart format on
