// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'book_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BookDetailState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is BookDetailState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'BookDetailState()';
  }
}

/// @nodoc
class $BookDetailStateCopyWith<$Res> {
  $BookDetailStateCopyWith(
      BookDetailState _, $Res Function(BookDetailState) __);
}

/// Adds pattern-matching-related methods to [BookDetailState].
extension BookDetailStatePatterns on BookDetailState {
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
    TResult Function(BookDetailLoading value)? loading,
    TResult Function(BookDetailLoaded value)? loaded,
    TResult Function(BookDetailError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case BookDetailLoading() when loading != null:
        return loading(_that);
      case BookDetailLoaded() when loaded != null:
        return loaded(_that);
      case BookDetailError() when error != null:
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
    required TResult Function(BookDetailLoading value) loading,
    required TResult Function(BookDetailLoaded value) loaded,
    required TResult Function(BookDetailError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case BookDetailLoading():
        return loading(_that);
      case BookDetailLoaded():
        return loaded(_that);
      case BookDetailError():
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
    TResult? Function(BookDetailLoading value)? loading,
    TResult? Function(BookDetailLoaded value)? loaded,
    TResult? Function(BookDetailError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case BookDetailLoading() when loading != null:
        return loading(_that);
      case BookDetailLoaded() when loaded != null:
        return loaded(_that);
      case BookDetailError() when error != null:
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
    TResult Function()? loading,
    TResult Function(Book book, LibraryCtaState libraryState)? loaded,
    TResult Function(String code, String message)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case BookDetailLoading() when loading != null:
        return loading();
      case BookDetailLoaded() when loaded != null:
        return loaded(_that.book, _that.libraryState);
      case BookDetailError() when error != null:
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
    required TResult Function() loading,
    required TResult Function(Book book, LibraryCtaState libraryState) loaded,
    required TResult Function(String code, String message) error,
  }) {
    final _that = this;
    switch (_that) {
      case BookDetailLoading():
        return loading();
      case BookDetailLoaded():
        return loaded(_that.book, _that.libraryState);
      case BookDetailError():
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
    TResult? Function()? loading,
    TResult? Function(Book book, LibraryCtaState libraryState)? loaded,
    TResult? Function(String code, String message)? error,
  }) {
    final _that = this;
    switch (_that) {
      case BookDetailLoading() when loading != null:
        return loading();
      case BookDetailLoaded() when loaded != null:
        return loaded(_that.book, _that.libraryState);
      case BookDetailError() when error != null:
        return error(_that.code, _that.message);
      case _:
        return null;
    }
  }
}

/// @nodoc

class BookDetailLoading implements BookDetailState {
  const BookDetailLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is BookDetailLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'BookDetailState.loading()';
  }
}

/// @nodoc

class BookDetailLoaded implements BookDetailState {
  const BookDetailLoaded(
      {required this.book, this.libraryState = const LibraryCtaIdle()});

  final Book book;
  @JsonKey()
  final LibraryCtaState libraryState;

  /// Create a copy of BookDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BookDetailLoadedCopyWith<BookDetailLoaded> get copyWith =>
      _$BookDetailLoadedCopyWithImpl<BookDetailLoaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BookDetailLoaded &&
            (identical(other.book, book) || other.book == book) &&
            (identical(other.libraryState, libraryState) ||
                other.libraryState == libraryState));
  }

  @override
  int get hashCode => Object.hash(runtimeType, book, libraryState);

  @override
  String toString() {
    return 'BookDetailState.loaded(book: $book, libraryState: $libraryState)';
  }
}

/// @nodoc
abstract mixin class $BookDetailLoadedCopyWith<$Res>
    implements $BookDetailStateCopyWith<$Res> {
  factory $BookDetailLoadedCopyWith(
          BookDetailLoaded value, $Res Function(BookDetailLoaded) _then) =
      _$BookDetailLoadedCopyWithImpl;
  @useResult
  $Res call({Book book, LibraryCtaState libraryState});

  $BookCopyWith<$Res> get book;
  $LibraryCtaStateCopyWith<$Res> get libraryState;
}

