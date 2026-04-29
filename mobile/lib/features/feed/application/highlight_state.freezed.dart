// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'highlight_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HighlightState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Highlight> items, String? nextCursor) loaded,
    required TResult Function(String code, String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Highlight> items, String? nextCursor)? loaded,
    TResult? Function(String code, String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Highlight> items, String? nextCursor)? loaded,
    TResult Function(String code, String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HighlightInitial value) initial,
    required TResult Function(HighlightLoading value) loading,
    required TResult Function(HighlightLoaded value) loaded,
    required TResult Function(HighlightError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HighlightInitial value)? initial,
    TResult? Function(HighlightLoading value)? loading,
    TResult? Function(HighlightLoaded value)? loaded,
    TResult? Function(HighlightError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HighlightInitial value)? initial,
    TResult Function(HighlightLoading value)? loading,
    TResult Function(HighlightLoaded value)? loaded,
    TResult Function(HighlightError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HighlightStateCopyWith<$Res> {
  factory $HighlightStateCopyWith(
          HighlightState value, $Res Function(HighlightState) then) =
      _$HighlightStateCopyWithImpl<$Res, HighlightState>;
}

/// @nodoc
class _$HighlightStateCopyWithImpl<$Res, $Val extends HighlightState>
    implements $HighlightStateCopyWith<$Res> {
  _$HighlightStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HighlightState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$HighlightInitialImplCopyWith<$Res> {
  factory _$$HighlightInitialImplCopyWith(_$HighlightInitialImpl value,
          $Res Function(_$HighlightInitialImpl) then) =
      __$$HighlightInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$HighlightInitialImplCopyWithImpl<$Res>
    extends _$HighlightStateCopyWithImpl<$Res, _$HighlightInitialImpl>
    implements _$$HighlightInitialImplCopyWith<$Res> {
  __$$HighlightInitialImplCopyWithImpl(_$HighlightInitialImpl _value,
      $Res Function(_$HighlightInitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of HighlightState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$HighlightInitialImpl implements HighlightInitial {
  const _$HighlightInitialImpl();

  @override
  String toString() {
    return 'HighlightState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$HighlightInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Highlight> items, String? nextCursor) loaded,
    required TResult Function(String code, String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Highlight> items, String? nextCursor)? loaded,
    TResult? Function(String code, String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Highlight> items, String? nextCursor)? loaded,
    TResult Function(String code, String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HighlightInitial value) initial,
    required TResult Function(HighlightLoading value) loading,
    required TResult Function(HighlightLoaded value) loaded,
    required TResult Function(HighlightError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HighlightInitial value)? initial,
    TResult? Function(HighlightLoading value)? loading,
    TResult? Function(HighlightLoaded value)? loaded,
    TResult? Function(HighlightError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HighlightInitial value)? initial,
    TResult Function(HighlightLoading value)? loading,
    TResult Function(HighlightLoaded value)? loaded,
    TResult Function(HighlightError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class HighlightInitial implements HighlightState {
  const factory HighlightInitial() = _$HighlightInitialImpl;
}

/// @nodoc
abstract class _$$HighlightLoadingImplCopyWith<$Res> {
  factory _$$HighlightLoadingImplCopyWith(_$HighlightLoadingImpl value,
          $Res Function(_$HighlightLoadingImpl) then) =
      __$$HighlightLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$HighlightLoadingImplCopyWithImpl<$Res>
    extends _$HighlightStateCopyWithImpl<$Res, _$HighlightLoadingImpl>
    implements _$$HighlightLoadingImplCopyWith<$Res> {
  __$$HighlightLoadingImplCopyWithImpl(_$HighlightLoadingImpl _value,
      $Res Function(_$HighlightLoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of HighlightState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$HighlightLoadingImpl implements HighlightLoading {
  const _$HighlightLoadingImpl();

  @override
  String toString() {
    return 'HighlightState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$HighlightLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Highlight> items, String? nextCursor) loaded,
    required TResult Function(String code, String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Highlight> items, String? nextCursor)? loaded,
    TResult? Function(String code, String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Highlight> items, String? nextCursor)? loaded,
    TResult Function(String code, String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HighlightInitial value) initial,
    required TResult Function(HighlightLoading value) loading,
    required TResult Function(HighlightLoaded value) loaded,
    required TResult Function(HighlightError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HighlightInitial value)? initial,
    TResult? Function(HighlightLoading value)? loading,
    TResult? Function(HighlightLoaded value)? loaded,
    TResult? Function(HighlightError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HighlightInitial value)? initial,
    TResult Function(HighlightLoading value)? loading,
    TResult Function(HighlightLoaded value)? loaded,
    TResult Function(HighlightError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class HighlightLoading implements HighlightState {
  const factory HighlightLoading() = _$HighlightLoadingImpl;
}

/// @nodoc
abstract class _$$HighlightLoadedImplCopyWith<$Res> {
  factory _$$HighlightLoadedImplCopyWith(_$HighlightLoadedImpl value,
          $Res Function(_$HighlightLoadedImpl) then) =
      __$$HighlightLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<Highlight> items, String? nextCursor});
}

/// @nodoc
class __$$HighlightLoadedImplCopyWithImpl<$Res>
    extends _$HighlightStateCopyWithImpl<$Res, _$HighlightLoadedImpl>
    implements _$$HighlightLoadedImplCopyWith<$Res> {
  __$$HighlightLoadedImplCopyWithImpl(
      _$HighlightLoadedImpl _value, $Res Function(_$HighlightLoadedImpl) _then)
      : super(_value, _then);

  /// Create a copy of HighlightState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? nextCursor = freezed,
  }) {
    return _then(_$HighlightLoadedImpl(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Highlight>,
      nextCursor: freezed == nextCursor
          ? _value.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$HighlightLoadedImpl implements HighlightLoaded {
  const _$HighlightLoadedImpl(
      {required final List<Highlight> items, this.nextCursor})
      : _items = items;

  final List<Highlight> _items;
  @override
  List<Highlight> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final String? nextCursor;

  @override
  String toString() {
    return 'HighlightState.loaded(items: $items, nextCursor: $nextCursor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HighlightLoadedImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_items), nextCursor);

  /// Create a copy of HighlightState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HighlightLoadedImplCopyWith<_$HighlightLoadedImpl> get copyWith =>
      __$$HighlightLoadedImplCopyWithImpl<_$HighlightLoadedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Highlight> items, String? nextCursor) loaded,
    required TResult Function(String code, String message) error,
  }) {
    return loaded(items, nextCursor);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Highlight> items, String? nextCursor)? loaded,
    TResult? Function(String code, String message)? error,
  }) {
    return loaded?.call(items, nextCursor);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Highlight> items, String? nextCursor)? loaded,
    TResult Function(String code, String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(items, nextCursor);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HighlightInitial value) initial,
    required TResult Function(HighlightLoading value) loading,
    required TResult Function(HighlightLoaded value) loaded,
    required TResult Function(HighlightError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HighlightInitial value)? initial,
    TResult? Function(HighlightLoading value)? loading,
    TResult? Function(HighlightLoaded value)? loaded,
    TResult? Function(HighlightError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HighlightInitial value)? initial,
    TResult Function(HighlightLoading value)? loading,
    TResult Function(HighlightLoaded value)? loaded,
    TResult Function(HighlightError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class HighlightLoaded implements HighlightState {
  const factory HighlightLoaded(
      {required final List<Highlight> items,
      final String? nextCursor}) = _$HighlightLoadedImpl;

  List<Highlight> get items;
  String? get nextCursor;

  /// Create a copy of HighlightState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HighlightLoadedImplCopyWith<_$HighlightLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$HighlightErrorImplCopyWith<$Res> {
  factory _$$HighlightErrorImplCopyWith(_$HighlightErrorImpl value,
          $Res Function(_$HighlightErrorImpl) then) =
      __$$HighlightErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String code, String message});
}

/// @nodoc
class __$$HighlightErrorImplCopyWithImpl<$Res>
    extends _$HighlightStateCopyWithImpl<$Res, _$HighlightErrorImpl>
    implements _$$HighlightErrorImplCopyWith<$Res> {
  __$$HighlightErrorImplCopyWithImpl(
      _$HighlightErrorImpl _value, $Res Function(_$HighlightErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of HighlightState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? message = null,
  }) {
    return _then(_$HighlightErrorImpl(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$HighlightErrorImpl implements HighlightError {
  const _$HighlightErrorImpl({required this.code, required this.message});

  @override
  final String code;
  @override
  final String message;

  @override
  String toString() {
    return 'HighlightState.error(code: $code, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HighlightErrorImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, code, message);

  /// Create a copy of HighlightState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HighlightErrorImplCopyWith<_$HighlightErrorImpl> get copyWith =>
      __$$HighlightErrorImplCopyWithImpl<_$HighlightErrorImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Highlight> items, String? nextCursor) loaded,
    required TResult Function(String code, String message) error,
  }) {
    return error(code, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Highlight> items, String? nextCursor)? loaded,
    TResult? Function(String code, String message)? error,
  }) {
    return error?.call(code, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Highlight> items, String? nextCursor)? loaded,
    TResult Function(String code, String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(code, message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HighlightInitial value) initial,
    required TResult Function(HighlightLoading value) loading,
    required TResult Function(HighlightLoaded value) loaded,
    required TResult Function(HighlightError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HighlightInitial value)? initial,
    TResult? Function(HighlightLoading value)? loading,
    TResult? Function(HighlightLoaded value)? loaded,
    TResult? Function(HighlightError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HighlightInitial value)? initial,
    TResult Function(HighlightLoading value)? loading,
    TResult Function(HighlightLoaded value)? loaded,
    TResult Function(HighlightError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class HighlightError implements HighlightState {
  const factory HighlightError(
      {required final String code,
      required final String message}) = _$HighlightErrorImpl;

  String get code;
  String get message;

  /// Create a copy of HighlightState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HighlightErrorImplCopyWith<_$HighlightErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
