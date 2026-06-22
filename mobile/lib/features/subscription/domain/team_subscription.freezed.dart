// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team_subscription.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TeamSubscription {
  String get id;
  String get teamName;
  String get adminUserId;
  int get seatCount;
  String get planType;
  DateTime get validFrom;
  DateTime get validUntil;
  int get usedSeats;
  List<TeamMember> get members;

  /// Create a copy of TeamSubscription
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TeamSubscriptionCopyWith<TeamSubscription> get copyWith =>
      _$TeamSubscriptionCopyWithImpl<TeamSubscription>(
          this as TeamSubscription, _$identity);

  /// Serializes this TeamSubscription to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TeamSubscription &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.teamName, teamName) ||
                other.teamName == teamName) &&
            (identical(other.adminUserId, adminUserId) ||
                other.adminUserId == adminUserId) &&
            (identical(other.seatCount, seatCount) ||
                other.seatCount == seatCount) &&
            (identical(other.planType, planType) ||
                other.planType == planType) &&
            (identical(other.validFrom, validFrom) ||
                other.validFrom == validFrom) &&
            (identical(other.validUntil, validUntil) ||
                other.validUntil == validUntil) &&
            (identical(other.usedSeats, usedSeats) ||
                other.usedSeats == usedSeats) &&
            const DeepCollectionEquality().equals(other.members, members));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      teamName,
      adminUserId,
      seatCount,
      planType,
      validFrom,
      validUntil,
      usedSeats,
      const DeepCollectionEquality().hash(members));

  @override
  String toString() {
    return 'TeamSubscription(id: $id, teamName: $teamName, adminUserId: $adminUserId, seatCount: $seatCount, planType: $planType, validFrom: $validFrom, validUntil: $validUntil, usedSeats: $usedSeats, members: $members)';
  }
}

/// @nodoc
abstract mixin class $TeamSubscriptionCopyWith<$Res> {
  factory $TeamSubscriptionCopyWith(
          TeamSubscription value, $Res Function(TeamSubscription) _then) =
      _$TeamSubscriptionCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String teamName,
      String adminUserId,
      int seatCount,
      String planType,
      DateTime validFrom,
      DateTime validUntil,
      int usedSeats,
      List<TeamMember> members});
}

/// @nodoc
class _$TeamSubscriptionCopyWithImpl<$Res>
    implements $TeamSubscriptionCopyWith<$Res> {
  _$TeamSubscriptionCopyWithImpl(this._self, this._then);

  final TeamSubscription _self;
  final $Res Function(TeamSubscription) _then;

  /// Create a copy of TeamSubscription
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? teamName = null,
    Object? adminUserId = null,
    Object? seatCount = null,
    Object? planType = null,
    Object? validFrom = null,
    Object? validUntil = null,
    Object? usedSeats = null,
    Object? members = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      teamName: null == teamName
          ? _self.teamName
          : teamName // ignore: cast_nullable_to_non_nullable
              as String,
      adminUserId: null == adminUserId
          ? _self.adminUserId
          : adminUserId // ignore: cast_nullable_to_non_nullable
              as String,
      seatCount: null == seatCount
          ? _self.seatCount
          : seatCount // ignore: cast_nullable_to_non_nullable
              as int,
      planType: null == planType
          ? _self.planType
          : planType // ignore: cast_nullable_to_non_nullable
              as String,
      validFrom: null == validFrom
          ? _self.validFrom
          : validFrom // ignore: cast_nullable_to_non_nullable
              as DateTime,
      validUntil: null == validUntil
          ? _self.validUntil
          : validUntil // ignore: cast_nullable_to_non_nullable
              as DateTime,
      usedSeats: null == usedSeats
          ? _self.usedSeats
          : usedSeats // ignore: cast_nullable_to_non_nullable
              as int,
      members: null == members
          ? _self.members
          : members // ignore: cast_nullable_to_non_nullable
              as List<TeamMember>,
    ));
  }
}

