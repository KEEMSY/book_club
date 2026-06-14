// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BookSearchItem {
  String get id;
  String get title;
  String get author;
  String? get thumbnailUrl;

  /// Create a copy of BookSearchItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BookSearchItemCopyWith<BookSearchItem> get copyWith =>
      _$BookSearchItemCopyWithImpl<BookSearchItem>(
          this as BookSearchItem, _$identity);

  /// Serializes this BookSearchItem to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BookSearchItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, author, thumbnailUrl);

  @override
  String toString() {
    return 'BookSearchItem(id: $id, title: $title, author: $author, thumbnailUrl: $thumbnailUrl)';
  }
}

/// @nodoc
abstract mixin class $BookSearchItemCopyWith<$Res> {
  factory $BookSearchItemCopyWith(
          BookSearchItem value, $Res Function(BookSearchItem) _then) =
      _$BookSearchItemCopyWithImpl;
  @useResult
  $Res call({String id, String title, String author, String? thumbnailUrl});
}

/// @nodoc
class _$BookSearchItemCopyWithImpl<$Res>
    implements $BookSearchItemCopyWith<$Res> {
  _$BookSearchItemCopyWithImpl(this._self, this._then);

  final BookSearchItem _self;
  final $Res Function(BookSearchItem) _then;

  /// Create a copy of BookSearchItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? author = null,
    Object? thumbnailUrl = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      author: null == author
          ? _self.author
          : author // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnailUrl: freezed == thumbnailUrl
          ? _self.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [BookSearchItem].
extension BookSearchItemPatterns on BookSearchItem {
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
    TResult Function(_BookSearchItem value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BookSearchItem() when $default != null:
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
    TResult Function(_BookSearchItem value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BookSearchItem():
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
    TResult? Function(_BookSearchItem value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BookSearchItem() when $default != null:
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
            String id, String title, String author, String? thumbnailUrl)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BookSearchItem() when $default != null:
        return $default(
            _that.id, _that.title, _that.author, _that.thumbnailUrl);
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
            String id, String title, String author, String? thumbnailUrl)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BookSearchItem():
        return $default(
            _that.id, _that.title, _that.author, _that.thumbnailUrl);
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
            String id, String title, String author, String? thumbnailUrl)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BookSearchItem() when $default != null:
        return $default(
            _that.id, _that.title, _that.author, _that.thumbnailUrl);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _BookSearchItem implements BookSearchItem {
  const _BookSearchItem(
      {required this.id,
      required this.title,
      required this.author,
      this.thumbnailUrl});
  factory _BookSearchItem.fromJson(Map<String, dynamic> json) =>
      _$BookSearchItemFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String author;
  @override
  final String? thumbnailUrl;

  /// Create a copy of BookSearchItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BookSearchItemCopyWith<_BookSearchItem> get copyWith =>
      __$BookSearchItemCopyWithImpl<_BookSearchItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BookSearchItemToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BookSearchItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, author, thumbnailUrl);

  @override
  String toString() {
    return 'BookSearchItem(id: $id, title: $title, author: $author, thumbnailUrl: $thumbnailUrl)';
  }
}

/// @nodoc
abstract mixin class _$BookSearchItemCopyWith<$Res>
    implements $BookSearchItemCopyWith<$Res> {
  factory _$BookSearchItemCopyWith(
          _BookSearchItem value, $Res Function(_BookSearchItem) _then) =
      __$BookSearchItemCopyWithImpl;
  @override
  @useResult
  $Res call({String id, String title, String author, String? thumbnailUrl});
}

/// @nodoc
class __$BookSearchItemCopyWithImpl<$Res>
    implements _$BookSearchItemCopyWith<$Res> {
  __$BookSearchItemCopyWithImpl(this._self, this._then);

  final _BookSearchItem _self;
  final $Res Function(_BookSearchItem) _then;

  /// Create a copy of BookSearchItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? author = null,
    Object? thumbnailUrl = freezed,
  }) {
    return _then(_BookSearchItem(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      author: null == author
          ? _self.author
          : author // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnailUrl: freezed == thumbnailUrl
          ? _self.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$UserSearchItem {
  String get id;
  String get nickname;
  String? get avatarUrl;

  /// Create a copy of UserSearchItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserSearchItemCopyWith<UserSearchItem> get copyWith =>
      _$UserSearchItemCopyWithImpl<UserSearchItem>(
          this as UserSearchItem, _$identity);

  /// Serializes this UserSearchItem to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserSearchItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, nickname, avatarUrl);

  @override
  String toString() {
    return 'UserSearchItem(id: $id, nickname: $nickname, avatarUrl: $avatarUrl)';
  }
}

/// @nodoc
abstract mixin class $UserSearchItemCopyWith<$Res> {
  factory $UserSearchItemCopyWith(
          UserSearchItem value, $Res Function(UserSearchItem) _then) =
      _$UserSearchItemCopyWithImpl;
  @useResult
  $Res call({String id, String nickname, String? avatarUrl});
}

/// @nodoc
class _$UserSearchItemCopyWithImpl<$Res>
    implements $UserSearchItemCopyWith<$Res> {
  _$UserSearchItemCopyWithImpl(this._self, this._then);

  final UserSearchItem _self;
  final $Res Function(UserSearchItem) _then;

  /// Create a copy of UserSearchItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? nickname = null,
    Object? avatarUrl = freezed,
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
      avatarUrl: freezed == avatarUrl
          ? _self.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [UserSearchItem].
extension UserSearchItemPatterns on UserSearchItem {
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
    TResult Function(_UserSearchItem value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserSearchItem() when $default != null:
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
    TResult Function(_UserSearchItem value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserSearchItem():
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
    TResult? Function(_UserSearchItem value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserSearchItem() when $default != null:
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
    TResult Function(String id, String nickname, String? avatarUrl)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserSearchItem() when $default != null:
        return $default(_that.id, _that.nickname, _that.avatarUrl);
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
    TResult Function(String id, String nickname, String? avatarUrl) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserSearchItem():
        return $default(_that.id, _that.nickname, _that.avatarUrl);
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
    TResult? Function(String id, String nickname, String? avatarUrl)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserSearchItem() when $default != null:
        return $default(_that.id, _that.nickname, _that.avatarUrl);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _UserSearchItem implements UserSearchItem {
  const _UserSearchItem(
      {required this.id, required this.nickname, this.avatarUrl});
  factory _UserSearchItem.fromJson(Map<String, dynamic> json) =>
      _$UserSearchItemFromJson(json);

  @override
  final String id;
  @override
  final String nickname;
  @override
  final String? avatarUrl;

  /// Create a copy of UserSearchItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserSearchItemCopyWith<_UserSearchItem> get copyWith =>
      __$UserSearchItemCopyWithImpl<_UserSearchItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UserSearchItemToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserSearchItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, nickname, avatarUrl);

  @override
  String toString() {
    return 'UserSearchItem(id: $id, nickname: $nickname, avatarUrl: $avatarUrl)';
  }
}

/// @nodoc
abstract mixin class _$UserSearchItemCopyWith<$Res>
    implements $UserSearchItemCopyWith<$Res> {
  factory _$UserSearchItemCopyWith(
          _UserSearchItem value, $Res Function(_UserSearchItem) _then) =
      __$UserSearchItemCopyWithImpl;
  @override
  @useResult
  $Res call({String id, String nickname, String? avatarUrl});
}

/// @nodoc
class __$UserSearchItemCopyWithImpl<$Res>
    implements _$UserSearchItemCopyWith<$Res> {
  __$UserSearchItemCopyWithImpl(this._self, this._then);

  final _UserSearchItem _self;
  final $Res Function(_UserSearchItem) _then;

  /// Create a copy of UserSearchItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? nickname = null,
    Object? avatarUrl = freezed,
  }) {
    return _then(_UserSearchItem(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      avatarUrl: freezed == avatarUrl
          ? _self.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$ClubSearchItem {
  String get id;
  String get name;
  int get memberCount;
  String? get currentBookTitle;

  /// Create a copy of ClubSearchItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ClubSearchItemCopyWith<ClubSearchItem> get copyWith =>
      _$ClubSearchItemCopyWithImpl<ClubSearchItem>(
          this as ClubSearchItem, _$identity);

  /// Serializes this ClubSearchItem to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ClubSearchItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.memberCount, memberCount) ||
                other.memberCount == memberCount) &&
            (identical(other.currentBookTitle, currentBookTitle) ||
                other.currentBookTitle == currentBookTitle));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, memberCount, currentBookTitle);

  @override
  String toString() {
    return 'ClubSearchItem(id: $id, name: $name, memberCount: $memberCount, currentBookTitle: $currentBookTitle)';
  }
}

/// @nodoc
abstract mixin class $ClubSearchItemCopyWith<$Res> {
  factory $ClubSearchItemCopyWith(
          ClubSearchItem value, $Res Function(ClubSearchItem) _then) =
      _$ClubSearchItemCopyWithImpl;
  @useResult
  $Res call(
      {String id, String name, int memberCount, String? currentBookTitle});
}

/// @nodoc
class _$ClubSearchItemCopyWithImpl<$Res>
    implements $ClubSearchItemCopyWith<$Res> {
  _$ClubSearchItemCopyWithImpl(this._self, this._then);

  final ClubSearchItem _self;
  final $Res Function(ClubSearchItem) _then;

  /// Create a copy of ClubSearchItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? memberCount = null,
    Object? currentBookTitle = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      memberCount: null == memberCount
          ? _self.memberCount
          : memberCount // ignore: cast_nullable_to_non_nullable
              as int,
      currentBookTitle: freezed == currentBookTitle
          ? _self.currentBookTitle
          : currentBookTitle // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [ClubSearchItem].
extension ClubSearchItemPatterns on ClubSearchItem {
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
    TResult Function(_ClubSearchItem value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ClubSearchItem() when $default != null:
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
    TResult Function(_ClubSearchItem value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ClubSearchItem():
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
    TResult? Function(_ClubSearchItem value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ClubSearchItem() when $default != null:
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
            String id, String name, int memberCount, String? currentBookTitle)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ClubSearchItem() when $default != null:
        return $default(
            _that.id, _that.name, _that.memberCount, _that.currentBookTitle);
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
            String id, String name, int memberCount, String? currentBookTitle)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ClubSearchItem():
        return $default(
            _that.id, _that.name, _that.memberCount, _that.currentBookTitle);
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
            String id, String name, int memberCount, String? currentBookTitle)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ClubSearchItem() when $default != null:
        return $default(
            _that.id, _that.name, _that.memberCount, _that.currentBookTitle);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ClubSearchItem implements ClubSearchItem {
  const _ClubSearchItem(
      {required this.id,
      required this.name,
      required this.memberCount,
      this.currentBookTitle});
  factory _ClubSearchItem.fromJson(Map<String, dynamic> json) =>
      _$ClubSearchItemFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final int memberCount;
  @override
  final String? currentBookTitle;

  /// Create a copy of ClubSearchItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ClubSearchItemCopyWith<_ClubSearchItem> get copyWith =>
      __$ClubSearchItemCopyWithImpl<_ClubSearchItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ClubSearchItemToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ClubSearchItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.memberCount, memberCount) ||
                other.memberCount == memberCount) &&
            (identical(other.currentBookTitle, currentBookTitle) ||
                other.currentBookTitle == currentBookTitle));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, memberCount, currentBookTitle);

  @override
  String toString() {
    return 'ClubSearchItem(id: $id, name: $name, memberCount: $memberCount, currentBookTitle: $currentBookTitle)';
  }
}

/// @nodoc
abstract mixin class _$ClubSearchItemCopyWith<$Res>
    implements $ClubSearchItemCopyWith<$Res> {
  factory _$ClubSearchItemCopyWith(
          _ClubSearchItem value, $Res Function(_ClubSearchItem) _then) =
      __$ClubSearchItemCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id, String name, int memberCount, String? currentBookTitle});
}

/// @nodoc
class __$ClubSearchItemCopyWithImpl<$Res>
    implements _$ClubSearchItemCopyWith<$Res> {
  __$ClubSearchItemCopyWithImpl(this._self, this._then);

  final _ClubSearchItem _self;
  final $Res Function(_ClubSearchItem) _then;

  /// Create a copy of ClubSearchItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? memberCount = null,
    Object? currentBookTitle = freezed,
  }) {
    return _then(_ClubSearchItem(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      memberCount: null == memberCount
          ? _self.memberCount
          : memberCount // ignore: cast_nullable_to_non_nullable
              as int,
      currentBookTitle: freezed == currentBookTitle
          ? _self.currentBookTitle
          : currentBookTitle // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$SearchResult {
  List<BookSearchItem> get books;
  List<UserSearchItem> get users;
  List<ClubSearchItem> get clubs;

  /// Create a copy of SearchResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SearchResultCopyWith<SearchResult> get copyWith =>
      _$SearchResultCopyWithImpl<SearchResult>(
          this as SearchResult, _$identity);

  /// Serializes this SearchResult to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SearchResult &&
            const DeepCollectionEquality().equals(other.books, books) &&
            const DeepCollectionEquality().equals(other.users, users) &&
            const DeepCollectionEquality().equals(other.clubs, clubs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(books),
      const DeepCollectionEquality().hash(users),
      const DeepCollectionEquality().hash(clubs));

  @override
  String toString() {
    return 'SearchResult(books: $books, users: $users, clubs: $clubs)';
  }
}

/// @nodoc
abstract mixin class $SearchResultCopyWith<$Res> {
  factory $SearchResultCopyWith(
          SearchResult value, $Res Function(SearchResult) _then) =
      _$SearchResultCopyWithImpl;
  @useResult
  $Res call(
      {List<BookSearchItem> books,
      List<UserSearchItem> users,
      List<ClubSearchItem> clubs});
}

/// @nodoc
class _$SearchResultCopyWithImpl<$Res> implements $SearchResultCopyWith<$Res> {
  _$SearchResultCopyWithImpl(this._self, this._then);

  final SearchResult _self;
  final $Res Function(SearchResult) _then;

  /// Create a copy of SearchResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? books = null,
    Object? users = null,
    Object? clubs = null,
  }) {
    return _then(_self.copyWith(
      books: null == books
          ? _self.books
          : books // ignore: cast_nullable_to_non_nullable
              as List<BookSearchItem>,
      users: null == users
          ? _self.users
          : users // ignore: cast_nullable_to_non_nullable
              as List<UserSearchItem>,
      clubs: null == clubs
          ? _self.clubs
          : clubs // ignore: cast_nullable_to_non_nullable
              as List<ClubSearchItem>,
    ));
  }
}

/// Adds pattern-matching-related methods to [SearchResult].
extension SearchResultPatterns on SearchResult {
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
    TResult Function(_SearchResult value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SearchResult() when $default != null:
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
    TResult Function(_SearchResult value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SearchResult():
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
    TResult? Function(_SearchResult value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SearchResult() when $default != null:
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
    TResult Function(List<BookSearchItem> books, List<UserSearchItem> users,
            List<ClubSearchItem> clubs)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SearchResult() when $default != null:
        return $default(_that.books, _that.users, _that.clubs);
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
    TResult Function(List<BookSearchItem> books, List<UserSearchItem> users,
            List<ClubSearchItem> clubs)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SearchResult():
        return $default(_that.books, _that.users, _that.clubs);
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
    TResult? Function(List<BookSearchItem> books, List<UserSearchItem> users,
            List<ClubSearchItem> clubs)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SearchResult() when $default != null:
        return $default(_that.books, _that.users, _that.clubs);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SearchResult implements SearchResult {
  const _SearchResult(
      {required final List<BookSearchItem> books,
      required final List<UserSearchItem> users,
      required final List<ClubSearchItem> clubs})
      : _books = books,
        _users = users,
        _clubs = clubs;
  factory _SearchResult.fromJson(Map<String, dynamic> json) =>
      _$SearchResultFromJson(json);

  final List<BookSearchItem> _books;
  @override
  List<BookSearchItem> get books {
    if (_books is EqualUnmodifiableListView) return _books;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_books);
  }

  final List<UserSearchItem> _users;
  @override
  List<UserSearchItem> get users {
    if (_users is EqualUnmodifiableListView) return _users;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_users);
  }

  final List<ClubSearchItem> _clubs;
  @override
  List<ClubSearchItem> get clubs {
    if (_clubs is EqualUnmodifiableListView) return _clubs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_clubs);
  }

  /// Create a copy of SearchResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SearchResultCopyWith<_SearchResult> get copyWith =>
      __$SearchResultCopyWithImpl<_SearchResult>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SearchResultToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SearchResult &&
            const DeepCollectionEquality().equals(other._books, _books) &&
            const DeepCollectionEquality().equals(other._users, _users) &&
            const DeepCollectionEquality().equals(other._clubs, _clubs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_books),
      const DeepCollectionEquality().hash(_users),
      const DeepCollectionEquality().hash(_clubs));

  @override
  String toString() {
    return 'SearchResult(books: $books, users: $users, clubs: $clubs)';
  }
}

/// @nodoc
abstract mixin class _$SearchResultCopyWith<$Res>
    implements $SearchResultCopyWith<$Res> {
  factory _$SearchResultCopyWith(
          _SearchResult value, $Res Function(_SearchResult) _then) =
      __$SearchResultCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<BookSearchItem> books,
      List<UserSearchItem> users,
      List<ClubSearchItem> clubs});
}

/// @nodoc
class __$SearchResultCopyWithImpl<$Res>
    implements _$SearchResultCopyWith<$Res> {
  __$SearchResultCopyWithImpl(this._self, this._then);

  final _SearchResult _self;
  final $Res Function(_SearchResult) _then;

  /// Create a copy of SearchResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? books = null,
    Object? users = null,
    Object? clubs = null,
  }) {
    return _then(_SearchResult(
      books: null == books
          ? _self._books
          : books // ignore: cast_nullable_to_non_nullable
              as List<BookSearchItem>,
      users: null == users
          ? _self._users
          : users // ignore: cast_nullable_to_non_nullable
              as List<UserSearchItem>,
      clubs: null == clubs
          ? _self._clubs
          : clubs // ignore: cast_nullable_to_non_nullable
              as List<ClubSearchItem>,
    ));
  }
}

// dart format on
