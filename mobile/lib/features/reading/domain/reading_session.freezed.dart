// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reading_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ReadingSession {
  String get id => throw _privateConstructorUsedError;
  String get userBookId => throw _privateConstructorUsedError;
  DateTime get startedAt => throw _privateConstructorUsedError;
  ReadingSessionSource get source => throw _privateConstructorUsedError;
  DateTime? get endedAt => throw _privateConstructorUsedError;
  int? get durationSec => throw _privateConstructorUsedError;

  /// Create a copy of ReadingSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReadingSessionCopyWith<ReadingSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReadingSessionCopyWith<$Res> {
  factory $ReadingSessionCopyWith(
          ReadingSession value, $Res Function(ReadingSession) then) =
      _$ReadingSessionCopyWithImpl<$Res, ReadingSession>;
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
class _$ReadingSessionCopyWithImpl<$Res, $Val extends ReadingSession>
    implements $ReadingSessionCopyWith<$Res> {
  _$ReadingSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userBookId: null == userBookId
          ? _value.userBookId
          : userBookId // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as ReadingSessionSource,
      endedAt: freezed == endedAt
          ? _value.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      durationSec: freezed == durationSec
          ? _value.durationSec
          : durationSec // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReadingSessionImplCopyWith<$Res>
    implements $ReadingSessionCopyWith<$Res> {
  factory _$$ReadingSessionImplCopyWith(_$ReadingSessionImpl value,
          $Res Function(_$ReadingSessionImpl) then) =
      __$$ReadingSessionImplCopyWithImpl<$Res>;
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
class __$$ReadingSessionImplCopyWithImpl<$Res>
    extends _$ReadingSessionCopyWithImpl<$Res, _$ReadingSessionImpl>
    implements _$$ReadingSessionImplCopyWith<$Res> {
  __$$ReadingSessionImplCopyWithImpl(
      _$ReadingSessionImpl _value, $Res Function(_$ReadingSessionImpl) _then)
      : super(_value, _then);

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
    return _then(_$ReadingSessionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userBookId: null == userBookId
          ? _value.userBookId
          : userBookId // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as ReadingSessionSource,
      endedAt: freezed == endedAt
          ? _value.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      durationSec: freezed == durationSec
          ? _value.durationSec
          : durationSec // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$ReadingSessionImpl implements _ReadingSession {
  const _$ReadingSessionImpl(
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

  @override
  String toString() {
    return 'ReadingSession(id: $id, userBookId: $userBookId, startedAt: $startedAt, source: $source, endedAt: $endedAt, durationSec: $durationSec)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReadingSessionImpl &&
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

  /// Create a copy of ReadingSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReadingSessionImplCopyWith<_$ReadingSessionImpl> get copyWith =>
      __$$ReadingSessionImplCopyWithImpl<_$ReadingSessionImpl>(
          this, _$identity);
}

abstract class _ReadingSession implements ReadingSession {
  const factory _ReadingSession(
      {required final String id,
      required final String userBookId,
      required final DateTime startedAt,
      required final ReadingSessionSource source,
      final DateTime? endedAt,
      final int? durationSec}) = _$ReadingSessionImpl;

  @override
  String get id;
  @override
  String get userBookId;
  @override
  DateTime get startedAt;
  @override
  ReadingSessionSource get source;
  @override
  DateTime? get endedAt;
  @override
  int? get durationSec;

  /// Create a copy of ReadingSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReadingSessionImplCopyWith<_$ReadingSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
