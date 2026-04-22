// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'book_search_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BookSearchState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(String query, List<Book> items, int page,
            bool hasMore, bool isLoadingMore)
        loaded,
    required TResult Function(String code, String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(String query, List<Book> items, int page, bool hasMore,
            bool isLoadingMore)?
        loaded,
    TResult? Function(String code, String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(String query, List<Book> items, int page, bool hasMore,
            bool isLoadingMore)?
        loaded,
    TResult Function(String code, String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BookSearchIdle value) idle,
    required TResult Function(BookSearchLoading value) loading,
    required TResult Function(BookSearchLoaded value) loaded,
    required TResult Function(BookSearchError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BookSearchIdle value)? idle,
    TResult? Function(BookSearchLoading value)? loading,
    TResult? Function(BookSearchLoaded value)? loaded,
    TResult? Function(BookSearchError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BookSearchIdle value)? idle,
    TResult Function(BookSearchLoading value)? loading,
    TResult Function(BookSearchLoaded value)? loaded,
    TResult Function(BookSearchError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookSearchStateCopyWith<$Res> {
  factory $BookSearchStateCopyWith(
          BookSearchState value, $Res Function(BookSearchState) then) =
      _$BookSearchStateCopyWithImpl<$Res, BookSearchState>;
}

/// @nodoc
class _$BookSearchStateCopyWithImpl<$Res, $Val extends BookSearchState>
    implements $BookSearchStateCopyWith<$Res> {
  _$BookSearchStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookSearchState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$BookSearchIdleImplCopyWith<$Res> {
  factory _$$BookSearchIdleImplCopyWith(_$BookSearchIdleImpl value,
          $Res Function(_$BookSearchIdleImpl) then) =
      __$$BookSearchIdleImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$BookSearchIdleImplCopyWithImpl<$Res>
    extends _$BookSearchStateCopyWithImpl<$Res, _$BookSearchIdleImpl>
    implements _$$BookSearchIdleImplCopyWith<$Res> {
  __$$BookSearchIdleImplCopyWithImpl(
      _$BookSearchIdleImpl _value, $Res Function(_$BookSearchIdleImpl) _then)
      : super(_value, _then);

  /// Create a copy of BookSearchState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$BookSearchIdleImpl implements BookSearchIdle {
  const _$BookSearchIdleImpl();

  @override
  String toString() {
    return 'BookSearchState.idle()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$BookSearchIdleImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(String query, List<Book> items, int page,
            bool hasMore, bool isLoadingMore)
        loaded,
    required TResult Function(String code, String message) error,
  }) {
    return idle();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(String query, List<Book> items, int page, bool hasMore,
            bool isLoadingMore)?
        loaded,
    TResult? Function(String code, String message)? error,
  }) {
    return idle?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(String query, List<Book> items, int page, bool hasMore,
            bool isLoadingMore)?
        loaded,
    TResult Function(String code, String message)? error,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BookSearchIdle value) idle,
    required TResult Function(BookSearchLoading value) loading,
    required TResult Function(BookSearchLoaded value) loaded,
    required TResult Function(BookSearchError value) error,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BookSearchIdle value)? idle,
    TResult? Function(BookSearchLoading value)? loading,
    TResult? Function(BookSearchLoaded value)? loaded,
    TResult? Function(BookSearchError value)? error,
  }) {
    return idle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BookSearchIdle value)? idle,
    TResult Function(BookSearchLoading value)? loading,
    TResult Function(BookSearchLoaded value)? loaded,
    TResult Function(BookSearchError value)? error,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }
}

abstract class BookSearchIdle implements BookSearchState {
  const factory BookSearchIdle() = _$BookSearchIdleImpl;
}