/// Adds pattern-matching-related methods to [TeamSubscription].
extension TeamSubscriptionPatterns on TeamSubscription {
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
    TResult Function(_TeamSubscription value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TeamSubscription() when $default != null:
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
    TResult Function(_TeamSubscription value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TeamSubscription():
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
    TResult? Function(_TeamSubscription value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TeamSubscription() when $default != null:
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
            String teamName,
            String adminUserId,
            int seatCount,
            String planType,
            DateTime validFrom,
            DateTime validUntil,
            int usedSeats,
            List<TeamMember> members)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TeamSubscription() when $default != null:
        return $default(
            _that.id,
            _that.teamName,
            _that.adminUserId,
            _that.seatCount,
            _that.planType,
            _that.validFrom,
            _that.validUntil,
            _that.usedSeats,
            _that.members);
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
            String teamName,
            String adminUserId,
            int seatCount,
            String planType,
            DateTime validFrom,
            DateTime validUntil,
            int usedSeats,
            List<TeamMember> members)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TeamSubscription():
        return $default(
            _that.id,
            _that.teamName,
            _that.adminUserId,
            _that.seatCount,
            _that.planType,
            _that.validFrom,
            _that.validUntil,
            _that.usedSeats,
            _that.members);
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
            String teamName,
            String adminUserId,
            int seatCount,
            String planType,
            DateTime validFrom,
            DateTime validUntil,
            int usedSeats,
            List<TeamMember> members)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TeamSubscription() when $default != null:
        return $default(
            _that.id,
            _that.teamName,
            _that.adminUserId,
            _that.seatCount,
            _that.planType,
            _that.validFrom,
            _that.validUntil,
            _that.usedSeats,
            _that.members);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TeamSubscription implements TeamSubscription {
  const _TeamSubscription(
      {required this.id,
      required this.teamName,
      required this.adminUserId,
      required this.seatCount,
      required this.planType,
      required this.validFrom,
      required this.validUntil,
      this.usedSeats = 0,
      final List<TeamMember> members = const <TeamMember>[]})
      : _members = members;
  factory _TeamSubscription.fromJson(Map<String, dynamic> json) =>
      _$TeamSubscriptionFromJson(json);

  @override
  final String id;
  @override
  final String teamName;
  @override
  final String adminUserId;
  @override
  final int seatCount;
  @override
  final String planType;
  @override
  final DateTime validFrom;
  @override
  final DateTime validUntil;
  @override
  @JsonKey()
  final int usedSeats;
  final List<TeamMember> _members;
  @override
  @JsonKey()
  List<TeamMember> get members {
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_members);
  }

  /// Create a copy of TeamSubscription
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TeamSubscriptionCopyWith<_TeamSubscription> get copyWith =>
      __$TeamSubscriptionCopyWithImpl<_TeamSubscription>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TeamSubscriptionToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TeamSubscription &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.teamName, teamName) ||
                other.teamName == teamName) &&
            (identical(other.adminUserId, adminUserId) ||
                other.adminUserId == adminUserId) &&
            (identical(other.seatCount, seatCount) ||
                other.seatCount == seatCount) &&
            (identical(other.planType, planType) ||
                other.planType == planType) &&
            (identical(other.validFrom, validFrom) ||
                other.validFrom == validFrom) &&
            (identical(other.validUntil, validUntil) ||
                other.validUntil == validUntil) &&
            (identical(other.usedSeats, usedSeats) ||
                other.usedSeats == usedSeats) &&
            const DeepCollectionEquality().equals(other._members, _members));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      teamName,
      adminUserId,
      seatCount,
      planType,
      validFrom,
      validUntil,
      usedSeats,
      const DeepCollectionEquality().hash(_members));

  @override
  String toString() {
    return 'TeamSubscription(id: $id, teamName: $teamName, adminUserId: $adminUserId, seatCount: $seatCount, planType: $planType, validFrom: $validFrom, validUntil: $validUntil, usedSeats: $usedSeats, members: $members)';
  }
}

/// @nodoc
abstract mixin class _$TeamSubscriptionCopyWith<$Res>
    implements $TeamSubscriptionCopyWith<$Res> {
  factory _$TeamSubscriptionCopyWith(
          _TeamSubscription value, $Res Function(_TeamSubscription) _then) =
      __$TeamSubscriptionCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String teamName,
      String adminUserId,
      int seatCount,
      String planType,
      DateTime validFrom,
      DateTime validUntil,
      int usedSeats,
      List<TeamMember> members});
}

/// @nodoc
class __$TeamSubscriptionCopyWithImpl<$Res>
    implements _$TeamSubscriptionCopyWith<$Res> {
  __$TeamSubscriptionCopyWithImpl(this._self, this._then);

  final _TeamSubscription _self;
  final $Res Function(_TeamSubscription) _then;

  /// Create a copy of TeamSubscription
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? teamName = null,
    Object? adminUserId = null,
    Object? seatCount = null,
    Object? planType = null,
    Object? validFrom = null,
    Object? validUntil = null,
    Object? usedSeats = null,
    Object? members = null,
  }) {
    return _then(_TeamSubscription(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      teamName: null == teamName
          ? _self.teamName
          : teamName // ignore: cast_nullable_to_non_nullable
              as String,
      adminUserId: null == adminUserId
          ? _self.adminUserId
          : adminUserId // ignore: cast_nullable_to_non_nullable
              as String,
      seatCount: null == seatCount
          ? _self.seatCount
          : seatCount // ignore: cast_nullable_to_non_nullable
              as int,
      planType: null == planType
          ? _self.planType
          : planType // ignore: cast_nullable_to_non_nullable
              as String,
      validFrom: null == validFrom
          ? _self.validFrom
          : validFrom // ignore: cast_nullable_to_non_nullable
              as DateTime,
      validUntil: null == validUntil
          ? _self.validUntil
          : validUntil // ignore: cast_nullable_to_non_nullable
              as DateTime,
      usedSeats: null == usedSeats
          ? _self.usedSeats
          : usedSeats // ignore: cast_nullable_to_non_nullable
              as int,
      members: null == members
          ? _self._members
          : members // ignore: cast_nullable_to_non_nullable
              as List<TeamMember>,
    ));
  }
}

