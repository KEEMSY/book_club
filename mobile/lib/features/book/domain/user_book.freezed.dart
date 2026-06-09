// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_book.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserBook {
  String get id;
  Book get book;
  BookStatus get status;
  DateTime? get startedAt;
  DateTime? get finishedAt;
  int? get rating;
  String? get oneLineReview;
  int get currentChapter;

  /// Create a copy of UserBook
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserBookCopyWith<UserBook> get copyWith =>
      _$UserBookCopyWithImpl<UserBook>(this as UserBook, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserBook &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.book, book) || other.book == book) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.finishedAt, finishedAt) ||
                other.finishedAt == finishedAt) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.oneLineReview, oneLineReview) ||
                other.oneLineReview == oneLineReview) &&
            (identical(other.currentChapter, currentChapter) ||
                other.currentChapter == currentChapter));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, book, status, startedAt,
      finishedAt, rating, oneLineReview, currentChapter);

  @override
  String toString() {
    return 'UserBook(id: $id, book: $book, status: $status, startedAt: $startedAt, finishedAt: $finishedAt, rating: $rating, oneLineReview: $oneLineReview, currentChapter: $currentChapter)';
  }
}

/// @nodoc
abstract mixin class $UserBookCopyWith<$Res> {
  factory $UserBookCopyWith(UserBook value, $Res Function(UserBook) _then) =
      _$UserBookCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      Book book,
      BookStatus status,
      DateTime? startedAt,
      DateTime? finishedAt,
      int? rating,
      String? oneLineReview,
      int currentChapter});

  $BookCopyWith<$Res> get book;
}

/// @nodoc
class _$UserBookCopyWithImpl<$Res> implements $UserBookCopyWith<$Res> {
  _$UserBookCopyWithImpl(this._self, this._then);

  final UserBook _self;
  final $Res Function(UserBook) _then;

  /// Create a copy of UserBook
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? book = null,
    Object? status = null,
    Object? startedAt = freezed,
    Object? finishedAt = freezed,
    Object? rating = freezed,
    Object? oneLineReview = freezed,
    Object? currentChapter = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      book: null == book
          ? _self.book
          : book // ignore: cast_nullable_to_non_nullable
              as Book,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as BookStatus,
      startedAt: freezed == startedAt
          ? _self.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      finishedAt: freezed == finishedAt
          ? _self.finishedAt
          : finishedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      rating: freezed == rating
          ? _self.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as int?,
      oneLineReview: freezed == oneLineReview
          ? _self.oneLineReview
          : oneLineReview // ignore: cast_nullable_to_non_nullable
              as String?,
      currentChapter: null == currentChapter
          ? _self.currentChapter
          : currentChapter // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }

  /// Create a copy of UserBook
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BookCopyWith<$Res> get book {
    return $BookCopyWith<$Res>(_self.book, (value) {
      return _then(_self.copyWith(book: value));
    });
  }
}

/// Adds pattern-matching-related methods to [UserBook].
extension UserBookPatterns on UserBook {
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
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_UserBook value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserBook() when $default != null:
        return $default(_that);
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
  TResult map<TResult extends Object?>(
    TResult Function(_UserBook value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserBook():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
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
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_UserBook value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserBook() when $default != null:
        return $default(_that);
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
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            Book book,
            BookStatus status,
            DateTime? startedAt,
            DateTime? finishedAt,
            int? rating,
            String? oneLineReview,
            int currentChapter)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserBook() when $default != null:
        return $default(
            _that.id,
            _that.book,
            _that.status,
            _that.startedAt,
            _that.finishedAt,
            _that.rating,
            _that.oneLineReview,
            _that.currentChapter);
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
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            Book book,
            BookStatus status,
            DateTime? startedAt,
            DateTime? finishedAt,
            int? rating,
            String? oneLineReview,
            int currentChapter)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserBook():
        return $default(
            _that.id,
            _that.book,
            _that.status,
            _that.startedAt,
            _that.finishedAt,
            _that.rating,
            _that.oneLineReview,
            _that.currentChapter);
      case _:
        throw StateError('Unexpected subclass');
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
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            Book book,
            BookStatus status,
            DateTime? startedAt,
            DateTime? finishedAt,
            int? rating,
            String? oneLineReview,
            int currentChapter)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserBook() when $default != null:
        return $default(
            _that.id,
            _that.book,
            _that.status,
            _that.startedAt,
            _that.finishedAt,
            _that.rating,
            _that.oneLineReview,
            _that.currentChapter);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _UserBook implements UserBook {
  const _UserBook(
      {required this.id,
      required this.book,
      required this.status,
      this.startedAt,
      this.finishedAt,
      this.rating,
      this.oneLineReview,
      this.currentChapter = 0});

  @override
  final String id;
  @override
  final Book book;
  @override
  final BookStatus status;
  @override
  final DateTime? startedAt;
  @override
  final DateTime? finishedAt;
  @override
  final int? rating;
  @override
  final String? oneLineReview;
  @override
  @JsonKey()
  final int currentChapter;

  /// Create a copy of UserBook
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserBookCopyWith<_UserBook> get copyWith =>
      __$UserBookCopyWithImpl<_UserBook>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserBook &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.book, book) || other.book == book) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.finishedAt, finishedAt) ||
                other.finishedAt == finishedAt) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.oneLineReview, oneLineReview) ||
                other.oneLineReview == oneLineReview) &&
            (identical(other.currentChapter, currentChapter) ||
                other.currentChapter == currentChapter));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, book, status, startedAt,
      finishedAt, rating, oneLineReview, currentChapter);

  @override
  String toString() {
    return 'UserBook(id: $id, book: $book, status: $status, startedAt: $startedAt, finishedAt: $finishedAt, rating: $rating, oneLineReview: $oneLineReview, currentChapter: $currentChapter)';
  }
}

/// @nodoc
abstract mixin class _$UserBookCopyWith<$Res>
    implements $UserBookCopyWith<$Res> {
  factory _$UserBookCopyWith(_UserBook value, $Res Function(_UserBook) _then) =
      __$UserBookCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      Book book,
      BookStatus status,
      DateTime? startedAt,
      DateTime? finishedAt,
      int? rating,
      String? oneLineReview,
      int currentChapter});

  @override
  $BookCopyWith<$Res> get book;
}

/// @nodoc
class __$UserBookCopyWithImpl<$Res> implements _$UserBookCopyWith<$Res> {
  __$UserBookCopyWithImpl(this._self, this._then);

  final _UserBook _self;
  final $Res Function(_UserBook) _then;

  /// Create a copy of UserBook
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? book = null,
    Object? status = null,
    Object? startedAt = freezed,
    Object? finishedAt = freezed,
    Object? rating = freezed,
    Object? oneLineReview = freezed,
    Object? currentChapter = null,
  }) {
    return _then(_UserBook(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      book: null == book
          ? _self.book
          : book // ignore: cast_nullable_to_non_nullable
              as Book,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as BookStatus,
      startedAt: freezed == startedAt
          ? _self.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      finishedAt: freezed == finishedAt
          ? _self.finishedAt
          : finishedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      rating: freezed == rating
          ? _self.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as int?,
      oneLineReview: freezed == oneLineReview
          ? _self.oneLineReview
          : oneLineReview // ignore: cast_nullable_to_non_nullable
              as String?,
      currentChapter: null == currentChapter
          ? _self.currentChapter
          : currentChapter // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }

  /// Create a copy of UserBook
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BookCopyWith<$Res> get book {
    return $BookCopyWith<$Res>(_self.book, (value) {
      return _then(_self.copyWith(book: value));
    });
  }
}

// dart format on
