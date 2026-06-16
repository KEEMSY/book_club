// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_comment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FeedComment {
  String get id;
  String get body;
  String get userId;
  String get eventId;
  String? get parentId;
  DateTime get createdAt;
  List<FeedComment> get replies;

  /// Create a copy of FeedComment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FeedCommentCopyWith<FeedComment> get copyWith =>
      _$FeedCommentCopyWithImpl<FeedComment>(this as FeedComment, _$identity);

  /// Serializes this FeedComment to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FeedComment &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.replies, replies));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, body, userId, eventId,
      parentId, createdAt, const DeepCollectionEquality().hash(replies));

  @override
  String toString() {
    return 'FeedComment(id: $id, body: $body, userId: $userId, eventId: $eventId, parentId: $parentId, createdAt: $createdAt, replies: $replies)';
  }
}

/// @nodoc
abstract mixin class $FeedCommentCopyWith<$Res> {
  factory $FeedCommentCopyWith(
          FeedComment value, $Res Function(FeedComment) _then) =
      _$FeedCommentCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String body,
      String userId,
      String eventId,
      String? parentId,
      DateTime createdAt,
      List<FeedComment> replies});
}

/// @nodoc
class _$FeedCommentCopyWithImpl<$Res> implements $FeedCommentCopyWith<$Res> {
  _$FeedCommentCopyWithImpl(this._self, this._then);

  final FeedComment _self;
  final $Res Function(FeedComment) _then;

  /// Create a copy of FeedComment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? body = null,
    Object? userId = null,
    Object? eventId = null,
    Object? parentId = freezed,
    Object? createdAt = null,
    Object? replies = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _self.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      eventId: null == eventId
          ? _self.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: freezed == parentId
          ? _self.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      replies: null == replies
          ? _self.replies
          : replies // ignore: cast_nullable_to_non_nullable
              as List<FeedComment>,
    ));
  }
}

/// Adds pattern-matching-related methods to [FeedComment].
extension FeedCommentPatterns on FeedComment {
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
    TResult Function(_FeedComment value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FeedComment() when $default != null:
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
    TResult Function(_FeedComment value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeedComment():
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
    TResult? Function(_FeedComment value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeedComment() when $default != null:
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
    TResult Function(String id, String body, String userId, String eventId,
            String? parentId, DateTime createdAt, List<FeedComment> replies)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FeedComment() when $default != null:
        return $default(_that.id, _that.body, _that.userId, _that.eventId,
            _that.parentId, _that.createdAt, _that.replies);
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
    TResult Function(String id, String body, String userId, String eventId,
            String? parentId, DateTime createdAt, List<FeedComment> replies)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeedComment():
        return $default(_that.id, _that.body, _that.userId, _that.eventId,
            _that.parentId, _that.createdAt, _that.replies);
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
    TResult? Function(String id, String body, String userId, String eventId,
            String? parentId, DateTime createdAt, List<FeedComment> replies)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeedComment() when $default != null:
        return $default(_that.id, _that.body, _that.userId, _that.eventId,
            _that.parentId, _that.createdAt, _that.replies);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _FeedComment implements FeedComment {
  const _FeedComment(
      {required this.id,
      required this.body,
      required this.userId,
      required this.eventId,
      this.parentId,
      required this.createdAt,
      final List<FeedComment> replies = const <FeedComment>[]})
      : _replies = replies;
  factory _FeedComment.fromJson(Map<String, dynamic> json) =>
      _$FeedCommentFromJson(json);

  @override
  final String id;
  @override
  final String body;
  @override
  final String userId;
  @override
  final String eventId;
  @override
  final String? parentId;
  @override
  final DateTime createdAt;
  final List<FeedComment> _replies;
  @override
  @JsonKey()
  List<FeedComment> get replies {
    if (_replies is EqualUnmodifiableListView) return _replies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_replies);
  }

  /// Create a copy of FeedComment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FeedCommentCopyWith<_FeedComment> get copyWith =>
      __$FeedCommentCopyWithImpl<_FeedComment>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$FeedCommentToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FeedComment &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other._replies, _replies));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, body, userId, eventId,
      parentId, createdAt, const DeepCollectionEquality().hash(_replies));

  @override
  String toString() {
    return 'FeedComment(id: $id, body: $body, userId: $userId, eventId: $eventId, parentId: $parentId, createdAt: $createdAt, replies: $replies)';
  }
}

/// @nodoc
abstract mixin class _$FeedCommentCopyWith<$Res>
    implements $FeedCommentCopyWith<$Res> {
  factory _$FeedCommentCopyWith(
          _FeedComment value, $Res Function(_FeedComment) _then) =
      __$FeedCommentCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String body,
      String userId,
      String eventId,
      String? parentId,
      DateTime createdAt,
      List<FeedComment> replies});
}

