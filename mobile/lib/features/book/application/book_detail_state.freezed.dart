// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'book_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BookDetailState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(Book book, LibraryCtaState libraryState) loaded,
    required TResult Function(String code, String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(Book book, LibraryCtaState libraryState)? loaded,
    TResult? Function(String code, String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(Book book, LibraryCtaState libraryState)? loaded,
    TResult Function(String code, String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BookDetailLoading value) loading,
    required TResult Function(BookDetailLoaded value) loaded,
    required TResult Function(BookDetailError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BookDetailLoading value)? loading,
    TResult? Function(BookDetailLoaded value)? loaded,
    TResult? Function(BookDetailError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BookDetailLoading value)? loading,
    TResult Function(BookDetailLoaded value)? loaded,
    TResult Function(BookDetailError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookDetailStateCopyWith<$Res> {
  factory $BookDetailStateCopyWith(
          BookDetailState value, $Res Function(BookDetailState) then) =
      _$BookDetailStateCopyWithImpl<$Res, BookDetailState>;
}

/// @nodoc
class _$BookDetailStateCopyWithImpl<$Res, $Val extends BookDetailState>
    implements $BookDetailStateCopyWith<$Res> {
  _$BookDetailStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookDetailState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$BookDetailLoadingImplCopyWith<$Res> {
  factory _$$BookDetailLoadingImplCopyWith(_$BookDetailLoadingImpl value,
          $Res Function(_$BookDetailLoadingImpl) then) =
      __$$BookDetailLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$BookDetailLoadingImplCopyWithImpl<$Res>
    extends _$BookDetailStateCopyWithImpl<$Res, _$BookDetailLoadingImpl>
    implements _$$BookDetailLoadingImplCopyWith<$Res> {
  __$$BookDetailLoadingImplCopyWithImpl(_$BookDetailLoadingImpl _value,
      $Res Function(_$BookDetailLoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of BookDetailState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$BookDetailLoadingImpl implements BookDetailLoading {
  const _$BookDetailLoadingImpl();

  @override
  String toString() {
    return 'BookDetailState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$BookDetailLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(Book book, LibraryCtaState libraryState) loaded,
    required TResult Function(String code, String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(Book book, LibraryCtaState libraryState)? loaded,
    TResult? Function(String code, String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(Book book, LibraryCtaState libraryState)? loaded,
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
    required TResult Function(BookDetailLoading value) loading,
    required TResult Function(BookDetailLoaded value) loaded,
    required TResult Function(BookDetailError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BookDetailLoading value)? loading,
    TResult? Function(BookDetailLoaded value)? loaded,
    TResult? Function(BookDetailError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BookDetailLoading value)? loading,
    TResult Function(BookDetailLoaded value)? loaded,
    TResult Function(BookDetailError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class BookDetailLoading implements BookDetailState {
  const factory BookDetailLoading() = _$BookDetailLoadingImpl;
}

/// @nodoc
abstract class _$$BookDetailLoadedImplCopyWith<$Res> {
  factory _$$BookDetailLoadedImplCopyWith(_$BookDetailLoadedImpl value,
          $Res Function(_$BookDetailLoadedImpl) then) =
      __$$BookDetailLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Book book, LibraryCtaState libraryState});

  $BookCopyWith<$Res> get book;
  $LibraryCtaStateCopyWith<$Res> get libraryState;
}

/// @nodoc
class __$$BookDetailLoadedImplCopyWithImpl<$Res>
    extends _$BookDetailStateCopyWithImpl<$Res, _$BookDetailLoadedImpl>
    implements _$$BookDetailLoadedImplCopyWith<$Res> {
  __$$BookDetailLoadedImplCopyWithImpl(_$BookDetailLoadedImpl _value,
      $Res Function(_$BookDetailLoadedImpl) _then)
      : super(_value, _then);

  /// Create a copy of BookDetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? book = null,
    Object? libraryState = null,
  }) {
    return _then(_$BookDetailLoadedImpl(
      book: null == book
          ? _value.book
          : book // ignore: cast_nullable_to_non_nullable
              as Book,
      libraryState: null == libraryState
          ? _value.libraryState
          : libraryState // ignore: cast_nullable_to_non_nullable
              as LibraryCtaState,
    ));
  }

  /// Create a copy of BookDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BookCopyWith<$Res> get book {
    return $BookCopyWith<$Res>(_value.book, (value) {
      return _then(_value.copyWith(book: value));
    });
  }

  /// Create a copy of BookDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LibraryCtaStateCopyWith<$Res> get libraryState {
    return $LibraryCtaStateCopyWith<$Res>(_value.libraryState, (value) {
      return _then(_value.copyWith(libraryState: value));
    });
  }
}

/// @nodoc

class _$BookDetailLoadedImpl implements BookDetailLoaded {
  const _$BookDetailLoadedImpl(
      {required this.book, this.libraryState = const LibraryCtaIdle()});

  @override
  final Book book;
  @override
  @JsonKey()
  final LibraryCtaState libraryState;

  @override
  String toString() {
    return 'BookDetailState.loaded(book: $book, libraryState: $libraryState)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookDetailLoadedImpl &&
            (identical(other.book, book) || other.book == book) &&
            (identical(other.libraryState, libraryState) ||
                other.libraryState == libraryState));
  }

  @override
  int get hashCode => Object.hash(runtimeType, book, libraryState);

  /// Create a copy of BookDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookDetailLoadedImplCopyWith<_$BookDetailLoadedImpl> get copyWith =>
      __$$BookDetailLoadedImplCopyWithImpl<_$BookDetailLoadedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(Book book, LibraryCtaState libraryState) loaded,
    required TResult Function(String code, String message) error,
  }) {
    return loaded(book, libraryState);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(Book book, LibraryCtaState libraryState)? loaded,
    TResult? Function(String code, String message)? error,
  }) {
    return loaded?.call(book, libraryState);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(Book book, LibraryCtaState libraryState)? loaded,
    TResult Function(String code, String message)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(book, libraryState);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(BookDetailLoading value) loading,
    required TResult Function(BookDetailLoaded value) loaded,
    required TResult Function(BookDetailError value) error,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BookDetailLoading value)? loading,
    TResult? Function(BookDetailLoaded value)? loaded,
    TResult? Function(BookDetailError value)? error,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BookDetailLoading value)? loading,
    TResult Function(BookDetailLoaded value)? loaded,
    TResult Function(BookDetailError value)? error,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class BookDetailLoaded implements BookDetailState {
  const factory BookDetailLoaded(
      {required final Book book,
      final LibraryCtaState libraryState}) = _$BookDetailLoadedImpl;

  Book get book;
  LibraryCtaState get libraryState;

  /// Create a copy of BookDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookDetailLoadedImplCopyWith<_$BookDetailLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BookDetailErrorImplCopyWith<$Res> {
  factory _$$BookDetailErrorImplCopyWith(_$BookDetailErrorImpl value,
          $Res Function(_$BookDetailErrorImpl) then) =
      __$$BookDetailErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String code, String message});
}

/// @nodoc
class __$$BookDetailErrorImplCopyWithImpl<$Res>
    extends _$BookDetailStateCopyWithImpl<$Res, _$BookDetailErrorImpl>
    implements _$$BookDetailErrorImplCopyWith<$Res> {
  __$$BookDetailErrorImplCopyWithImpl(
      _$BookDetailErrorImpl _value, $Res Function(_$BookDetailErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of BookDetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? message = null,
  }) {
    return _then(_$BookDetailErrorImpl(
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

class _$BookDetailErrorImpl implements BookDetailError {
  const _$BookDetailErrorImpl({required this.code, required this.message});

  @override
  final String code;
  @override
  final String message;

  @override
  String toString() {
    return 'BookDetailState.error(code: $code, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookDetailErrorImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, code, message);

  /// Create a copy of BookDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookDetailErrorImplCopyWith<_$BookDetailErrorImpl> get copyWith =>
      __$$BookDetailErrorImplCopyWithImpl<_$BookDetailErrorImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(Book book, LibraryCtaState libraryState) loaded,
    required TResult Function(String code, String message) error,
  }) {
    return error(code, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(Book book, LibraryCtaState libraryState)? loaded,
    TResult? Function(String code, String message)? error,
  }) {
    return error?.call(code, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(Book book, LibraryCtaState libraryState)? loaded,
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
    required TResult Function(BookDetailLoading value) loading,
    required TResult Function(BookDetailLoaded value) loaded,
    required TResult Function(BookDetailError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(BookDetailLoading value)? loading,
    TResult? Function(BookDetailLoaded value)? loaded,
    TResult? Function(BookDetailError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(BookDetailLoading value)? loading,
    TResult Function(BookDetailLoaded value)? loaded,
    TResult Function(BookDetailError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class BookDetailError implements BookDetailState {
  const factory BookDetailError(
      {required final String code,
      required final String message}) = _$BookDetailErrorImpl;

  String get code;
  String get message;

  /// Create a copy of BookDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookDetailErrorImplCopyWith<_$BookDetailErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$LibraryCtaState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() adding,
    required TResult Function(UserBook userBook) added,
    required TResult Function(String? duplicateUserBookId) duplicate,
    required TResult Function(String code, String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? adding,
    TResult? Function(UserBook userBook)? added,
    TResult? Function(String? duplicateUserBookId)? duplicate,
    TResult? Function(String code, String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? adding,
    TResult Function(UserBook userBook)? added,
    TResult Function(String? duplicateUserBookId)? duplicate,
    TResult Function(String code, String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LibraryCtaIdle value) idle,
    required TResult Function(LibraryCtaAdding value) adding,
    required TResult Function(LibraryCtaAdded value) added,
    required TResult Function(LibraryCtaDuplicate value) duplicate,
    required TResult Function(LibraryCtaError value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LibraryCtaIdle value)? idle,
    TResult? Function(LibraryCtaAdding value)? adding,
    TResult? Function(LibraryCtaAdded value)? added,
    TResult? Function(LibraryCtaDuplicate value)? duplicate,
    TResult? Function(LibraryCtaError value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LibraryCtaIdle value)? idle,
    TResult Function(LibraryCtaAdding value)? adding,
    TResult Function(LibraryCtaAdded value)? added,
    TResult Function(LibraryCtaDuplicate value)? duplicate,
    TResult Function(LibraryCtaError value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LibraryCtaStateCopyWith<$Res> {
  factory $LibraryCtaStateCopyWith(
          LibraryCtaState value, $Res Function(LibraryCtaState) then) =
      _$LibraryCtaStateCopyWithImpl<$Res, LibraryCtaState>;
}

/// @nodoc
class _$LibraryCtaStateCopyWithImpl<$Res, $Val extends LibraryCtaState>
    implements $LibraryCtaStateCopyWith<$Res> {
  _$LibraryCtaStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LibraryCtaState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$LibraryCtaIdleImplCopyWith<$Res> {
  factory _$$LibraryCtaIdleImplCopyWith(_$LibraryCtaIdleImpl value,
          $Res Function(_$LibraryCtaIdleImpl) then) =
      __$$LibraryCtaIdleImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LibraryCtaIdleImplCopyWithImpl<$Res>
    extends _$LibraryCtaStateCopyWithImpl<$Res, _$LibraryCtaIdleImpl>
    implements _$$LibraryCtaIdleImplCopyWith<$Res> {
  __$$LibraryCtaIdleImplCopyWithImpl(
      _$LibraryCtaIdleImpl _value, $Res Function(_$LibraryCtaIdleImpl) _then)
      : super(_value, _then);

  /// Create a copy of LibraryCtaState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LibraryCtaIdleImpl implements LibraryCtaIdle {
  const _$LibraryCtaIdleImpl();

  @override
  String toString() {
    return 'LibraryCtaState.idle()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LibraryCtaIdleImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() adding,
    required TResult Function(UserBook userBook) added,
    required TResult Function(String? duplicateUserBookId) duplicate,
    required TResult Function(String code, String message) error,
  }) {
    return idle();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? adding,
    TResult? Function(UserBook userBook)? added,
    TResult? Function(String? duplicateUserBookId)? duplicate,
    TResult? Function(String code, String message)? error,
  }) {
    return idle?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? adding,
    TResult Function(UserBook userBook)? added,
    TResult Function(String? duplicateUserBookId)? duplicate,
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
    required TResult Function(LibraryCtaIdle value) idle,
    required TResult Function(LibraryCtaAdding value) adding,
    required TResult Function(LibraryCtaAdded value) added,
    required TResult Function(LibraryCtaDuplicate value) duplicate,
    required TResult Function(LibraryCtaError value) error,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LibraryCtaIdle value)? idle,
    TResult? Function(LibraryCtaAdding value)? adding,
    TResult? Function(LibraryCtaAdded value)? added,
    TResult? Function(LibraryCtaDuplicate value)? duplicate,
    TResult? Function(LibraryCtaError value)? error,
  }) {
    return idle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LibraryCtaIdle value)? idle,
    TResult Function(LibraryCtaAdding value)? adding,
    TResult Function(LibraryCtaAdded value)? added,
    TResult Function(LibraryCtaDuplicate value)? duplicate,
    TResult Function(LibraryCtaError value)? error,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }
}

abstract class LibraryCtaIdle implements LibraryCtaState {
  const factory LibraryCtaIdle() = _$LibraryCtaIdleImpl;
}

/// @nodoc
abstract class _$$LibraryCtaAddingImplCopyWith<$Res> {
  factory _$$LibraryCtaAddingImplCopyWith(_$LibraryCtaAddingImpl value,
          $Res Function(_$LibraryCtaAddingImpl) then) =
      __$$LibraryCtaAddingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LibraryCtaAddingImplCopyWithImpl<$Res>
    extends _$LibraryCtaStateCopyWithImpl<$Res, _$LibraryCtaAddingImpl>
    implements _$$LibraryCtaAddingImplCopyWith<$Res> {
  __$$LibraryCtaAddingImplCopyWithImpl(_$LibraryCtaAddingImpl _value,
      $Res Function(_$LibraryCtaAddingImpl) _then)
      : super(_value, _then);

  /// Create a copy of LibraryCtaState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LibraryCtaAddingImpl implements LibraryCtaAdding {
  const _$LibraryCtaAddingImpl();

  @override
  String toString() {
    return 'LibraryCtaState.adding()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LibraryCtaAddingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() adding,
    required TResult Function(UserBook userBook) added,
    required TResult Function(String? duplicateUserBookId) duplicate,
    required TResult Function(String code, String message) error,
  }) {
    return adding();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? adding,
    TResult? Function(UserBook userBook)? added,
    TResult? Function(String? duplicateUserBookId)? duplicate,
    TResult? Function(String code, String message)? error,
  }) {
    return adding?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? adding,
    TResult Function(UserBook userBook)? added,
    TResult Function(String? duplicateUserBookId)? duplicate,
    TResult Function(String code, String message)? error,
    required TResult orElse(),
  }) {
    if (adding != null) {
      return adding();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LibraryCtaIdle value) idle,
    required TResult Function(LibraryCtaAdding value) adding,
    required TResult Function(LibraryCtaAdded value) added,
    required TResult Function(LibraryCtaDuplicate value) duplicate,
    required TResult Function(LibraryCtaError value) error,
  }) {
    return adding(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LibraryCtaIdle value)? idle,
    TResult? Function(LibraryCtaAdding value)? adding,
    TResult? Function(LibraryCtaAdded value)? added,
    TResult? Function(LibraryCtaDuplicate value)? duplicate,
    TResult? Function(LibraryCtaError value)? error,
  }) {
    return adding?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LibraryCtaIdle value)? idle,
    TResult Function(LibraryCtaAdding value)? adding,
    TResult Function(LibraryCtaAdded value)? added,
    TResult Function(LibraryCtaDuplicate value)? duplicate,
    TResult Function(LibraryCtaError value)? error,
    required TResult orElse(),
  }) {
    if (adding != null) {
      return adding(this);
    }
    return orElse();
  }
}

abstract class LibraryCtaAdding implements LibraryCtaState {
  const factory LibraryCtaAdding() = _$LibraryCtaAddingImpl;
}

/// @nodoc
abstract class _$$LibraryCtaAddedImplCopyWith<$Res> {
  factory _$$LibraryCtaAddedImplCopyWith(_$LibraryCtaAddedImpl value,
          $Res Function(_$LibraryCtaAddedImpl) then) =
      __$$LibraryCtaAddedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({UserBook userBook});

  $UserBookCopyWith<$Res> get userBook;
}

/// @nodoc
class __$$LibraryCtaAddedImplCopyWithImpl<$Res>
    extends _$LibraryCtaStateCopyWithImpl<$Res, _$LibraryCtaAddedImpl>
    implements _$$LibraryCtaAddedImplCopyWith<$Res> {
  __$$LibraryCtaAddedImplCopyWithImpl(
      _$LibraryCtaAddedImpl _value, $Res Function(_$LibraryCtaAddedImpl) _then)
      : super(_value, _then);

  /// Create a copy of LibraryCtaState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userBook = null,
  }) {
    return _then(_$LibraryCtaAddedImpl(
      userBook: null == userBook
          ? _value.userBook
          : userBook // ignore: cast_nullable_to_non_nullable
              as UserBook,
    ));
  }

  /// Create a copy of LibraryCtaState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserBookCopyWith<$Res> get userBook {
    return $UserBookCopyWith<$Res>(_value.userBook, (value) {
      return _then(_value.copyWith(userBook: value));
    });
  }
}

/// @nodoc

class _$LibraryCtaAddedImpl implements LibraryCtaAdded {
  const _$LibraryCtaAddedImpl({required this.userBook});

  @override
  final UserBook userBook;

  @override
  String toString() {
    return 'LibraryCtaState.added(userBook: $userBook)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LibraryCtaAddedImpl &&
            (identical(other.userBook, userBook) ||
                other.userBook == userBook));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userBook);

  /// Create a copy of LibraryCtaState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LibraryCtaAddedImplCopyWith<_$LibraryCtaAddedImpl> get copyWith =>
      __$$LibraryCtaAddedImplCopyWithImpl<_$LibraryCtaAddedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() adding,
    required TResult Function(UserBook userBook) added,
    required TResult Function(String? duplicateUserBookId) duplicate,
    required TResult Function(String code, String message) error,
  }) {
    return added(userBook);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? adding,
    TResult? Function(UserBook userBook)? added,
    TResult? Function(String? duplicateUserBookId)? duplicate,
    TResult? Function(String code, String message)? error,
  }) {
    return added?.call(userBook);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? adding,
    TResult Function(UserBook userBook)? added,
    TResult Function(String? duplicateUserBookId)? duplicate,
    TResult Function(String code, String message)? error,
    required TResult orElse(),
  }) {
    if (added != null) {
      return added(userBook);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LibraryCtaIdle value) idle,
    required TResult Function(LibraryCtaAdding value) adding,
    required TResult Function(LibraryCtaAdded value) added,
    required TResult Function(LibraryCtaDuplicate value) duplicate,
    required TResult Function(LibraryCtaError value) error,
  }) {
    return added(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LibraryCtaIdle value)? idle,
    TResult? Function(LibraryCtaAdding value)? adding,
    TResult? Function(LibraryCtaAdded value)? added,
    TResult? Function(LibraryCtaDuplicate value)? duplicate,
    TResult? Function(LibraryCtaError value)? error,
  }) {
    return added?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LibraryCtaIdle value)? idle,
    TResult Function(LibraryCtaAdding value)? adding,
    TResult Function(LibraryCtaAdded value)? added,
    TResult Function(LibraryCtaDuplicate value)? duplicate,
    TResult Function(LibraryCtaError value)? error,
    required TResult orElse(),
  }) {
    if (added != null) {
      return added(this);
    }
    return orElse();
  }
}

