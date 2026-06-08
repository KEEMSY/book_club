// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'club_room.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ClubRoom {
  String get id;
  String get clubId;
  String get name;

  /// Minimum progress percentage (0–100) required to enter.
  int get progressGate;
  DateTime get createdAt;

  /// True when the current user's reading progress meets [progressGate].
  bool get canEnter;

  /// Create a copy of ClubRoom
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ClubRoomCopyWith<ClubRoom> get copyWith =>
      _$ClubRoomCopyWithImpl<ClubRoom>(this as ClubRoom, _$identity);

  /// Serializes this ClubRoom to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ClubRoom &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.clubId, clubId) || other.clubId == clubId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.progressGate, progressGate) ||
                other.progressGate == progressGate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.canEnter, canEnter) ||
                other.canEnter == canEnter));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, clubId, name, progressGate, createdAt, canEnter);

  @override
  String toString() {
    return 'ClubRoom(id: $id, clubId: $clubId, name: $name, progressGate: $progressGate, createdAt: $createdAt, canEnter: $canEnter)';
  }
}

/// @nodoc
abstract mixin class $ClubRoomCopyWith<$Res> {
  factory $ClubRoomCopyWith(ClubRoom value, $Res Function(ClubRoom) _then) =
      _$ClubRoomCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String clubId,
      String name,
      int progressGate,
      DateTime createdAt,
      bool canEnter});
}

/// @nodoc
class _$ClubRoomCopyWithImpl<$Res> implements $ClubRoomCopyWith<$Res> {
  _$ClubRoomCopyWithImpl(this._self, this._then);

  final ClubRoom _self;
  final $Res Function(ClubRoom) _then;

  /// Create a copy of ClubRoom
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clubId = null,
    Object? name = null,
    Object? progressGate = null,
    Object? createdAt = null,
    Object? canEnter = null,
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
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      progressGate: null == progressGate
          ? _self.progressGate
          : progressGate // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      canEnter: null == canEnter
          ? _self.canEnter
          : canEnter // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [ClubRoom].
extension ClubRoomPatterns on ClubRoom {
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
    TResult Function(_ClubRoom value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ClubRoom() when $default != null:
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
    TResult Function(_ClubRoom value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ClubRoom():
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
    TResult? Function(_ClubRoom value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ClubRoom() when $default != null:
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
    TResult Function(String id, String clubId, String name, int progressGate,
            DateTime createdAt, bool canEnter)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ClubRoom() when $default != null:
        return $default(_that.id, _that.clubId, _that.name, _that.progressGate,
            _that.createdAt, _that.canEnter);
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
    TResult Function(String id, String clubId, String name, int progressGate,
            DateTime createdAt, bool canEnter)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ClubRoom():
        return $default(_that.id, _that.clubId, _that.name, _that.progressGate,
            _that.createdAt, _that.canEnter);
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
    TResult? Function(String id, String clubId, String name, int progressGate,
            DateTime createdAt, bool canEnter)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ClubRoom() when $default != null:
        return $default(_that.id, _that.clubId, _that.name, _that.progressGate,
            _that.createdAt, _that.canEnter);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ClubRoom implements ClubRoom {
  const _ClubRoom(
      {required this.id,
      required this.clubId,
      required this.name,
      this.progressGate = 0,
      required this.createdAt,
      this.canEnter = true});
  factory _ClubRoom.fromJson(Map<String, dynamic> json) =>
      _$ClubRoomFromJson(json);

  @override
  final String id;
  @override
  final String clubId;
  @override
  final String name;

  /// Minimum progress percentage (0–100) required to enter.
  @override
  @JsonKey()
  final int progressGate;
  @override
  final DateTime createdAt;

  /// True when the current user's reading progress meets [progressGate].
  @override
  @JsonKey()
  final bool canEnter;

  /// Create a copy of ClubRoom
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ClubRoomCopyWith<_ClubRoom> get copyWith =>
      __$ClubRoomCopyWithImpl<_ClubRoom>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ClubRoomToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ClubRoom &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.clubId, clubId) || other.clubId == clubId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.progressGate, progressGate) ||
                other.progressGate == progressGate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.canEnter, canEnter) ||
                other.canEnter == canEnter));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, clubId, name, progressGate, createdAt, canEnter);

  @override
  String toString() {
    return 'ClubRoom(id: $id, clubId: $clubId, name: $name, progressGate: $progressGate, createdAt: $createdAt, canEnter: $canEnter)';
  }
}

/// @nodoc
abstract mixin class _$ClubRoomCopyWith<$Res>
    implements $ClubRoomCopyWith<$Res> {
  factory _$ClubRoomCopyWith(_ClubRoom value, $Res Function(_ClubRoom) _then) =
      __$ClubRoomCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String clubId,
      String name,
      int progressGate,
      DateTime createdAt,
      bool canEnter});
}

/// @nodoc
class __$ClubRoomCopyWithImpl<$Res> implements _$ClubRoomCopyWith<$Res> {
  __$ClubRoomCopyWithImpl(this._self, this._then);

  final _ClubRoom _self;
  final $Res Function(_ClubRoom) _then;

  /// Create a copy of ClubRoom
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? clubId = null,
    Object? name = null,
    Object? progressGate = null,
    Object? createdAt = null,
    Object? canEnter = null,
  }) {
    return _then(_ClubRoom(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      clubId: null == clubId
          ? _self.clubId
          : clubId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      progressGate: null == progressGate
          ? _self.progressGate
          : progressGate // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      canEnter: null == canEnter
          ? _self.canEnter
          : canEnter // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
