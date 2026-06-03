// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comment_thread_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CommentThreadState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is CommentThreadState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'CommentThreadState()';
  }
}

/// @nodoc
class $CommentThreadStateCopyWith<$Res> {
  $CommentThreadStateCopyWith(
      CommentThreadState _, $Res Function(CommentThreadState) __);
}

/// Adds pattern-matching-related methods to [CommentThreadState].
extension CommentThreadStatePatterns on CommentThreadState {
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
    TResult Function(CommentThreadInitial value)? initial,
    TResult Function(CommentThreadLoading value)? loading,
    TResult Function(CommentThreadLoaded value)? loaded,
    TResult Function(CommentThreadError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case CommentThreadInitial() when initial != null:
        return initial(_that);
      case CommentThreadLoading() when loading != null:
        return loading(_that);
      case CommentThreadLoaded() when loaded != null:
        return loaded(_that);
      case CommentThreadError() when error != null:
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
    required TResult Function(CommentThreadInitial value) initial,
    required TResult Function(CommentThreadLoading value) loading,
    required TResult Function(CommentThreadLoaded value) loaded,
    required TResult Function(CommentThreadError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case CommentThreadInitial():
        return initial(_that);
      case CommentThreadLoading():
        return loading(_that);
      case CommentThreadLoaded():
        return loaded(_that);
      case CommentThreadError():
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
    TResult? Function(CommentThreadInitial value)? initial,
    TResult? Function(CommentThreadLoading value)? loading,
    TResult? Function(CommentThreadLoaded value)? loaded,
    TResult? Function(CommentThreadError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case CommentThreadInitial() when initial != null:
        return initial(_that);
      case CommentThreadLoading() when loading != null:
        return loading(_that);
      case CommentThreadLoaded() when loaded != null:
        return loaded(_that);
      case CommentThreadError() when error != null:
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
    TResult Function(List<Comment> items, String? nextCursor,
            bool isLoadingMore, bool isPosting, String? postError)?
        loaded,
    TResult Function(String code, String message)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case CommentThreadInitial() when initial != null:
        return initial();
      case CommentThreadLoading() when loading != null:
        return loading();
      case CommentThreadLoaded() when loaded != null:
        return loaded(_that.items, _that.nextCursor, _that.isLoadingMore,
            _that.isPosting, _that.postError);
      case CommentThreadError() when error != null:
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
    required TResult Function(List<Comment> items, String? nextCursor,
            bool isLoadingMore, bool isPosting, String? postError)
        loaded,
    required TResult Function(String code, String message) error,
  }) {
    final _that = this;
    switch (_that) {
      case CommentThreadInitial():
        return initial();
      case CommentThreadLoading():
        return loading();
      case CommentThreadLoaded():
        return loaded(_that.items, _that.nextCursor, _that.isLoadingMore,
            _that.isPosting, _that.postError);
      case CommentThreadError():
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
    TResult? Function(List<Comment> items, String? nextCursor,
            bool isLoadingMore, bool isPosting, String? postError)?
        loaded,
    TResult? Function(String code, String message)? error,
  }) {
    final _that = this;
    switch (_that) {
      case CommentThreadInitial() when initial != null:
        return initial();
      case CommentThreadLoading() when loading != null:
        return loading();
      case CommentThreadLoaded() when loaded != null:
        return loaded(_that.items, _that.nextCursor, _that.isLoadingMore,
            _that.isPosting, _that.postError);
      case CommentThreadError() when error != null:
        return error(_that.code, _that.message);
      case _:
        return null;
    }
  }
}

/// @nodoc

class CommentThreadInitial implements CommentThreadState {
  const CommentThreadInitial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is CommentThreadInitial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'CommentThreadState.initial()';
  }
}

/// @nodoc

class CommentThreadLoading implements CommentThreadState {
  const CommentThreadLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is CommentThreadLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'CommentThreadState.loading()';
  }
}

/// @nodoc

class CommentThreadLoaded implements CommentThreadState {
  const CommentThreadLoaded(
      {required final List<Comment> items,
      this.nextCursor,
      this.isLoadingMore = false,
      this.isPosting = false,
      this.postError})
      : _items = items;

  final List<Comment> _items;
  List<Comment> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  final String? nextCursor;
  @JsonKey()
  final bool isLoadingMore;
  @JsonKey()
  final bool isPosting;
  final String? postError;

  /// Create a copy of CommentThreadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CommentThreadLoadedCopyWith<CommentThreadLoaded> get copyWith =>
      _$CommentThreadLoadedCopyWithImpl<CommentThreadLoaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CommentThreadLoaded &&
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

  @override
  String toString() {
    return 'CommentThreadState.loaded(items: $items, nextCursor: $nextCursor, isLoadingMore: $isLoadingMore, isPosting: $isPosting, postError: $postError)';
  }
}

/// @nodoc
abstract mixin class $CommentThreadLoadedCopyWith<$Res>
    implements $CommentThreadStateCopyWith<$Res> {
  factory $CommentThreadLoadedCopyWith(
          CommentThreadLoaded value, $Res Function(CommentThreadLoaded) _then) =
      _$CommentThreadLoadedCopyWithImpl;
  @useResult
  $Res call(
      {List<Comment> items,
      String? nextCursor,
      bool isLoadingMore,
      bool isPosting,
      String? postError});
}

/// @nodoc
class _$CommentThreadLoadedCopyWithImpl<$Res>
    implements $CommentThreadLoadedCopyWith<$Res> {
  _$CommentThreadLoadedCopyWithImpl(this._self, this._then);

  final CommentThreadLoaded _self;
  final $Res Function(CommentThreadLoaded) _then;

  /// Create a copy of CommentThreadState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? items = null,
    Object? nextCursor = freezed,
    Object? isLoadingMore = null,
    Object? isPosting = null,
    Object? postError = freezed,
  }) {
    return _then(CommentThreadLoaded(
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Comment>,
      nextCursor: freezed == nextCursor
          ? _self.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
      isLoadingMore: null == isLoadingMore
          ? _self.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
      isPosting: null == isPosting
          ? _self.isPosting
          : isPosting // ignore: cast_nullable_to_non_nullable
              as bool,
      postError: freezed == postError
          ? _self.postError
          : postError // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class CommentThreadError implements CommentThreadState {
  const CommentThreadError({required this.code, required this.message});

  final String code;
  final String message;

  /// Create a copy of CommentThreadState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CommentThreadErrorCopyWith<CommentThreadError> get copyWith =>
      _$CommentThreadErrorCopyWithImpl<CommentThreadError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CommentThreadError &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, code, message);

  @override
  String toString() {
    return 'CommentThreadState.error(code: $code, message: $message)';
  }
}

/// @nodoc
abstract mixin class $CommentThreadErrorCopyWith<$Res>
    implements $CommentThreadStateCopyWith<$Res> {
  factory $CommentThreadErrorCopyWith(
          CommentThreadError value, $Res Function(CommentThreadError) _then) =
      _$CommentThreadErrorCopyWithImpl;
  @useResult
  $Res call({String code, String message});
}

/// @nodoc
class _$CommentThreadErrorCopyWithImpl<$Res>
    implements $CommentThreadErrorCopyWith<$Res> {
  _$CommentThreadErrorCopyWithImpl(this._self, this._then);

  final CommentThreadError _self;
  final $Res Function(CommentThreadError) _then;

  /// Create a copy of CommentThreadState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? code = null,
    Object? message = null,
  }) {
    return _then(CommentThreadError(
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
