// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'library_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LibraryListState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is LibraryListState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'LibraryListState()';
  }
}

/// @nodoc
class $LibraryListStateCopyWith<$Res> {
  $LibraryListStateCopyWith(
      LibraryListState _, $Res Function(LibraryListState) __);
}

/// Adds pattern-matching-related methods to [LibraryListState].
extension LibraryListStatePatterns on LibraryListState {
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
    TResult Function(LibraryListInitial value)? initial,
    TResult Function(LibraryListLoading value)? loading,
    TResult Function(LibraryListLoaded value)? loaded,
    TResult Function(LibraryListError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case LibraryListInitial() when initial != null:
        return initial(_that);
      case LibraryListLoading() when loading != null:
        return loading(_that);
      case LibraryListLoaded() when loaded != null:
        return loaded(_that);
      case LibraryListError() when error != null:
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
    required TResult Function(LibraryListInitial value) initial,
    required TResult Function(LibraryListLoading value) loading,
    required TResult Function(LibraryListLoaded value) loaded,
    required TResult Function(LibraryListError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case LibraryListInitial():
        return initial(_that);
      case LibraryListLoading():
        return loading(_that);
      case LibraryListLoaded():
        return loaded(_that);
      case LibraryListError():
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
    TResult? Function(LibraryListInitial value)? initial,
    TResult? Function(LibraryListLoading value)? loading,
    TResult? Function(LibraryListLoaded value)? loaded,
    TResult? Function(LibraryListError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case LibraryListInitial() when initial != null:
        return initial(_that);
      case LibraryListLoading() when loading != null:
        return loading(_that);
      case LibraryListLoaded() when loaded != null:
        return loaded(_that);
      case LibraryListError() when error != null:
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
    TResult Function(
            List<UserBook> items, String? nextCursor, bool isLoadingMore)?
        loaded,
    TResult Function(String code, String message)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case LibraryListInitial() when initial != null:
        return initial();
      case LibraryListLoading() when loading != null:
        return loading();
      case LibraryListLoaded() when loaded != null:
        return loaded(_that.items, _that.nextCursor, _that.isLoadingMore);
      case LibraryListError() when error != null:
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
            List<UserBook> items, String? nextCursor, bool isLoadingMore)
        loaded,
    required TResult Function(String code, String message) error,
  }) {
    final _that = this;
    switch (_that) {
      case LibraryListInitial():
        return initial();
      case LibraryListLoading():
        return loading();
      case LibraryListLoaded():
        return loaded(_that.items, _that.nextCursor, _that.isLoadingMore);
      case LibraryListError():
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
    TResult? Function(
            List<UserBook> items, String? nextCursor, bool isLoadingMore)?
        loaded,
    TResult? Function(String code, String message)? error,
  }) {
    final _that = this;
    switch (_that) {
      case LibraryListInitial() when initial != null:
        return initial();
      case LibraryListLoading() when loading != null:
        return loading();
      case LibraryListLoaded() when loaded != null:
        return loaded(_that.items, _that.nextCursor, _that.isLoadingMore);
      case LibraryListError() when error != null:
        return error(_that.code, _that.message);
      case _:
        return null;
    }
  }
}

/// @nodoc

class LibraryListInitial implements LibraryListState {
  const LibraryListInitial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is LibraryListInitial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'LibraryListState.initial()';
  }
}

/// @nodoc

class LibraryListLoading implements LibraryListState {
  const LibraryListLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is LibraryListLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'LibraryListState.loading()';
  }
}

/// @nodoc

class LibraryListLoaded implements LibraryListState {
  const LibraryListLoaded(
      {required final List<UserBook> items,
      this.nextCursor,
      this.isLoadingMore = false})
      : _items = items;

  final List<UserBook> _items;
  List<UserBook> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  final String? nextCursor;
  @JsonKey()
  final bool isLoadingMore;

  /// Create a copy of LibraryListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LibraryListLoadedCopyWith<LibraryListLoaded> get copyWith =>
      _$LibraryListLoadedCopyWithImpl<LibraryListLoaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LibraryListLoaded &&
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
    return 'LibraryListState.loaded(items: $items, nextCursor: $nextCursor, isLoadingMore: $isLoadingMore)';
  }
}

/// @nodoc
abstract mixin class $LibraryListLoadedCopyWith<$Res>
    implements $LibraryListStateCopyWith<$Res> {
  factory $LibraryListLoadedCopyWith(
          LibraryListLoaded value, $Res Function(LibraryListLoaded) _then) =
      _$LibraryListLoadedCopyWithImpl;
  @useResult
  $Res call({List<UserBook> items, String? nextCursor, bool isLoadingMore});
}

/// @nodoc
class _$LibraryListLoadedCopyWithImpl<$Res>
    implements $LibraryListLoadedCopyWith<$Res> {
  _$LibraryListLoadedCopyWithImpl(this._self, this._then);

  final LibraryListLoaded _self;
  final $Res Function(LibraryListLoaded) _then;

  /// Create a copy of LibraryListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? items = null,
    Object? nextCursor = freezed,
    Object? isLoadingMore = null,
  }) {
    return _then(LibraryListLoaded(
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<UserBook>,
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

class LibraryListError implements LibraryListState {
  const LibraryListError({required this.code, required this.message});

  final String code;
  final String message;

  /// Create a copy of LibraryListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LibraryListErrorCopyWith<LibraryListError> get copyWith =>
      _$LibraryListErrorCopyWithImpl<LibraryListError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LibraryListError &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, code, message);

  @override
  String toString() {
    return 'LibraryListState.error(code: $code, message: $message)';
  }
}

/// @nodoc
abstract mixin class $LibraryListErrorCopyWith<$Res>
    implements $LibraryListStateCopyWith<$Res> {
  factory $LibraryListErrorCopyWith(
          LibraryListError value, $Res Function(LibraryListError) _then) =
      _$LibraryListErrorCopyWithImpl;
  @useResult
  $Res call({String code, String message});
}

/// @nodoc
class _$LibraryListErrorCopyWithImpl<$Res>
    implements $LibraryListErrorCopyWith<$Res> {
  _$LibraryListErrorCopyWithImpl(this._self, this._then);

  final LibraryListError _self;
  final $Res Function(LibraryListError) _then;

  /// Create a copy of LibraryListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? code = null,
    Object? message = null,
  }) {
    return _then(LibraryListError(
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