/// @nodoc
class _$BookDetailLoadedCopyWithImpl<$Res>
    implements $BookDetailLoadedCopyWith<$Res> {
  _$BookDetailLoadedCopyWithImpl(this._self, this._then);

  final BookDetailLoaded _self;
  final $Res Function(BookDetailLoaded) _then;

  /// Create a copy of BookDetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? book = null,
    Object? libraryState = null,
  }) {
    return _then(BookDetailLoaded(
      book: null == book
          ? _self.book
          : book // ignore: cast_nullable_to_non_nullable
              as Book,
      libraryState: null == libraryState
          ? _self.libraryState
          : libraryState // ignore: cast_nullable_to_non_nullable
              as LibraryCtaState,
    ));
  }

  /// Create a copy of BookDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BookCopyWith<$Res> get book {
    return $BookCopyWith<$Res>(_self.book, (value) {
      return _then(_self.copyWith(book: value));
    });
  }

  /// Create a copy of BookDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LibraryCtaStateCopyWith<$Res> get libraryState {
    return $LibraryCtaStateCopyWith<$Res>(_self.libraryState, (value) {
      return _then(_self.copyWith(libraryState: value));
    });
  }
}

/// @nodoc

class BookDetailError implements BookDetailState {
  const BookDetailError({required this.code, required this.message});

  final String code;
  final String message;

  /// Create a copy of BookDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BookDetailErrorCopyWith<BookDetailError> get copyWith =>
      _$BookDetailErrorCopyWithImpl<BookDetailError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BookDetailError &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, code, message);

  @override
  String toString() {
    return 'BookDetailState.error(code: $code, message: $message)';
  }
}

/// @nodoc
abstract mixin class $BookDetailErrorCopyWith<$Res>
    implements $BookDetailStateCopyWith<$Res> {
  factory $BookDetailErrorCopyWith(
          BookDetailError value, $Res Function(BookDetailError) _then) =
      _$BookDetailErrorCopyWithImpl;
  @useResult
  $Res call({String code, String message});
}

