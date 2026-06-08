// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'club_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AttendeeCount {
  int get going;
  int get maybe;
  int get notGoing;

  /// Create a copy of AttendeeCount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AttendeeCountCopyWith<AttendeeCount> get copyWith =>
      _$AttendeeCountCopyWithImpl<AttendeeCount>(
          this as AttendeeCount, _$identity);

  /// Serializes this AttendeeCount to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AttendeeCount &&
            (identical(other.going, going) || other.going == going) &&
            (identical(other.maybe, maybe) || other.maybe == maybe) &&
            (identical(other.notGoing, notGoing) ||
                other.notGoing == notGoing));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, going, maybe, notGoing);

  @override
  String toString() {
    return 'AttendeeCount(going: $going, maybe: $maybe, notGoing: $notGoing)';
  }
}

/// @nodoc
abstract mixin class $AttendeeCountCopyWith<$Res> {
  factory $AttendeeCountCopyWith(
          AttendeeCount value, $Res Function(AttendeeCount) _then) =
      _$AttendeeCountCopyWithImpl;
  @useResult
  $Res call({int going, int maybe, int notGoing});
}

/// @nodoc
class _$AttendeeCountCopyWithImpl<$Res>
    implements $AttendeeCountCopyWith<$Res> {
  _$AttendeeCountCopyWithImpl(this._self, this._then);

  final AttendeeCount _self;
  final $Res Function(AttendeeCount) _then;

  /// Create a copy of AttendeeCount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? going = null,
    Object? maybe = null,
    Object? notGoing = null,
  }) {
    return _then(_self.copyWith(
      going: null == going
          ? _self.going
          : going // ignore: cast_nullable_to_non_nullable
              as int,
      maybe: null == maybe
          ? _self.maybe
          : maybe // ignore: cast_nullable_to_non_nullable
              as int,
      notGoing: null == notGoing
          ? _self.notGoing
          : notGoing // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [AttendeeCount].
extension AttendeeCountPatterns on AttendeeCount {
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
    TResult Function(_AttendeeCount value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AttendeeCount() when $default != null:
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
    TResult Function(_AttendeeCount value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AttendeeCount():
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
    TResult? Function(_AttendeeCount value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AttendeeCount() when $default != null:
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
    TResult Function(int going, int maybe, int notGoing)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AttendeeCount() when $default != null:
        return $default(_that.going, _that.maybe, _that.notGoing);
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
    TResult Function(int going, int maybe, int notGoing) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AttendeeCount():
        return $default(_that.going, _that.maybe, _that.notGoing);
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
    TResult? Function(int going, int maybe, int notGoing)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AttendeeCount() when $default != null:
        return $default(_that.going, _that.maybe, _that.notGoing);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AttendeeCount implements AttendeeCount {
  const _AttendeeCount({this.going = 0, this.maybe = 0, this.notGoing = 0});
  factory _AttendeeCount.fromJson(Map<String, dynamic> json) =>
      _$AttendeeCountFromJson(json);

  @override
  @JsonKey()
  final int going;
  @override
  @JsonKey()
  final int maybe;
  @override
  @JsonKey()
  final int notGoing;

  /// Create a copy of AttendeeCount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AttendeeCountCopyWith<_AttendeeCount> get copyWith =>
      __$AttendeeCountCopyWithImpl<_AttendeeCount>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AttendeeCountToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AttendeeCount &&
            (identical(other.going, going) || other.going == going) &&
            (identical(other.maybe, maybe) || other.maybe == maybe) &&
            (identical(other.notGoing, notGoing) ||
                other.notGoing == notGoing));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, going, maybe, notGoing);

  @override
  String toString() {
    return 'AttendeeCount(going: $going, maybe: $maybe, notGoing: $notGoing)';
  }
}

/// @nodoc
abstract mixin class _$AttendeeCountCopyWith<$Res>
    implements $AttendeeCountCopyWith<$Res> {
  factory _$AttendeeCountCopyWith(
          _AttendeeCount value, $Res Function(_AttendeeCount) _then) =
      __$AttendeeCountCopyWithImpl;
  @override
  @useResult
  $Res call({int going, int maybe, int notGoing});
}

/// @nodoc
class __$AttendeeCountCopyWithImpl<$Res>
    implements _$AttendeeCountCopyWith<$Res> {
  __$AttendeeCountCopyWithImpl(this._self, this._then);

  final _AttendeeCount _self;
  final $Res Function(_AttendeeCount) _then;

  /// Create a copy of AttendeeCount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? going = null,
    Object? maybe = null,
    Object? notGoing = null,
  }) {
    return _then(_AttendeeCount(
      going: null == going
          ? _self.going
          : going // ignore: cast_nullable_to_non_nullable
              as int,
      maybe: null == maybe
          ? _self.maybe
          : maybe // ignore: cast_nullable_to_non_nullable
              as int,
      notGoing: null == notGoing
          ? _self.notGoing
          : notGoing // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$ClubEvent {
  String get id;
  String get clubId;
  String get title;
  String? get description;
  DateTime get eventAt;
  String? get location;
  int? get maxAttendees;
  DateTime get createdAt;
  AttendeeCount get attendeeCounts;
  RsvpStatus? get myStatus;

  /// Create a copy of ClubEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ClubEventCopyWith<ClubEvent> get copyWith =>
      _$ClubEventCopyWithImpl<ClubEvent>(this as ClubEvent, _$identity);

  /// Serializes this ClubEvent to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ClubEvent &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.clubId, clubId) || other.clubId == clubId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.eventAt, eventAt) || other.eventAt == eventAt) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.maxAttendees, maxAttendees) ||
                other.maxAttendees == maxAttendees) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.attendeeCounts, attendeeCounts) ||
                other.attendeeCounts == attendeeCounts) &&
            (identical(other.myStatus, myStatus) ||
                other.myStatus == myStatus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, clubId, title, description,
      eventAt, location, maxAttendees, createdAt, attendeeCounts, myStatus);

  @override
  String toString() {
    return 'ClubEvent(id: $id, clubId: $clubId, title: $title, description: $description, eventAt: $eventAt, location: $location, maxAttendees: $maxAttendees, createdAt: $createdAt, attendeeCounts: $attendeeCounts, myStatus: $myStatus)';
  }
}

/// @nodoc
abstract mixin class $ClubEventCopyWith<$Res> {
  factory $ClubEventCopyWith(ClubEvent value, $Res Function(ClubEvent) _then) =
      _$ClubEventCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String clubId,
      String title,
      String? description,
      DateTime eventAt,
      String? location,
      int? maxAttendees,
      DateTime createdAt,
      AttendeeCount attendeeCounts,
      RsvpStatus? myStatus});

  $AttendeeCountCopyWith<$Res> get attendeeCounts;
}

/// @nodoc
class _$ClubEventCopyWithImpl<$Res> implements $ClubEventCopyWith<$Res> {
  _$ClubEventCopyWithImpl(this._self, this._then);

  final ClubEvent _self;
  final $Res Function(ClubEvent) _then;

  /// Create a copy of ClubEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clubId = null,
    Object? title = null,
    Object? description = freezed,
    Object? eventAt = null,
    Object? location = freezed,
    Object? maxAttendees = freezed,
    Object? createdAt = null,
    Object? attendeeCounts = null,
    Object? myStatus = freezed,
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
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      eventAt: null == eventAt
          ? _self.eventAt
          : eventAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      location: freezed == location
          ? _self.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      maxAttendees: freezed == maxAttendees
          ? _self.maxAttendees
          : maxAttendees // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      attendeeCounts: null == attendeeCounts
          ? _self.attendeeCounts
          : attendeeCounts // ignore: cast_nullable_to_non_nullable
              as AttendeeCount,
      myStatus: freezed == myStatus
          ? _self.myStatus
          : myStatus // ignore: cast_nullable_to_non_nullable
              as RsvpStatus?,
    ));
  }

  /// Create a copy of ClubEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AttendeeCountCopyWith<$Res> get attendeeCounts {
    return $AttendeeCountCopyWith<$Res>(_self.attendeeCounts, (value) {
      return _then(_self.copyWith(attendeeCounts: value));
    });
  }
}

