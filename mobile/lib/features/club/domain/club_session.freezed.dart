// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'club_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ClubSession {
  String get id;
  String get clubId;
  String get bookId;

  /// Denormalized for list/detail display, same convention as
  /// [Club.bookTitle] — avoids a second round-trip per session card.
  String? get bookTitle;
  String get title;

  /// Free-text chapter/page range (design doc: "챕터/페이지 범위").
  String? get scope;
  String? get presenterId;
  String? get presenterName;
  DateTime? get scheduledAt;
  ClubSessionStatus get status;
  DateTime get createdAt;

  /// Create a copy of ClubSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ClubSessionCopyWith<ClubSession> get copyWith =>
      _$ClubSessionCopyWithImpl<ClubSession>(this as ClubSession, _$identity);

  /// Serializes this ClubSession to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ClubSession &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.clubId, clubId) || other.clubId == clubId) &&
            (identical(other.bookId, bookId) || other.bookId == bookId) &&
            (identical(other.bookTitle, bookTitle) ||
                other.bookTitle == bookTitle) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.scope, scope) || other.scope == scope) &&
            (identical(other.presenterId, presenterId) ||
                other.presenterId == presenterId) &&
            (identical(other.presenterName, presenterName) ||
                other.presenterName == presenterName) &&
            (identical(other.scheduledAt, scheduledAt) ||
                other.scheduledAt == scheduledAt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, clubId, bookId, bookTitle,
      title, scope, presenterId, presenterName, scheduledAt, status, createdAt);

  @override
  String toString() {
    return 'ClubSession(id: $id, clubId: $clubId, bookId: $bookId, bookTitle: $bookTitle, title: $title, scope: $scope, presenterId: $presenterId, presenterName: $presenterName, scheduledAt: $scheduledAt, status: $status, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $ClubSessionCopyWith<$Res> {
  factory $ClubSessionCopyWith(
          ClubSession value, $Res Function(ClubSession) _then) =
      _$ClubSessionCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String clubId,
      String bookId,
      String? bookTitle,
      String title,
      String? scope,
      String? presenterId,
      String? presenterName,
      DateTime? scheduledAt,
      ClubSessionStatus status,
      DateTime createdAt});
}

/// @nodoc
class _$ClubSessionCopyWithImpl<$Res> implements $ClubSessionCopyWith<$Res> {
  _$ClubSessionCopyWithImpl(this._self, this._then);

  final ClubSession _self;
  final $Res Function(ClubSession) _then;

