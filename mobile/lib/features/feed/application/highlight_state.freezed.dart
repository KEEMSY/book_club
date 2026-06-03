// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'highlight_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HighlightState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is HighlightState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'HighlightState()';
  }
}

/// @nodoc
class $HighlightStateCopyWith<$Res> {
  $HighlightStateCopyWith(HighlightState _, $Res Function(HighlightState) __);
}

/// Adds pattern-matching-related methods to [HighlightState].
extension HighlightStatePatterns on HighlightState {
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
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HighlightInitial value)? initial,
    TResult Function(HighlightLoading value)? loading,
    TResult Function(HighlightLoaded value)? loaded,
    TResult Function(HighlightError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case HighlightInitial() when initial != null:
        return initial(_that);
      case HighlightLoading() when loading != null:
        return loading(_that);
      case HighlightLoaded() when loaded != null:
        return loaded(_that);
      case HighlightError() when error != null:
        return error(_that);
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
  TResult map<TResult extends Object?>({
    required TResult Function(HighlightInitial value) initial,
    required TResult Function(HighlightLoading value) loading,
    required TResult Function(HighlightLoaded value) loaded,
    required TResult Function(HighlightError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case HighlightInitial():
        return initial(_that);
      case HighlightLoading():
        return loading(_that);
      case HighlightLoaded():
        return loaded(_that);
      case HighlightError():
        return error(_that);
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
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HighlightInitial value)? initial,
    TResult? Function(HighlightLoading value)? loading,
    TResult? Function(HighlightLoaded value)? loaded,
    TResult? Function(HighlightError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case HighlightInitial() when initial != null:
        return initial(_that);
      case HighlightLoading() when loading != null:
        return loading(_that);
      case HighlightLoaded() when loaded != null:
        return loaded(_that);
      case HighlightError() when error != null:
        return error(_that);
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
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Highlight> items, String? nextCursor)? loaded,
    TResult Function(String code, String message)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case HighlightInitial() when initial != null:
        return initial();
      case HighlightLoading() when loading != null:
        return loading();
      case HighlightLoaded() when loaded != null:
        return loaded(_that.items, _that.nextCursor);
      case HighlightError() when error != null:
        return error(_that.code, _that.message);
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
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Highlight> items, String? nextCursor) loaded,
    required TResult Function(String code, String message) error,
  }) {
    final _that = this;
    switch (_that) {
      case HighlightInitial():
        return initial();
      case HighlightLoading():
        return loading();
      case HighlightLoaded():
        return loaded(_that.items, _that.nextCursor);
      case HighlightError():
        return error(_that.code, _that.message);
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
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Highlight> items, String? nextCursor)? loaded,
    TResult? Function(String code, String message)? error,
  }) {
    final _that = this;
    switch (_that) {
      case HighlightInitial() when initial != null:
        return initial();
      case HighlightLoading() when loading != null:
        return loading();
      case HighlightLoaded() when loaded != null:
        return loaded(_that.items, _that.nextCursor);
      case HighlightError() when error != null:
        return error(_that.code, _that.message);
      case _:
        return null;
    }
  }
}

/// @nodoc

class HighlightInitial implements HighlightState {
  const HighlightInitial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is HighlightInitial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'HighlightState.initial()';
  }
}

/// @nodoc

class HighlightLoading implements HighlightState {
  const HighlightLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is HighlightLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'HighlightState.loading()';
  }
}

/// @nodoc

class HighlightLoaded implements HighlightState {
  const HighlightLoaded({required final List<Highlight> items, this.nextCursor})
      : _items = items;

  final List<Highlight> _items;
  List<Highlight> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  final String? nextCursor;

  /// Create a copy of HighlightState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HighlightLoadedCopyWith<HighlightLoaded> get copyWith =>
      _$HighlightLoadedCopyWithImpl<HighlightLoaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HighlightLoaded &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_items), nextCursor);

  @override
  String toString() {
    return 'HighlightState.loaded(items: $items, nextCursor: $nextCursor)';
  }
}

/// @nodoc
abstract mixin class $HighlightLoadedCopyWith<$Res>
    implements $HighlightStateCopyWith<$Res> {
  factory $HighlightLoadedCopyWith(
          HighlightLoaded value, $Res Function(HighlightLoaded) _then) =
      _$HighlightLoadedCopyWithImpl;
  @useResult
  $Res call({List<Highlight> items, String? nextCursor});
}

/// @nodoc
class _$HighlightLoadedCopyWithImpl<$Res>
    implements $HighlightLoadedCopyWith<$Res> {
  _$HighlightLoadedCopyWithImpl(this._self, this._then);

  final HighlightLoaded _self;
  final $Res Function(HighlightLoaded) _then;

  /// Create a copy of HighlightState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? items = null,
    Object? nextCursor = freezed,
  }) {
    return _then(HighlightLoaded(
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Highlight>,
      nextCursor: freezed == nextCursor
          ? _self.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class HighlightError implements HighlightState {
  const HighlightError({required this.code, required this.message});

  final String code;
  final String message;

  /// Create a copy of HighlightState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HighlightErrorCopyWith<HighlightError> get copyWith =>
      _$HighlightErrorCopyWithImpl<HighlightError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HighlightError &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, code, message);

  @override
  String toString() {
    return 'HighlightState.error(code: $code, message: $message)';
  }
}

/// @nodoc
abstract mixin class $HighlightErrorCopyWith<$Res>
    implements $HighlightStateCopyWith<$Res> {
  factory $HighlightErrorCopyWith(
          HighlightError value, $Res Function(HighlightError) _then) =
      _$HighlightErrorCopyWithImpl;
  @useResult
  $Res call({String code, String message});
}

/// @nodoc
class _$HighlightErrorCopyWithImpl<$Res>
    implements $HighlightErrorCopyWith<$Res> {
  _$HighlightErrorCopyWithImpl(this._self, this._then);

  final HighlightError _self;
  final $Res Function(HighlightError) _then;

  /// Create a copy of HighlightState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? code = null,
    Object? message = null,
  }) {
    return _then(HighlightError(
      code: null == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