abstract class LibraryCtaAdded implements LibraryCtaState {
  const factory LibraryCtaAdded({required final UserBook userBook}) =
      _$LibraryCtaAddedImpl;

  UserBook get userBook;

  /// Create a copy of LibraryCtaState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LibraryCtaAddedImplCopyWith<_$LibraryCtaAddedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LibraryCtaDuplicateImplCopyWith<$Res> {
  factory _$$LibraryCtaDuplicateImplCopyWith(_$LibraryCtaDuplicateImpl value,
          $Res Function(_$LibraryCtaDuplicateImpl) then) =
      __$$LibraryCtaDuplicateImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String? duplicateUserBookId});
}

/// @nodoc
class __$$LibraryCtaDuplicateImplCopyWithImpl<$Res>
    extends _$LibraryCtaStateCopyWithImpl<$Res, _$LibraryCtaDuplicateImpl>
    implements _$$LibraryCtaDuplicateImplCopyWith<$Res> {
  __$$LibraryCtaDuplicateImplCopyWithImpl(_$LibraryCtaDuplicateImpl _value,
      $Res Function(_$LibraryCtaDuplicateImpl) _then)
      : super(_value, _then);

  /// Create a copy of LibraryCtaState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? duplicateUserBookId = freezed,
  }) {
    return _then(_$LibraryCtaDuplicateImpl(
      duplicateUserBookId: freezed == duplicateUserBookId
          ? _value.duplicateUserBookId
          : duplicateUserBookId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$LibraryCtaDuplicateImpl implements LibraryCtaDuplicate {
  const _$LibraryCtaDuplicateImpl({this.duplicateUserBookId});

  @override
  final String? duplicateUserBookId;

  @override
  String toString() {
    return 'LibraryCtaState.duplicate(duplicateUserBookId: $duplicateUserBookId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LibraryCtaDuplicateImpl &&
            (identical(other.duplicateUserBookId, duplicateUserBookId) ||
                other.duplicateUserBookId == duplicateUserBookId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, duplicateUserBookId);

  /// Create a copy of LibraryCtaState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LibraryCtaDuplicateImplCopyWith<_$LibraryCtaDuplicateImpl> get copyWith =>
      __$$LibraryCtaDuplicateImplCopyWithImpl<_$LibraryCtaDuplicateImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() adding,
    required TResult Function(UserBook userBook) added,
    required TResult Function(String? duplicateUserBookId) duplicate,
    required TResult Function(String code, String message) error,
  }) {
    return duplicate(duplicateUserBookId);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? adding,
    TResult? Function(UserBook userBook)? added,
    TResult? Function(String? duplicateUserBookId)? duplicate,
    TResult? Function(String code, String message)? error,
  }) {
    return duplicate?.call(duplicateUserBookId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? adding,
    TResult Function(UserBook userBook)? added,
    TResult Function(String? duplicateUserBookId)? duplicate,
    TResult Function(String code, String message)? error,
    required TResult orElse(),
  }) {
    if (duplicate != null) {
      return duplicate(duplicateUserBookId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LibraryCtaIdle value) idle,
    required TResult Function(LibraryCtaAdding value) adding,
    required TResult Function(LibraryCtaAdded value) added,
    required TResult Function(LibraryCtaDuplicate value) duplicate,
    required TResult Function(LibraryCtaError value) error,
  }) {
    return duplicate(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LibraryCtaIdle value)? idle,
    TResult? Function(LibraryCtaAdding value)? adding,
    TResult? Function(LibraryCtaAdded value)? added,
    TResult? Function(LibraryCtaDuplicate value)? duplicate,
    TResult? Function(LibraryCtaError value)? error,
  }) {
    return duplicate?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LibraryCtaIdle value)? idle,
    TResult Function(LibraryCtaAdding value)? adding,
    TResult Function(LibraryCtaAdded value)? added,
    TResult Function(LibraryCtaDuplicate value)? duplicate,
    TResult Function(LibraryCtaError value)? error,
    required TResult orElse(),
  }) {
    if (duplicate != null) {
      return duplicate(this);
    }
    return orElse();
  }
}

