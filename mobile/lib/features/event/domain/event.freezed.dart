// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Event {
  String get id;
  String get title;
  String? get description;
  String? get address;
  double get lat;
  double get lng;
  DateTime get eventAt;
  int? get maxAttendees;
  bool get isPublic;
  String? get clubId;
  String? get bookId;
  String? get category;
  int get joinedCount;
  double get distanceKm;
  DateTime get createdAt;

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EventCopyWith<Event> get copyWith =>
      _$EventCopyWithImpl<Event>(this as Event, _$identity);

  /// Serializes this Event to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Event &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng) &&
            (identical(other.eventAt, eventAt) || other.eventAt == eventAt) &&
            (identical(other.maxAttendees, maxAttendees) ||
                other.maxAttendees == maxAttendees) &&
            (identical(other.isPublic, isPublic) ||
                other.isPublic == isPublic) &&
            (identical(other.clubId, clubId) || other.clubId == clubId) &&
            (identical(other.bookId, bookId) || other.bookId == bookId) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.joinedCount, joinedCount) ||
                other.joinedCount == joinedCount) &&
            (identical(other.distanceKm, distanceKm) ||
                other.distanceKm == distanceKm) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      address,
      lat,
      lng,
      eventAt,
      maxAttendees,
      isPublic,
      clubId,
      bookId,
      category,
      joinedCount,
      distanceKm,
      createdAt);

  @override
  String toString() {
    return 'Event(id: $id, title: $title, description: $description, address: $address, lat: $lat, lng: $lng, eventAt: $eventAt, maxAttendees: $maxAttendees, isPublic: $isPublic, clubId: $clubId, bookId: $bookId, category: $category, joinedCount: $joinedCount, distanceKm: $distanceKm, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $EventCopyWith<$Res> {
  factory $EventCopyWith(Event value, $Res Function(Event) _then) =
      _$EventCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String title,
      String? description,
      String? address,
      double lat,
      double lng,
      DateTime eventAt,
      int? maxAttendees,
      bool isPublic,
      String? clubId,
      String? bookId,
      String? category,
      int joinedCount,
      double distanceKm,
      DateTime createdAt});
}

/// @nodoc
class _$EventCopyWithImpl<$Res> implements $EventCopyWith<$Res> {
  _$EventCopyWithImpl(this._self, this._then);

