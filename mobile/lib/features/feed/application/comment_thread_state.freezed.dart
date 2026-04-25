// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comment_thread_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CommentThreadState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Comment> items, String? nextCursor,
            bool isLoadingMore, bool isPosting, String? postError)
        loaded,
    required TResult Function(String code, String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Comment> items, String? nextCursor,
            bool isLoadingMore, bool isPosting, String? postError)?
        loaded,
    TResult? Function(String code, String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Comment> items, String? nextCursor,
            bool isLoadingMore, bool isPosting, String? postError)?
        loaded,
    TResult Function(String code, String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CommentThreadInitial value) initial,
    required TResult Function(CommentThreadLoading value) loading,
    required TResult Function(CommentThreadLoaded value) loaded,
    required TResult Function(CommentThreadError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CommentThreadInitial value)? initial,
    TResult? Function(CommentThreadLoading value)? loading,
    TResult? Function(CommentThreadLoaded value)? loaded,
    TResult? Function(CommentThreadError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CommentThreadInitial value)? initial,
    TResult Function(CommentThreadLoading value)? loading,
    TResult Function(CommentThreadLoaded value)? loaded,
    TResult Function(CommentThreadError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentThreadStateCopyWith<$Res> {
  factory $CommentThreadStateCopyWith(
          CommentThreadState value, $Res Function(CommentThreadState) then) =
      _$CommentThreadStateCopyWithImpl<$Res, CommentThreadState>;
}

/// @nodoc
class _$CommentThreadStateCopyWithImpl<$Res, $Val extends CommentThreadState>
    implements $CommentThreadStateCopyWith<$Res> {
  _$CommentThreadStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CommentThreadState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$CommentThreadInitialImplCopyWith<$Res> {
  factory _$$CommentThreadInitialImplCopyWith(_$CommentThreadInitialImpl value,
          $Res Function(_$CommentThreadInitialImpl) then) =
      __$$CommentThreadInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CommentThreadInitialImplCopyWithImpl<$Res>
    extends _$CommentThreadStateCopyWithImpl<$Res, _$CommentThreadInitialImpl>
    implements _$$CommentThreadInitialImplCopyWith<$Res> {
  __$$CommentThreadInitialImplCopyWithImpl(_$CommentThreadInitialImpl _value,
      $Res Function(_$CommentThreadInitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of CommentThreadState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$CommentThreadInitialImpl implements CommentThreadInitial {
  const _$CommentThreadInitialImpl();

  @override
  String toString() {
    return 'CommentThreadState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommentThreadInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Comment> items, String? nextCursor,
            bool isLoadingMore, bool isPosting, String? postError)
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
    TResult? Function(List<Comment> items, String? nextCursor,
            bool isLoadingMore, bool isPosting, String? postError)?
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
    TResult Function(List<Comment> items, String? nextCursor,
            bool isLoadingMore, bool isPosting, String? postError)?
        loaded,
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
    required TResult Function(CommentThreadInitial value) initial,
    required TResult Function(CommentThreadLoading value) loading,
    required TResult Function(CommentThreadLoaded value) loaded,
    required TResult Function(CommentThreadError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CommentThreadInitial value)? initial,
    TResult? Function(CommentThreadLoading value)? loading,
    TResult? Function(CommentThreadLoaded value)? loaded,
    TResult? Function(CommentThreadError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CommentThreadInitial value)? initial,
    TResult Function(CommentThreadLoading value)? loading,
    TResult Function(CommentThreadLoaded value)? loaded,
    TResult Function(CommentThreadError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class CommentThreadInitial implements CommentThreadState {
  const factory CommentThreadInitial() = _$CommentThreadInitialImpl;
}

/// @nodoc
abstract class _$$CommentThreadLoadingImplCopyWith<$Res> {
  factory _$$CommentThreadLoadingImplCopyWith(_$CommentThreadLoadingImpl value,
          $Res Function(_$CommentThreadLoadingImpl) then) =
      __$$CommentThreadLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CommentThreadLoadingImplCopyWithImpl<$Res>
    extends _$CommentThreadStateCopyWithImpl<$Res, _$CommentThreadLoadingImpl>
    implements _$$CommentThreadLoadingImplCopyWith<$Res> {
  __$$CommentThreadLoadingImplCopyWithImpl(_$CommentThreadLoadingImpl _value,
      $Res Function(_$CommentThreadLoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of CommentThreadState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$CommentThreadLoadingImpl implements CommentThreadLoading {
  const _$CommentThreadLoadingImpl();

  @override
  String toString() {
    return 'CommentThreadState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommentThreadLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Comment> items, String? nextCursor,
            bool isLoadingMore, bool isPosting, String? postError)
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
    TResult? Function(List<Comment> items, String? nextCursor,
            bool isLoadingMore, bool isPosting, String? postError)?
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
    TResult Function(List<Comment> items, String? nextCursor,
            bool isLoadingMore, bool isPosting, String? postError)?
        loaded,
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
    required TResult Function(CommentThreadInitial value) initial,
    required TResult Function(CommentThreadLoading value) loading,
    required TResult Function(CommentThreadLoaded value) loaded,
    required TResult Function(CommentThreadError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CommentThreadInitial value)? initial,
    TResult? Function(CommentThreadLoading value)? loading,
    TResult? Function(CommentThreadLoaded value)? loaded,
    TResult? Function(CommentThreadError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CommentThreadInitial value)? initial,
    TResult Function(CommentThreadLoading value)? loading,
    TResult Function(CommentThreadLoaded value)? loaded,
    TResult Function(CommentThreadError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class CommentThreadLoading implements CommentThreadState {
  const factory CommentThreadLoading() = _$CommentThreadLoadingImpl;
}

/// @nodoc
abstract class _$$CommentThreadLoadedImplCopyWith<$Res> {
  factory _$$CommentThreadLoadedImplCopyWith(_$CommentThreadLoadedImpl value,
          $Res Function(_$CommentThreadLoadedImpl) then) =
      __$$CommentThreadLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {List<Comment> items,
      String? nextCursor,
      bool isLoadingMore,
      bool isPosting,
      String? postError});
}

/// @nodoc
class __$$CommentThreadLoadedImplCopyWithImpl<$Res>
    extends _$CommentThreadStateCopyWithImpl<$Res, _$CommentThreadLoadedImpl>
    implements _$$CommentThreadLoadedImplCopyWith<$Res> {
  __$$CommentThreadLoadedImplCopyWithImpl(_$CommentThreadLoadedImpl _value,
      $Res Function(_$CommentThreadLoadedImpl) _then)
      : super(_value, _then);

  /// Create a copy of CommentThreadState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? nextCursor = freezed,
    Object? isLoadingMore = null,
    Object? isPosting = null,
    Object? postError = freezed,
  }) {
    return _then(_$CommentThreadLoadedImpl(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Comment>,
      nextCursor: freezed == nextCursor
          ? _value.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
      isLoadingMore: null == isLoadingMore
          ? _value.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
      isPosting: null == isPosting
          ? _value.isPosting
          : isPosting // ignore: cast_nullable_to_non_nullable
              as bool,
      postError: freezed == postError
          ? _value.postError
          : postError // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$CommentThreadLoadedImpl implements CommentThreadLoaded {
  const _$CommentThreadLoadedImpl(
      {required final List<Comment> items,
      this.nextCursor,
      this.isLoadingMore = false,
      this.isPosting = false,
      this.postError})
      : _items = items;

  final List<Comment> _items;
  @override
  List<Comment> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final String? nextCursor;
  @override
  @JsonKey()
  final bool isLoadingMore;
  @override
  @JsonKey()
  final bool isPosting;
  @override
  final String? postError;

  @override
  String toString() {
    return 'CommentThreadState.loaded(items: $items, nextCursor: $nextCursor, isLoadingMore: $isLoadingMore, isPosting: $isPosting, postError: $postError)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommentThreadLoadedImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor) &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore) &&
            (identical(other.isPosting, isPosting) ||
                other.isPosting == isPosting) &&
            (identical(other.postError, postError) ||
                other.postError == postError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_items),
      nextCursor,
      isLoadingMore,
      isPosting,
      postError);

  /// Create a copy of CommentThreadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommentThreadLoadedImplCopyWith<_$CommentThreadLoadedImpl> get copyWith =>
      __$$CommentThreadLoadedImplCopyWithImpl<_$CommentThreadLoadedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Comment> items, String? nextCursor,
            bool isLoadingMore, bool isPosting, String? postError)
        loaded,
    required TResult Function(String code, String message) error,
  }) {
    return loaded(items, nextCursor, isLoadingMore, isPosting, postError);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Comment> items, String? nextCursor,
            bool isLoadingMore, bool isPosting, String? postError)?
        loaded,
    TResult? Function(String code, String message)? error,
  }) {
    return loaded?.call(items, nextCursor, isLoadingMore, isPosting, postError);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Comment> items, String? nextCursor,
            bool isLoadingMore, bool isPosting, String? postError)?
        loaded,
    TResult Function(String code, String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(items, nextCursor, isLoadingMore, isPosting, postError);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CommentThreadInitial value) initial,
    required TResult Function(CommentThreadLoading value) loading,
    required TResult Function(CommentThreadLoaded value) loaded,
    required TResult Function(CommentThreadError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CommentThreadInitial value)? initial,
    TResult? Function(CommentThreadLoading value)? loading,
    TResult? Function(CommentThreadLoaded value)? loaded,
    TResult? Function(CommentThreadError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CommentThreadInitial value)? initial,
    TResult Function(CommentThreadLoading value)? loading,
    TResult Function(CommentThreadLoaded value)? loaded,
    TResult Function(CommentThreadError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class CommentThreadLoaded implements CommentThreadState {
  const factory CommentThreadLoaded(
      {required final List<Comment> items,
      final String? nextCursor,
      final bool isLoadingMore,
      final bool isPosting,
      final String? postError}) = _$CommentThreadLoadedImpl;

  List<Comment> get items;
  String? get nextCursor;
  bool get isLoadingMore;
  bool get isPosting;
  String? get postError;

  /// Create a copy of CommentThreadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommentThreadLoadedImplCopyWith<_$CommentThreadLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CommentThreadErrorImplCopyWith<$Res> {
  factory _$$CommentThreadErrorImplCopyWith(_$CommentThreadErrorImpl value,
          $Res Function(_$CommentThreadErrorImpl) then) =
      __$$CommentThreadErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String code, String message});
}

/// @nodoc
class __$$CommentThreadErrorImplCopyWithImpl<$Res>
    extends _$CommentThreadStateCopyWithImpl<$Res, _$CommentThreadErrorImpl>
    implements _$$CommentThreadErrorImplCopyWith<$Res> {
  __$$CommentThreadErrorImplCopyWithImpl(_$CommentThreadErrorImpl _value,
      $Res Function(_$CommentThreadErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of CommentThreadState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? message = null,
  }) {
    return _then(_$CommentThreadErrorImpl(
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

class _$CommentThreadErrorImpl implements CommentThreadError {
  const _$CommentThreadErrorImpl({required this.code, required this.message});

  @override
  final String code;
  @override
  final String message;

  @override
  String toString() {
    return 'CommentThreadState.error(code: $code, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommentThreadErrorImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, code, message);

  /// Create a copy of CommentThreadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CommentThreadErrorImplCopyWith<_$CommentThreadErrorImpl> get copyWith =>
      __$$CommentThreadErrorImplCopyWithImpl<_$CommentThreadErrorImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<Comment> items, String? nextCursor,
            bool isLoadingMore, bool isPosting, String? postError)
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
    TResult? Function(List<Comment> items, String? nextCursor,
            bool isLoadingMore, bool isPosting, String? postError)?
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
    TResult Function(List<Comment> items, String? nextCursor,
            bool isLoadingMore, bool isPosting, String? postError)?
        loaded,
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
    required TResult Function(CommentThreadInitial value) initial,
    required TResult Function(CommentThreadLoading value) loading,
    required TResult Function(CommentThreadLoaded value) loaded,
    required TResult Function(CommentThreadError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CommentThreadInitial value)? initial,
    TResult? Function(CommentThreadLoading value)? loading,
    TResult? Function(CommentThreadLoaded value)? loaded,
    TResult? Function(CommentThreadError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CommentThreadInitial value)? initial,
    TResult Function(CommentThreadLoading value)? loading,
    TResult Function(CommentThreadLoaded value)? loaded,
    TResult Function(CommentThreadError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class CommentThreadError implements CommentThreadState {
  const factory CommentThreadError(
      {required final String code,
      required final String message}) = _$CommentThreadErrorImpl;

  String get code;
  String get message;

  /// Create a copy of CommentThreadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CommentThreadErrorImplCopyWith<_$CommentThreadErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
