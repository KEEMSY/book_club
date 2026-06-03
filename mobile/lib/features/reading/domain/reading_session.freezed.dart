// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reading_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReadingSession {
  String get id;
  String get userBookId;
  DateTime get startedAt;
  ReadingSessionSource get source;
  DateTime? get endedAt;
  int? get durationSec;

  /// Create a copy of ReadingSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReadingSessionCopyWith<ReadingSession> get copyWith =>
      _$ReadingSessionCopyWithImpl<ReadingSession>(
          this as ReadingSession, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReadingSession &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userBookId, userBookId) ||
                other.userBookId == userBookId) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.endedAt, endedAt) || other.endedAt == endedAt) &&
            (identical(other.durationSec, durationSec) ||
                other.durationSec == durationSec));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, userBookId, startedAt, source, endedAt, durationSec);

  @override
  String toString() {
    return 'ReadingSession(id: $id, userBookId: $userBookId, startedAt: $startedAt, source: $source, endedAt: $endedAt, durationSec: $durationSec)';
  }
}

/// @nodoc
abstract mixin class $ReadingSessionCopyWith<$Res> {
  factory $ReadingSessionCopyWith(
          ReadingSession value, $Res Function(ReadingSession) _then) =
      _$ReadingSessionCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String userBookId,
      DateTime startedAt,
      ReadingSessionSource source,
      DateTime? endedAt,
      int? durationSec});
}

/// @nodoc
class _$ReadingSessionCopyWithImpl<$Res>
    implements $ReadingSessionCopyWith<$Res> {
  _$ReadingSessionCopyWithImpl(this._self, this._then);

  final ReadingSession _self;
  final $Res Function(ReadingSession) _then;

  /// Create a copy of ReadingSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userBookId = null,
    Object? startedAt = null,
    Object? source = null,
    Object? endedAt = freezed,
    Object? durationSec = freezed,
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
      startedAt: null == startedAt
          ? _self.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      source: null == source
          ? _self.source
          : source // ignore: cast_nullable_to_non_nullable
              as ReadingSessionSource,
      endedAt: freezed == endedAt
          ? _self.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      durationSec: freezed == durationSec
          ? _self.durationSec
          : durationSec // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// Adds pattern-matching-related methods to [ReadingSession].
extension ReadingSessionPatterns on ReadingSession {
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
    TResult Function(_ReadingSession value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ReadingSession() when $default != null:
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
    TResult Function(_ReadingSession value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReadingSession():
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
    TResult? Function(_ReadingSession value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReadingSession() when $default != null:
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
    TResult Function(String id, String userBookId, DateTime startedAt,
            ReadingSessionSource source, DateTime? endedAt, int? durationSec)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ReadingSession() when $default != null:
        return $default(_that.id, _that.userBookId, _that.startedAt,
            _that.source, _that.endedAt, _that.durationSec);
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
    TResult Function(String id, String userBookId, DateTime startedAt,
            ReadingSessionSource source, DateTime? endedAt, int? durationSec)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReadingSession():
        return $default(_that.id, _that.userBookId, _that.startedAt,
            _that.source, _that.endedAt, _that.durationSec);
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
    TResult? Function(String id, String userBookId, DateTime startedAt,
            ReadingSessionSource source, DateTime? endedAt, int? durationSec)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReadingSession() when $default != null:
        return $default(_that.id, _that.userBookId, _that.startedAt,
            _that.source, _that.endedAt, _that.durationSec);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ReadingSession implements ReadingSession {
  const _ReadingSession(
      {required this.id,
      required this.userBookId,
      required this.startedAt,
      required this.source,
      this.endedAt,
      this.durationSec});

  @override
  final String id;
  @override
  final String userBookId;
  @override
  final DateTime startedAt;
  @override
  final ReadingSessionSource source;
  @override
  final DateTime? endedAt;
  @override
  final int? durationSec;

  /// Create a copy of ReadingSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ReadingSessionCopyWith<_ReadingSession> get copyWith =>
      __$ReadingSessionCopyWithImpl<_ReadingSession>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ReadingSession &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userBookId, userBookId) ||
                other.userBookId == userBookId) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.endedAt, endedAt) || other.endedAt == endedAt) &&
            (identical(other.durationSec, durationSec) ||
                other.durationSec == durationSec));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, userBookId, startedAt, source, endedAt, durationSec);

  @override
  String toString() {
    return 'ReadingSession(id: $id, userBookId: $userBookId, startedAt: $startedAt, source: $source, endedAt: $endedAt, durationSec: $durationSec)';
  }
}

/// @nodoc
abstract mixin class _$ReadingSessionCopyWith<$Res>
    implements $ReadingSessionCopyWith<$Res> {
  factory _$ReadingSessionCopyWith(
          _ReadingSession value, $Res Function(_ReadingSession) _then) =
      __$ReadingSessionCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String userBookId,
      DateTime startedAt,
      ReadingSessionSource source,
      DateTime? endedAt,
      int? durationSec});
}

/// @nodoc
class __$ReadingSessionCopyWithImpl<$Res>
    implements _$ReadingSessionCopyWith<$Res> {
  __$ReadingSessionCopyWithImpl(this._self, this._then);

  final _ReadingSession _self;
  final $Res Function(_ReadingSession) _then;

  /// Create a copy of ReadingSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? userBookId = null,
    Object? startedAt = null,
    Object? source = null,
    Object? endedAt = freezed,
    Object? durationSec = freezed,
  }) {
    return _then(_ReadingSession(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userBookId: null == userBookId
          ? _self.userBookId
          : userBookId // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: null == startedAt
          ? _self.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      source: null == source
          ? _self.source
          : source // ignore: cast_nullable_to_non_nullable
              as ReadingSessionSource,
      endedAt: freezed == endedAt
          ? _self.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      durationSec: freezed == durationSec
          ? _self.durationSec
          : durationSec // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

// dart format on