  final Event _self;
  final $Res Function(Event) _then;

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? address = freezed,
    Object? lat = null,
    Object? lng = null,
    Object? eventAt = null,
    Object? maxAttendees = freezed,
    Object? isPublic = null,
    Object? clubId = freezed,
    Object? bookId = freezed,
    Object? category = freezed,
    Object? joinedCount = null,
    Object? distanceKm = null,
    Object? createdAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      lat: null == lat
          ? _self.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lng: null == lng
          ? _self.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double,
      eventAt: null == eventAt
          ? _self.eventAt
          : eventAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      maxAttendees: freezed == maxAttendees
          ? _self.maxAttendees
          : maxAttendees // ignore: cast_nullable_to_non_nullable
              as int?,
      isPublic: null == isPublic
          ? _self.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      clubId: freezed == clubId
          ? _self.clubId
          : clubId // ignore: cast_nullable_to_non_nullable
              as String?,
      bookId: freezed == bookId
          ? _self.bookId
          : bookId // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      joinedCount: null == joinedCount
          ? _self.joinedCount
          : joinedCount // ignore: cast_nullable_to_non_nullable
              as int,
      distanceKm: null == distanceKm
          ? _self.distanceKm
          : distanceKm // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [Event].
extension EventPatterns on Event {
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
    TResult Function(_Event value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Event() when $default != null:
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
    TResult Function(_Event value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Event():
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
    TResult? Function(_Event value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Event() when $default != null:
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
            String title,
            String? description,
            String? address,
            double lat,
            double lng,
            DateTime eventAt,
            int? maxAttendees,
            bool isPublic,
            String? clubId,
            String? bookId,
            String? category,
            int joinedCount,
            double distanceKm,
            DateTime createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Event() when $default != null:
        return $default(
            _that.id,
            _that.title,
            _that.description,
            _that.address,
            _that.lat,
            _that.lng,
            _that.eventAt,
            _that.maxAttendees,
            _that.isPublic,
            _that.clubId,
            _that.bookId,
            _that.category,
            _that.joinedCount,
            _that.distanceKm,
            _that.createdAt);
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
            String title,
            String? description,
            String? address,
            double lat,
            double lng,
            DateTime eventAt,
            int? maxAttendees,
            bool isPublic,
            String? clubId,
            String? bookId,
            String? category,
            int joinedCount,
            double distanceKm,
            DateTime createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Event():
        return $default(
            _that.id,
            _that.title,
            _that.description,
            _that.address,
            _that.lat,
            _that.lng,
            _that.eventAt,
            _that.maxAttendees,
            _that.isPublic,
            _that.clubId,
            _that.bookId,
            _that.category,
            _that.joinedCount,
            _that.distanceKm,
            _that.createdAt);
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
            String title,
            String? description,
            String? address,
            double lat,
            double lng,
            DateTime eventAt,
            int? maxAttendees,
            bool isPublic,
            String? clubId,
            String? bookId,
            String? category,
            int joinedCount,
            double distanceKm,
            DateTime createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Event() when $default != null:
        return $default(
            _that.id,
            _that.title,
            _that.description,
            _that.address,
            _that.lat,
            _that.lng,
            _that.eventAt,
            _that.maxAttendees,
            _that.isPublic,
            _that.clubId,
            _that.bookId,
            _that.category,
            _that.joinedCount,
            _that.distanceKm,
            _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Event implements Event {
  const _Event(
      {required this.id,
      required this.title,
      this.description,
      this.address,
      required this.lat,
      required this.lng,
      required this.eventAt,
      this.maxAttendees,
      required this.isPublic,
      this.clubId,
      this.bookId,
      this.category,
      this.joinedCount = 0,
      this.distanceKm = 0,
      required this.createdAt});
  factory _Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String? description;
  @override
  final String? address;
  @override
  final double lat;
  @override
  final double lng;
  @override
  final DateTime eventAt;
  @override
  final int? maxAttendees;
  @override
  final bool isPublic;
  @override
  final String? clubId;
  @override
  final String? bookId;
  @override
  final String? category;
  @override
  @JsonKey()
  final int joinedCount;
  @override
  @JsonKey()
  final double distanceKm;
  @override
  final DateTime createdAt;

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$EventCopyWith<_Event> get copyWith =>
      __$EventCopyWithImpl<_Event>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$EventToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Event &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng) &&
            (identical(other.eventAt, eventAt) || other.eventAt == eventAt) &&
            (identical(other.maxAttendees, maxAttendees) ||
                other.maxAttendees == maxAttendees) &&
            (identical(other.isPublic, isPublic) ||
                other.isPublic == isPublic) &&
            (identical(other.clubId, clubId) || other.clubId == clubId) &&
            (identical(other.bookId, bookId) || other.bookId == bookId) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.joinedCount, joinedCount) ||
                other.joinedCount == joinedCount) &&
            (identical(other.distanceKm, distanceKm) ||
                other.distanceKm == distanceKm) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      address,
      lat,
      lng,
      eventAt,
      maxAttendees,
      isPublic,
      clubId,
      bookId,
      category,
      joinedCount,
      distanceKm,
      createdAt);

  @override
  String toString() {
    return 'Event(id: $id, title: $title, description: $description, address: $address, lat: $lat, lng: $lng, eventAt: $eventAt, maxAttendees: $maxAttendees, isPublic: $isPublic, clubId: $clubId, bookId: $bookId, category: $category, joinedCount: $joinedCount, distanceKm: $distanceKm, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$EventCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory _$EventCopyWith(_Event value, $Res Function(_Event) _then) =
      __$EventCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String? description,
      String? address,
      double lat,
      double lng,
      DateTime eventAt,
      int? maxAttendees,
      bool isPublic,
      String? clubId,
      String? bookId,
      String? category,
      int joinedCount,
      double distanceKm,
      DateTime createdAt});
}

/// @nodoc
class __$EventCopyWithImpl<$Res> implements _$EventCopyWith<$Res> {
  __$EventCopyWithImpl(this._self, this._then);

  final _Event _self;
  final $Res Function(_Event) _then;

