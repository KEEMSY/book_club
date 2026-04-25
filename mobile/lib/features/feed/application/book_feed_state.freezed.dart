// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'book_feed_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BookFeedState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<Post> items, String? nextCursor, bool isLoadingMore)
        loaded,
    required TResult Function(String code, String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Post> items, String? nextCursor, bool isLoadingMore)?
        loaded,
    TResult? Function(String code, String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Post> items, String? nextCursor, bool isLoadingMore)?
        loaded,
    TResult Function(String code, String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BookFeedInitial value) initial,
    required TResult Function(BookFeedLoading value) loading,
    required TResult Function(BookFeedLoaded value) loaded,
    required TResult Function(BookFeedError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BookFeedInitial value)? initial,
    TResult? Function(BookFeedLoading value)? loading,
    TResult? Function(BookFeedLoaded value)? loaded,
    TResult? Function(BookFeedError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BookFeedInitial value)? initial,
    TResult Function(BookFeedLoading value)? loading,
    TResult Function(BookFeedLoaded value)? loaded,
    TResult Function(BookFeedError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookFeedStateCopyWith<$Res> {
  factory $BookFeedStateCopyWith(
          BookFeedState value, $Res Function(BookFeedState) then) =
      _$BookFeedStateCopyWithImpl<$Res, BookFeedState>;
}

/// @nodoc
class _$BookFeedStateCopyWithImpl<$Res, $Val extends BookFeedState>
    implements $BookFeedStateCopyWith<$Res> {
  _$BookFeedStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookFeedState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$BookFeedInitialImplCopyWith<$Res> {
  factory _$$BookFeedInitialImplCopyWith(_$BookFeedInitialImpl value,
          $Res Function(_$BookFeedInitialImpl) then) =
      __$$BookFeedInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$BookFeedInitialImplCopyWithImpl<$Res>
    extends _$BookFeedStateCopyWithImpl<$Res, _$BookFeedInitialImpl>
    implements _$$BookFeedInitialImplCopyWith<$Res> {
  __$$BookFeedInitialImplCopyWithImpl(
      _$BookFeedInitialImpl _value, $Res Function(_$BookFeedInitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of BookFeedState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$BookFeedInitialImpl implements BookFeedInitial {
  const _$BookFeedInitialImpl();

  @override
  String toString() {
    return 'BookFeedState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$BookFeedInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<Post> items, String? nextCursor, bool isLoadingMore)
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
    TResult? Function(List<Post> items, String? nextCursor, bool isLoadingMore)?
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
    TResult Function(List<Post> items, String? nextCursor, bool isLoadingMore)?
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
    required TResult Function(BookFeedInitial value) initial,
    required TResult Function(BookFeedLoading value) loading,
    required TResult Function(BookFeedLoaded value) loaded,
    required TResult Function(BookFeedError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BookFeedInitial value)? initial,
    TResult? Function(BookFeedLoading value)? loading,
    TResult? Function(BookFeedLoaded value)? loaded,
    TResult? Function(BookFeedError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BookFeedInitial value)? initial,
    TResult Function(BookFeedLoading value)? loading,
    TResult Function(BookFeedLoaded value)? loaded,
    TResult Function(BookFeedError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class BookFeedInitial implements BookFeedState {
  const factory BookFeedInitial() = _$BookFeedInitialImpl;
}

/// @nodoc
abstract class _$$BookFeedLoadingImplCopyWith<$Res> {
  factory _$$BookFeedLoadingImplCopyWith(_$BookFeedLoadingImpl value,
          $Res Function(_$BookFeedLoadingImpl) then) =
      __$$BookFeedLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$BookFeedLoadingImplCopyWithImpl<$Res>
    extends _$BookFeedStateCopyWithImpl<$Res, _$BookFeedLoadingImpl>
    implements _$$BookFeedLoadingImplCopyWith<$Res> {
  __$$BookFeedLoadingImplCopyWithImpl(
      _$BookFeedLoadingImpl _value, $Res Function(_$BookFeedLoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of BookFeedState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$BookFeedLoadingImpl implements BookFeedLoading {
  const _$BookFeedLoadingImpl();

  @override
  String toString() {
    return 'BookFeedState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$BookFeedLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<Post> items, String? nextCursor, bool isLoadingMore)
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
    TResult? Function(List<Post> items, String? nextCursor, bool isLoadingMore)?
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
    TResult Function(List<Post> items, String? nextCursor, bool isLoadingMore)?
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
    required TResult Function(BookFeedInitial value) initial,
    required TResult Function(BookFeedLoading value) loading,
    required TResult Function(BookFeedLoaded value) loaded,
    required TResult Function(BookFeedError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BookFeedInitial value)? initial,
    TResult? Function(BookFeedLoading value)? loading,
    TResult? Function(BookFeedLoaded value)? loaded,
    TResult? Function(BookFeedError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BookFeedInitial value)? initial,
    TResult Function(BookFeedLoading value)? loading,
    TResult Function(BookFeedLoaded value)? loaded,
    TResult Function(BookFeedError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class BookFeedLoading implements BookFeedState {
  const factory BookFeedLoading() = _$BookFeedLoadingImpl;
}

/// @nodoc
abstract class _$$BookFeedLoadedImplCopyWith<$Res> {
  factory _$$BookFeedLoadedImplCopyWith(_$BookFeedLoadedImpl value,
          $Res Function(_$BookFeedLoadedImpl) then) =
      __$$BookFeedLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<Post> items, String? nextCursor, bool isLoadingMore});
}

/// @nodoc
class __$$BookFeedLoadedImplCopyWithImpl<$Res>
    extends _$BookFeedStateCopyWithImpl<$Res, _$BookFeedLoadedImpl>
    implements _$$BookFeedLoadedImplCopyWith<$Res> {
  __$$BookFeedLoadedImplCopyWithImpl(
      _$BookFeedLoadedImpl _value, $Res Function(_$BookFeedLoadedImpl) _then)
      : super(_value, _then);

  /// Create a copy of BookFeedState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? nextCursor = freezed,
    Object? isLoadingMore = null,
  }) {
    return _then(_$BookFeedLoadedImpl(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Post>,
      nextCursor: freezed == nextCursor
          ? _value.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
      isLoadingMore: null == isLoadingMore
          ? _value.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$BookFeedLoadedImpl implements BookFeedLoaded {
  const _$BookFeedLoadedImpl(
      {required final List<Post> items,
      this.nextCursor,
      this.isLoadingMore = false})
      : _items = items;

  final List<Post> _items;
  @override
  List<Post> get items {
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
  String toString() {
    return 'BookFeedState.loaded(items: $items, nextCursor: $nextCursor, isLoadingMore: $isLoadingMore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookFeedLoadedImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor) &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_items), nextCursor, isLoadingMore);

  /// Create a copy of BookFeedState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookFeedLoadedImplCopyWith<_$BookFeedLoadedImpl> get copyWith =>
      __$$BookFeedLoadedImplCopyWithImpl<_$BookFeedLoadedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<Post> items, String? nextCursor, bool isLoadingMore)
        loaded,
    required TResult Function(String code, String message) error,
  }) {
    return loaded(items, nextCursor, isLoadingMore);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<Post> items, String? nextCursor, bool isLoadingMore)?
        loaded,
    TResult? Function(String code, String message)? error,
  }) {
    return loaded?.call(items, nextCursor, isLoadingMore);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<Post> items, String? nextCursor, bool isLoadingMore)?
        loaded,
    TResult Function(String code, String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(items, nextCursor, isLoadingMore);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BookFeedInitial value) initial,
    required TResult Function(BookFeedLoading value) loading,
    required TResult Function(BookFeedLoaded value) loaded,
    required TResult Function(BookFeedError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BookFeedInitial value)? initial,
    TResult? Function(BookFeedLoading value)? loading,
    TResult? Function(BookFeedLoaded value)? loaded,
    TResult? Function(BookFeedError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BookFeedInitial value)? initial,
    TResult Function(BookFeedLoading value)? loading,
    TResult Function(BookFeedLoaded value)? loaded,
    TResult Function(BookFeedError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class BookFeedLoaded implements BookFeedState {
  const factory BookFeedLoaded(
      {required final List<Post> items,
      final String? nextCursor,
      final bool isLoadingMore}) = _$BookFeedLoadedImpl;

  List<Post> get items;
  String? get nextCursor;
  bool get isLoadingMore;

  /// Create a copy of BookFeedState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookFeedLoadedImplCopyWith<_$BookFeedLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BookFeedErrorImplCopyWith<$Res> {
  factory _$$BookFeedErrorImplCopyWith(
          _$BookFeedErrorImpl value, $Res Function(_$BookFeedErrorImpl) then) =
      __$$BookFeedErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String code, String message});
}

/// @nodoc
class __$$BookFeedErrorImplCopyWithImpl<$Res>
    extends _$BookFeedStateCopyWithImpl<$Res, _$BookFeedErrorImpl>
    implements _$$BookFeedErrorImplCopyWith<$Res> {
  __$$BookFeedErrorImplCopyWithImpl(
      _$BookFeedErrorImpl _value, $Res Function(_$BookFeedErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of BookFeedState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? message = null,
  }) {
    return _then(_$BookFeedErrorImpl(
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

class _$BookFeedErrorImpl implements BookFeedError {
  const _$BookFeedErrorImpl({required this.code, required this.message});

  @override
  final String code;
  @override
  final String message;

  @override
  String toString() {
    return 'BookFeedState.error(code: $code, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookFeedErrorImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, code, message);

  /// Create a copy of BookFeedState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookFeedErrorImplCopyWith<_$BookFeedErrorImpl> get copyWith =>
      __$$BookFeedErrorImplCopyWithImpl<_$BookFeedErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<Post> items, String? nextCursor, bool isLoadingMore)
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
    TResult? Function(List<Post> items, String? nextCursor, bool isLoadingMore)?
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
    TResult Function(List<Post> items, String? nextCursor, bool isLoadingMore)?
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
    required TResult Function(BookFeedInitial value) initial,
    required TResult Function(BookFeedLoading value) loading,
    required TResult Function(BookFeedLoaded value) loaded,
    required TResult Function(BookFeedError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BookFeedInitial value)? initial,
    TResult? Function(BookFeedLoading value)? loading,
    TResult? Function(BookFeedLoaded value)? loaded,
    TResult? Function(BookFeedError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BookFeedInitial value)? initial,
    TResult Function(BookFeedLoading value)? loading,
    TResult Function(BookFeedLoaded value)? loaded,
    TResult Function(BookFeedError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class BookFeedError implements BookFeedState {
  const factory BookFeedError(
      {required final String code,
      required final String message}) = _$BookFeedErrorImpl;

  String get code;
  String get message;

  /// Create a copy of BookFeedState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookFeedErrorImplCopyWith<_$BookFeedErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
