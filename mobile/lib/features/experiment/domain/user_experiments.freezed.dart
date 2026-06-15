// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_experiments.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserExperiments {
  List<ExperimentAssignment> get assignments;

  /// Create a copy of UserExperiments
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserExperimentsCopyWith<UserExperiments> get copyWith =>
      _$UserExperimentsCopyWithImpl<UserExperiments>(
          this as UserExperiments, _$identity);

  /// Serializes this UserExperiments to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserExperiments &&
            const DeepCollectionEquality()
                .equals(other.assignments, assignments));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(assignments));

  @override
  String toString() {
    return 'UserExperiments(assignments: $assignments)';
  }
}

/// @nodoc
abstract mixin class $UserExperimentsCopyWith<$Res> {
  factory $UserExperimentsCopyWith(
          UserExperiments value, $Res Function(UserExperiments) _then) =
      _$UserExperimentsCopyWithImpl;
  @useResult
  $Res call({List<ExperimentAssignment> assignments});
}

/// @nodoc
class _$UserExperimentsCopyWithImpl<$Res>
    implements $UserExperimentsCopyWith<$Res> {
  _$UserExperimentsCopyWithImpl(this._self, this._then);

  final UserExperiments _self;
  final $Res Function(UserExperiments) _then;

  /// Create a copy of UserExperiments
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? assignments = null,
  }) {
    return _then(_self.copyWith(
      assignments: null == assignments
          ? _self.assignments
          : assignments // ignore: cast_nullable_to_non_nullable
              as List<ExperimentAssignment>,
    ));
  }
}

/// Adds pattern-matching-related methods to [UserExperiments].
extension UserExperimentsPatterns on UserExperiments {
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
    TResult Function(_UserExperiments value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserExperiments() when $default != null:
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
    TResult Function(_UserExperiments value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserExperiments():
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
    TResult? Function(_UserExperiments value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserExperiments() when $default != null:
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
    TResult Function(List<ExperimentAssignment> assignments)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserExperiments() when $default != null:
        return $default(_that.assignments);
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
    TResult Function(List<ExperimentAssignment> assignments) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserExperiments():
        return $default(_that.assignments);
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
    TResult? Function(List<ExperimentAssignment> assignments)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserExperiments() when $default != null:
        return $default(_that.assignments);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _UserExperiments implements UserExperiments {
  const _UserExperiments(
      {required final List<ExperimentAssignment> assignments})
      : _assignments = assignments;
  factory _UserExperiments.fromJson(Map<String, dynamic> json) =>
      _$UserExperimentsFromJson(json);

  final List<ExperimentAssignment> _assignments;
  @override
  List<ExperimentAssignment> get assignments {
    if (_assignments is EqualUnmodifiableListView) return _assignments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_assignments);
  }

  /// Create a copy of UserExperiments
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserExperimentsCopyWith<_UserExperiments> get copyWith =>
      __$UserExperimentsCopyWithImpl<_UserExperiments>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UserExperimentsToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserExperiments &&
            const DeepCollectionEquality()
                .equals(other._assignments, _assignments));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_assignments));

  @override
  String toString() {
    return 'UserExperiments(assignments: $assignments)';
  }
}

/// @nodoc
abstract mixin class _$UserExperimentsCopyWith<$Res>
    implements $UserExperimentsCopyWith<$Res> {
  factory _$UserExperimentsCopyWith(
          _UserExperiments value, $Res Function(_UserExperiments) _then) =
      __$UserExperimentsCopyWithImpl;
  @override
  @useResult
  $Res call({List<ExperimentAssignment> assignments});
}

/// @nodoc
class __$UserExperimentsCopyWithImpl<$Res>
    implements _$UserExperimentsCopyWith<$Res> {
  __$UserExperimentsCopyWithImpl(this._self, this._then);

  final _UserExperiments _self;
  final $Res Function(_UserExperiments) _then;

  /// Create a copy of UserExperiments
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? assignments = null,
  }) {
    return _then(_UserExperiments(
      assignments: null == assignments
          ? _self._assignments
          : assignments // ignore: cast_nullable_to_non_nullable
              as List<ExperimentAssignment>,
    ));
  }
}

// dart format on