/// @nodoc
abstract class _$$BookSearchLoadingImplCopyWith<$Res> {
  factory _$$BookSearchLoadingImplCopyWith(_$BookSearchLoadingImpl value,
          $Res Function(_$BookSearchLoadingImpl) then) =
      __$$BookSearchLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$BookSearchLoadingImplCopyWithImpl<$Res>
    extends _$BookSearchStateCopyWithImpl<$Res, _$BookSearchLoadingImpl>
    implements _$$BookSearchLoadingImplCopyWith<$Res> {
  __$$BookSearchLoadingImplCopyWithImpl(_$BookSearchLoadingImpl _value,
      $Res Function(_$BookSearchLoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of BookSearchState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$BookSearchLoadingImpl implements BookSearchLoading {
  const _$BookSearchLoadingImpl();

  @override
  String toString() {
    return 'BookSearchState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$BookSearchLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(String query, List<Book> items, int page,
            bool hasMore, bool isLoadingMore)
        loaded,
    required TResult Function(String code, String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(String query, List<Book> items, int page, bool hasMore,
            bool isLoadingMore)?
        loaded,
    TResult? Function(String code, String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(String query, List<Book> items, int page, bool hasMore,
            bool isLoadingMore)?
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
    required TResult Function(BookSearchIdle value) idle,
    required TResult Function(BookSearchLoading value) loading,
    required TResult Function(BookSearchLoaded value) loaded,
    required TResult Function(BookSearchError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BookSearchIdle value)? idle,
    TResult? Function(BookSearchLoading value)? loading,
    TResult? Function(BookSearchLoaded value)? loaded,
    TResult? Function(BookSearchError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BookSearchIdle value)? idle,
    TResult Function(BookSearchLoading value)? loading,
    TResult Function(BookSearchLoaded value)? loaded,
    TResult Function(BookSearchError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class BookSearchLoading implements BookSearchState {
  const factory BookSearchLoading() = _$BookSearchLoadingImpl;
}

/// @nodoc
abstract class _$$BookSearchLoadedImplCopyWith<$Res> {
  factory _$$BookSearchLoadedImplCopyWith(_$BookSearchLoadedImpl value,
          $Res Function(_$BookSearchLoadedImpl) then) =
      __$$BookSearchLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {String query,
      List<Book> items,
      int page,
      bool hasMore,
      bool isLoadingMore});
}

/// @nodoc
class __$$BookSearchLoadedImplCopyWithImpl<$Res>
    extends _$BookSearchStateCopyWithImpl<$Res, _$BookSearchLoadedImpl>
    implements _$$BookSearchLoadedImplCopyWith<$Res> {
  __$$BookSearchLoadedImplCopyWithImpl(_$BookSearchLoadedImpl _value,
      $Res Function(_$BookSearchLoadedImpl) _then)
      : super(_value, _then);

  /// Create a copy of BookSearchState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = null,
    Object? items = null,
    Object? page = null,
    Object? hasMore = null,
    Object? isLoadingMore = null,
  }) {
    return _then(_$BookSearchLoadedImpl(
      query: null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Book>,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingMore: null == isLoadingMore
          ? _value.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$BookSearchLoadedImpl implements BookSearchLoaded {
  const _$BookSearchLoadedImpl(
      {required this.query,
      required final List<Book> items,
      required this.page,
      required this.hasMore,
      this.isLoadingMore = false})
      : _items = items;

  @override
  final String query;
  final List<Book> _items;
  @override
  List<Book> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final int page;
  @override
  final bool hasMore;
  @override
  @JsonKey()
  final bool isLoadingMore;

  @override
  String toString() {
    return 'BookSearchState.loaded(query: $query, items: $items, page: $page, hasMore: $hasMore, isLoadingMore: $isLoadingMore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookSearchLoadedImpl &&
            (identical(other.query, query) || other.query == query) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      query,
      const DeepCollectionEquality().hash(_items),
      page,
      hasMore,
      isLoadingMore);

  /// Create a copy of BookSearchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookSearchLoadedImplCopyWith<_$BookSearchLoadedImpl> get copyWith =>
      __$$BookSearchLoadedImplCopyWithImpl<_$BookSearchLoadedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(String query, List<Book> items, int page,
            bool hasMore, bool isLoadingMore)
        loaded,
    required TResult Function(String code, String message) error,
  }) {
    return loaded(query, items, page, hasMore, isLoadingMore);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(String query, List<Book> items, int page, bool hasMore,
            bool isLoadingMore)?
        loaded,
    TResult? Function(String code, String message)? error,
  }) {
    return loaded?.call(query, items, page, hasMore, isLoadingMore);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(String query, List<Book> items, int page, bool hasMore,
            bool isLoadingMore)?
        loaded,
    TResult Function(String code, String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(query, items, page, hasMore, isLoadingMore);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BookSearchIdle value) idle,
    required TResult Function(BookSearchLoading value) loading,
    required TResult Function(BookSearchLoaded value) loaded,
    required TResult Function(BookSearchError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BookSearchIdle value)? idle,
    TResult? Function(BookSearchLoading value)? loading,
    TResult? Function(BookSearchLoaded value)? loaded,
    TResult? Function(BookSearchError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BookSearchIdle value)? idle,
    TResult Function(BookSearchLoading value)? loading,
    TResult Function(BookSearchLoaded value)? loaded,
    TResult Function(BookSearchError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class BookSearchLoaded implements BookSearchState {
  const factory BookSearchLoaded(
      {required final String query,
      required final List<Book> items,
      required final int page,
      required final bool hasMore,
      final bool isLoadingMore}) = _$BookSearchLoadedImpl;

  String get query;
  List<Book> get items;
  int get page;
  bool get hasMore;
  bool get isLoadingMore;

  /// Create a copy of BookSearchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookSearchLoadedImplCopyWith<_$BookSearchLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BookSearchErrorImplCopyWith<$Res> {
  factory _$$BookSearchErrorImplCopyWith(_$BookSearchErrorImpl value,
          $Res Function(_$BookSearchErrorImpl) then) =
      __$$BookSearchErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String code, String message});
}

/// @nodoc
class __$$BookSearchErrorImplCopyWithImpl<$Res>
    extends _$BookSearchStateCopyWithImpl<$Res, _$BookSearchErrorImpl>
    implements _$$BookSearchErrorImplCopyWith<$Res> {
  __$$BookSearchErrorImplCopyWithImpl(
      _$BookSearchErrorImpl _value, $Res Function(_$BookSearchErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of BookSearchState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? message = null,
  }) {
    return _then(_$BookSearchErrorImpl(
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

class _$BookSearchErrorImpl implements BookSearchError {
  const _$BookSearchErrorImpl({required this.code, required this.message});

  @override
  final String code;
  @override
  final String message;

  @override
  String toString() {
    return 'BookSearchState.error(code: $code, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookSearchErrorImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, code, message);

  /// Create a copy of BookSearchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookSearchErrorImplCopyWith<_$BookSearchErrorImpl> get copyWith =>
      __$$BookSearchErrorImplCopyWithImpl<_$BookSearchErrorImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(String query, List<Book> items, int page,
            bool hasMore, bool isLoadingMore)
        loaded,
    required TResult Function(String code, String message) error,
  }) {
    return error(code, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(String query, List<Book> items, int page, bool hasMore,
            bool isLoadingMore)?
        loaded,
    TResult? Function(String code, String message)? error,
  }) {
    return error?.call(code, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(String query, List<Book> items, int page, bool hasMore,
            bool isLoadingMore)?
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
    required TResult Function(BookSearchIdle value) idle,
    required TResult Function(BookSearchLoading value) loading,
    required TResult Function(BookSearchLoaded value) loaded,
    required TResult Function(BookSearchError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BookSearchIdle value)? idle,
    TResult? Function(BookSearchLoading value)? loading,
    TResult? Function(BookSearchLoaded value)? loaded,
    TResult? Function(BookSearchError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BookSearchIdle value)? idle,
    TResult Function(BookSearchLoading value)? loading,
    TResult Function(BookSearchLoaded value)? loaded,
    TResult Function(BookSearchError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class BookSearchError implements BookSearchState {
  const factory BookSearchError(
      {required final String code,
      required final String message}) = _$BookSearchErrorImpl;

  String get code;
  String get message;

  /// Create a copy of BookSearchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookSearchErrorImplCopyWith<_$BookSearchErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
