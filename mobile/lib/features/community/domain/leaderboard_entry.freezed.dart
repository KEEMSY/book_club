// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'leaderboard_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LeaderboardEntry {
  int get rank;
  String get userId;
  String get nickname;
  String? get profileImageUrl;
  int? get gradeTier;
  int get weeklyMinutes;
  bool get isMe;

  /// Create a copy of LeaderboardEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LeaderboardEntryCopyWith<LeaderboardEntry> get copyWith =>
      _$LeaderboardEntryCopyWithImpl<LeaderboardEntry>(
          this as LeaderboardEntry, _$identity);

  /// Serializes this LeaderboardEntry to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LeaderboardEntry &&
            (identical(other.rank, rank) || other.rank == rank) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.gradeTier, gradeTier) ||
                other.gradeTier == gradeTier) &&
            (identical(other.weeklyMinutes, weeklyMinutes) ||
                other.weeklyMinutes == weeklyMinutes) &&
            (identical(other.isMe, isMe) || other.isMe == isMe));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, rank, userId, nickname,
      profileImageUrl, gradeTier, weeklyMinutes, isMe);

  @override
  String toString() {
    return 'LeaderboardEntry(rank: $rank, userId: $userId, nickname: $nickname, profileImageUrl: $profileImageUrl, gradeTier: $gradeTier, weeklyMinutes: $weeklyMinutes, isMe: $isMe)';
  }
}

/// @nodoc
abstract mixin class $LeaderboardEntryCopyWith<$Res> {
  factory $LeaderboardEntryCopyWith(
          LeaderboardEntry value, $Res Function(LeaderboardEntry) _then) =
      _$LeaderboardEntryCopyWithImpl;
  @useResult
  $Res call(
      {int rank,
      String userId,
      String nickname,
      String? profileImageUrl,
      int? gradeTier,
      int weeklyMinutes,
      bool isMe});
}

/// @nodoc
class _$LeaderboardEntryCopyWithImpl<$Res>
    implements $LeaderboardEntryCopyWith<$Res> {
  _$LeaderboardEntryCopyWithImpl(this._self, this._then);

  final LeaderboardEntry _self;
  final $Res Function(LeaderboardEntry) _then;

  /// Create a copy of LeaderboardEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rank = null,
    Object? userId = null,
    Object? nickname = null,
    Object? profileImageUrl = freezed,
    Object? gradeTier = freezed,
    Object? weeklyMinutes = null,
    Object? isMe = null,
  }) {
    return _then(_self.copyWith(
      rank: null == rank
          ? _self.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      profileImageUrl: freezed == profileImageUrl
          ? _self.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      gradeTier: freezed == gradeTier
          ? _self.gradeTier
          : gradeTier // ignore: cast_nullable_to_non_nullable
              as int?,
      weeklyMinutes: null == weeklyMinutes
          ? _self.weeklyMinutes
          : weeklyMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      isMe: null == isMe
          ? _self.isMe
          : isMe // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [LeaderboardEntry].
extension LeaderboardEntryPatterns on LeaderboardEntry {
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
    TResult Function(_LeaderboardEntry value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LeaderboardEntry() when $default != null:
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
    TResult Function(_LeaderboardEntry value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LeaderboardEntry():
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
    TResult? Function(_LeaderboardEntry value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LeaderboardEntry() when $default != null:
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
            int rank,
            String userId,
            String nickname,
            String? profileImageUrl,
            int? gradeTier,
            int weeklyMinutes,
            bool isMe)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LeaderboardEntry() when $default != null:
        return $default(
            _that.rank,
            _that.userId,
            _that.nickname,
            _that.profileImageUrl,
            _that.gradeTier,
            _that.weeklyMinutes,
            _that.isMe);
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
            int rank,
            String userId,
            String nickname,
            String? profileImageUrl,
            int? gradeTier,
            int weeklyMinutes,
            bool isMe)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LeaderboardEntry():
        return $default(
            _that.rank,
            _that.userId,
            _that.nickname,
            _that.profileImageUrl,
            _that.gradeTier,
            _that.weeklyMinutes,
            _that.isMe);
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
            int rank,
            String userId,
            String nickname,
            String? profileImageUrl,
            int? gradeTier,
            int weeklyMinutes,
            bool isMe)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LeaderboardEntry() when $default != null:
        return $default(
            _that.rank,
            _that.userId,
            _that.nickname,
            _that.profileImageUrl,
            _that.gradeTier,
            _that.weeklyMinutes,
            _that.isMe);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _LeaderboardEntry implements LeaderboardEntry {
  const _LeaderboardEntry(
      {required this.rank,
      required this.userId,
      required this.nickname,
      this.profileImageUrl,
      this.gradeTier,
      required this.weeklyMinutes,
      this.isMe = false});
  factory _LeaderboardEntry.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardEntryFromJson(json);

  @override
  final int rank;
  @override
  final String userId;
  @override
  final String nickname;
  @override
  final String? profileImageUrl;
  @override
  final int? gradeTier;
  @override
  final int weeklyMinutes;
  @override
  @JsonKey()
  final bool isMe;

  /// Create a copy of LeaderboardEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LeaderboardEntryCopyWith<_LeaderboardEntry> get copyWith =>
      __$LeaderboardEntryCopyWithImpl<_LeaderboardEntry>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$LeaderboardEntryToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LeaderboardEntry &&
            (identical(other.rank, rank) || other.rank == rank) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.gradeTier, gradeTier) ||
                other.gradeTier == gradeTier) &&
            (identical(other.weeklyMinutes, weeklyMinutes) ||
                other.weeklyMinutes == weeklyMinutes) &&
            (identical(other.isMe, isMe) || other.isMe == isMe));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, rank, userId, nickname,
      profileImageUrl, gradeTier, weeklyMinutes, isMe);

  @override
  String toString() {
    return 'LeaderboardEntry(rank: $rank, userId: $userId, nickname: $nickname, profileImageUrl: $profileImageUrl, gradeTier: $gradeTier, weeklyMinutes: $weeklyMinutes, isMe: $isMe)';
  }
}

/// @nodoc
abstract mixin class _$LeaderboardEntryCopyWith<$Res>
    implements $LeaderboardEntryCopyWith<$Res> {
  factory _$LeaderboardEntryCopyWith(
          _LeaderboardEntry value, $Res Function(_LeaderboardEntry) _then) =
      __$LeaderboardEntryCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int rank,
      String userId,
      String nickname,
      String? profileImageUrl,
      int? gradeTier,
      int weeklyMinutes,
      bool isMe});
}

/// @nodoc
class __$LeaderboardEntryCopyWithImpl<$Res>
    implements _$LeaderboardEntryCopyWith<$Res> {
  __$LeaderboardEntryCopyWithImpl(this._self, this._then);

  final _LeaderboardEntry _self;
  final $Res Function(_LeaderboardEntry) _then;

  /// Create a copy of LeaderboardEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? rank = null,
    Object? userId = null,
    Object? nickname = null,
    Object? profileImageUrl = freezed,
    Object? gradeTier = freezed,
    Object? weeklyMinutes = null,
    Object? isMe = null,
  }) {
    return _then(_LeaderboardEntry(
      rank: null == rank
          ? _self.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _self.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      profileImageUrl: freezed == profileImageUrl
          ? _self.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      gradeTier: freezed == gradeTier
          ? _self.gradeTier
          : gradeTier // ignore: cast_nullable_to_non_nullable
              as int?,
      weeklyMinutes: null == weeklyMinutes
          ? _self.weeklyMinutes
          : weeklyMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      isMe: null == isMe
          ? _self.isMe
          : isMe // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