abstract class LibraryCtaDuplicate implements LibraryCtaState {
  const factory LibraryCtaDuplicate({final String? duplicateUserBookId}) =
      _$LibraryCtaDuplicateImpl;

  String? get duplicateUserBookId;

  /// Create a copy of LibraryCtaState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LibraryCtaDuplicateImplCopyWith<_$LibraryCtaDuplicateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LibraryCtaErrorImplCopyWith<$Res> {
  factory _$$LibraryCtaErrorImplCopyWith(_$LibraryCtaErrorImpl value,
          $Res Function(_$LibraryCtaErrorImpl) then) =
      __$$LibraryCtaErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String code, String message});
}

/// @nodoc
class __$$LibraryCtaErrorImplCopyWithImpl<$Res>
    extends _$LibraryCtaStateCopyWithImpl<$Res, _$LibraryCtaErrorImpl>
    implements _$$LibraryCtaErrorImplCopyWith<$Res> {
  __$$LibraryCtaErrorImplCopyWithImpl(
      _$LibraryCtaErrorImpl _value, $Res Function(_$LibraryCtaErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of LibraryCtaState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? message = null,
  }) {
    return _then(_$LibraryCtaErrorImpl(
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

class _$LibraryCtaErrorImpl implements LibraryCtaError {
  const _$LibraryCtaErrorImpl({required this.code, required this.message});

  @override
  final String code;
  @override
  final String message;

  @override
  String toString() {
    return 'LibraryCtaState.error(code: $code, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LibraryCtaErrorImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, code, message);

  /// Create a copy of LibraryCtaState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LibraryCtaErrorImplCopyWith<_$LibraryCtaErrorImpl> get copyWith =>
      __$$LibraryCtaErrorImplCopyWithImpl<_$LibraryCtaErrorImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() adding,
    required TResult Function(UserBook userBook) added,
    required TResult Function(String? duplicateUserBookId) duplicate,
    required TResult Function(String code, String message) error,
  }) {
    return error(code, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? adding,
    TResult? Function(UserBook userBook)? added,
    TResult? Function(String? duplicateUserBookId)? duplicate,
    TResult? Function(String code, String message)? error,
  }) {
    return error?.call(code, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? adding,
    TResult Function(UserBook userBook)? added,
    TResult Function(String? duplicateUserBookId)? duplicate,
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
    required TResult Function(LibraryCtaIdle value) idle,
    required TResult Function(LibraryCtaAdding value) adding,
    required TResult Function(LibraryCtaAdded value) added,
    required TResult Function(LibraryCtaDuplicate value) duplicate,
    required TResult Function(LibraryCtaError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LibraryCtaIdle value)? idle,
    TResult? Function(LibraryCtaAdding value)? adding,
    TResult? Function(LibraryCtaAdded value)? added,
    TResult? Function(LibraryCtaDuplicate value)? duplicate,
    TResult? Function(LibraryCtaError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LibraryCtaIdle value)? idle,
    TResult Function(LibraryCtaAdding value)? adding,
    TResult Function(LibraryCtaAdded value)? added,
    TResult Function(LibraryCtaDuplicate value)? duplicate,
    TResult Function(LibraryCtaError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class LibraryCtaError implements LibraryCtaState {
  const factory LibraryCtaError(
      {required final String code,
      required final String message}) = _$LibraryCtaErrorImpl;

  String get code;
  String get message;

  /// Create a copy of LibraryCtaState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LibraryCtaErrorImplCopyWith<_$LibraryCtaErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
