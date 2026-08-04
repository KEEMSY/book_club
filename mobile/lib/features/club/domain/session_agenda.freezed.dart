// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_agenda.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SessionAgenda {
  String get id;
  String get sessionId;
  String get authorId;
  String? get authorName;
  String get body;
  AgendaStatus get status;
  DateTime? get publishedAt;
  DateTime get createdAt;
  List<AgendaTopic> get topics;

  /// Create a copy of SessionAgenda
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SessionAgendaCopyWith<SessionAgenda> get copyWith =>
      _$SessionAgendaCopyWithImpl<SessionAgenda>(
          this as SessionAgenda, _$identity);

  /// Serializes this SessionAgenda to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SessionAgenda &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.authorId, authorId) ||
                other.authorId == authorId) &&
            (identical(other.authorName, authorName) ||
                other.authorName == authorName) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.publishedAt, publishedAt) ||
                other.publishedAt == publishedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.topics, topics));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      sessionId,
      authorId,
      authorName,
      body,
      status,
      publishedAt,
      createdAt,
      const DeepCollectionEquality().hash(topics));

  @override
  String toString() {
    return 'SessionAgenda(id: $id, sessionId: $sessionId, authorId: $authorId, authorName: $authorName, body: $body, status: $status, publishedAt: $publishedAt, createdAt: $createdAt, topics: $topics)';
  }
}

/// @nodoc
abstract mixin class $SessionAgendaCopyWith<$Res> {
  factory $SessionAgendaCopyWith(
          SessionAgenda value, $Res Function(SessionAgenda) _then) =
      _$SessionAgendaCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String sessionId,
      String authorId,
      String? authorName,
      String body,
      AgendaStatus status,
      DateTime? publishedAt,
      DateTime createdAt,
      List<AgendaTopic> topics});
}

/// @nodoc
class _$SessionAgendaCopyWithImpl<$Res>
    implements $SessionAgendaCopyWith<$Res> {
  _$SessionAgendaCopyWithImpl(this._self, this._then);

  final SessionAgenda _self;
  final $Res Function(SessionAgenda) _then;

  /// Create a copy of SessionAgenda
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sessionId = null,
    Object? authorId = null,
    Object? authorName = freezed,
    Object? body = null,
    Object? status = null,
    Object? publishedAt = freezed,
    Object? createdAt = null,
    Object? topics = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _self.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      authorId: null == authorId
          ? _self.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
      authorName: freezed == authorName
          ? _self.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String?,
      body: null == body
          ? _self.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as AgendaStatus,
      publishedAt: freezed == publishedAt
          ? _self.publishedAt
          : publishedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      topics: null == topics
          ? _self.topics
          : topics // ignore: cast_nullable_to_non_nullable
              as List<AgendaTopic>,
    ));
  }
}