  /// Create a copy of ClubSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clubId = null,
    Object? bookId = null,
    Object? bookTitle = freezed,
    Object? title = null,
    Object? scope = freezed,
    Object? presenterId = freezed,
    Object? presenterName = freezed,
    Object? scheduledAt = freezed,
    Object? status = null,
    Object? createdAt = null,
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
      bookId: null == bookId
          ? _self.bookId
          : bookId // ignore: cast_nullable_to_non_nullable
              as String,
      bookTitle: freezed == bookTitle
          ? _self.bookTitle
          : bookTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      scope: freezed == scope
          ? _self.scope
          : scope // ignore: cast_nullable_to_non_nullable
              as String?,
      presenterId: freezed == presenterId
          ? _self.presenterId
          : presenterId // ignore: cast_nullable_to_non_nullable
              as String?,
      presenterName: freezed == presenterName
          ? _self.presenterName
          : presenterName // ignore: cast_nullable_to_non_nullable
              as String?,
      scheduledAt: freezed == scheduledAt
          ? _self.scheduledAt
          : scheduledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as ClubSessionStatus,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [ClubSession].
extension ClubSessionPatterns on ClubSession {
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
    TResult Function(_ClubSession value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ClubSession() when $default != null:
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
    TResult Function(_ClubSession value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ClubSession():
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
    TResult? Function(_ClubSession value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ClubSession() when $default != null:
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
            String bookId,
            String? bookTitle,
            String title,
            String? scope,
            String? presenterId,
            String? presenterName,
            DateTime? scheduledAt,
            ClubSessionStatus status,
            DateTime createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ClubSession() when $default != null:
        return $default(
            _that.id,
            _that.clubId,
            _that.bookId,
            _that.bookTitle,
            _that.title,
            _that.scope,
            _that.presenterId,
            _that.presenterName,
            _that.scheduledAt,
            _that.status,
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
            String clubId,
            String bookId,
            String? bookTitle,
            String title,
            String? scope,
            String? presenterId,
            String? presenterName,
            DateTime? scheduledAt,
            ClubSessionStatus status,
            DateTime createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ClubSession():
        return $default(
            _that.id,
            _that.clubId,
            _that.bookId,
            _that.bookTitle,
            _that.title,
            _that.scope,
            _that.presenterId,
            _that.presenterName,
            _that.scheduledAt,
            _that.status,
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
            String clubId,
            String bookId,
            String? bookTitle,
            String title,
            String? scope,
            String? presenterId,
            String? presenterName,
            DateTime? scheduledAt,
            ClubSessionStatus status,
            DateTime createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ClubSession() when $default != null:
        return $default(
            _that.id,
            _that.clubId,
            _that.bookId,
            _that.bookTitle,
            _that.title,
            _that.scope,
            _that.presenterId,
            _that.presenterName,
            _that.scheduledAt,
            _that.status,
            _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ClubSession implements ClubSession {
  const _ClubSession(
      {required this.id,
      required this.clubId,
      required this.bookId,
      this.bookTitle,
      required this.title,
      this.scope,
      this.presenterId,
      this.presenterName,
      this.scheduledAt,
      required this.status,
      required this.createdAt});
  factory _ClubSession.fromJson(Map<String, dynamic> json) =>
      _$ClubSessionFromJson(json);

  @override
  final String id;
  @override
  final String clubId;
  @override
  final String bookId;

  /// Denormalized for list/detail display, same convention as
  /// [Club.bookTitle] — avoids a second round-trip per session card.
  @override
  final String? bookTitle;
  @override
  final String title;

  /// Free-text chapter/page range (design doc: "챕터/페이지 범위").
  @override
  final String? scope;
  @override
  final String? presenterId;
  @override
  final String? presenterName;
  @override
  final DateTime? scheduledAt;
  @override
  final ClubSessionStatus status;
  @override
  final DateTime createdAt;

  /// Create a copy of ClubSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ClubSessionCopyWith<_ClubSession> get copyWith =>
      __$ClubSessionCopyWithImpl<_ClubSession>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ClubSessionToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ClubSession &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.clubId, clubId) || other.clubId == clubId) &&
            (identical(other.bookId, bookId) || other.bookId == bookId) &&
            (identical(other.bookTitle, bookTitle) ||
                other.bookTitle == bookTitle) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.scope, scope) || other.scope == scope) &&
            (identical(other.presenterId, presenterId) ||
                other.presenterId == presenterId) &&
            (identical(other.presenterName, presenterName) ||
                other.presenterName == presenterName) &&
            (identical(other.scheduledAt, scheduledAt) ||
                other.scheduledAt == scheduledAt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, clubId, bookId, bookTitle,
      title, scope, presenterId, presenterName, scheduledAt, status, createdAt);

  @override
  String toString() {
    return 'ClubSession(id: $id, clubId: $clubId, bookId: $bookId, bookTitle: $bookTitle, title: $title, scope: $scope, presenterId: $presenterId, presenterName: $presenterName, scheduledAt: $scheduledAt, status: $status, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$ClubSessionCopyWith<$Res>
    implements $ClubSessionCopyWith<$Res> {
  factory _$ClubSessionCopyWith(
          _ClubSession value, $Res Function(_ClubSession) _then) =
      __$ClubSessionCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String clubId,
      String bookId,
      String? bookTitle,
      String title,
      String? scope,
      String? presenterId,
      String? presenterName,
      DateTime? scheduledAt,
      ClubSessionStatus status,
      DateTime createdAt});
}

/// @nodoc
class __$ClubSessionCopyWithImpl<$Res> implements _$ClubSessionCopyWith<$Res> {
  __$ClubSessionCopyWithImpl(this._self, this._then);

  final _ClubSession _self;
  final $Res Function(_ClubSession) _then;

  /// Create a copy of ClubSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? clubId = null,
    Object? bookId = null,
    Object? bookTitle = freezed,
    Object? title = null,
    Object? scope = freezed,
    Object? presenterId = freezed,
    Object? presenterName = freezed,
    Object? scheduledAt = freezed,
    Object? status = null,
    Object? createdAt = null,
  }) {
    return _then(_ClubSession(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      clubId: null == clubId
          ? _self.clubId
          : clubId // ignore: cast_nullable_to_non_nullable
              as String,
      bookId: null == bookId
          ? _self.bookId
          : bookId // ignore: cast_nullable_to_non_nullable
              as String,
      bookTitle: freezed == bookTitle
          ? _self.bookTitle
          : bookTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      scope: freezed == scope
          ? _self.scope
          : scope // ignore: cast_nullable_to_non_nullable
              as String?,
      presenterId: freezed == presenterId
          ? _self.presenterId
          : presenterId // ignore: cast_nullable_to_non_nullable
              as String?,
      presenterName: freezed == presenterName
          ? _self.presenterName
          : presenterName // ignore: cast_nullable_to_non_nullable
              as String?,
      scheduledAt: freezed == scheduledAt
          ? _self.scheduledAt
          : scheduledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as ClubSessionStatus,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
