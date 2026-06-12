// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reading_reminder.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReadingReminder {
  String get id;
  List<int> get daysOfWeek;
  String get remindAt;
  bool get isActive;
  DateTime get createdAt;

  /// Create a copy of ReadingReminder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReadingReminderCopyWith<ReadingReminder> get copyWith =>
      _$ReadingReminderCopyWithImpl<ReadingReminder>(
          this as ReadingReminder, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReadingReminder &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality()
                .equals(other.daysOfWeek, daysOfWeek) &&
            (identical(other.remindAt, remindAt) ||
                other.remindAt == remindAt) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      const DeepCollectionEquality().hash(daysOfWeek),
      remindAt,
      isActive,
      createdAt);

  @override
  String toString() {
    return 'ReadingReminder(id: $id, daysOfWeek: $daysOfWeek, remindAt: $remindAt, isActive: $isActive, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $ReadingReminderCopyWith<$Res> {
  factory $ReadingReminderCopyWith(
          ReadingReminder value, $Res Function(ReadingReminder) _then) =
      _$ReadingReminderCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      List<int> daysOfWeek,
      String remindAt,
      bool isActive,
      DateTime createdAt});
}

/// @nodoc
class _$ReadingReminderCopyWithImpl<$Res>
    implements $ReadingReminderCopyWith<$Res> {
  _$ReadingReminderCopyWithImpl(this._self, this._then);

  final ReadingReminder _self;
  final $Res Function(ReadingReminder) _then;

  /// Create a copy of ReadingReminder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? daysOfWeek = null,
    Object? remindAt = null,
    Object? isActive = null,
    Object? createdAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      daysOfWeek: null == daysOfWeek
          ? _self.daysOfWeek
          : daysOfWeek // ignore: cast_nullable_to_non_nullable
              as List<int>,
      remindAt: null == remindAt
          ? _self.remindAt
          : remindAt // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [ReadingReminder].
extension ReadingReminderPatterns on ReadingReminder {
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
    TResult Function(_ReadingReminder value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ReadingReminder() when $default != null:
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
    TResult Function(_ReadingReminder value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReadingReminder():
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
    TResult? Function(_ReadingReminder value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReadingReminder() when $default != null:
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
    TResult Function(String id, List<int> daysOfWeek, String remindAt,
            bool isActive, DateTime createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ReadingReminder() when $default != null:
        return $default(_that.id, _that.daysOfWeek, _that.remindAt,
            _that.isActive, _that.createdAt);
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
    TResult Function(String id, List<int> daysOfWeek, String remindAt,
            bool isActive, DateTime createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReadingReminder():
        return $default(_that.id, _that.daysOfWeek, _that.remindAt,
            _that.isActive, _that.createdAt);
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
    TResult? Function(String id, List<int> daysOfWeek, String remindAt,
            bool isActive, DateTime createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReadingReminder() when $default != null:
        return $default(_that.id, _that.daysOfWeek, _that.remindAt,
            _that.isActive, _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ReadingReminder implements ReadingReminder {
  const _ReadingReminder(
      {required this.id,
      required final List<int> daysOfWeek,
      required this.remindAt,
      this.isActive = true,
      required this.createdAt})
      : _daysOfWeek = daysOfWeek;

  @override
  final String id;
  final List<int> _daysOfWeek;
  @override
  List<int> get daysOfWeek {
    if (_daysOfWeek is EqualUnmodifiableListView) return _daysOfWeek;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_daysOfWeek);
  }

  @override
  final String remindAt;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final DateTime createdAt;

  /// Create a copy of ReadingReminder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ReadingReminderCopyWith<_ReadingReminder> get copyWith =>
      __$ReadingReminderCopyWithImpl<_ReadingReminder>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ReadingReminder &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality()
                .equals(other._daysOfWeek, _daysOfWeek) &&
            (identical(other.remindAt, remindAt) ||
                other.remindAt == remindAt) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      const DeepCollectionEquality().hash(_daysOfWeek),
      remindAt,
      isActive,
      createdAt);

  @override
  String toString() {
    return 'ReadingReminder(id: $id, daysOfWeek: $daysOfWeek, remindAt: $remindAt, isActive: $isActive, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$ReadingReminderCopyWith<$Res>
    implements $ReadingReminderCopyWith<$Res> {
  factory _$ReadingReminderCopyWith(
          _ReadingReminder value, $Res Function(_ReadingReminder) _then) =
      __$ReadingReminderCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      List<int> daysOfWeek,
      String remindAt,
      bool isActive,
      DateTime createdAt});
}

/// @nodoc
class __$ReadingReminderCopyWithImpl<$Res>
    implements _$ReadingReminderCopyWith<$Res> {
  __$ReadingReminderCopyWithImpl(this._self, this._then);

  final _ReadingReminder _self;
  final $Res Function(_ReadingReminder) _then;

  /// Create a copy of ReadingReminder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? daysOfWeek = null,
    Object? remindAt = null,
    Object? isActive = null,
    Object? createdAt = null,
  }) {
    return _then(_ReadingReminder(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      daysOfWeek: null == daysOfWeek
          ? _self._daysOfWeek
          : daysOfWeek // ignore: cast_nullable_to_non_nullable
              as List<int>,
      remindAt: null == remindAt
          ? _self.remindAt
          : remindAt // ignore: cast_nullable_to_non_nullable
              as String,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
