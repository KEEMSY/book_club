// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_reaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FeedReaction {
  String get id;
  String get emoji;
  String get userId;
  DateTime get createdAt;

  /// Create a copy of FeedReaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FeedReactionCopyWith<FeedReaction> get copyWith =>
      _$FeedReactionCopyWithImpl<FeedReaction>(
          this as FeedReaction, _$identity);

  /// Serializes this FeedReaction to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FeedReaction &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.emoji, emoji) || other.emoji == emoji) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, emoji, userId, createdAt);

  @override
  String toString() {
    return 'FeedReaction(id: $id, emoji: $emoji, userId: $userId, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $FeedReactionCopyWith<$Res> {
  factory $FeedReactionCopyWith(
          FeedReaction value, $Res Function(FeedReaction) _then) =
      _$FeedReactionCopyWithImpl;
  @useResult
  $Res call({String id, String emoji, String userId, DateTime createdAt});
}

/// @nodoc
class _$FeedReactionCopyWithImpl<$Res> implements $FeedReactionCopyWith<$Res> {
  _$FeedReactionCopyWithImpl(this._self, this._then);

  final FeedReaction _self;
  final $Res Function(FeedReaction) _then;

  /// Create a copy of FeedReaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? emoji = null,
    Object? userId = null,
    Object? createdAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      emoji: null == emoji
          ? _self.emoji
          : emoji // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [FeedReaction].
extension FeedReactionPatterns on FeedReaction {
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
    TResult Function(_FeedReaction value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FeedReaction() when $default != null:
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
    TResult Function(_FeedReaction value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeedReaction():
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
    TResult? Function(_FeedReaction value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeedReaction() when $default != null:
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
            String id, String emoji, String userId, DateTime createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FeedReaction() when $default != null:
        return $default(_that.id, _that.emoji, _that.userId, _that.createdAt);
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
    TResult Function(String id, String emoji, String userId, DateTime createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeedReaction():
        return $default(_that.id, _that.emoji, _that.userId, _that.createdAt);
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
            String id, String emoji, String userId, DateTime createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FeedReaction() when $default != null:
        return $default(_that.id, _that.emoji, _that.userId, _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _FeedReaction implements FeedReaction {
  const _FeedReaction(
      {required this.id,
      required this.emoji,
      required this.userId,
      required this.createdAt});
  factory _FeedReaction.fromJson(Map<String, dynamic> json) =>
      _$FeedReactionFromJson(json);

  @override
  final String id;
  @override
  final String emoji;
  @override
  final String userId;
  @override
  final DateTime createdAt;

  /// Create a copy of FeedReaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FeedReactionCopyWith<_FeedReaction> get copyWith =>
      __$FeedReactionCopyWithImpl<_FeedReaction>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$FeedReactionToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FeedReaction &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.emoji, emoji) || other.emoji == emoji) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, emoji, userId, createdAt);

  @override
  String toString() {
    return 'FeedReaction(id: $id, emoji: $emoji, userId: $userId, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$FeedReactionCopyWith<$Res>
    implements $FeedReactionCopyWith<$Res> {
  factory _$FeedReactionCopyWith(
          _FeedReaction value, $Res Function(_FeedReaction) _then) =
      __$FeedReactionCopyWithImpl;
  @override
  @useResult
  $Res call({String id, String emoji, String userId, DateTime createdAt});
}

/// @nodoc
class __$FeedReactionCopyWithImpl<$Res>
    implements _$FeedReactionCopyWith<$Res> {
  __$FeedReactionCopyWithImpl(this._self, this._then);

  final _FeedReaction _self;
  final $Res Function(_FeedReaction) _then;

  /// Create a copy of FeedReaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? emoji = null,
    Object? userId = null,
    Object? createdAt = null,
  }) {
    return _then(_FeedReaction(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      emoji: null == emoji
          ? _self.emoji
          : emoji // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
