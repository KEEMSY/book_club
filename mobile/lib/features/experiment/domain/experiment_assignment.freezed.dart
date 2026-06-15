// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'experiment_assignment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExperimentAssignment {
  String get experimentKey;
  String get variant;
  DateTime get assignedAt;

  /// Create a copy of ExperimentAssignment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ExperimentAssignmentCopyWith<ExperimentAssignment> get copyWith =>
      _$ExperimentAssignmentCopyWithImpl<ExperimentAssignment>(
          this as ExperimentAssignment, _$identity);

  /// Serializes this ExperimentAssignment to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ExperimentAssignment &&
            (identical(other.experimentKey, experimentKey) ||
                other.experimentKey == experimentKey) &&
            (identical(other.variant, variant) || other.variant == variant) &&
            (identical(other.assignedAt, assignedAt) ||
                other.assignedAt == assignedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, experimentKey, variant, assignedAt);

  @override
  String toString() {
    return 'ExperimentAssignment(experimentKey: $experimentKey, variant: $variant, assignedAt: $assignedAt)';
  }
}

/// @nodoc
abstract mixin class $ExperimentAssignmentCopyWith<$Res> {
  factory $ExperimentAssignmentCopyWith(ExperimentAssignment value,
          $Res Function(ExperimentAssignment) _then) =
      _$ExperimentAssignmentCopyWithImpl;
  @useResult
  $Res call({String experimentKey, String variant, DateTime assignedAt});
}

/// @nodoc
class _$ExperimentAssignmentCopyWithImpl<$Res>
    implements $ExperimentAssignmentCopyWith<$Res> {
  _$ExperimentAssignmentCopyWithImpl(this._self, this._then);

  final ExperimentAssignment _self;
  final $Res Function(ExperimentAssignment) _then;

  /// Create a copy of ExperimentAssignment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? experimentKey = null,
    Object? variant = null,
    Object? assignedAt = null,
  }) {
    return _then(_self.copyWith(
      experimentKey: null == experimentKey
          ? _self.experimentKey
          : experimentKey // ignore: cast_nullable_to_non_nullable
              as String,
      variant: null == variant
          ? _self.variant
          : variant // ignore: cast_nullable_to_non_nullable
              as String,
      assignedAt: null == assignedAt
          ? _self.assignedAt
          : assignedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [ExperimentAssignment].
extension ExperimentAssignmentPatterns on ExperimentAssignment {
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
    TResult Function(_ExperimentAssignment value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ExperimentAssignment() when $default != null:
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
    TResult Function(_ExperimentAssignment value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExperimentAssignment():
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
    TResult? Function(_ExperimentAssignment value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExperimentAssignment() when $default != null:
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
    TResult Function(String experimentKey, String variant, DateTime assignedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ExperimentAssignment() when $default != null:
        return $default(_that.experimentKey, _that.variant, _that.assignedAt);
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
    TResult Function(String experimentKey, String variant, DateTime assignedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExperimentAssignment():
        return $default(_that.experimentKey, _that.variant, _that.assignedAt);
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
            String experimentKey, String variant, DateTime assignedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ExperimentAssignment() when $default != null:
        return $default(_that.experimentKey, _that.variant, _that.assignedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ExperimentAssignment implements ExperimentAssignment {
  const _ExperimentAssignment(
      {required this.experimentKey,
      required this.variant,
      required this.assignedAt});
  factory _ExperimentAssignment.fromJson(Map<String, dynamic> json) =>
      _$ExperimentAssignmentFromJson(json);

  @override
  final String experimentKey;
  @override
  final String variant;
  @override
  final DateTime assignedAt;

  /// Create a copy of ExperimentAssignment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ExperimentAssignmentCopyWith<_ExperimentAssignment> get copyWith =>
      __$ExperimentAssignmentCopyWithImpl<_ExperimentAssignment>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ExperimentAssignmentToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ExperimentAssignment &&
            (identical(other.experimentKey, experimentKey) ||
                other.experimentKey == experimentKey) &&
            (identical(other.variant, variant) || other.variant == variant) &&
            (identical(other.assignedAt, assignedAt) ||
                other.assignedAt == assignedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, experimentKey, variant, assignedAt);

  @override
  String toString() {
    return 'ExperimentAssignment(experimentKey: $experimentKey, variant: $variant, assignedAt: $assignedAt)';
  }
}

/// @nodoc
abstract mixin class _$ExperimentAssignmentCopyWith<$Res>
    implements $ExperimentAssignmentCopyWith<$Res> {
  factory _$ExperimentAssignmentCopyWith(_ExperimentAssignment value,
          $Res Function(_ExperimentAssignment) _then) =
      __$ExperimentAssignmentCopyWithImpl;
  @override
  @useResult
  $Res call({String experimentKey, String variant, DateTime assignedAt});
}

/// @nodoc
class __$ExperimentAssignmentCopyWithImpl<$Res>
    implements _$ExperimentAssignmentCopyWith<$Res> {
  __$ExperimentAssignmentCopyWithImpl(this._self, this._then);

  final _ExperimentAssignment _self;
  final $Res Function(_ExperimentAssignment) _then;

  /// Create a copy of ExperimentAssignment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? experimentKey = null,
    Object? variant = null,
    Object? assignedAt = null,
  }) {
    return _then(_ExperimentAssignment(
      experimentKey: null == experimentKey
          ? _self.experimentKey
          : experimentKey // ignore: cast_nullable_to_non_nullable
              as String,
      variant: null == variant
          ? _self.variant
          : variant // ignore: cast_nullable_to_non_nullable
              as String,
      assignedAt: null == assignedAt
          ? _self.assignedAt
          : assignedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
