// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'grade_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GradeState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(GradeSummary summary, bool recentGradeUp) loaded,
    required TResult Function(String code, String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(GradeSummary summary, bool recentGradeUp)? loaded,
    TResult? Function(String code, String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(GradeSummary summary, bool recentGradeUp)? loaded,
    TResult Function(String code, String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GradeInitial value) initial,
    required TResult Function(GradeLoading value) loading,
    required TResult Function(GradeLoaded value) loaded,
    required TResult Function(GradeError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GradeInitial value)? initial,
    TResult? Function(GradeLoading value)? loading,
    TResult? Function(GradeLoaded value)? loaded,
    TResult? Function(GradeError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GradeInitial value)? initial,
    TResult Function(GradeLoading value)? loading,
    TResult Function(GradeLoaded value)? loaded,
    TResult Function(GradeError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GradeStateCopyWith<$Res> {
  factory $GradeStateCopyWith(
          GradeState value, $Res Function(GradeState) then) =
      _$GradeStateCopyWithImpl<$Res, GradeState>;
}

/// @nodoc
class _$GradeStateCopyWithImpl<$Res, $Val extends GradeState>
    implements $GradeStateCopyWith<$Res> {
  _$GradeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GradeState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$GradeInitialImplCopyWith<$Res> {
  factory _$$GradeInitialImplCopyWith(
          _$GradeInitialImpl value, $Res Function(_$GradeInitialImpl) then) =
      __$$GradeInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$GradeInitialImplCopyWithImpl<$Res>
    extends _$GradeStateCopyWithImpl<$Res, _$GradeInitialImpl>
    implements _$$GradeInitialImplCopyWith<$Res> {
  __$$GradeInitialImplCopyWithImpl(
      _$GradeInitialImpl _value, $Res Function(_$GradeInitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of GradeState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$GradeInitialImpl implements GradeInitial {
  const _$GradeInitialImpl();

  @override
  String toString() {
    return 'GradeState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$GradeInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(GradeSummary summary, bool recentGradeUp) loaded,
    required TResult Function(String code, String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(GradeSummary summary, bool recentGradeUp)? loaded,
    TResult? Function(String code, String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(GradeSummary summary, bool recentGradeUp)? loaded,
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
    required TResult Function(GradeInitial value) initial,
    required TResult Function(GradeLoading value) loading,
    required TResult Function(GradeLoaded value) loaded,
    required TResult Function(GradeError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GradeInitial value)? initial,
    TResult? Function(GradeLoading value)? loading,
    TResult? Function(GradeLoaded value)? loaded,
    TResult? Function(GradeError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GradeInitial value)? initial,
    TResult Function(GradeLoading value)? loading,
    TResult Function(GradeLoaded value)? loaded,
    TResult Function(GradeError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class GradeInitial implements GradeState {
  const factory GradeInitial() = _$GradeInitialImpl;
}

/// @nodoc
abstract class _$$GradeLoadingImplCopyWith<$Res> {
  factory _$$GradeLoadingImplCopyWith(
          _$GradeLoadingImpl value, $Res Function(_$GradeLoadingImpl) then) =
      __$$GradeLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$GradeLoadingImplCopyWithImpl<$Res>
    extends _$GradeStateCopyWithImpl<$Res, _$GradeLoadingImpl>
    implements _$$GradeLoadingImplCopyWith<$Res> {
  __$$GradeLoadingImplCopyWithImpl(
      _$GradeLoadingImpl _value, $Res Function(_$GradeLoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of GradeState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$GradeLoadingImpl implements GradeLoading {
  const _$GradeLoadingImpl();

  @override
  String toString() {
    return 'GradeState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$GradeLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(GradeSummary summary, bool recentGradeUp) loaded,
    required TResult Function(String code, String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(GradeSummary summary, bool recentGradeUp)? loaded,
    TResult? Function(String code, String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(GradeSummary summary, bool recentGradeUp)? loaded,
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
    required TResult Function(GradeInitial value) initial,
    required TResult Function(GradeLoading value) loading,
    required TResult Function(GradeLoaded value) loaded,
    required TResult Function(GradeError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GradeInitial value)? initial,
    TResult? Function(GradeLoading value)? loading,
    TResult? Function(GradeLoaded value)? loaded,
    TResult? Function(GradeError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GradeInitial value)? initial,
    TResult Function(GradeLoading value)? loading,
    TResult Function(GradeLoaded value)? loaded,
    TResult Function(GradeError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class GradeLoading implements GradeState {
  const factory GradeLoading() = _$GradeLoadingImpl;
}

/// @nodoc
abstract class _$$GradeLoadedImplCopyWith<$Res> {
  factory _$$GradeLoadedImplCopyWith(
          _$GradeLoadedImpl value, $Res Function(_$GradeLoadedImpl) then) =
      __$$GradeLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({GradeSummary summary, bool recentGradeUp});

  $GradeSummaryCopyWith<$Res> get summary;
}

/// @nodoc
class __$$GradeLoadedImplCopyWithImpl<$Res>
    extends _$GradeStateCopyWithImpl<$Res, _$GradeLoadedImpl>
    implements _$$GradeLoadedImplCopyWith<$Res> {
  __$$GradeLoadedImplCopyWithImpl(
      _$GradeLoadedImpl _value, $Res Function(_$GradeLoadedImpl) _then)
      : super(_value, _then);

  /// Create a copy of GradeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? summary = null,
    Object? recentGradeUp = null,
  }) {
    return _then(_$GradeLoadedImpl(
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as GradeSummary,
      recentGradeUp: null == recentGradeUp
          ? _value.recentGradeUp
          : recentGradeUp // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  /// Create a copy of GradeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GradeSummaryCopyWith<$Res> get summary {
    return $GradeSummaryCopyWith<$Res>(_value.summary, (value) {
      return _then(_value.copyWith(summary: value));
    });
  }
}

/// @nodoc

class _$GradeLoadedImpl implements GradeLoaded {
  const _$GradeLoadedImpl({required this.summary, this.recentGradeUp = false});

  @override
  final GradeSummary summary;
  @override
  @JsonKey()
  final bool recentGradeUp;

  @override
  String toString() {
    return 'GradeState.loaded(summary: $summary, recentGradeUp: $recentGradeUp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GradeLoadedImpl &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.recentGradeUp, recentGradeUp) ||
                other.recentGradeUp == recentGradeUp));
  }

  @override
  int get hashCode => Object.hash(runtimeType, summary, recentGradeUp);

  /// Create a copy of GradeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GradeLoadedImplCopyWith<_$GradeLoadedImpl> get copyWith =>
      __$$GradeLoadedImplCopyWithImpl<_$GradeLoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(GradeSummary summary, bool recentGradeUp) loaded,
    required TResult Function(String code, String message) error,
  }) {
    return loaded(summary, recentGradeUp);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(GradeSummary summary, bool recentGradeUp)? loaded,
    TResult? Function(String code, String message)? error,
  }) {
    return loaded?.call(summary, recentGradeUp);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(GradeSummary summary, bool recentGradeUp)? loaded,
    TResult Function(String code, String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(summary, recentGradeUp);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GradeInitial value) initial,
    required TResult Function(GradeLoading value) loading,
    required TResult Function(GradeLoaded value) loaded,
    required TResult Function(GradeError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GradeInitial value)? initial,
    TResult? Function(GradeLoading value)? loading,
    TResult? Function(GradeLoaded value)? loaded,
    TResult? Function(GradeError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GradeInitial value)? initial,
    TResult Function(GradeLoading value)? loading,
    TResult Function(GradeLoaded value)? loaded,
    TResult Function(GradeError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class GradeLoaded implements GradeState {
  const factory GradeLoaded(
      {required final GradeSummary summary,
      final bool recentGradeUp}) = _$GradeLoadedImpl;

  GradeSummary get summary;
  bool get recentGradeUp;

  /// Create a copy of GradeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GradeLoadedImplCopyWith<_$GradeLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$GradeErrorImplCopyWith<$Res> {
  factory _$$GradeErrorImplCopyWith(
          _$GradeErrorImpl value, $Res Function(_$GradeErrorImpl) then) =
      __$$GradeErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String code, String message});
}

/// @nodoc
class __$$GradeErrorImplCopyWithImpl<$Res>
    extends _$GradeStateCopyWithImpl<$Res, _$GradeErrorImpl>
    implements _$$GradeErrorImplCopyWith<$Res> {
  __$$GradeErrorImplCopyWithImpl(
      _$GradeErrorImpl _value, $Res Function(_$GradeErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of GradeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? message = null,
  }) {
    return _then(_$GradeErrorImpl(
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

class _$GradeErrorImpl implements GradeError {
  const _$GradeErrorImpl({required this.code, required this.message});

  @override
  final String code;
  @override
  final String message;

  @override
  String toString() {
    return 'GradeState.error(code: $code, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GradeErrorImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, code, message);

  /// Create a copy of GradeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GradeErrorImplCopyWith<_$GradeErrorImpl> get copyWith =>
      __$$GradeErrorImplCopyWithImpl<_$GradeErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(GradeSummary summary, bool recentGradeUp) loaded,
    required TResult Function(String code, String message) error,
  }) {
    return error(code, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(GradeSummary summary, bool recentGradeUp)? loaded,
    TResult? Function(String code, String message)? error,
  }) {
    return error?.call(code, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(GradeSummary summary, bool recentGradeUp)? loaded,
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
    required TResult Function(GradeInitial value) initial,
    required TResult Function(GradeLoading value) loading,
    required TResult Function(GradeLoaded value) loaded,
    required TResult Function(GradeError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GradeInitial value)? initial,
    TResult? Function(GradeLoading value)? loading,
    TResult? Function(GradeLoaded value)? loaded,
    TResult? Function(GradeError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GradeInitial value)? initial,
    TResult Function(GradeLoading value)? loading,
    TResult Function(GradeLoaded value)? loaded,
    TResult Function(GradeError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class GradeError implements GradeState {
  const factory GradeError(
      {required final String code,
      required final String message}) = _$GradeErrorImpl;

  String get code;
  String get message;

  /// Create a copy of GradeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GradeErrorImplCopyWith<_$GradeErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