/// Adds pattern-matching-related methods to [ClubEvent].
extension ClubEventPatterns on ClubEvent {
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
    TResult Function(_ClubEvent value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ClubEvent() when $default != null:
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
    TResult Function(_ClubEvent value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ClubEvent():
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
    TResult? Function(_ClubEvent value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ClubEvent() when $default != null:
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
            String title,
            String? description,
            DateTime eventAt,
            String? location,
            int? maxAttendees,
            DateTime createdAt,
            AttendeeCount attendeeCounts,
            RsvpStatus? myStatus)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ClubEvent() when $default != null:
        return $default(
            _that.id,
            _that.clubId,
            _that.title,
            _that.description,
            _that.eventAt,
            _that.location,
            _that.maxAttendees,
            _that.createdAt,
            _that.attendeeCounts,
            _that.myStatus);
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
            String title,
            String? description,
            DateTime eventAt,
            String? location,
            int? maxAttendees,
            DateTime createdAt,
            AttendeeCount attendeeCounts,
            RsvpStatus? myStatus)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ClubEvent():
        return $default(
            _that.id,
            _that.clubId,
            _that.title,
            _that.description,
            _that.eventAt,
            _that.location,
            _that.maxAttendees,
            _that.createdAt,
            _that.attendeeCounts,
            _that.myStatus);
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
            String title,
            String? description,
            DateTime eventAt,
            String? location,
            int? maxAttendees,
            DateTime createdAt,
            AttendeeCount attendeeCounts,
            RsvpStatus? myStatus)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ClubEvent() when $default != null:
        return $default(
            _that.id,
            _that.clubId,
            _that.title,
            _that.description,
            _that.eventAt,
            _that.location,
            _that.maxAttendees,
            _that.createdAt,
            _that.attendeeCounts,
            _that.myStatus);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ClubEvent implements ClubEvent {
  const _ClubEvent(
      {required this.id,
      required this.clubId,
      required this.title,
      this.description,
      required this.eventAt,
      this.location,
      this.maxAttendees,
      required this.createdAt,
      this.attendeeCounts = const AttendeeCount(),
      this.myStatus});
  factory _ClubEvent.fromJson(Map<String, dynamic> json) =>
      _$ClubEventFromJson(json);

  @override
  final String id;
  @override
  final String clubId;
  @override
  final String title;
  @override
  final String? description;
  @override
  final DateTime eventAt;
  @override
  final String? location;
  @override
  final int? maxAttendees;
  @override
  final DateTime createdAt;
  @override
  @JsonKey()
  final AttendeeCount attendeeCounts;
  @override
  final RsvpStatus? myStatus;

  /// Create a copy of ClubEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ClubEventCopyWith<_ClubEvent> get copyWith =>
      __$ClubEventCopyWithImpl<_ClubEvent>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ClubEventToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ClubEvent &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.clubId, clubId) || other.clubId == clubId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.eventAt, eventAt) || other.eventAt == eventAt) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.maxAttendees, maxAttendees) ||
                other.maxAttendees == maxAttendees) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.attendeeCounts, attendeeCounts) ||
                other.attendeeCounts == attendeeCounts) &&
            (identical(other.myStatus, myStatus) ||
                other.myStatus == myStatus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, clubId, title, description,
      eventAt, location, maxAttendees, createdAt, attendeeCounts, myStatus);

  @override
  String toString() {
    return 'ClubEvent(id: $id, clubId: $clubId, title: $title, description: $description, eventAt: $eventAt, location: $location, maxAttendees: $maxAttendees, createdAt: $createdAt, attendeeCounts: $attendeeCounts, myStatus: $myStatus)';
  }
}

