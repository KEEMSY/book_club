// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VideoSession {
  String get id;
  String get clubId;
  String get hostId;
  String get agoraChannel;
  int get maxParticipants;
  DateTime get startedAt;
  DateTime? get endedAt;
  String? get agoraToken;
  String? get channel;

  /// Create a copy of VideoSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VideoSessionCopyWith<VideoSession> get copyWith =>
      _$VideoSessionCopyWithImpl<VideoSession>(
          this as VideoSession, _$identity);

  /// Serializes this VideoSession to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VideoSession &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.clubId, clubId) || other.clubId == clubId) &&
            (identical(other.hostId, hostId) || other.hostId == hostId) &&
            (identical(other.agoraChannel, agoraChannel) ||
                other.agoraChannel == agoraChannel) &&
            (identical(other.maxParticipants, maxParticipants) ||
                other.maxParticipants == maxParticipants) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.endedAt, endedAt) || other.endedAt == endedAt) &&
            (identical(other.agoraToken, agoraToken) ||
                other.agoraToken == agoraToken) &&
            (identical(other.channel, channel) || other.channel == channel));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, clubId, hostId, agoraChannel,
      maxParticipants, startedAt, endedAt, agoraToken, channel);

  @override
  String toString() {
    return 'VideoSession(id: $id, clubId: $clubId, hostId: $hostId, agoraChannel: $agoraChannel, maxParticipants: $maxParticipants, startedAt: $startedAt, endedAt: $endedAt, agoraToken: $agoraToken, channel: $channel)';
  }
}

/// @nodoc
abstract mixin class $VideoSessionCopyWith<$Res> {
  factory $VideoSessionCopyWith(
          VideoSession value, $Res Function(VideoSession) _then) =
      _$VideoSessionCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String clubId,
      String hostId,
      String agoraChannel,
      int maxParticipants,
      DateTime startedAt,
      DateTime? endedAt,
      String? agoraToken,
      String? channel});
}

/// @nodoc
class _$VideoSessionCopyWithImpl<$Res> implements $VideoSessionCopyWith<$Res> {
  _$VideoSessionCopyWithImpl(this._self, this._then);

  final VideoSession _self;
  final $Res Function(VideoSession) _then;