/// @nodoc
class _$BookDetailErrorCopyWithImpl<$Res>
    implements $BookDetailErrorCopyWith<$Res> {
  _$BookDetailErrorCopyWithImpl(this._self, this._then);

  final BookDetailError _self;
  final $Res Function(BookDetailError) _then;

  /// Create a copy of BookDetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? code = null,
    Object? message = null,
  }) {
    return _then(BookDetailError(
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

/// @nodoc
mixin _$LibraryCtaState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is LibraryCtaState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'LibraryCtaState()';
  }
}

/// @nodoc
class $LibraryCtaStateCopyWith<$Res> {
  $LibraryCtaStateCopyWith(
      LibraryCtaState _, $Res Function(LibraryCtaState) __);
}

/// Adds pattern-matching-related methods to [LibraryCtaState].
extension LibraryCtaStatePatterns on LibraryCtaState {
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
    TResult Function(LibraryCtaIdle value)? idle,
    TResult Function(LibraryCtaAdding value)? adding,
    TResult Function(LibraryCtaAdded value)? added,
    TResult Function(LibraryCtaDuplicate value)? duplicate,
    TResult Function(LibraryCtaError value)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case LibraryCtaIdle() when idle != null:
        return idle(_that);
      case LibraryCtaAdding() when adding != null:
        return adding(_that);
      case LibraryCtaAdded() when added != null:
        return added(_that);
      case LibraryCtaDuplicate() when duplicate != null:
        return duplicate(_that);
      case LibraryCtaError() when error != null:
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
    required TResult Function(LibraryCtaIdle value) idle,
    required TResult Function(LibraryCtaAdding value) adding,
    required TResult Function(LibraryCtaAdded value) added,
    required TResult Function(LibraryCtaDuplicate value) duplicate,
    required TResult Function(LibraryCtaError value) error,
  }) {
    final _that = this;
    switch (_that) {
      case LibraryCtaIdle():
        return idle(_that);
      case LibraryCtaAdding():
        return adding(_that);
      case LibraryCtaAdded():
        return added(_that);
      case LibraryCtaDuplicate():
        return duplicate(_that);
      case LibraryCtaError():
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
    TResult? Function(LibraryCtaIdle value)? idle,
    TResult? Function(LibraryCtaAdding value)? adding,
    TResult? Function(LibraryCtaAdded value)? added,
    TResult? Function(LibraryCtaDuplicate value)? duplicate,
    TResult? Function(LibraryCtaError value)? error,
  }) {
    final _that = this;
    switch (_that) {
      case LibraryCtaIdle() when idle != null:
        return idle(_that);
      case LibraryCtaAdding() when adding != null:
        return adding(_that);
      case LibraryCtaAdded() when added != null:
        return added(_that);
      case LibraryCtaDuplicate() when duplicate != null:
        return duplicate(_that);
      case LibraryCtaError() when error != null:
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
    TResult Function()? adding,
    TResult Function(UserBook userBook)? added,
    TResult Function(String? duplicateUserBookId)? duplicate,
    TResult Function(String code, String message)? error,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case LibraryCtaIdle() when idle != null:
        return idle();
      case LibraryCtaAdding() when adding != null:
        return adding();
      case LibraryCtaAdded() when added != null:
        return added(_that.userBook);
      case LibraryCtaDuplicate() when duplicate != null:
        return duplicate(_that.duplicateUserBookId);
      case LibraryCtaError() when error != null:
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
    required TResult Function() adding,
    required TResult Function(UserBook userBook) added,
    required TResult Function(String? duplicateUserBookId) duplicate,
    required TResult Function(String code, String message) error,
  }) {
    final _that = this;
    switch (_that) {
      case LibraryCtaIdle():
        return idle();
      case LibraryCtaAdding():
        return adding();
      case LibraryCtaAdded():
        return added(_that.userBook);
      case LibraryCtaDuplicate():
        return duplicate(_that.duplicateUserBookId);
      case LibraryCtaError():
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
    TResult? Function()? adding,
    TResult? Function(UserBook userBook)? added,
    TResult? Function(String? duplicateUserBookId)? duplicate,
    TResult? Function(String code, String message)? error,
  }) {
    final _that = this;
    switch (_that) {
      case LibraryCtaIdle() when idle != null:
        return idle();
      case LibraryCtaAdding() when adding != null:
        return adding();
      case LibraryCtaAdded() when added != null:
        return added(_that.userBook);
      case LibraryCtaDuplicate() when duplicate != null:
        return duplicate(_that.duplicateUserBookId);
      case LibraryCtaError() when error != null:
        return error(_that.code, _that.message);
      case _:
        return null;
    }
  }
}

/// @nodoc

class LibraryCtaIdle implements LibraryCtaState {
  const LibraryCtaIdle();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is LibraryCtaIdle);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'LibraryCtaState.idle()';
  }
}

/// @nodoc

class LibraryCtaAdding implements LibraryCtaState {
  const LibraryCtaAdding();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is LibraryCtaAdding);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'LibraryCtaState.adding()';
  }
}

/// @nodoc

class LibraryCtaAdded implements LibraryCtaState {
  const LibraryCtaAdded({required this.userBook});

  final UserBook userBook;

  /// Create a copy of LibraryCtaState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LibraryCtaAddedCopyWith<LibraryCtaAdded> get copyWith =>
      _$LibraryCtaAddedCopyWithImpl<LibraryCtaAdded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LibraryCtaAdded &&
            (identical(other.userBook, userBook) ||
                other.userBook == userBook));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userBook);

  @override
  String toString() {
    return 'LibraryCtaState.added(userBook: $userBook)';
  }
}

/// @nodoc
abstract mixin class $LibraryCtaAddedCopyWith<$Res>
    implements $LibraryCtaStateCopyWith<$Res> {
  factory $LibraryCtaAddedCopyWith(
          LibraryCtaAdded value, $Res Function(LibraryCtaAdded) _then) =
      _$LibraryCtaAddedCopyWithImpl;
  @useResult
  $Res call({UserBook userBook});

  $UserBookCopyWith<$Res> get userBook;
}