/// @nodoc
class __$FeedCommentCopyWithImpl<$Res> implements _$FeedCommentCopyWith<$Res> {
  __$FeedCommentCopyWithImpl(this._self, this._then);

  final _FeedComment _self;
  final $Res Function(_FeedComment) _then;

  /// Create a copy of FeedComment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? body = null,
    Object? userId = null,
    Object? eventId = null,
    Object? parentId = freezed,
    Object? createdAt = null,
    Object? replies = null,
  }) {
    return _then(_FeedComment(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _self.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      eventId: null == eventId
          ? _self.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: freezed == parentId
          ? _self.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      replies: null == replies
          ? _self._replies
          : replies // ignore: cast_nullable_to_non_nullable
              as List<FeedComment>,
    ));
  }
}

/// @nodoc
mixin _$FeedCommentList {
  List<FeedComment> get comments;

  /// Create a copy of FeedCommentList
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FeedCommentListCopyWith<FeedCommentList> get copyWith =>
      _$FeedCommentListCopyWithImpl<FeedCommentList>(
          this as FeedCommentList, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FeedCommentList &&
            const DeepCollectionEquality().equals(other.comments, comments));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(comments));

  @override
  String toString() {
    return 'FeedCommentList(comments: $comments)';
  }
}

/// @nodoc
abstract mixin class $FeedCommentListCopyWith<$Res> {
  factory $FeedCommentListCopyWith(
          FeedCommentList value, $Res Function(FeedCommentList) _then) =
      _$FeedCommentListCopyWithImpl;
  @useResult
  $Res call({List<FeedComment> comments});
}

/// @nodoc
class _$FeedCommentListCopyWithImpl<$Res>
    implements $FeedCommentListCopyWith<$Res> {
  _$FeedCommentListCopyWithImpl(this._self, this._then);

  final FeedCommentList _self;
  final $Res Function(FeedCommentList) _then;

  /// Create a copy of FeedCommentList
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? comments = null,
  }) {
    return _then(_self.copyWith(
      comments: null == comments
          ? _self.comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<FeedComment>,
    ));
  }
}

/// Adds pattern-matching-related methods to [FeedCommentList].
extension FeedCommentListPatterns on FeedCommentList {
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
    TResult Function(_FeedCommentList value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FeedCommentList() when $default != null:
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
    TResult Function(_FeedCommentList value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeedCommentList():
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
    TResult? Function(_FeedCommentList value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeedCommentList() when $default != null:
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
    TResult Function(List<FeedComment> comments)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FeedCommentList() when $default != null:
        return $default(_that.comments);
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
    TResult Function(List<FeedComment> comments) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeedCommentList():
        return $default(_that.comments);
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
    TResult? Function(List<FeedComment> comments)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeedCommentList() when $default != null:
        return $default(_that.comments);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _FeedCommentList implements FeedCommentList {
  const _FeedCommentList({required final List<FeedComment> comments})
      : _comments = comments;

  final List<FeedComment> _comments;
  @override
  List<FeedComment> get comments {
    if (_comments is EqualUnmodifiableListView) return _comments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_comments);
  }

  /// Create a copy of FeedCommentList
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FeedCommentListCopyWith<_FeedCommentList> get copyWith =>
      __$FeedCommentListCopyWithImpl<_FeedCommentList>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FeedCommentList &&
            const DeepCollectionEquality().equals(other._comments, _comments));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_comments));

  @override
  String toString() {
    return 'FeedCommentList(comments: $comments)';
  }
}

/// @nodoc
abstract mixin class _$FeedCommentListCopyWith<$Res>
    implements $FeedCommentListCopyWith<$Res> {
  factory _$FeedCommentListCopyWith(
          _FeedCommentList value, $Res Function(_FeedCommentList) _then) =
      __$FeedCommentListCopyWithImpl;
  @override
  @useResult
  $Res call({List<FeedComment> comments});
}

/// @nodoc
class __$FeedCommentListCopyWithImpl<$Res>
    implements _$FeedCommentListCopyWith<$Res> {
  __$FeedCommentListCopyWithImpl(this._self, this._then);

  final _FeedCommentList _self;
  final $Res Function(_FeedCommentList) _then;

  /// Create a copy of FeedCommentList
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? comments = null,
  }) {
    return _then(_FeedCommentList(
      comments: null == comments
          ? _self._comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<FeedComment>,
    ));
  }
}

// dart format on