/// @nodoc
mixin _$TeamMember {
  String get userId;
  String get nickname;
  String? get profileImageUrl;
  DateTime get joinedAt;

  /// Create a copy of TeamMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TeamMemberCopyWith<TeamMember> get copyWith =>
      _$TeamMemberCopyWithImpl<TeamMember>(this as TeamMember, _$identity);

  /// Serializes this TeamMember to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TeamMember &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.joinedAt, joinedAt) ||
                other.joinedAt == joinedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, userId, nickname, profileImageUrl, joinedAt);

  @override
  String toString() {
    return 'TeamMember(userId: $userId, nickname: $nickname, profileImageUrl: $profileImageUrl, joinedAt: $joinedAt)';
  }
}

/// @nodoc
abstract mixin class $TeamMemberCopyWith<$Res> {
  factory $TeamMemberCopyWith(
          TeamMember value, $Res Function(TeamMember) _then) =
      _$TeamMemberCopyWithImpl;
  @useResult
  $Res call(
      {String userId,
      String nickname,
      String? profileImageUrl,
      DateTime joinedAt});
}

/// @nodoc
class _$TeamMemberCopyWithImpl<$Res> implements $TeamMemberCopyWith<$Res> {
  _$TeamMemberCopyWithImpl(this._self, this._then);

  final TeamMember _self;
  final $Res Function(TeamMember) _then;

  /// Create a copy of TeamMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? nickname = null,
    Object? profileImageUrl = freezed,
    Object? joinedAt = null,
  }) {
    return _then(_self.copyWith(
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
      joinedAt: null == joinedAt
          ? _self.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [TeamMember].
extension TeamMemberPatterns on TeamMember {
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
    TResult Function(_TeamMember value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TeamMember() when $default != null:
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
    TResult Function(_TeamMember value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TeamMember():
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
    TResult? Function(_TeamMember value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TeamMember() when $default != null:
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
    TResult Function(String userId, String nickname, String? profileImageUrl,
            DateTime joinedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TeamMember() when $default != null:
        return $default(_that.userId, _that.nickname, _that.profileImageUrl,
            _that.joinedAt);
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
    TResult Function(String userId, String nickname, String? profileImageUrl,
            DateTime joinedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TeamMember():
        return $default(_that.userId, _that.nickname, _that.profileImageUrl,
            _that.joinedAt);
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
    TResult? Function(String userId, String nickname, String? profileImageUrl,
            DateTime joinedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TeamMember() when $default != null:
        return $default(_that.userId, _that.nickname, _that.profileImageUrl,
            _that.joinedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TeamMember implements TeamMember {
  const _TeamMember(
      {required this.userId,
      required this.nickname,
      this.profileImageUrl,
      required this.joinedAt});
  factory _TeamMember.fromJson(Map<String, dynamic> json) =>
      _$TeamMemberFromJson(json);

  @override
  final String userId;
  @override
  final String nickname;
  @override
  final String? profileImageUrl;
  @override
  final DateTime joinedAt;

  /// Create a copy of TeamMember
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TeamMemberCopyWith<_TeamMember> get copyWith =>
      __$TeamMemberCopyWithImpl<_TeamMember>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TeamMemberToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TeamMember &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.joinedAt, joinedAt) ||
                other.joinedAt == joinedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, userId, nickname, profileImageUrl, joinedAt);

  @override
  String toString() {
    return 'TeamMember(userId: $userId, nickname: $nickname, profileImageUrl: $profileImageUrl, joinedAt: $joinedAt)';
  }
}

/// @nodoc
abstract mixin class _$TeamMemberCopyWith<$Res>
    implements $TeamMemberCopyWith<$Res> {
  factory _$TeamMemberCopyWith(
          _TeamMember value, $Res Function(_TeamMember) _then) =
      __$TeamMemberCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String userId,
      String nickname,
      String? profileImageUrl,
      DateTime joinedAt});
}

/// @nodoc
class __$TeamMemberCopyWithImpl<$Res> implements _$TeamMemberCopyWith<$Res> {
  __$TeamMemberCopyWithImpl(this._self, this._then);

  final _TeamMember _self;
  final $Res Function(_TeamMember) _then;

  /// Create a copy of TeamMember
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? userId = null,
    Object? nickname = null,
    Object? profileImageUrl = freezed,
    Object? joinedAt = null,
  }) {
    return _then(_TeamMember(
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
      joinedAt: null == joinedAt
          ? _self.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
