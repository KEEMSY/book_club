// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'topic_comment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TopicComment {
  String get id;
  String get topicId;
  String get authorId;
  String? get authorName;
  String? get parentCommentId;
  String get body;
  DateTime get createdAt;
  DateTime? get editedAt;

  /// Create a copy of TopicComment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TopicCommentCopyWith<TopicComment> get copyWith =>
      _$TopicCommentCopyWithImpl<TopicComment>(
          this as TopicComment, _$identity);

  /// Serializes this TopicComment to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TopicComment &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.topicId, topicId) || other.topicId == topicId) &&
            (identical(other.authorId, authorId) ||
                other.authorId == authorId) &&
            (identical(other.authorName, authorName) ||
                other.authorName == authorName) &&
            (identical(other.parentCommentId, parentCommentId) ||
                other.parentCommentId == parentCommentId) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.editedAt, editedAt) ||
                other.editedAt == editedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, topicId, authorId,
      authorName, parentCommentId, body, createdAt, editedAt);

  @override
  String toString() {
    return 'TopicComment(id: $id, topicId: $topicId, authorId: $authorId, authorName: $authorName, parentCommentId: $parentCommentId, body: $body, createdAt: $createdAt, editedAt: $editedAt)';
  }
}

/// @nodoc
abstract mixin class $TopicCommentCopyWith<$Res> {
  factory $TopicCommentCopyWith(
          TopicComment value, $Res Function(TopicComment) _then) =
      _$TopicCommentCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String topicId,
      String authorId,
      String? authorName,
      String? parentCommentId,
      String body,
      DateTime createdAt,
      DateTime? editedAt});
}

/// @nodoc
class _$TopicCommentCopyWithImpl<$Res> implements $TopicCommentCopyWith<$Res> {
  _$TopicCommentCopyWithImpl(this._self, this._then);

  final TopicComment _self;
  final $Res Function(TopicComment) _then;

  /// Create a copy of TopicComment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? topicId = null,
    Object? authorId = null,
    Object? authorName = freezed,
    Object? parentCommentId = freezed,
    Object? body = null,
    Object? createdAt = null,
    Object? editedAt = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      topicId: null == topicId
          ? _self.topicId
          : topicId // ignore: cast_nullable_to_non_nullable
              as String,
      authorId: null == authorId
          ? _self.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
      authorName: freezed == authorName
          ? _self.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String?,
      parentCommentId: freezed == parentCommentId
          ? _self.parentCommentId
          : parentCommentId // ignore: cast_nullable_to_non_nullable
              as String?,
      body: null == body
          ? _self.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      editedAt: freezed == editedAt
          ? _self.editedAt
          : editedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [TopicComment].
extension TopicCommentPatterns on TopicComment {
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
    TResult Function(_TopicComment value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TopicComment() when $default != null:
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
    TResult Function(_TopicComment value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TopicComment():
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
    TResult? Function(_TopicComment value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TopicComment() when $default != null:
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
            String topicId,
            String authorId,
            String? authorName,
            String? parentCommentId,
            String body,
            DateTime createdAt,
            DateTime? editedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TopicComment() when $default != null:
        return $default(
            _that.id,
            _that.topicId,
            _that.authorId,
            _that.authorName,
            _that.parentCommentId,
            _that.body,
            _that.createdAt,
            _that.editedAt);
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
            String topicId,
            String authorId,
            String? authorName,
            String? parentCommentId,
            String body,
            DateTime createdAt,
            DateTime? editedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TopicComment():
        return $default(
            _that.id,
            _that.topicId,
            _that.authorId,
            _that.authorName,
            _that.parentCommentId,
            _that.body,
            _that.createdAt,
            _that.editedAt);
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
            String topicId,
            String authorId,
            String? authorName,
            String? parentCommentId,
            String body,
            DateTime createdAt,
            DateTime? editedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TopicComment() when $default != null:
        return $default(
            _that.id,
            _that.topicId,
            _that.authorId,
            _that.authorName,
            _that.parentCommentId,
            _that.body,
            _that.createdAt,
            _that.editedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TopicComment implements TopicComment {
  const _TopicComment(
      {required this.id,
      required this.topicId,
      required this.authorId,
      this.authorName,
      this.parentCommentId,
      required this.body,
      required this.createdAt,
      this.editedAt});
  factory _TopicComment.fromJson(Map<String, dynamic> json) =>
      _$TopicCommentFromJson(json);

  @override
  final String id;
  @override
  final String topicId;
  @override
  final String authorId;
  @override
  final String? authorName;
  @override
  final String? parentCommentId;
  @override
  final String body;
  @override
  final DateTime createdAt;
  @override
  final DateTime? editedAt;

  /// Create a copy of TopicComment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TopicCommentCopyWith<_TopicComment> get copyWith =>
      __$TopicCommentCopyWithImpl<_TopicComment>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TopicCommentToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TopicComment &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.topicId, topicId) || other.topicId == topicId) &&
            (identical(other.authorId, authorId) ||
                other.authorId == authorId) &&
            (identical(other.authorName, authorName) ||
                other.authorName == authorName) &&
            (identical(other.parentCommentId, parentCommentId) ||
                other.parentCommentId == parentCommentId) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.editedAt, editedAt) ||
                other.editedAt == editedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, topicId, authorId,
      authorName, parentCommentId, body, createdAt, editedAt);

  @override
  String toString() {
    return 'TopicComment(id: $id, topicId: $topicId, authorId: $authorId, authorName: $authorName, parentCommentId: $parentCommentId, body: $body, createdAt: $createdAt, editedAt: $editedAt)';
  }
}

/// @nodoc
abstract mixin class _$TopicCommentCopyWith<$Res>
    implements $TopicCommentCopyWith<$Res> {
  factory _$TopicCommentCopyWith(
          _TopicComment value, $Res Function(_TopicComment) _then) =
      __$TopicCommentCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String topicId,
      String authorId,
      String? authorName,
      String? parentCommentId,
      String body,
      DateTime createdAt,
      DateTime? editedAt});
}

/// @nodoc
class __$TopicCommentCopyWithImpl<$Res>
    implements _$TopicCommentCopyWith<$Res> {
  __$TopicCommentCopyWithImpl(this._self, this._then);

  final _TopicComment _self;
  final $Res Function(_TopicComment) _then;

  /// Create a copy of TopicComment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? topicId = null,
    Object? authorId = null,
    Object? authorName = freezed,
    Object? parentCommentId = freezed,
    Object? body = null,
    Object? createdAt = null,
    Object? editedAt = freezed,
  }) {
    return _then(_TopicComment(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      topicId: null == topicId
          ? _self.topicId
          : topicId // ignore: cast_nullable_to_non_nullable
              as String,
      authorId: null == authorId
          ? _self.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
      authorName: freezed == authorName
          ? _self.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String?,
      parentCommentId: freezed == parentCommentId
          ? _self.parentCommentId
          : parentCommentId // ignore: cast_nullable_to_non_nullable
              as String?,
      body: null == body
          ? _self.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      editedAt: freezed == editedAt
          ? _self.editedAt
          : editedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
