// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'agenda_topic.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AgendaTopic {
  String get id;
  String get agendaId;
  int get position;
  String get prompt;
  DateTime get createdAt;

  /// Create a copy of AgendaTopic
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AgendaTopicCopyWith<AgendaTopic> get copyWith =>
      _$AgendaTopicCopyWithImpl<AgendaTopic>(this as AgendaTopic, _$identity);

  /// Serializes this AgendaTopic to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AgendaTopic &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.agendaId, agendaId) ||
                other.agendaId == agendaId) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.prompt, prompt) || other.prompt == prompt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, agendaId, position, prompt, createdAt);

  @override
  String toString() {
    return 'AgendaTopic(id: $id, agendaId: $agendaId, position: $position, prompt: $prompt, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $AgendaTopicCopyWith<$Res> {
  factory $AgendaTopicCopyWith(
          AgendaTopic value, $Res Function(AgendaTopic) _then) =
      _$AgendaTopicCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String agendaId,
      int position,
      String prompt,
      DateTime createdAt});
}

/// @nodoc
class _$AgendaTopicCopyWithImpl<$Res> implements $AgendaTopicCopyWith<$Res> {
  _$AgendaTopicCopyWithImpl(this._self, this._then);

  final AgendaTopic _self;
  final $Res Function(AgendaTopic) _then;

  /// Create a copy of AgendaTopic
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? agendaId = null,
    Object? position = null,
    Object? prompt = null,
    Object? createdAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      agendaId: null == agendaId
          ? _self.agendaId
          : agendaId // ignore: cast_nullable_to_non_nullable
              as String,
      position: null == position
          ? _self.position
          : position // ignore: cast_nullable_to_non_nullable
              as int,
      prompt: null == prompt
          ? _self.prompt
          : prompt // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [AgendaTopic].
extension AgendaTopicPatterns on AgendaTopic {
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
    TResult Function(_AgendaTopic value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AgendaTopic() when $default != null:
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
    TResult Function(_AgendaTopic value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AgendaTopic():
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
    TResult? Function(_AgendaTopic value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AgendaTopic() when $default != null:
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
    TResult Function(String id, String agendaId, int position, String prompt,
            DateTime createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AgendaTopic() when $default != null:
        return $default(_that.id, _that.agendaId, _that.position, _that.prompt,
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
    TResult Function(String id, String agendaId, int position, String prompt,
            DateTime createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AgendaTopic():
        return $default(_that.id, _that.agendaId, _that.position, _that.prompt,
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
    TResult? Function(String id, String agendaId, int position, String prompt,
            DateTime createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AgendaTopic() when $default != null:
        return $default(_that.id, _that.agendaId, _that.position, _that.prompt,
            _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AgendaTopic implements AgendaTopic {
  const _AgendaTopic(
      {required this.id,
      required this.agendaId,
      required this.position,
      required this.prompt,
      required this.createdAt});
  factory _AgendaTopic.fromJson(Map<String, dynamic> json) =>
      _$AgendaTopicFromJson(json);

  @override
  final String id;
  @override
  final String agendaId;
  @override
  final int position;
  @override
  final String prompt;
  @override
  final DateTime createdAt;

  /// Create a copy of AgendaTopic
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AgendaTopicCopyWith<_AgendaTopic> get copyWith =>
      __$AgendaTopicCopyWithImpl<_AgendaTopic>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AgendaTopicToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AgendaTopic &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.agendaId, agendaId) ||
                other.agendaId == agendaId) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.prompt, prompt) || other.prompt == prompt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, agendaId, position, prompt, createdAt);

  @override
  String toString() {
    return 'AgendaTopic(id: $id, agendaId: $agendaId, position: $position, prompt: $prompt, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$AgendaTopicCopyWith<$Res>
    implements $AgendaTopicCopyWith<$Res> {
  factory _$AgendaTopicCopyWith(
          _AgendaTopic value, $Res Function(_AgendaTopic) _then) =
      __$AgendaTopicCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String agendaId,
      int position,
      String prompt,
      DateTime createdAt});
}

/// @nodoc
class __$AgendaTopicCopyWithImpl<$Res> implements _$AgendaTopicCopyWith<$Res> {
  __$AgendaTopicCopyWithImpl(this._self, this._then);

  final _AgendaTopic _self;
  final $Res Function(_AgendaTopic) _then;

  /// Create a copy of AgendaTopic
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? agendaId = null,
    Object? position = null,
    Object? prompt = null,
    Object? createdAt = null,
  }) {
    return _then(_AgendaTopic(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      agendaId: null == agendaId
          ? _self.agendaId
          : agendaId // ignore: cast_nullable_to_non_nullable
              as String,
      position: null == position
          ? _self.position
          : position // ignore: cast_nullable_to_non_nullable
              as int,
      prompt: null == prompt
          ? _self.prompt
          : prompt // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
