// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'book_feed_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BookFeedState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is BookFeedState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'BookFeedState()';
  }
}

/// @nodoc
class $BookFeedStateCopyWith<$Res> {
  $BookFeedStateCopyWith(BookFeedState _, $Res Function(BookFeedState) __);
}

/// Adds pattern-matching-related methods to [BookFeedState].
extension BookFeedStatePatterns on BookFeedState {
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
    TResult Function(BookFeedInitial value)? initial,
    TResult Function(BookFeedLoading value)? loading,
    TResult Function(BookFeedLoaded value)? loaded,
    TResult Function(BookFeedError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case BookFeedInitial() when initial != null:
        return initial(_that);
      case BookFeedLoading() when loading != null:
        return loading(_that);
      case BookFeedLoaded() when loaded != null:
        return loaded(_that);
      case BookFeedError() when error != null:
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
    required TResult Function(BookFeedInitial value) initial,
    required TResult Function(BookFeedLoading value) loading,
    required TResult Function(BookFeedLoaded value) loaded,
    required TResult Function(BookFeedError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case BookFeedInitial():
        return initial(_that);
      case BookFeedLoading():
        return loading(_that);
      case BookFeedLoaded():
        return loaded(_that);
      case BookFeedError():
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
    TResult? Function(BookFeedInitial value)? initial,
    TResult? Function(BookFeedLoading value)? loading,
    TResult? Function(BookFeedLoaded value)? loaded,
    TResult? Function(BookFeedError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case BookFeedInitial() when initial != null:
        return initial(_that);
      case BookFeedLoading() when loading != null:
        return loading(_that);
      case BookFeedLoaded() when loaded != null:
        return loaded(_that);
      case BookFeedError() when error != null:
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
    TResult Function(List<Post> items, String? nextCursor, bool isLoadingMore)?
        loaded,
    TResult Function(String code, String message)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case BookFeedInitial() when initial != null:
        return initial();
      case BookFeedLoading() when loading != null:
        return loading();
      case BookFeedLoaded() when loaded != null:
        return loaded(_that.items, _that.nextCursor, _that.isLoadingMore);
      case BookFeedError() when error != null:
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
    required TResult Function(
            List<Post> items, String? nextCursor, bool isLoadingMore)
        loaded,
    required TResult Function(String code, String message) error,
  }) {
    final _that = this;
    switch (_that) {
      case BookFeedInitial():
        return initial();
      case BookFeedLoading():
        return loading();
      case BookFeedLoaded():
        return loaded(_that.items, _that.nextCursor, _that.isLoadingMore);
      case BookFeedError():
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
    TResult? Function(List<Post> items, String? nextCursor, bool isLoadingMore)?
        loaded,
    TResult? Function(String code, String message)? error,
  }) {
    final _that = this;
    switch (_that) {
      case BookFeedInitial() when initial != null:
        return initial();
      case BookFeedLoading() when loading != null:
        return loading();
      case BookFeedLoaded() when loaded != null:
        return loaded(_that.items, _that.nextCursor, _that.isLoadingMore);
      case BookFeedError() when error != null:
        return error(_that.code, _that.message);
      case _:
        return null;
    }
  }
}

/// @nodoc

class BookFeedInitial implements BookFeedState {
  const BookFeedInitial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is BookFeedInitial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'BookFeedState.initial()';
  }
}

/// @nodoc

class BookFeedLoading implements BookFeedState {
  const BookFeedLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is BookFeedLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'BookFeedState.loading()';
  }
}

/// @nodoc

class BookFeedLoaded implements BookFeedState {
  const BookFeedLoaded(
      {required final List<Post> items,
      this.nextCursor,
      this.isLoadingMore = false})
      : _items = items;

  final List<Post> _items;
  List<Post> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  final String? nextCursor;
  @JsonKey()
  final bool isLoadingMore;

  /// Create a copy of BookFeedState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BookFeedLoadedCopyWith<BookFeedLoaded> get copyWith =>
      _$BookFeedLoadedCopyWithImpl<BookFeedLoaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BookFeedLoaded &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor) &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_items), nextCursor, isLoadingMore);

  @override
  String toString() {
    return 'BookFeedState.loaded(items: $items, nextCursor: $nextCursor, isLoadingMore: $isLoadingMore)';
  }
}

/// @nodoc
abstract mixin class $BookFeedLoadedCopyWith<$Res>
    implements $BookFeedStateCopyWith<$Res> {
  factory $BookFeedLoadedCopyWith(
          BookFeedLoaded value, $Res Function(BookFeedLoaded) _then) =
      _$BookFeedLoadedCopyWithImpl;
  @useResult
  $Res call({List<Post> items, String? nextCursor, bool isLoadingMore});
}

/// @nodoc
class _$BookFeedLoadedCopyWithImpl<$Res>
    implements $BookFeedLoadedCopyWith<$Res> {
  _$BookFeedLoadedCopyWithImpl(this._self, this._then);

  final BookFeedLoaded _self;
  final $Res Function(BookFeedLoaded) _then;

  /// Create a copy of BookFeedState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? items = null,
    Object? nextCursor = freezed,
    Object? isLoadingMore = null,
  }) {
    return _then(BookFeedLoaded(
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Post>,
      nextCursor: freezed == nextCursor
          ? _self.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
      isLoadingMore: null == isLoadingMore
          ? _self.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class BookFeedError implements BookFeedState {
  const BookFeedError({required this.code, required this.message});

  final String code;
  final String message;

  /// Create a copy of BookFeedState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BookFeedErrorCopyWith<BookFeedError> get copyWith =>
      _$BookFeedErrorCopyWithImpl<BookFeedError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BookFeedError &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, code, message);

  @override
  String toString() {
    return 'BookFeedState.error(code: $code, message: $message)';
  }
}

/// @nodoc
abstract mixin class $BookFeedErrorCopyWith<$Res>
    implements $BookFeedStateCopyWith<$Res> {
  factory $BookFeedErrorCopyWith(
          BookFeedError value, $Res Function(BookFeedError) _then) =
      _$BookFeedErrorCopyWithImpl;
  @useResult
  $Res call({String code, String message});
}

/// @nodoc
class _$BookFeedErrorCopyWithImpl<$Res>
    implements $BookFeedErrorCopyWith<$Res> {
  _$BookFeedErrorCopyWithImpl(this._self, this._then);

  final BookFeedError _self;
  final $Res Function(BookFeedError) _then;

  /// Create a copy of BookFeedState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? code = null,
    Object? message = null,
  }) {
    return _then(BookFeedError(
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
