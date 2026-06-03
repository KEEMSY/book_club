// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'book_search_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BookSearchState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is BookSearchState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'BookSearchState()';
  }
}

/// @nodoc
class $BookSearchStateCopyWith<$Res> {
  $BookSearchStateCopyWith(
      BookSearchState _, $Res Function(BookSearchState) __);
}

/// Adds pattern-matching-related methods to [BookSearchState].
extension BookSearchStatePatterns on BookSearchState {
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
    TResult Function(BookSearchIdle value)? idle,
    TResult Function(BookSearchLoading value)? loading,
    TResult Function(BookSearchLoaded value)? loaded,
    TResult Function(BookSearchError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case BookSearchIdle() when idle != null:
        return idle(_that);
      case BookSearchLoading() when loading != null:
        return loading(_that);
      case BookSearchLoaded() when loaded != null:
        return loaded(_that);
      case BookSearchError() when error != null:
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
    required TResult Function(BookSearchIdle value) idle,
    required TResult Function(BookSearchLoading value) loading,
    required TResult Function(BookSearchLoaded value) loaded,
    required TResult Function(BookSearchError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case BookSearchIdle():
        return idle(_that);
      case BookSearchLoading():
        return loading(_that);
      case BookSearchLoaded():
        return loaded(_that);
      case BookSearchError():
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
    TResult? Function(BookSearchIdle value)? idle,
    TResult? Function(BookSearchLoading value)? loading,
    TResult? Function(BookSearchLoaded value)? loaded,
    TResult? Function(BookSearchError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case BookSearchIdle() when idle != null:
        return idle(_that);
      case BookSearchLoading() when loading != null:
        return loading(_that);
      case BookSearchLoaded() when loaded != null:
        return loaded(_that);
      case BookSearchError() when error != null:
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
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(String query, List<Book> items, int page, bool hasMore,
            bool isLoadingMore)?
        loaded,
    TResult Function(String code, String message)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case BookSearchIdle() when idle != null:
        return idle();
      case BookSearchLoading() when loading != null:
        return loading();
      case BookSearchLoaded() when loaded != null:
        return loaded(_that.query, _that.items, _that.page, _that.hasMore,
            _that.isLoadingMore);
      case BookSearchError() when error != null:
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
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(String query, List<Book> items, int page,
            bool hasMore, bool isLoadingMore)
        loaded,
    required TResult Function(String code, String message) error,
  }) {
    final _that = this;
    switch (_that) {
      case BookSearchIdle():
        return idle();
      case BookSearchLoading():
        return loading();
      case BookSearchLoaded():
        return loaded(_that.query, _that.items, _that.page, _that.hasMore,
            _that.isLoadingMore);
      case BookSearchError():
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
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(String query, List<Book> items, int page, bool hasMore,
            bool isLoadingMore)?
        loaded,
    TResult? Function(String code, String message)? error,
  }) {
    final _that = this;
    switch (_that) {
      case BookSearchIdle() when idle != null:
        return idle();
      case BookSearchLoading() when loading != null:
        return loading();
      case BookSearchLoaded() when loaded != null:
        return loaded(_that.query, _that.items, _that.page, _that.hasMore,
            _that.isLoadingMore);
      case BookSearchError() when error != null:
        return error(_that.code, _that.message);
      case _:
        return null;
    }
  }
}

/// @nodoc

class BookSearchIdle implements BookSearchState {
  const BookSearchIdle();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is BookSearchIdle);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'BookSearchState.idle()';
  }
}

/// @nodoc

class BookSearchLoading implements BookSearchState {
  const BookSearchLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is BookSearchLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'BookSearchState.loading()';
  }
}

/// @nodoc

class BookSearchLoaded implements BookSearchState {
  const BookSearchLoaded(
      {required this.query,
      required final List<Book> items,
      required this.page,
      required this.hasMore,
      this.isLoadingMore = false})
      : _items = items;

  final String query;
  final List<Book> _items;
  List<Book> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  final int page;
  final bool hasMore;
  @JsonKey()
  final bool isLoadingMore;

  /// Create a copy of BookSearchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BookSearchLoadedCopyWith<BookSearchLoaded> get copyWith =>
      _$BookSearchLoadedCopyWithImpl<BookSearchLoaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BookSearchLoaded &&
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

  @override
  String toString() {
    return 'BookSearchState.loaded(query: $query, items: $items, page: $page, hasMore: $hasMore, isLoadingMore: $isLoadingMore)';
  }
}

/// @nodoc
abstract mixin class $BookSearchLoadedCopyWith<$Res>
    implements $BookSearchStateCopyWith<$Res> {
  factory $BookSearchLoadedCopyWith(
          BookSearchLoaded value, $Res Function(BookSearchLoaded) _then) =
      _$BookSearchLoadedCopyWithImpl;
  @useResult
  $Res call(
      {String query,
      List<Book> items,
      int page,
      bool hasMore,
      bool isLoadingMore});
}

/// @nodoc
class _$BookSearchLoadedCopyWithImpl<$Res>
    implements $BookSearchLoadedCopyWith<$Res> {
  _$BookSearchLoadedCopyWithImpl(this._self, this._then);

  final BookSearchLoaded _self;
  final $Res Function(BookSearchLoaded) _then;

  /// Create a copy of BookSearchState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? query = null,
    Object? items = null,
    Object? page = null,
    Object? hasMore = null,
    Object? isLoadingMore = null,
  }) {
    return _then(BookSearchLoaded(
      query: null == query
          ? _self.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Book>,
      page: null == page
          ? _self.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _self.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingMore: null == isLoadingMore
          ? _self.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class BookSearchError implements BookSearchState {
  const BookSearchError({required this.code, required this.message});

  final String code;
  final String message;

  /// Create a copy of BookSearchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BookSearchErrorCopyWith<BookSearchError> get copyWith =>
      _$BookSearchErrorCopyWithImpl<BookSearchError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BookSearchError &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, code, message);

  @override
  String toString() {
    return 'BookSearchState.error(code: $code, message: $message)';
  }
}

/// @nodoc
abstract mixin class $BookSearchErrorCopyWith<$Res>
    implements $BookSearchStateCopyWith<$Res> {
  factory $BookSearchErrorCopyWith(
          BookSearchError value, $Res Function(BookSearchError) _then) =
      _$BookSearchErrorCopyWithImpl;
  @useResult
  $Res call({String code, String message});
}

/// @nodoc
class _$BookSearchErrorCopyWithImpl<$Res>
    implements $BookSearchErrorCopyWith<$Res> {
  _$BookSearchErrorCopyWithImpl(this._self, this._then);

  final BookSearchError _self;
  final $Res Function(BookSearchError) _then;

  /// Create a copy of BookSearchState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? code = null,
    Object? message = null,
  }) {
    return _then(BookSearchError(
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