/// @nodoc
abstract mixin class _$ClubEventCopyWith<$Res>
    implements $ClubEventCopyWith<$Res> {
  factory _$ClubEventCopyWith(
          _ClubEvent value, $Res Function(_ClubEvent) _then) =
      __$ClubEventCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String clubId,
      String title,
      String? description,
      DateTime eventAt,
      String? location,
      int? maxAttendees,
      DateTime createdAt,
      AttendeeCount attendeeCounts,
      RsvpStatus? myStatus});

  @override
  $AttendeeCountCopyWith<$Res> get attendeeCounts;
}

/// @nodoc
class __$ClubEventCopyWithImpl<$Res> implements _$ClubEventCopyWith<$Res> {
  __$ClubEventCopyWithImpl(this._self, this._then);

  final _ClubEvent _self;
  final $Res Function(_ClubEvent) _then;

  /// Create a copy of ClubEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? clubId = null,
    Object? title = null,
    Object? description = freezed,
    Object? eventAt = null,
    Object? location = freezed,
    Object? maxAttendees = freezed,
    Object? createdAt = null,
    Object? attendeeCounts = null,
    Object? myStatus = freezed,
  }) {
    return _then(_ClubEvent(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      clubId: null == clubId
          ? _self.clubId
          : clubId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      eventAt: null == eventAt
          ? _self.eventAt
          : eventAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      location: freezed == location
          ? _self.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      maxAttendees: freezed == maxAttendees
          ? _self.maxAttendees
          : maxAttendees // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      attendeeCounts: null == attendeeCounts
          ? _self.attendeeCounts
          : attendeeCounts // ignore: cast_nullable_to_non_nullable
              as AttendeeCount,
      myStatus: freezed == myStatus
          ? _self.myStatus
          : myStatus // ignore: cast_nullable_to_non_nullable
              as RsvpStatus?,
    ));
  }

  /// Create a copy of ClubEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AttendeeCountCopyWith<$Res> get attendeeCounts {
    return $AttendeeCountCopyWith<$Res>(_self.attendeeCounts, (value) {
      return _then(_self.copyWith(attendeeCounts: value));
    });
  }
}

// dart format on