  /// Create a copy of Event
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? address = freezed,
    Object? lat = null,
    Object? lng = null,
    Object? eventAt = null,
    Object? maxAttendees = freezed,
    Object? isPublic = null,
    Object? clubId = freezed,
    Object? bookId = freezed,
    Object? category = freezed,
    Object? joinedCount = null,
    Object? distanceKm = null,
    Object? createdAt = null,
  }) {
    return _then(_Event(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _self.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      lat: null == lat
          ? _self.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double,
      lng: null == lng
          ? _self.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double,
      eventAt: null == eventAt
          ? _self.eventAt
          : eventAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      maxAttendees: freezed == maxAttendees
          ? _self.maxAttendees
          : maxAttendees // ignore: cast_nullable_to_non_nullable
              as int?,
      isPublic: null == isPublic
          ? _self.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
      clubId: freezed == clubId
          ? _self.clubId
          : clubId // ignore: cast_nullable_to_non_nullable
              as String?,
      bookId: freezed == bookId
          ? _self.bookId
          : bookId // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      joinedCount: null == joinedCount
          ? _self.joinedCount
          : joinedCount // ignore: cast_nullable_to_non_nullable
              as int,
      distanceKm: null == distanceKm
          ? _self.distanceKm
          : distanceKm // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
mixin _$EventWaitlistStatus {
  String get eventId;
  int get position;
  bool get confirmed;

  /// Create a copy of EventWaitlistStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EventWaitlistStatusCopyWith<EventWaitlistStatus> get copyWith =>
      _$EventWaitlistStatusCopyWithImpl<EventWaitlistStatus>(
          this as EventWaitlistStatus, _$identity);

  /// Serializes this EventWaitlistStatus to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EventWaitlistStatus &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.confirmed, confirmed) ||
                other.confirmed == confirmed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, eventId, position, confirmed);

  @override
  String toString() {
    return 'EventWaitlistStatus(eventId: $eventId, position: $position, confirmed: $confirmed)';
  }
}

/// @nodoc
abstract mixin class $EventWaitlistStatusCopyWith<$Res> {
  factory $EventWaitlistStatusCopyWith(
          EventWaitlistStatus value, $Res Function(EventWaitlistStatus) _then) =
      _$EventWaitlistStatusCopyWithImpl;
  @useResult
  $Res call({String eventId, int position, bool confirmed});
}

/// @nodoc
class _$EventWaitlistStatusCopyWithImpl<$Res>
    implements $EventWaitlistStatusCopyWith<$Res> {
  _$EventWaitlistStatusCopyWithImpl(this._self, this._then);

  final EventWaitlistStatus _self;
  final $Res Function(EventWaitlistStatus) _then;

  /// Create a copy of EventWaitlistStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventId = null,
    Object? position = null,
    Object? confirmed = null,
  }) {
    return _then(_self.copyWith(
      eventId: null == eventId
          ? _self.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      position: null == position
          ? _self.position
          : position // ignore: cast_nullable_to_non_nullable
              as int,
      confirmed: null == confirmed
          ? _self.confirmed
          : confirmed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [EventWaitlistStatus].
extension EventWaitlistStatusPatterns on EventWaitlistStatus {
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
    TResult Function(_EventWaitlistStatus value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _EventWaitlistStatus() when $default != null:
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
    TResult Function(_EventWaitlistStatus value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EventWaitlistStatus():
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
    TResult? Function(_EventWaitlistStatus value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EventWaitlistStatus() when $default != null:
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
    TResult Function(String eventId, int position, bool confirmed)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _EventWaitlistStatus() when $default != null:
        return $default(_that.eventId, _that.position, _that.confirmed);
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
    TResult Function(String eventId, int position, bool confirmed) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EventWaitlistStatus():
        return $default(_that.eventId, _that.position, _that.confirmed);
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
    TResult? Function(String eventId, int position, bool confirmed)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EventWaitlistStatus() when $default != null:
        return $default(_that.eventId, _that.position, _that.confirmed);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _EventWaitlistStatus implements EventWaitlistStatus {
  const _EventWaitlistStatus(
      {required this.eventId, required this.position, required this.confirmed});
  factory _EventWaitlistStatus.fromJson(Map<String, dynamic> json) =>
      _$EventWaitlistStatusFromJson(json);

  @override
  final String eventId;
  @override
  final int position;
  @override
  final bool confirmed;

  /// Create a copy of EventWaitlistStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$EventWaitlistStatusCopyWith<_EventWaitlistStatus> get copyWith =>
      __$EventWaitlistStatusCopyWithImpl<_EventWaitlistStatus>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$EventWaitlistStatusToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _EventWaitlistStatus &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.confirmed, confirmed) ||
                other.confirmed == confirmed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, eventId, position, confirmed);

  @override
  String toString() {
    return 'EventWaitlistStatus(eventId: $eventId, position: $position, confirmed: $confirmed)';
  }
}

/// @nodoc
abstract mixin class _$EventWaitlistStatusCopyWith<$Res>
    implements $EventWaitlistStatusCopyWith<$Res> {
  factory _$EventWaitlistStatusCopyWith(_EventWaitlistStatus value,
          $Res Function(_EventWaitlistStatus) _then) =
      __$EventWaitlistStatusCopyWithImpl;
  @override
  @useResult
  $Res call({String eventId, int position, bool confirmed});
}

/// @nodoc
class __$EventWaitlistStatusCopyWithImpl<$Res>
    implements _$EventWaitlistStatusCopyWith<$Res> {
  __$EventWaitlistStatusCopyWithImpl(this._self, this._then);

  final _EventWaitlistStatus _self;
  final $Res Function(_EventWaitlistStatus) _then;

  /// Create a copy of EventWaitlistStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? eventId = null,
    Object? position = null,
    Object? confirmed = null,
  }) {
    return _then(_EventWaitlistStatus(
      eventId: null == eventId
          ? _self.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      position: null == position
          ? _self.position
          : position // ignore: cast_nullable_to_non_nullable
              as int,
      confirmed: null == confirmed
          ? _self.confirmed
          : confirmed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
mixin _$EventReview {
  String get id;
  String get eventId;
  String get reviewerId;
  double get rating;
  String? get body;
  DateTime get createdAt;

  /// Create a copy of EventReview
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EventReviewCopyWith<EventReview> get copyWith =>
      _$EventReviewCopyWithImpl<EventReview>(this as EventReview, _$identity);

  /// Serializes this EventReview to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EventReview &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.reviewerId, reviewerId) ||
                other.reviewerId == reviewerId) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, eventId, reviewerId, rating, body, createdAt);

  @override
  String toString() {
    return 'EventReview(id: $id, eventId: $eventId, reviewerId: $reviewerId, rating: $rating, body: $body, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $EventReviewCopyWith<$Res> {
  factory $EventReviewCopyWith(
          EventReview value, $Res Function(EventReview) _then) =
      _$EventReviewCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String eventId,
      String reviewerId,
      double rating,
      String? body,
      DateTime createdAt});
}

/// @nodoc
class _$EventReviewCopyWithImpl<$Res> implements $EventReviewCopyWith<$Res> {
  _$EventReviewCopyWithImpl(this._self, this._then);

  final EventReview _self;
  final $Res Function(EventReview) _then;

  /// Create a copy of EventReview
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? reviewerId = null,
    Object? rating = null,
    Object? body = freezed,
    Object? createdAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      eventId: null == eventId
          ? _self.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      reviewerId: null == reviewerId
          ? _self.reviewerId
          : reviewerId // ignore: cast_nullable_to_non_nullable
              as String,
      rating: null == rating
          ? _self.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      body: freezed == body
          ? _self.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [EventReview].
extension EventReviewPatterns on EventReview {
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
    TResult Function(_EventReview value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _EventReview() when $default != null:
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
    TResult Function(_EventReview value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EventReview():
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
    TResult? Function(_EventReview value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EventReview() when $default != null:
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
    TResult Function(String id, String eventId, String reviewerId,
            double rating, String? body, DateTime createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _EventReview() when $default != null:
        return $default(_that.id, _that.eventId, _that.reviewerId, _that.rating,
            _that.body, _that.createdAt);
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
    TResult Function(String id, String eventId, String reviewerId,
            double rating, String? body, DateTime createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EventReview():
        return $default(_that.id, _that.eventId, _that.reviewerId, _that.rating,
            _that.body, _that.createdAt);
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
    TResult? Function(String id, String eventId, String reviewerId,
            double rating, String? body, DateTime createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EventReview() when $default != null:
        return $default(_that.id, _that.eventId, _that.reviewerId, _that.rating,
            _that.body, _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _EventReview implements EventReview {
  const _EventReview(
      {required this.id,
      required this.eventId,
      required this.reviewerId,
      required this.rating,
      this.body,
      required this.createdAt});
  factory _EventReview.fromJson(Map<String, dynamic> json) =>
      _$EventReviewFromJson(json);

  @override
  final String id;
  @override
  final String eventId;
  @override
  final String reviewerId;
  @override
  final double rating;
  @override
  final String? body;
  @override
  final DateTime createdAt;

  /// Create a copy of EventReview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$EventReviewCopyWith<_EventReview> get copyWith =>
      __$EventReviewCopyWithImpl<_EventReview>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$EventReviewToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _EventReview &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.reviewerId, reviewerId) ||
                other.reviewerId == reviewerId) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, eventId, reviewerId, rating, body, createdAt);

  @override
  String toString() {
    return 'EventReview(id: $id, eventId: $eventId, reviewerId: $reviewerId, rating: $rating, body: $body, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$EventReviewCopyWith<$Res>
    implements $EventReviewCopyWith<$Res> {
  factory _$EventReviewCopyWith(
          _EventReview value, $Res Function(_EventReview) _then) =
      __$EventReviewCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String eventId,
      String reviewerId,
      double rating,
      String? body,
      DateTime createdAt});
}

/// @nodoc
class __$EventReviewCopyWithImpl<$Res> implements _$EventReviewCopyWith<$Res> {
  __$EventReviewCopyWithImpl(this._self, this._then);

  final _EventReview _self;
  final $Res Function(_EventReview) _then;

  /// Create a copy of EventReview
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? eventId = null,
    Object? reviewerId = null,
    Object? rating = null,
    Object? body = freezed,
    Object? createdAt = null,
  }) {
    return _then(_EventReview(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      eventId: null == eventId
          ? _self.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      reviewerId: null == reviewerId
          ? _self.reviewerId
          : reviewerId // ignore: cast_nullable_to_non_nullable
              as String,
      rating: null == rating
          ? _self.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      body: freezed == body
          ? _self.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