/// Adds pattern-matching-related methods to [SessionAgenda].
extension SessionAgendaPatterns on SessionAgenda {
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
    TResult Function(_SessionAgenda value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SessionAgenda() when $default != null:
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
    TResult Function(_SessionAgenda value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SessionAgenda():
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
    TResult? Function(_SessionAgenda value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SessionAgenda() when $default != null:
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
            String sessionId,
            String authorId,
            String? authorName,
            String body,
            AgendaStatus status,
            DateTime? publishedAt,
            DateTime createdAt,
            List<AgendaTopic> topics)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SessionAgenda() when $default != null:
        return $default(
            _that.id,
            _that.sessionId,
            _that.authorId,
            _that.authorName,
            _that.body,
            _that.status,
            _that.publishedAt,
            _that.createdAt,
            _that.topics);
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
            String sessionId,
            String authorId,
            String? authorName,
            String body,
            AgendaStatus status,
            DateTime? publishedAt,
            DateTime createdAt,
            List<AgendaTopic> topics)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SessionAgenda():
        return $default(
            _that.id,
            _that.sessionId,
            _that.authorId,
            _that.authorName,
            _that.body,
            _that.status,
            _that.publishedAt,
            _that.createdAt,
            _that.topics);
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
            String sessionId,
            String authorId,
            String? authorName,
            String body,
            AgendaStatus status,
            DateTime? publishedAt,
            DateTime createdAt,
            List<AgendaTopic> topics)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SessionAgenda() when $default != null:
        return $default(
            _that.id,
            _that.sessionId,
            _that.authorId,
            _that.authorName,
            _that.body,
            _that.status,
            _that.publishedAt,
            _that.createdAt,
            _that.topics);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SessionAgenda implements SessionAgenda {
  const _SessionAgenda(
      {required this.id,
      required this.sessionId,
      required this.authorId,
      this.authorName,
      required this.body,
      required this.status,
      this.publishedAt,
      required this.createdAt,
      final List<AgendaTopic> topics = const <AgendaTopic>[]})
      : _topics = topics;
  factory _SessionAgenda.fromJson(Map<String, dynamic> json) =>
      _$SessionAgendaFromJson(json);

  @override
  final String id;
  @override
  final String sessionId;
  @override
  final String authorId;
  @override
  final String? authorName;
  @override
  final String body;
  @override
  final AgendaStatus status;
  @override
  final DateTime? publishedAt;
  @override
  final DateTime createdAt;
  final List<AgendaTopic> _topics;
  @override
  @JsonKey()
  List<AgendaTopic> get topics {
    if (_topics is EqualUnmodifiableListView) return _topics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topics);
  }

  /// Create a copy of SessionAgenda
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SessionAgendaCopyWith<_SessionAgenda> get copyWith =>
      __$SessionAgendaCopyWithImpl<_SessionAgenda>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SessionAgendaToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SessionAgenda &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.authorId, authorId) ||
                other.authorId == authorId) &&
            (identical(other.authorName, authorName) ||
                other.authorName == authorName) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.publishedAt, publishedAt) ||
                other.publishedAt == publishedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other._topics, _topics));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      sessionId,
      authorId,
      authorName,
      body,
      status,
      publishedAt,
      createdAt,
      const DeepCollectionEquality().hash(_topics));

  @override
  String toString() {
    return 'SessionAgenda(id: $id, sessionId: $sessionId, authorId: $authorId, authorName: $authorName, body: $body, status: $status, publishedAt: $publishedAt, createdAt: $createdAt, topics: $topics)';
  }
}

/// @nodoc
abstract mixin class _$SessionAgendaCopyWith<$Res>
    implements $SessionAgendaCopyWith<$Res> {
  factory _$SessionAgendaCopyWith(
          _SessionAgenda value, $Res Function(_SessionAgenda) _then) =
      __$SessionAgendaCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String sessionId,
      String authorId,
      String? authorName,
      String body,
      AgendaStatus status,
      DateTime? publishedAt,
      DateTime createdAt,
      List<AgendaTopic> topics});
}

/// @nodoc
class __$SessionAgendaCopyWithImpl<$Res>
    implements _$SessionAgendaCopyWith<$Res> {
  __$SessionAgendaCopyWithImpl(this._self, this._then);

  final _SessionAgenda _self;
  final $Res Function(_SessionAgenda) _then;

  /// Create a copy of SessionAgenda
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? sessionId = null,
    Object? authorId = null,
    Object? authorName = freezed,
    Object? body = null,
    Object? status = null,
    Object? publishedAt = freezed,
    Object? createdAt = null,
    Object? topics = null,
  }) {
    return _then(_SessionAgenda(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _self.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      authorId: null == authorId
          ? _self.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
      authorName: freezed == authorName
          ? _self.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String?,
      body: null == body
          ? _self.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as AgendaStatus,
      publishedAt: freezed == publishedAt
          ? _self.publishedAt
          : publishedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      topics: null == topics
          ? _self._topics
          : topics // ignore: cast_nullable_to_non_nullable
              as List<AgendaTopic>,
    ));
  }
}

// dart format on