  /// Create a copy of VideoSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clubId = null,
    Object? hostId = null,
    Object? agoraChannel = null,
    Object? maxParticipants = null,
    Object? startedAt = null,
    Object? endedAt = freezed,
    Object? agoraToken = freezed,
    Object? channel = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      clubId: null == clubId
          ? _self.clubId
          : clubId // ignore: cast_nullable_to_non_nullable
              as String,
      hostId: null == hostId
          ? _self.hostId
          : hostId // ignore: cast_nullable_to_non_nullable
              as String,
      agoraChannel: null == agoraChannel
          ? _self.agoraChannel
          : agoraChannel // ignore: cast_nullable_to_non_nullable
              as String,
      maxParticipants: null == maxParticipants
          ? _self.maxParticipants
          : maxParticipants // ignore: cast_nullable_to_non_nullable
              as int,
      startedAt: null == startedAt
          ? _self.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endedAt: freezed == endedAt
          ? _self.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      agoraToken: freezed == agoraToken
          ? _self.agoraToken
          : agoraToken // ignore: cast_nullable_to_non_nullable
              as String?,
      channel: freezed == channel
          ? _self.channel
          : channel // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [VideoSession].
extension VideoSessionPatterns on VideoSession {
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
    TResult Function(_VideoSession value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VideoSession() when $default != null:
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
    TResult Function(_VideoSession value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VideoSession():
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
    TResult? Function(_VideoSession value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VideoSession() when $default != null:
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
            String clubId,
            String hostId,
            String agoraChannel,
            int maxParticipants,
            DateTime startedAt,
            DateTime? endedAt,
            String? agoraToken,
            String? channel)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VideoSession() when $default != null:
        return $default(
            _that.id,
            _that.clubId,
            _that.hostId,
            _that.agoraChannel,
            _that.maxParticipants,
            _that.startedAt,
            _that.endedAt,
            _that.agoraToken,
            _that.channel);
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
            String clubId,
            String hostId,
            String agoraChannel,
            int maxParticipants,
            DateTime startedAt,
            DateTime? endedAt,
            String? agoraToken,
            String? channel)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VideoSession():
        return $default(
            _that.id,
            _that.clubId,
            _that.hostId,
            _that.agoraChannel,
            _that.maxParticipants,
            _that.startedAt,
            _that.endedAt,
            _that.agoraToken,
            _that.channel);
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
            String clubId,
            String hostId,
            String agoraChannel,
            int maxParticipants,
            DateTime startedAt,
            DateTime? endedAt,
            String? agoraToken,
            String? channel)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VideoSession() when $default != null:
        return $default(
            _that.id,
            _that.clubId,
            _that.hostId,
            _that.agoraChannel,
            _that.maxParticipants,
            _that.startedAt,
            _that.endedAt,
            _that.agoraToken,
            _that.channel);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _VideoSession implements VideoSession {
  const _VideoSession(
      {required this.id,
      required this.clubId,
      required this.hostId,
      required this.agoraChannel,
      required this.maxParticipants,
      required this.startedAt,
      this.endedAt,
      this.agoraToken,
      this.channel});
  factory _VideoSession.fromJson(Map<String, dynamic> json) =>
      _$VideoSessionFromJson(json);

  @override
  final String id;
  @override
  final String clubId;
  @override
  final String hostId;
  @override
  final String agoraChannel;
  @override
  final int maxParticipants;
  @override
  final DateTime startedAt;
  @override
  final DateTime? endedAt;
  @override
  final String? agoraToken;
  @override
  final String? channel;

  /// Create a copy of VideoSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VideoSessionCopyWith<_VideoSession> get copyWith =>
      __$VideoSessionCopyWithImpl<_VideoSession>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$VideoSessionToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _VideoSession &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.clubId, clubId) || other.clubId == clubId) &&
            (identical(other.hostId, hostId) || other.hostId == hostId) &&
            (identical(other.agoraChannel, agoraChannel) ||
                other.agoraChannel == agoraChannel) &&
            (identical(other.maxParticipants, maxParticipants) ||
                other.maxParticipants == maxParticipants) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.endedAt, endedAt) || other.endedAt == endedAt) &&
            (identical(other.agoraToken, agoraToken) ||
                other.agoraToken == agoraToken) &&
            (identical(other.channel, channel) || other.channel == channel));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, clubId, hostId, agoraChannel,
      maxParticipants, startedAt, endedAt, agoraToken, channel);

  @override
  String toString() {
    return 'VideoSession(id: $id, clubId: $clubId, hostId: $hostId, agoraChannel: $agoraChannel, maxParticipants: $maxParticipants, startedAt: $startedAt, endedAt: $endedAt, agoraToken: $agoraToken, channel: $channel)';
  }
}

/// @nodoc
abstract mixin class _$VideoSessionCopyWith<$Res>
    implements $VideoSessionCopyWith<$Res> {
  factory _$VideoSessionCopyWith(
          _VideoSession value, $Res Function(_VideoSession) _then) =
      __$VideoSessionCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String clubId,
      String hostId,
      String agoraChannel,
      int maxParticipants,
      DateTime startedAt,
      DateTime? endedAt,
      String? agoraToken,
      String? channel});
}

/// @nodoc
class __$VideoSessionCopyWithImpl<$Res>
    implements _$VideoSessionCopyWith<$Res> {
  __$VideoSessionCopyWithImpl(this._self, this._then);

  final _VideoSession _self;
  final $Res Function(_VideoSession) _then;

  /// Create a copy of VideoSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? clubId = null,
    Object? hostId = null,
    Object? agoraChannel = null,
    Object? maxParticipants = null,
    Object? startedAt = null,
    Object? endedAt = freezed,
    Object? agoraToken = freezed,
    Object? channel = freezed,
  }) {
    return _then(_VideoSession(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      clubId: null == clubId
          ? _self.clubId
          : clubId // ignore: cast_nullable_to_non_nullable
              as String,
      hostId: null == hostId
          ? _self.hostId
          : hostId // ignore: cast_nullable_to_non_nullable
              as String,
      agoraChannel: null == agoraChannel
          ? _self.agoraChannel
          : agoraChannel // ignore: cast_nullable_to_non_nullable
              as String,
      maxParticipants: null == maxParticipants
          ? _self.maxParticipants
          : maxParticipants // ignore: cast_nullable_to_non_nullable
              as int,
      startedAt: null == startedAt
          ? _self.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endedAt: freezed == endedAt
          ? _self.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      agoraToken: freezed == agoraToken
          ? _self.agoraToken
          : agoraToken // ignore: cast_nullable_to_non_nullable
              as String?,
      channel: freezed == channel
          ? _self.channel
          : channel // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
