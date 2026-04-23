// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'heatmap_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HeatmapState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<HeatmapDay> days, DateTime from, DateTime to)
        loaded,
    required TResult Function(String code, String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<HeatmapDay> days, DateTime from, DateTime to)?
        loaded,
    TResult? Function(String code, String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<HeatmapDay> days, DateTime from, DateTime to)? loaded,
    TResult Function(String code, String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HeatmapInitial value) initial,
    required TResult Function(HeatmapLoading value) loading,
    required TResult Function(HeatmapLoaded value) loaded,
    required TResult Function(HeatmapError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HeatmapInitial value)? initial,
    TResult? Function(HeatmapLoading value)? loading,
    TResult? Function(HeatmapLoaded value)? loaded,
    TResult? Function(HeatmapError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HeatmapInitial value)? initial,
    TResult Function(HeatmapLoading value)? loading,
    TResult Function(HeatmapLoaded value)? loaded,
    TResult Function(HeatmapError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HeatmapStateCopyWith<$Res> {
  factory $HeatmapStateCopyWith(
          HeatmapState value, $Res Function(HeatmapState) then) =
      _$HeatmapStateCopyWithImpl<$Res, HeatmapState>;
}

/// @nodoc
class _$HeatmapStateCopyWithImpl<$Res, $Val extends HeatmapState>
    implements $HeatmapStateCopyWith<$Res> {
  _$HeatmapStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HeatmapState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$HeatmapInitialImplCopyWith<$Res> {
  factory _$$HeatmapInitialImplCopyWith(_$HeatmapInitialImpl value,
          $Res Function(_$HeatmapInitialImpl) then) =
      __$$HeatmapInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$HeatmapInitialImplCopyWithImpl<$Res>
    extends _$HeatmapStateCopyWithImpl<$Res, _$HeatmapInitialImpl>
    implements _$$HeatmapInitialImplCopyWith<$Res> {
  __$$HeatmapInitialImplCopyWithImpl(
      _$HeatmapInitialImpl _value, $Res Function(_$HeatmapInitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of HeatmapState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$HeatmapInitialImpl implements HeatmapInitial {
  const _$HeatmapInitialImpl();

  @override
  String toString() {
    return 'HeatmapState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$HeatmapInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<HeatmapDay> days, DateTime from, DateTime to)
        loaded,
    required TResult Function(String code, String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<HeatmapDay> days, DateTime from, DateTime to)?
        loaded,
    TResult? Function(String code, String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<HeatmapDay> days, DateTime from, DateTime to)? loaded,
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
    required TResult Function(HeatmapInitial value) initial,
    required TResult Function(HeatmapLoading value) loading,
    required TResult Function(HeatmapLoaded value) loaded,
    required TResult Function(HeatmapError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HeatmapInitial value)? initial,
    TResult? Function(HeatmapLoading value)? loading,
    TResult? Function(HeatmapLoaded value)? loaded,
    TResult? Function(HeatmapError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HeatmapInitial value)? initial,
    TResult Function(HeatmapLoading value)? loading,
    TResult Function(HeatmapLoaded value)? loaded,
    TResult Function(HeatmapError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class HeatmapInitial implements HeatmapState {
  const factory HeatmapInitial() = _$HeatmapInitialImpl;
}

/// @nodoc
abstract class _$$HeatmapLoadingImplCopyWith<$Res> {
  factory _$$HeatmapLoadingImplCopyWith(_$HeatmapLoadingImpl value,
          $Res Function(_$HeatmapLoadingImpl) then) =
      __$$HeatmapLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$HeatmapLoadingImplCopyWithImpl<$Res>
    extends _$HeatmapStateCopyWithImpl<$Res, _$HeatmapLoadingImpl>
    implements _$$HeatmapLoadingImplCopyWith<$Res> {
  __$$HeatmapLoadingImplCopyWithImpl(
      _$HeatmapLoadingImpl _value, $Res Function(_$HeatmapLoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of HeatmapState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$HeatmapLoadingImpl implements HeatmapLoading {
  const _$HeatmapLoadingImpl();

  @override
  String toString() {
    return 'HeatmapState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$HeatmapLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<HeatmapDay> days, DateTime from, DateTime to)
        loaded,
    required TResult Function(String code, String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<HeatmapDay> days, DateTime from, DateTime to)?
        loaded,
    TResult? Function(String code, String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<HeatmapDay> days, DateTime from, DateTime to)? loaded,
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
    required TResult Function(HeatmapInitial value) initial,
    required TResult Function(HeatmapLoading value) loading,
    required TResult Function(HeatmapLoaded value) loaded,
    required TResult Function(HeatmapError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HeatmapInitial value)? initial,
    TResult? Function(HeatmapLoading value)? loading,
    TResult? Function(HeatmapLoaded value)? loaded,
    TResult? Function(HeatmapError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HeatmapInitial value)? initial,
    TResult Function(HeatmapLoading value)? loading,
    TResult Function(HeatmapLoaded value)? loaded,
    TResult Function(HeatmapError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class HeatmapLoading implements HeatmapState {
  const factory HeatmapLoading() = _$HeatmapLoadingImpl;
}

/// @nodoc
abstract class _$$HeatmapLoadedImplCopyWith<$Res> {
  factory _$$HeatmapLoadedImplCopyWith(
          _$HeatmapLoadedImpl value, $Res Function(_$HeatmapLoadedImpl) then) =
      __$$HeatmapLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<HeatmapDay> days, DateTime from, DateTime to});
}

/// @nodoc
class __$$HeatmapLoadedImplCopyWithImpl<$Res>
    extends _$HeatmapStateCopyWithImpl<$Res, _$HeatmapLoadedImpl>
    implements _$$HeatmapLoadedImplCopyWith<$Res> {
  __$$HeatmapLoadedImplCopyWithImpl(
      _$HeatmapLoadedImpl _value, $Res Function(_$HeatmapLoadedImpl) _then)
      : super(_value, _then);

  /// Create a copy of HeatmapState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? days = null,
    Object? from = null,
    Object? to = null,
  }) {
    return _then(_$HeatmapLoadedImpl(
      days: null == days
          ? _value._days
          : days // ignore: cast_nullable_to_non_nullable
              as List<HeatmapDay>,
      from: null == from
          ? _value.from
          : from // ignore: cast_nullable_to_non_nullable
              as DateTime,
      to: null == to
          ? _value.to
          : to // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$HeatmapLoadedImpl implements HeatmapLoaded {
  const _$HeatmapLoadedImpl(
      {required final List<HeatmapDay> days,
      required this.from,
      required this.to})
      : _days = days;

  final List<HeatmapDay> _days;
  @override
  List<HeatmapDay> get days {
    if (_days is EqualUnmodifiableListView) return _days;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_days);
  }

  @override
  final DateTime from;
  @override
  final DateTime to;

  @override
  String toString() {
    return 'HeatmapState.loaded(days: $days, from: $from, to: $to)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HeatmapLoadedImpl &&
            const DeepCollectionEquality().equals(other._days, _days) &&
            (identical(other.from, from) || other.from == from) &&
            (identical(other.to, to) || other.to == to));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_days), from, to);

  /// Create a copy of HeatmapState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HeatmapLoadedImplCopyWith<_$HeatmapLoadedImpl> get copyWith =>
      __$$HeatmapLoadedImplCopyWithImpl<_$HeatmapLoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<HeatmapDay> days, DateTime from, DateTime to)
        loaded,
    required TResult Function(String code, String message) error,
  }) {
    return loaded(days, from, to);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<HeatmapDay> days, DateTime from, DateTime to)?
        loaded,
    TResult? Function(String code, String message)? error,
  }) {
    return loaded?.call(days, from, to);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<HeatmapDay> days, DateTime from, DateTime to)? loaded,
    TResult Function(String code, String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(days, from, to);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(HeatmapInitial value) initial,
    required TResult Function(HeatmapLoading value) loading,
    required TResult Function(HeatmapLoaded value) loaded,
    required TResult Function(HeatmapError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HeatmapInitial value)? initial,
    TResult? Function(HeatmapLoading value)? loading,
    TResult? Function(HeatmapLoaded value)? loaded,
    TResult? Function(HeatmapError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HeatmapInitial value)? initial,
    TResult Function(HeatmapLoading value)? loading,
    TResult Function(HeatmapLoaded value)? loaded,
    TResult Function(HeatmapError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class HeatmapLoaded implements HeatmapState {
  const factory HeatmapLoaded(
      {required final List<HeatmapDay> days,
      required final DateTime from,
      required final DateTime to}) = _$HeatmapLoadedImpl;

  List<HeatmapDay> get days;
  DateTime get from;
  DateTime get to;

  /// Create a copy of HeatmapState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HeatmapLoadedImplCopyWith<_$HeatmapLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$HeatmapErrorImplCopyWith<$Res> {
  factory _$$HeatmapErrorImplCopyWith(
          _$HeatmapErrorImpl value, $Res Function(_$HeatmapErrorImpl) then) =
      __$$HeatmapErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String code, String message});
}

/// @nodoc
class __$$HeatmapErrorImplCopyWithImpl<$Res>
    extends _$HeatmapStateCopyWithImpl<$Res, _$HeatmapErrorImpl>
    implements _$$HeatmapErrorImplCopyWith<$Res> {
  __$$HeatmapErrorImplCopyWithImpl(
      _$HeatmapErrorImpl _value, $Res Function(_$HeatmapErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of HeatmapState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? message = null,
  }) {
    return _then(_$HeatmapErrorImpl(
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

class _$HeatmapErrorImpl implements HeatmapError {
  const _$HeatmapErrorImpl({required this.code, required this.message});

  @override
  final String code;
  @override
  final String message;

  @override
  String toString() {
    return 'HeatmapState.error(code: $code, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HeatmapErrorImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, code, message);

  /// Create a copy of HeatmapState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HeatmapErrorImplCopyWith<_$HeatmapErrorImpl> get copyWith =>
      __$$HeatmapErrorImplCopyWithImpl<_$HeatmapErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<HeatmapDay> days, DateTime from, DateTime to)
        loaded,
    required TResult Function(String code, String message) error,
  }) {
    return error(code, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<HeatmapDay> days, DateTime from, DateTime to)?
        loaded,
    TResult? Function(String code, String message)? error,
  }) {
    return error?.call(code, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<HeatmapDay> days, DateTime from, DateTime to)? loaded,
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
    required TResult Function(HeatmapInitial value) initial,
    required TResult Function(HeatmapLoading value) loading,
    required TResult Function(HeatmapLoaded value) loaded,
    required TResult Function(HeatmapError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(HeatmapInitial value)? initial,
    TResult? Function(HeatmapLoading value)? loading,
    TResult? Function(HeatmapLoaded value)? loaded,
    TResult? Function(HeatmapError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(HeatmapInitial value)? initial,
    TResult Function(HeatmapLoading value)? loading,
    TResult Function(HeatmapLoaded value)? loaded,
    TResult Function(HeatmapError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class HeatmapError implements HeatmapState {
  const factory HeatmapError(
      {required final String code,
      required final String message}) = _$HeatmapErrorImpl;

  String get code;
  String get message;

  /// Create a copy of HeatmapState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HeatmapErrorImplCopyWith<_$HeatmapErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