/// @nodoc
class _$LibraryCtaAddedCopyWithImpl<$Res>
    implements $LibraryCtaAddedCopyWith<$Res> {
  _$LibraryCtaAddedCopyWithImpl(this._self, this._then);

  final LibraryCtaAdded _self;
  final $Res Function(LibraryCtaAdded) _then;

  /// Create a copy of LibraryCtaState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? userBook = null,
  }) {
    return _then(LibraryCtaAdded(
      userBook: null == userBook
          ? _self.userBook
          : userBook // ignore: cast_nullable_to_non_nullable
              as UserBook,
    ));
  }

  /// Create a copy of LibraryCtaState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserBookCopyWith<$Res> get userBook {
    return $UserBookCopyWith<$Res>(_self.userBook, (value) {
      return _then(_self.copyWith(userBook: value));
    });
  }
}

/// @nodoc

class LibraryCtaDuplicate implements LibraryCtaState {
  const LibraryCtaDuplicate({this.duplicateUserBookId});

  final String? duplicateUserBookId;

  /// Create a copy of LibraryCtaState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LibraryCtaDuplicateCopyWith<LibraryCtaDuplicate> get copyWith =>
      _$LibraryCtaDuplicateCopyWithImpl<LibraryCtaDuplicate>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LibraryCtaDuplicate &&
            (identical(other.duplicateUserBookId, duplicateUserBookId) ||
                other.duplicateUserBookId == duplicateUserBookId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, duplicateUserBookId);

  @override
  String toString() {
    return 'LibraryCtaState.duplicate(duplicateUserBookId: $duplicateUserBookId)';
  }
}

/// @nodoc
abstract mixin class $LibraryCtaDuplicateCopyWith<$Res>
    implements $LibraryCtaStateCopyWith<$Res> {
  factory $LibraryCtaDuplicateCopyWith(
          LibraryCtaDuplicate value, $Res Function(LibraryCtaDuplicate) _then) =
      _$LibraryCtaDuplicateCopyWithImpl;
  @useResult
  $Res call({String? duplicateUserBookId});
}

/// @nodoc
class _$LibraryCtaDuplicateCopyWithImpl<$Res>
    implements $LibraryCtaDuplicateCopyWith<$Res> {
  _$LibraryCtaDuplicateCopyWithImpl(this._self, this._then);

  final LibraryCtaDuplicate _self;
  final $Res Function(LibraryCtaDuplicate) _then;

  /// Create a copy of LibraryCtaState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? duplicateUserBookId = freezed,
  }) {
    return _then(LibraryCtaDuplicate(
      duplicateUserBookId: freezed == duplicateUserBookId
          ? _self.duplicateUserBookId
          : duplicateUserBookId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class LibraryCtaError implements LibraryCtaState {
  const LibraryCtaError({required this.code, required this.message});

  final String code;
  final String message;

  /// Create a copy of LibraryCtaState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LibraryCtaErrorCopyWith<LibraryCtaError> get copyWith =>
      _$LibraryCtaErrorCopyWithImpl<LibraryCtaError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LibraryCtaError &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, code, message);

  @override
  String toString() {
    return 'LibraryCtaState.error(code: $code, message: $message)';
  }
}

/// @nodoc
abstract mixin class $LibraryCtaErrorCopyWith<$Res>
    implements $LibraryCtaStateCopyWith<$Res> {
  factory $LibraryCtaErrorCopyWith(
          LibraryCtaError value, $Res Function(LibraryCtaError) _then) =
      _$LibraryCtaErrorCopyWithImpl;
  @useResult
  $Res call({String code, String message});
}

/// @nodoc
class _$LibraryCtaErrorCopyWithImpl<$Res>
    implements $LibraryCtaErrorCopyWith<$Res> {
  _$LibraryCtaErrorCopyWithImpl(this._self, this._then);

  final LibraryCtaError _self;
  final $Res Function(LibraryCtaError) _then;

  /// Create a copy of LibraryCtaState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? code = null,
    Object? message = null,
  }) {
    return _then(LibraryCtaError(
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
