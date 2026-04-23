// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goal_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GoalState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<GoalProgress> items) loaded,
    required TResult Function(String code, String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<GoalProgress> items)? loaded,
    TResult? Function(String code, String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<GoalProgress> items)? loaded,
    TResult Function(String code, String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GoalInitial value) initial,
    required TResult Function(GoalLoading value) loading,
    required TResult Function(GoalLoaded value) loaded,
    required TResult Function(GoalError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GoalInitial value)? initial,
    TResult? Function(GoalLoading value)? loading,
    TResult? Function(GoalLoaded value)? loaded,
    TResult? Function(GoalError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GoalInitial value)? initial,
    TResult Function(GoalLoading value)? loading,
    TResult Function(GoalLoaded value)? loaded,
    TResult Function(GoalError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GoalStateCopyWith<$Res> {
  factory $GoalStateCopyWith(GoalState value, $Res Function(GoalState) then) =
      _$GoalStateCopyWithImpl<$Res, GoalState>;
}

/// @nodoc
class _$GoalStateCopyWithImpl<$Res, $Val extends GoalState>
    implements $GoalStateCopyWith<$Res> {
  _$GoalStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GoalState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$GoalInitialImplCopyWith<$Res> {
  factory _$$GoalInitialImplCopyWith(
          _$GoalInitialImpl value, $Res Function(_$GoalInitialImpl) then) =
      __$$GoalInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$GoalInitialImplCopyWithImpl<$Res>
    extends _$GoalStateCopyWithImpl<$Res, _$GoalInitialImpl>
    implements _$$GoalInitialImplCopyWith<$Res> {
  __$$GoalInitialImplCopyWithImpl(
      _$GoalInitialImpl _value, $Res Function(_$GoalInitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of GoalState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$GoalInitialImpl implements GoalInitial {
  const _$GoalInitialImpl();

  @override
  String toString() {
    return 'GoalState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$GoalInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<GoalProgress> items) loaded,
    required TResult Function(String code, String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<GoalProgress> items)? loaded,
    TResult? Function(String code, String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<GoalProgress> items)? loaded,
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
    required TResult Function(GoalInitial value) initial,
    required TResult Function(GoalLoading value) loading,
    required TResult Function(GoalLoaded value) loaded,
    required TResult Function(GoalError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GoalInitial value)? initial,
    TResult? Function(GoalLoading value)? loading,
    TResult? Function(GoalLoaded value)? loaded,
    TResult? Function(GoalError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GoalInitial value)? initial,
    TResult Function(GoalLoading value)? loading,
    TResult Function(GoalLoaded value)? loaded,
    TResult Function(GoalError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class GoalInitial implements GoalState {
  const factory GoalInitial() = _$GoalInitialImpl;
}

/// @nodoc
abstract class _$$GoalLoadingImplCopyWith<$Res> {
  factory _$$GoalLoadingImplCopyWith(
          _$GoalLoadingImpl value, $Res Function(_$GoalLoadingImpl) then) =
      __$$GoalLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$GoalLoadingImplCopyWithImpl<$Res>
    extends _$GoalStateCopyWithImpl<$Res, _$GoalLoadingImpl>
    implements _$$GoalLoadingImplCopyWith<$Res> {
  __$$GoalLoadingImplCopyWithImpl(
      _$GoalLoadingImpl _value, $Res Function(_$GoalLoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of GoalState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$GoalLoadingImpl implements GoalLoading {
  const _$GoalLoadingImpl();

  @override
  String toString() {
    return 'GoalState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$GoalLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<GoalProgress> items) loaded,
    required TResult Function(String code, String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<GoalProgress> items)? loaded,
    TResult? Function(String code, String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<GoalProgress> items)? loaded,
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
    required TResult Function(GoalInitial value) initial,
    required TResult Function(GoalLoading value) loading,
    required TResult Function(GoalLoaded value) loaded,
    required TResult Function(GoalError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GoalInitial value)? initial,
    TResult? Function(GoalLoading value)? loading,
    TResult? Function(GoalLoaded value)? loaded,
    TResult? Function(GoalError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GoalInitial value)? initial,
    TResult Function(GoalLoading value)? loading,
    TResult Function(GoalLoaded value)? loaded,
    TResult Function(GoalError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class GoalLoading implements GoalState {
  const factory GoalLoading() = _$GoalLoadingImpl;
}

/// @nodoc
abstract class _$$GoalLoadedImplCopyWith<$Res> {
  factory _$$GoalLoadedImplCopyWith(
          _$GoalLoadedImpl value, $Res Function(_$GoalLoadedImpl) then) =
      __$$GoalLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<GoalProgress> items});
}

/// @nodoc
class __$$GoalLoadedImplCopyWithImpl<$Res>
    extends _$GoalStateCopyWithImpl<$Res, _$GoalLoadedImpl>
    implements _$$GoalLoadedImplCopyWith<$Res> {
  __$$GoalLoadedImplCopyWithImpl(
      _$GoalLoadedImpl _value, $Res Function(_$GoalLoadedImpl) _then)
      : super(_value, _then);

  /// Create a copy of GoalState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
  }) {
    return _then(_$GoalLoadedImpl(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<GoalProgress>,
    ));
  }
}

/// @nodoc

class _$GoalLoadedImpl implements GoalLoaded {
  const _$GoalLoadedImpl({required final List<GoalProgress> items})
      : _items = items;

  final List<GoalProgress> _items;
  @override
  List<GoalProgress> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'GoalState.loaded(items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoalLoadedImpl &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_items));

  /// Create a copy of GoalState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GoalLoadedImplCopyWith<_$GoalLoadedImpl> get copyWith =>
      __$$GoalLoadedImplCopyWithImpl<_$GoalLoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<GoalProgress> items) loaded,
    required TResult Function(String code, String message) error,
  }) {
    return loaded(items);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<GoalProgress> items)? loaded,
    TResult? Function(String code, String message)? error,
  }) {
    return loaded?.call(items);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<GoalProgress> items)? loaded,
    TResult Function(String code, String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(items);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GoalInitial value) initial,
    required TResult Function(GoalLoading value) loading,
    required TResult Function(GoalLoaded value) loaded,
    required TResult Function(GoalError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GoalInitial value)? initial,
    TResult? Function(GoalLoading value)? loading,
    TResult? Function(GoalLoaded value)? loaded,
    TResult? Function(GoalError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GoalInitial value)? initial,
    TResult Function(GoalLoading value)? loading,
    TResult Function(GoalLoaded value)? loaded,
    TResult Function(GoalError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class GoalLoaded implements GoalState {
  const factory GoalLoaded({required final List<GoalProgress> items}) =
      _$GoalLoadedImpl;

  List<GoalProgress> get items;

  /// Create a copy of GoalState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GoalLoadedImplCopyWith<_$GoalLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$GoalErrorImplCopyWith<$Res> {
  factory _$$GoalErrorImplCopyWith(
          _$GoalErrorImpl value, $Res Function(_$GoalErrorImpl) then) =
      __$$GoalErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String code, String message});
}

/// @nodoc
class __$$GoalErrorImplCopyWithImpl<$Res>
    extends _$GoalStateCopyWithImpl<$Res, _$GoalErrorImpl>
    implements _$$GoalErrorImplCopyWith<$Res> {
  __$$GoalErrorImplCopyWithImpl(
      _$GoalErrorImpl _value, $Res Function(_$GoalErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of GoalState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? message = null,
  }) {
    return _then(_$GoalErrorImpl(
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

class _$GoalErrorImpl implements GoalError {
  const _$GoalErrorImpl({required this.code, required this.message});

  @override
  final String code;
  @override
  final String message;

  @override
  String toString() {
    return 'GoalState.error(code: $code, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoalErrorImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, code, message);

  /// Create a copy of GoalState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GoalErrorImplCopyWith<_$GoalErrorImpl> get copyWith =>
      __$$GoalErrorImplCopyWithImpl<_$GoalErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<GoalProgress> items) loaded,
    required TResult Function(String code, String message) error,
  }) {
    return error(code, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<GoalProgress> items)? loaded,
    TResult? Function(String code, String message)? error,
  }) {
    return error?.call(code, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<GoalProgress> items)? loaded,
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
    required TResult Function(GoalInitial value) initial,
    required TResult Function(GoalLoading value) loading,
    required TResult Function(GoalLoaded value) loaded,
    required TResult Function(GoalError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GoalInitial value)? initial,
    TResult? Function(GoalLoading value)? loading,
    TResult? Function(GoalLoaded value)? loaded,
    TResult? Function(GoalError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GoalInitial value)? initial,
    TResult Function(GoalLoading value)? loading,
    TResult Function(GoalLoaded value)? loaded,
    TResult Function(GoalError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class GoalError implements GoalState {
  const factory GoalError(
      {required final String code,
      required final String message}) = _$GoalErrorImpl;

  String get code;
  String get message;

  /// Create a copy of GoalState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GoalErrorImplCopyWith<_$GoalErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
