// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'book_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BookDto {
  String get id;
  String get isbn13;
  String get title;
  String get author;
  String get publisher;
  String? get coverUrl;
  String? get description;

  /// Create a copy of BookDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BookDtoCopyWith<BookDto> get copyWith =>
      _$BookDtoCopyWithImpl<BookDto>(this as BookDto, _$identity);

  /// Serializes this BookDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BookDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.isbn13, isbn13) || other.isbn13 == isbn13) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.publisher, publisher) ||
                other.publisher == publisher) &&
            (identical(other.coverUrl, coverUrl) ||
                other.coverUrl == coverUrl) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, isbn13, title, author, publisher, coverUrl, description);

  @override
  String toString() {
    return 'BookDto(id: $id, isbn13: $isbn13, title: $title, author: $author, publisher: $publisher, coverUrl: $coverUrl, description: $description)';
  }
}

/// @nodoc
abstract mixin class $BookDtoCopyWith<$Res> {
  factory $BookDtoCopyWith(BookDto value, $Res Function(BookDto) _then) =
      _$BookDtoCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String isbn13,
      String title,
      String author,
      String publisher,
      String? coverUrl,
      String? description});
}

/// @nodoc
class _$BookDtoCopyWithImpl<$Res> implements $BookDtoCopyWith<$Res> {
  _$BookDtoCopyWithImpl(this._self, this._then);

  final BookDto _self;
  final $Res Function(BookDto) _then;

  /// Create a copy of BookDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? isbn13 = null,
    Object? title = null,
    Object? author = null,
    Object? publisher = null,
    Object? coverUrl = freezed,
    Object? description = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      isbn13: null == isbn13
          ? _self.isbn13
          : isbn13 // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      author: null == author
          ? _self.author
          : author // ignore: cast_nullable_to_non_nullable
              as String,
      publisher: null == publisher
          ? _self.publisher
          : publisher // ignore: cast_nullable_to_non_nullable
              as String,
      coverUrl: freezed == coverUrl
          ? _self.coverUrl
          : coverUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [BookDto].
extension BookDtoPatterns on BookDto {
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
    TResult Function(_BookDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BookDto() when $default != null:
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
    TResult Function(_BookDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BookDto():
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
    TResult? Function(_BookDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BookDto() when $default != null:
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
    TResult Function(String id, String isbn13, String title, String author,
            String publisher, String? coverUrl, String? description)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BookDto() when $default != null:
        return $default(_that.id, _that.isbn13, _that.title, _that.author,
            _that.publisher, _that.coverUrl, _that.description);
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
    TResult Function(String id, String isbn13, String title, String author,
            String publisher, String? coverUrl, String? description)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BookDto():
        return $default(_that.id, _that.isbn13, _that.title, _that.author,
            _that.publisher, _that.coverUrl, _that.description);
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
    TResult? Function(String id, String isbn13, String title, String author,
            String publisher, String? coverUrl, String? description)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BookDto() when $default != null:
        return $default(_that.id, _that.isbn13, _that.title, _that.author,
            _that.publisher, _that.coverUrl, _that.description);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _BookDto extends BookDto {
  const _BookDto(
      {required this.id,
      required this.isbn13,
      required this.title,
      required this.author,
      required this.publisher,
      this.coverUrl,
      this.description})
      : super._();
  factory _BookDto.fromJson(Map<String, dynamic> json) =>
      _$BookDtoFromJson(json);

  @override
  final String id;
  @override
  final String isbn13;
  @override
  final String title;
  @override
  final String author;
  @override
  final String publisher;
  @override
  final String? coverUrl;
  @override
  final String? description;

  /// Create a copy of BookDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BookDtoCopyWith<_BookDto> get copyWith =>
      __$BookDtoCopyWithImpl<_BookDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BookDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BookDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.isbn13, isbn13) || other.isbn13 == isbn13) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.publisher, publisher) ||
                other.publisher == publisher) &&
            (identical(other.coverUrl, coverUrl) ||
                other.coverUrl == coverUrl) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, isbn13, title, author, publisher, coverUrl, description);

  @override
  String toString() {
    return 'BookDto(id: $id, isbn13: $isbn13, title: $title, author: $author, publisher: $publisher, coverUrl: $coverUrl, description: $description)';
  }
}

/// @nodoc
abstract mixin class _$BookDtoCopyWith<$Res> implements $BookDtoCopyWith<$Res> {
  factory _$BookDtoCopyWith(_BookDto value, $Res Function(_BookDto) _then) =
      __$BookDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String isbn13,
      String title,
      String author,
      String publisher,
      String? coverUrl,
      String? description});
}

/// @nodoc
class __$BookDtoCopyWithImpl<$Res> implements _$BookDtoCopyWith<$Res> {
  __$BookDtoCopyWithImpl(this._self, this._then);

  final _BookDto _self;
  final $Res Function(_BookDto) _then;

  /// Create a copy of BookDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? isbn13 = null,
    Object? title = null,
    Object? author = null,
    Object? publisher = null,
    Object? coverUrl = freezed,
    Object? description = freezed,
  }) {
    return _then(_BookDto(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      isbn13: null == isbn13
          ? _self.isbn13
          : isbn13 // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      author: null == author
          ? _self.author
          : author // ignore: cast_nullable_to_non_nullable
              as String,
      publisher: null == publisher
          ? _self.publisher
          : publisher // ignore: cast_nullable_to_non_nullable
              as String,
      coverUrl: freezed == coverUrl
          ? _self.coverUrl
          : coverUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$UserBookDto {
  String get id;
  BookDto get book;
  String get status;
  DateTime? get startedAt;
  DateTime? get finishedAt;
  int? get rating;
  String? get oneLineReview;

  /// Create a copy of UserBookDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserBookDtoCopyWith<UserBookDto> get copyWith =>
      _$UserBookDtoCopyWithImpl<UserBookDto>(this as UserBookDto, _$identity);

  /// Serializes this UserBookDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserBookDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.book, book) || other.book == book) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.finishedAt, finishedAt) ||
                other.finishedAt == finishedAt) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.oneLineReview, oneLineReview) ||
                other.oneLineReview == oneLineReview));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, book, status, startedAt,
      finishedAt, rating, oneLineReview);

  @override
  String toString() {
    return 'UserBookDto(id: $id, book: $book, status: $status, startedAt: $startedAt, finishedAt: $finishedAt, rating: $rating, oneLineReview: $oneLineReview)';
  }
}

/// @nodoc
abstract mixin class $UserBookDtoCopyWith<$Res> {
  factory $UserBookDtoCopyWith(
          UserBookDto value, $Res Function(UserBookDto) _then) =
      _$UserBookDtoCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      BookDto book,
      String status,
      DateTime? startedAt,
      DateTime? finishedAt,
      int? rating,
      String? oneLineReview});

  $BookDtoCopyWith<$Res> get book;
}

/// @nodoc
class _$UserBookDtoCopyWithImpl<$Res> implements $UserBookDtoCopyWith<$Res> {
  _$UserBookDtoCopyWithImpl(this._self, this._then);

  final UserBookDto _self;
  final $Res Function(UserBookDto) _then;

  /// Create a copy of UserBookDto
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
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      book: null == book
          ? _self.book
          : book // ignore: cast_nullable_to_non_nullable
              as BookDto,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
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
    ));
  }

  /// Create a copy of UserBookDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BookDtoCopyWith<$Res> get book {
    return $BookDtoCopyWith<$Res>(_self.book, (value) {
      return _then(_self.copyWith(book: value));
    });
  }
}

/// Adds pattern-matching-related methods to [UserBookDto].
extension UserBookDtoPatterns on UserBookDto {
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
    TResult Function(_UserBookDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserBookDto() when $default != null:
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
    TResult Function(_UserBookDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserBookDto():
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
    TResult? Function(_UserBookDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserBookDto() when $default != null:
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
            BookDto book,
            String status,
            DateTime? startedAt,
            DateTime? finishedAt,
            int? rating,
            String? oneLineReview)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserBookDto() when $default != null:
        return $default(_that.id, _that.book, _that.status, _that.startedAt,
            _that.finishedAt, _that.rating, _that.oneLineReview);
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
            BookDto book,
            String status,
            DateTime? startedAt,
            DateTime? finishedAt,
            int? rating,
            String? oneLineReview)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserBookDto():
        return $default(_that.id, _that.book, _that.status, _that.startedAt,
            _that.finishedAt, _that.rating, _that.oneLineReview);
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
            BookDto book,
            String status,
            DateTime? startedAt,
            DateTime? finishedAt,
            int? rating,
            String? oneLineReview)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserBookDto() when $default != null:
        return $default(_that.id, _that.book, _that.status, _that.startedAt,
            _that.finishedAt, _that.rating, _that.oneLineReview);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _UserBookDto extends UserBookDto {
  const _UserBookDto(
      {required this.id,
      required this.book,
      required this.status,
      this.startedAt,
      this.finishedAt,
      this.rating,
      this.oneLineReview})
      : super._();
  factory _UserBookDto.fromJson(Map<String, dynamic> json) =>
      _$UserBookDtoFromJson(json);

  @override
  final String id;
  @override
  final BookDto book;
  @override
  final String status;
  @override
  final DateTime? startedAt;
  @override
  final DateTime? finishedAt;
  @override
  final int? rating;
  @override
  final String? oneLineReview;

  /// Create a copy of UserBookDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserBookDtoCopyWith<_UserBookDto> get copyWith =>
      __$UserBookDtoCopyWithImpl<_UserBookDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UserBookDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserBookDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.book, book) || other.book == book) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.finishedAt, finishedAt) ||
                other.finishedAt == finishedAt) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.oneLineReview, oneLineReview) ||
                other.oneLineReview == oneLineReview));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, book, status, startedAt,
      finishedAt, rating, oneLineReview);

  @override
  String toString() {
    return 'UserBookDto(id: $id, book: $book, status: $status, startedAt: $startedAt, finishedAt: $finishedAt, rating: $rating, oneLineReview: $oneLineReview)';
  }
}

/// @nodoc
abstract mixin class _$UserBookDtoCopyWith<$Res>
    implements $UserBookDtoCopyWith<$Res> {
  factory _$UserBookDtoCopyWith(
          _UserBookDto value, $Res Function(_UserBookDto) _then) =
      __$UserBookDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      BookDto book,
      String status,
      DateTime? startedAt,
      DateTime? finishedAt,
      int? rating,
      String? oneLineReview});

  @override
  $BookDtoCopyWith<$Res> get book;
}

/// @nodoc
class __$UserBookDtoCopyWithImpl<$Res> implements _$UserBookDtoCopyWith<$Res> {
  __$UserBookDtoCopyWithImpl(this._self, this._then);

  final _UserBookDto _self;
  final $Res Function(_UserBookDto) _then;

  /// Create a copy of UserBookDto
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
  }) {
    return _then(_UserBookDto(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      book: null == book
          ? _self.book
          : book // ignore: cast_nullable_to_non_nullable
              as BookDto,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
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
    ));
  }

  /// Create a copy of UserBookDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BookDtoCopyWith<$Res> get book {
    return $BookDtoCopyWith<$Res>(_self.book, (value) {
      return _then(_self.copyWith(book: value));
    });
  }
}

/// @nodoc
mixin _$BookSearchResponse {
  List<BookDto> get items;
  int get page;
  int get size;
  bool get hasMore;

  /// Create a copy of BookSearchResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BookSearchResponseCopyWith<BookSearchResponse> get copyWith =>
      _$BookSearchResponseCopyWithImpl<BookSearchResponse>(
          this as BookSearchResponse, _$identity);

  /// Serializes this BookSearchResponse to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BookSearchResponse &&
            const DeepCollectionEquality().equals(other.items, items) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(items), page, size, hasMore);

  @override
  String toString() {
    return 'BookSearchResponse(items: $items, page: $page, size: $size, hasMore: $hasMore)';
  }
}

/// @nodoc
abstract mixin class $BookSearchResponseCopyWith<$Res> {
  factory $BookSearchResponseCopyWith(
          BookSearchResponse value, $Res Function(BookSearchResponse) _then) =
      _$BookSearchResponseCopyWithImpl;
  @useResult
  $Res call({List<BookDto> items, int page, int size, bool hasMore});
}

/// @nodoc
class _$BookSearchResponseCopyWithImpl<$Res>
    implements $BookSearchResponseCopyWith<$Res> {
  _$BookSearchResponseCopyWithImpl(this._self, this._then);

  final BookSearchResponse _self;
  final $Res Function(BookSearchResponse) _then;

  /// Create a copy of BookSearchResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? page = null,
    Object? size = null,
    Object? hasMore = null,
  }) {
    return _then(_self.copyWith(
      items: null == items
          ? _self.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<BookDto>,
      page: null == page
          ? _self.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      size: null == size
          ? _self.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _self.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [BookSearchResponse].
extension BookSearchResponsePatterns on BookSearchResponse {
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
    TResult Function(_BookSearchResponse value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BookSearchResponse() when $default != null:
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
    TResult Function(_BookSearchResponse value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BookSearchResponse():
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
    TResult? Function(_BookSearchResponse value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BookSearchResponse() when $default != null:
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
    TResult Function(List<BookDto> items, int page, int size, bool hasMore)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BookSearchResponse() when $default != null:
        return $default(_that.items, _that.page, _that.size, _that.hasMore);
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
    TResult Function(List<BookDto> items, int page, int size, bool hasMore)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BookSearchResponse():
        return $default(_that.items, _that.page, _that.size, _that.hasMore);
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
    TResult? Function(List<BookDto> items, int page, int size, bool hasMore)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BookSearchResponse() when $default != null:
        return $default(_that.items, _that.page, _that.size, _that.hasMore);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _BookSearchResponse implements BookSearchResponse {
  const _BookSearchResponse(
      {required final List<BookDto> items,
      required this.page,
      required this.size,
      required this.hasMore})
      : _items = items;
  factory _BookSearchResponse.fromJson(Map<String, dynamic> json) =>
      _$BookSearchResponseFromJson(json);

  final List<BookDto> _items;
  @override
  List<BookDto> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final int page;
  @override
  final int size;
  @override
  final bool hasMore;

  /// Create a copy of BookSearchResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BookSearchResponseCopyWith<_BookSearchResponse> get copyWith =>
      __$BookSearchResponseCopyWithImpl<_BookSearchResponse>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BookSearchResponseToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BookSearchResponse &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_items), page, size, hasMore);

  @override
  String toString() {
    return 'BookSearchResponse(items: $items, page: $page, size: $size, hasMore: $hasMore)';
  }
}

/// @nodoc
abstract mixin class _$BookSearchResponseCopyWith<$Res>
    implements $BookSearchResponseCopyWith<$Res> {
  factory _$BookSearchResponseCopyWith(
          _BookSearchResponse value, $Res Function(_BookSearchResponse) _then) =
      __$BookSearchResponseCopyWithImpl;
  @override
  @useResult
  $Res call({List<BookDto> items, int page, int size, bool hasMore});
}

/// @nodoc
class __$BookSearchResponseCopyWithImpl<$Res>
    implements _$BookSearchResponseCopyWith<$Res> {
  __$BookSearchResponseCopyWithImpl(this._self, this._then);

  final _BookSearchResponse _self;
  final $Res Function(_BookSearchResponse) _then;

  /// Create a copy of BookSearchResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? items = null,
    Object? page = null,
    Object? size = null,
    Object? hasMore = null,
  }) {
    return _then(_BookSearchResponse(
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<BookDto>,
      page: null == page
          ? _self.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      size: null == size
          ? _self.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _self.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
mixin _$LibraryPageDto {
  List<UserBookDto> get items;
  String? get nextCursor;

  /// Create a copy of LibraryPageDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LibraryPageDtoCopyWith<LibraryPageDto> get copyWith =>
      _$LibraryPageDtoCopyWithImpl<LibraryPageDto>(
          this as LibraryPageDto, _$identity);

  /// Serializes this LibraryPageDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LibraryPageDto &&
            const DeepCollectionEquality().equals(other.items, items) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(items), nextCursor);

  @override
  String toString() {
    return 'LibraryPageDto(items: $items, nextCursor: $nextCursor)';
  }
}

/// @nodoc
abstract mixin class $LibraryPageDtoCopyWith<$Res> {
  factory $LibraryPageDtoCopyWith(
          LibraryPageDto value, $Res Function(LibraryPageDto) _then) =
      _$LibraryPageDtoCopyWithImpl;
  @useResult
  $Res call({List<UserBookDto> items, String? nextCursor});
}

/// @nodoc
class _$LibraryPageDtoCopyWithImpl<$Res>
    implements $LibraryPageDtoCopyWith<$Res> {
  _$LibraryPageDtoCopyWithImpl(this._self, this._then);

  final LibraryPageDto _self;
  final $Res Function(LibraryPageDto) _then;

  /// Create a copy of LibraryPageDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? nextCursor = freezed,
  }) {
    return _then(_self.copyWith(
      items: null == items
          ? _self.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<UserBookDto>,
      nextCursor: freezed == nextCursor
          ? _self.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [LibraryPageDto].
extension LibraryPageDtoPatterns on LibraryPageDto {
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
    TResult Function(_LibraryPageDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LibraryPageDto() when $default != null:
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
    TResult Function(_LibraryPageDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LibraryPageDto():
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
    TResult? Function(_LibraryPageDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LibraryPageDto() when $default != null:
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
    TResult Function(List<UserBookDto> items, String? nextCursor)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _LibraryPageDto() when $default != null:
        return $default(_that.items, _that.nextCursor);
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
    TResult Function(List<UserBookDto> items, String? nextCursor) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LibraryPageDto():
        return $default(_that.items, _that.nextCursor);
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
    TResult? Function(List<UserBookDto> items, String? nextCursor)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _LibraryPageDto() when $default != null:
        return $default(_that.items, _that.nextCursor);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _LibraryPageDto implements LibraryPageDto {
  const _LibraryPageDto(
      {required final List<UserBookDto> items, this.nextCursor})
      : _items = items;
  factory _LibraryPageDto.fromJson(Map<String, dynamic> json) =>
      _$LibraryPageDtoFromJson(json);

  final List<UserBookDto> _items;
  @override
  List<UserBookDto> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final String? nextCursor;

  /// Create a copy of LibraryPageDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LibraryPageDtoCopyWith<_LibraryPageDto> get copyWith =>
      __$LibraryPageDtoCopyWithImpl<_LibraryPageDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$LibraryPageDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LibraryPageDto &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_items), nextCursor);

  @override
  String toString() {
    return 'LibraryPageDto(items: $items, nextCursor: $nextCursor)';
  }
}

/// @nodoc
abstract mixin class _$LibraryPageDtoCopyWith<$Res>
    implements $LibraryPageDtoCopyWith<$Res> {
  factory _$LibraryPageDtoCopyWith(
          _LibraryPageDto value, $Res Function(_LibraryPageDto) _then) =
      __$LibraryPageDtoCopyWithImpl;
  @override
  @useResult
  $Res call({List<UserBookDto> items, String? nextCursor});
}

/// @nodoc
class __$LibraryPageDtoCopyWithImpl<$Res>
    implements _$LibraryPageDtoCopyWith<$Res> {
  __$LibraryPageDtoCopyWithImpl(this._self, this._then);

  final _LibraryPageDto _self;
  final $Res Function(_LibraryPageDto) _then;

  /// Create a copy of LibraryPageDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? items = null,
    Object? nextCursor = freezed,
  }) {
    return _then(_LibraryPageDto(
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<UserBookDto>,
      nextCursor: freezed == nextCursor
          ? _self.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$AddToLibraryRequest {
  String get bookId;
  String get status;

  /// Create a copy of AddToLibraryRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AddToLibraryRequestCopyWith<AddToLibraryRequest> get copyWith =>
      _$AddToLibraryRequestCopyWithImpl<AddToLibraryRequest>(
          this as AddToLibraryRequest, _$identity);

  /// Serializes this AddToLibraryRequest to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AddToLibraryRequest &&
            (identical(other.bookId, bookId) || other.bookId == bookId) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, bookId, status);

  @override
  String toString() {
    return 'AddToLibraryRequest(bookId: $bookId, status: $status)';
  }
}

/// @nodoc
abstract mixin class $AddToLibraryRequestCopyWith<$Res> {
  factory $AddToLibraryRequestCopyWith(
          AddToLibraryRequest value, $Res Function(AddToLibraryRequest) _then) =
      _$AddToLibraryRequestCopyWithImpl;
  @useResult
  $Res call({String bookId, String status});
}

/// @nodoc
class _$AddToLibraryRequestCopyWithImpl<$Res>
    implements $AddToLibraryRequestCopyWith<$Res> {
  _$AddToLibraryRequestCopyWithImpl(this._self, this._then);

  final AddToLibraryRequest _self;
  final $Res Function(AddToLibraryRequest) _then;

  /// Create a copy of AddToLibraryRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookId = null,
    Object? status = null,
  }) {
    return _then(_self.copyWith(
      bookId: null == bookId
          ? _self.bookId
          : bookId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [AddToLibraryRequest].
extension AddToLibraryRequestPatterns on AddToLibraryRequest {
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
    TResult Function(_AddToLibraryRequest value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AddToLibraryRequest() when $default != null:
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
    TResult Function(_AddToLibraryRequest value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AddToLibraryRequest():
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
    TResult? Function(_AddToLibraryRequest value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AddToLibraryRequest() when $default != null:
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
    TResult Function(String bookId, String status)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AddToLibraryRequest() when $default != null:
        return $default(_that.bookId, _that.status);
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
    TResult Function(String bookId, String status) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AddToLibraryRequest():
        return $default(_that.bookId, _that.status);
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
    TResult? Function(String bookId, String status)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AddToLibraryRequest() when $default != null:
        return $default(_that.bookId, _that.status);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AddToLibraryRequest implements AddToLibraryRequest {
  const _AddToLibraryRequest({required this.bookId, this.status = 'reading'});
  factory _AddToLibraryRequest.fromJson(Map<String, dynamic> json) =>
      _$AddToLibraryRequestFromJson(json);

  @override
  final String bookId;
  @override
  @JsonKey()
  final String status;

  /// Create a copy of AddToLibraryRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AddToLibraryRequestCopyWith<_AddToLibraryRequest> get copyWith =>
      __$AddToLibraryRequestCopyWithImpl<_AddToLibraryRequest>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AddToLibraryRequestToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AddToLibraryRequest &&
            (identical(other.bookId, bookId) || other.bookId == bookId) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, bookId, status);

  @override
  String toString() {
    return 'AddToLibraryRequest(bookId: $bookId, status: $status)';
  }
}

/// @nodoc
abstract mixin class _$AddToLibraryRequestCopyWith<$Res>
    implements $AddToLibraryRequestCopyWith<$Res> {
  factory _$AddToLibraryRequestCopyWith(_AddToLibraryRequest value,
          $Res Function(_AddToLibraryRequest) _then) =
      __$AddToLibraryRequestCopyWithImpl;
  @override
  @useResult
  $Res call({String bookId, String status});
}

/// @nodoc
class __$AddToLibraryRequestCopyWithImpl<$Res>
    implements _$AddToLibraryRequestCopyWith<$Res> {
  __$AddToLibraryRequestCopyWithImpl(this._self, this._then);

  final _AddToLibraryRequest _self;
  final $Res Function(_AddToLibraryRequest) _then;

  /// Create a copy of AddToLibraryRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? bookId = null,
    Object? status = null,
  }) {
    return _then(_AddToLibraryRequest(
      bookId: null == bookId
          ? _self.bookId
          : bookId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$UpdateStatusRequest {
  String get status;

  /// Create a copy of UpdateStatusRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UpdateStatusRequestCopyWith<UpdateStatusRequest> get copyWith =>
      _$UpdateStatusRequestCopyWithImpl<UpdateStatusRequest>(
          this as UpdateStatusRequest, _$identity);

  /// Serializes this UpdateStatusRequest to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UpdateStatusRequest &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, status);

  @override
  String toString() {
    return 'UpdateStatusRequest(status: $status)';
  }
}

/// @nodoc
abstract mixin class $UpdateStatusRequestCopyWith<$Res> {
  factory $UpdateStatusRequestCopyWith(
          UpdateStatusRequest value, $Res Function(UpdateStatusRequest) _then) =
      _$UpdateStatusRequestCopyWithImpl;
  @useResult
  $Res call({String status});
}

/// @nodoc
class _$UpdateStatusRequestCopyWithImpl<$Res>
    implements $UpdateStatusRequestCopyWith<$Res> {
  _$UpdateStatusRequestCopyWithImpl(this._self, this._then);

  final UpdateStatusRequest _self;
  final $Res Function(UpdateStatusRequest) _then;

  /// Create a copy of UpdateStatusRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
  }) {
    return _then(_self.copyWith(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// Adds pattern-matching-related methods to [UpdateStatusRequest].
extension UpdateStatusRequestPatterns on UpdateStatusRequest {
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
    TResult Function(_UpdateStatusRequest value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UpdateStatusRequest() when $default != null:
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
    TResult Function(_UpdateStatusRequest value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UpdateStatusRequest():
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
    TResult? Function(_UpdateStatusRequest value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UpdateStatusRequest() when $default != null:
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
    TResult Function(String status)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UpdateStatusRequest() when $default != null:
        return $default(_that.status);
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
    TResult Function(String status) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UpdateStatusRequest():
        return $default(_that.status);
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
    TResult? Function(String status)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UpdateStatusRequest() when $default != null:
        return $default(_that.status);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _UpdateStatusRequest implements UpdateStatusRequest {
  const _UpdateStatusRequest({required this.status});
  factory _UpdateStatusRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateStatusRequestFromJson(json);

  @override
  final String status;

  /// Create a copy of UpdateStatusRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UpdateStatusRequestCopyWith<_UpdateStatusRequest> get copyWith =>
      __$UpdateStatusRequestCopyWithImpl<_UpdateStatusRequest>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UpdateStatusRequestToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UpdateStatusRequest &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, status);

  @override
  String toString() {
    return 'UpdateStatusRequest(status: $status)';
  }
}

/// @nodoc
abstract mixin class _$UpdateStatusRequestCopyWith<$Res>
    implements $UpdateStatusRequestCopyWith<$Res> {
  factory _$UpdateStatusRequestCopyWith(_UpdateStatusRequest value,
          $Res Function(_UpdateStatusRequest) _then) =
      __$UpdateStatusRequestCopyWithImpl;
  @override
  @useResult
  $Res call({String status});
}

/// @nodoc
class __$UpdateStatusRequestCopyWithImpl<$Res>
    implements _$UpdateStatusRequestCopyWith<$Res> {
  __$UpdateStatusRequestCopyWithImpl(this._self, this._then);

  final _UpdateStatusRequest _self;
  final $Res Function(_UpdateStatusRequest) _then;

  /// Create a copy of UpdateStatusRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? status = null,
  }) {
    return _then(_UpdateStatusRequest(
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$DiscoverSectionDto {
  String get id;
  String get title;
  List<BookDto> get books;

  /// Create a copy of DiscoverSectionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DiscoverSectionDtoCopyWith<DiscoverSectionDto> get copyWith =>
      _$DiscoverSectionDtoCopyWithImpl<DiscoverSectionDto>(
          this as DiscoverSectionDto, _$identity);

  /// Serializes this DiscoverSectionDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DiscoverSectionDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality().equals(other.books, books));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, title, const DeepCollectionEquality().hash(books));

  @override
  String toString() {
    return 'DiscoverSectionDto(id: $id, title: $title, books: $books)';
  }
}

/// @nodoc
abstract mixin class $DiscoverSectionDtoCopyWith<$Res> {
  factory $DiscoverSectionDtoCopyWith(
          DiscoverSectionDto value, $Res Function(DiscoverSectionDto) _then) =
      _$DiscoverSectionDtoCopyWithImpl;
  @useResult
  $Res call({String id, String title, List<BookDto> books});
}

/// @nodoc
class _$DiscoverSectionDtoCopyWithImpl<$Res>
    implements $DiscoverSectionDtoCopyWith<$Res> {
  _$DiscoverSectionDtoCopyWithImpl(this._self, this._then);

  final DiscoverSectionDto _self;
  final $Res Function(DiscoverSectionDto) _then;

  /// Create a copy of DiscoverSectionDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? books = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      books: null == books
          ? _self.books
          : books // ignore: cast_nullable_to_non_nullable
              as List<BookDto>,
    ));
  }
}

/// Adds pattern-matching-related methods to [DiscoverSectionDto].
extension DiscoverSectionDtoPatterns on DiscoverSectionDto {
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
    TResult Function(_DiscoverSectionDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DiscoverSectionDto() when $default != null:
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
    TResult Function(_DiscoverSectionDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DiscoverSectionDto():
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
    TResult? Function(_DiscoverSectionDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DiscoverSectionDto() when $default != null:
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
    TResult Function(String id, String title, List<BookDto> books)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DiscoverSectionDto() when $default != null:
        return $default(_that.id, _that.title, _that.books);
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
    TResult Function(String id, String title, List<BookDto> books) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DiscoverSectionDto():
        return $default(_that.id, _that.title, _that.books);
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
    TResult? Function(String id, String title, List<BookDto> books)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DiscoverSectionDto() when $default != null:
        return $default(_that.id, _that.title, _that.books);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _DiscoverSectionDto implements DiscoverSectionDto {
  const _DiscoverSectionDto(
      {required this.id,
      required this.title,
      required final List<BookDto> books})
      : _books = books;
  factory _DiscoverSectionDto.fromJson(Map<String, dynamic> json) =>
      _$DiscoverSectionDtoFromJson(json);

  @override
  final String id;
  @override
  final String title;
  final List<BookDto> _books;
  @override
  List<BookDto> get books {
    if (_books is EqualUnmodifiableListView) return _books;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_books);
  }

  /// Create a copy of DiscoverSectionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DiscoverSectionDtoCopyWith<_DiscoverSectionDto> get copyWith =>
      __$DiscoverSectionDtoCopyWithImpl<_DiscoverSectionDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$DiscoverSectionDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DiscoverSectionDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality().equals(other._books, _books));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, title, const DeepCollectionEquality().hash(_books));

  @override
  String toString() {
    return 'DiscoverSectionDto(id: $id, title: $title, books: $books)';
  }
}

/// @nodoc
abstract mixin class _$DiscoverSectionDtoCopyWith<$Res>
    implements $DiscoverSectionDtoCopyWith<$Res> {
  factory _$DiscoverSectionDtoCopyWith(
          _DiscoverSectionDto value, $Res Function(_DiscoverSectionDto) _then) =
      __$DiscoverSectionDtoCopyWithImpl;
  @override
  @useResult
  $Res call({String id, String title, List<BookDto> books});
}

/// @nodoc
class __$DiscoverSectionDtoCopyWithImpl<$Res>
    implements _$DiscoverSectionDtoCopyWith<$Res> {
  __$DiscoverSectionDtoCopyWithImpl(this._self, this._then);

  final _DiscoverSectionDto _self;
  final $Res Function(_DiscoverSectionDto) _then;

  /// Create a copy of DiscoverSectionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? books = null,
  }) {
    return _then(_DiscoverSectionDto(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      books: null == books
          ? _self._books
          : books // ignore: cast_nullable_to_non_nullable
              as List<BookDto>,
    ));
  }
}

/// @nodoc
mixin _$DiscoverResponseDto {
  List<DiscoverSectionDto> get sections;

  /// Create a copy of DiscoverResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DiscoverResponseDtoCopyWith<DiscoverResponseDto> get copyWith =>
      _$DiscoverResponseDtoCopyWithImpl<DiscoverResponseDto>(
          this as DiscoverResponseDto, _$identity);

  /// Serializes this DiscoverResponseDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DiscoverResponseDto &&
            const DeepCollectionEquality().equals(other.sections, sections));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(sections));

  @override
  String toString() {
    return 'DiscoverResponseDto(sections: $sections)';
  }
}

/// @nodoc
abstract mixin class $DiscoverResponseDtoCopyWith<$Res> {
  factory $DiscoverResponseDtoCopyWith(
          DiscoverResponseDto value, $Res Function(DiscoverResponseDto) _then) =
      _$DiscoverResponseDtoCopyWithImpl;
  @useResult
  $Res call({List<DiscoverSectionDto> sections});
}

/// @nodoc
class _$DiscoverResponseDtoCopyWithImpl<$Res>
    implements $DiscoverResponseDtoCopyWith<$Res> {
  _$DiscoverResponseDtoCopyWithImpl(this._self, this._then);

  final DiscoverResponseDto _self;
  final $Res Function(DiscoverResponseDto) _then;

  /// Create a copy of DiscoverResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sections = null,
  }) {
    return _then(_self.copyWith(
      sections: null == sections
          ? _self.sections
          : sections // ignore: cast_nullable_to_non_nullable
              as List<DiscoverSectionDto>,
    ));
  }
}

/// Adds pattern-matching-related methods to [DiscoverResponseDto].
extension DiscoverResponseDtoPatterns on DiscoverResponseDto {
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
    TResult Function(_DiscoverResponseDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DiscoverResponseDto() when $default != null:
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
    TResult Function(_DiscoverResponseDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DiscoverResponseDto():
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
    TResult? Function(_DiscoverResponseDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DiscoverResponseDto() when $default != null:
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
    TResult Function(List<DiscoverSectionDto> sections)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DiscoverResponseDto() when $default != null:
        return $default(_that.sections);
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
    TResult Function(List<DiscoverSectionDto> sections) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DiscoverResponseDto():
        return $default(_that.sections);
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
    TResult? Function(List<DiscoverSectionDto> sections)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DiscoverResponseDto() when $default != null:
        return $default(_that.sections);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _DiscoverResponseDto implements DiscoverResponseDto {
  const _DiscoverResponseDto({required final List<DiscoverSectionDto> sections})
      : _sections = sections;
  factory _DiscoverResponseDto.fromJson(Map<String, dynamic> json) =>
      _$DiscoverResponseDtoFromJson(json);

  final List<DiscoverSectionDto> _sections;
  @override
  List<DiscoverSectionDto> get sections {
    if (_sections is EqualUnmodifiableListView) return _sections;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sections);
  }

  /// Create a copy of DiscoverResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DiscoverResponseDtoCopyWith<_DiscoverResponseDto> get copyWith =>
      __$DiscoverResponseDtoCopyWithImpl<_DiscoverResponseDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$DiscoverResponseDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DiscoverResponseDto &&
            const DeepCollectionEquality().equals(other._sections, _sections));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_sections));

  @override
  String toString() {
    return 'DiscoverResponseDto(sections: $sections)';
  }
}

/// @nodoc
abstract mixin class _$DiscoverResponseDtoCopyWith<$Res>
    implements $DiscoverResponseDtoCopyWith<$Res> {
  factory _$DiscoverResponseDtoCopyWith(_DiscoverResponseDto value,
          $Res Function(_DiscoverResponseDto) _then) =
      __$DiscoverResponseDtoCopyWithImpl;
  @override
  @useResult
  $Res call({List<DiscoverSectionDto> sections});
}

/// @nodoc
class __$DiscoverResponseDtoCopyWithImpl<$Res>
    implements _$DiscoverResponseDtoCopyWith<$Res> {
  __$DiscoverResponseDtoCopyWithImpl(this._self, this._then);

  final _DiscoverResponseDto _self;
  final $Res Function(_DiscoverResponseDto) _then;

  /// Create a copy of DiscoverResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? sections = null,
  }) {
    return _then(_DiscoverResponseDto(
      sections: null == sections
          ? _self._sections
          : sections // ignore: cast_nullable_to_non_nullable
              as List<DiscoverSectionDto>,
    ));
  }
}

/// @nodoc
mixin _$SubmitReviewRequest {
  int get rating;
  String? get oneLineReview;

  /// Create a copy of SubmitReviewRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SubmitReviewRequestCopyWith<SubmitReviewRequest> get copyWith =>
      _$SubmitReviewRequestCopyWithImpl<SubmitReviewRequest>(
          this as SubmitReviewRequest, _$identity);

  /// Serializes this SubmitReviewRequest to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SubmitReviewRequest &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.oneLineReview, oneLineReview) ||
                other.oneLineReview == oneLineReview));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, rating, oneLineReview);

  @override
  String toString() {
    return 'SubmitReviewRequest(rating: $rating, oneLineReview: $oneLineReview)';
  }
}

/// @nodoc
abstract mixin class $SubmitReviewRequestCopyWith<$Res> {
  factory $SubmitReviewRequestCopyWith(
          SubmitReviewRequest value, $Res Function(SubmitReviewRequest) _then) =
      _$SubmitReviewRequestCopyWithImpl;
  @useResult
  $Res call({int rating, String? oneLineReview});
}

/// @nodoc
class _$SubmitReviewRequestCopyWithImpl<$Res>
    implements $SubmitReviewRequestCopyWith<$Res> {
  _$SubmitReviewRequestCopyWithImpl(this._self, this._then);

  final SubmitReviewRequest _self;
  final $Res Function(SubmitReviewRequest) _then;

  /// Create a copy of SubmitReviewRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rating = null,
    Object? oneLineReview = freezed,
  }) {
    return _then(_self.copyWith(
      rating: null == rating
          ? _self.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as int,
      oneLineReview: freezed == oneLineReview
          ? _self.oneLineReview
          : oneLineReview // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [SubmitReviewRequest].
extension SubmitReviewRequestPatterns on SubmitReviewRequest {
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
    TResult Function(_SubmitReviewRequest value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SubmitReviewRequest() when $default != null:
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
    TResult Function(_SubmitReviewRequest value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SubmitReviewRequest():
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
    TResult? Function(_SubmitReviewRequest value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SubmitReviewRequest() when $default != null:
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
    TResult Function(int rating, String? oneLineReview)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SubmitReviewRequest() when $default != null:
        return $default(_that.rating, _that.oneLineReview);
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
    TResult Function(int rating, String? oneLineReview) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SubmitReviewRequest():
        return $default(_that.rating, _that.oneLineReview);
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
    TResult? Function(int rating, String? oneLineReview)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SubmitReviewRequest() when $default != null:
        return $default(_that.rating, _that.oneLineReview);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SubmitReviewRequest implements SubmitReviewRequest {
  const _SubmitReviewRequest({required this.rating, this.oneLineReview});
  factory _SubmitReviewRequest.fromJson(Map<String, dynamic> json) =>
      _$SubmitReviewRequestFromJson(json);

  @override
  final int rating;
  @override
  final String? oneLineReview;

  /// Create a copy of SubmitReviewRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SubmitReviewRequestCopyWith<_SubmitReviewRequest> get copyWith =>
      __$SubmitReviewRequestCopyWithImpl<_SubmitReviewRequest>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SubmitReviewRequestToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SubmitReviewRequest &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.oneLineReview, oneLineReview) ||
                other.oneLineReview == oneLineReview));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, rating, oneLineReview);

  @override
  String toString() {
    return 'SubmitReviewRequest(rating: $rating, oneLineReview: $oneLineReview)';
  }
}

/// @nodoc
abstract mixin class _$SubmitReviewRequestCopyWith<$Res>
    implements $SubmitReviewRequestCopyWith<$Res> {
  factory _$SubmitReviewRequestCopyWith(_SubmitReviewRequest value,
          $Res Function(_SubmitReviewRequest) _then) =
      __$SubmitReviewRequestCopyWithImpl;
  @override
  @useResult
  $Res call({int rating, String? oneLineReview});
}

/// @nodoc
class __$SubmitReviewRequestCopyWithImpl<$Res>
    implements _$SubmitReviewRequestCopyWith<$Res> {
  __$SubmitReviewRequestCopyWithImpl(this._self, this._then);

  final _SubmitReviewRequest _self;
  final $Res Function(_SubmitReviewRequest) _then;

  /// Create a copy of SubmitReviewRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? rating = null,
    Object? oneLineReview = freezed,
  }) {
    return _then(_SubmitReviewRequest(
      rating: null == rating
          ? _self.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as int,
      oneLineReview: freezed == oneLineReview
          ? _self.oneLineReview
          : oneLineReview // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$BookReviewDto {
  String get userBookId;
  int get rating;
  String? get oneLineReview;
  String get authorNickname;
  String? get authorProfileImageUrl;
  DateTime get reviewedAt;

  /// Create a copy of BookReviewDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BookReviewDtoCopyWith<BookReviewDto> get copyWith =>
      _$BookReviewDtoCopyWithImpl<BookReviewDto>(
          this as BookReviewDto, _$identity);

  /// Serializes this BookReviewDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BookReviewDto &&
            (identical(other.userBookId, userBookId) ||
                other.userBookId == userBookId) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.oneLineReview, oneLineReview) ||
                other.oneLineReview == oneLineReview) &&
            (identical(other.authorNickname, authorNickname) ||
                other.authorNickname == authorNickname) &&
            (identical(other.authorProfileImageUrl, authorProfileImageUrl) ||
                other.authorProfileImageUrl == authorProfileImageUrl) &&
            (identical(other.reviewedAt, reviewedAt) ||
                other.reviewedAt == reviewedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userBookId, rating,
      oneLineReview, authorNickname, authorProfileImageUrl, reviewedAt);

  @override
  String toString() {
    return 'BookReviewDto(userBookId: $userBookId, rating: $rating, oneLineReview: $oneLineReview, authorNickname: $authorNickname, authorProfileImageUrl: $authorProfileImageUrl, reviewedAt: $reviewedAt)';
  }
}

/// @nodoc
abstract mixin class $BookReviewDtoCopyWith<$Res> {
  factory $BookReviewDtoCopyWith(
          BookReviewDto value, $Res Function(BookReviewDto) _then) =
      _$BookReviewDtoCopyWithImpl;
  @useResult
  $Res call(
      {String userBookId,
      int rating,
      String? oneLineReview,
      String authorNickname,
      String? authorProfileImageUrl,
      DateTime reviewedAt});
}

/// @nodoc
class _$BookReviewDtoCopyWithImpl<$Res>
    implements $BookReviewDtoCopyWith<$Res> {
  _$BookReviewDtoCopyWithImpl(this._self, this._then);

  final BookReviewDto _self;
  final $Res Function(BookReviewDto) _then;

  /// Create a copy of BookReviewDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userBookId = null,
    Object? rating = null,
    Object? oneLineReview = freezed,
    Object? authorNickname = null,
    Object? authorProfileImageUrl = freezed,
    Object? reviewedAt = null,
  }) {
    return _then(_self.copyWith(
      userBookId: null == userBookId
          ? _self.userBookId
          : userBookId // ignore: cast_nullable_to_non_nullable
              as String,
      rating: null == rating
          ? _self.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as int,
      oneLineReview: freezed == oneLineReview
          ? _self.oneLineReview
          : oneLineReview // ignore: cast_nullable_to_non_nullable
              as String?,
      authorNickname: null == authorNickname
          ? _self.authorNickname
          : authorNickname // ignore: cast_nullable_to_non_nullable
              as String,
      authorProfileImageUrl: freezed == authorProfileImageUrl
          ? _self.authorProfileImageUrl
          : authorProfileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewedAt: null == reviewedAt
          ? _self.reviewedAt
          : reviewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [BookReviewDto].
extension BookReviewDtoPatterns on BookReviewDto {
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
    TResult Function(_BookReviewDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BookReviewDto() when $default != null:
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
    TResult Function(_BookReviewDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BookReviewDto():
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
    TResult? Function(_BookReviewDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BookReviewDto() when $default != null:
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
            String userBookId,
            int rating,
            String? oneLineReview,
            String authorNickname,
            String? authorProfileImageUrl,
            DateTime reviewedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BookReviewDto() when $default != null:
        return $default(
            _that.userBookId,
            _that.rating,
            _that.oneLineReview,
            _that.authorNickname,
            _that.authorProfileImageUrl,
            _that.reviewedAt);
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
            String userBookId,
            int rating,
            String? oneLineReview,
            String authorNickname,
            String? authorProfileImageUrl,
            DateTime reviewedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BookReviewDto():
        return $default(
            _that.userBookId,
            _that.rating,
            _that.oneLineReview,
            _that.authorNickname,
            _that.authorProfileImageUrl,
            _that.reviewedAt);
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
            String userBookId,
            int rating,
            String? oneLineReview,
            String authorNickname,
            String? authorProfileImageUrl,
            DateTime reviewedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BookReviewDto() when $default != null:
        return $default(
            _that.userBookId,
            _that.rating,
            _that.oneLineReview,
            _that.authorNickname,
            _that.authorProfileImageUrl,
            _that.reviewedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _BookReviewDto extends BookReviewDto {
  const _BookReviewDto(
      {required this.userBookId,
      required this.rating,
      this.oneLineReview,
      required this.authorNickname,
      this.authorProfileImageUrl,
      required this.reviewedAt})
      : super._();
  factory _BookReviewDto.fromJson(Map<String, dynamic> json) =>
      _$BookReviewDtoFromJson(json);

  @override
  final String userBookId;
  @override
  final int rating;
  @override
  final String? oneLineReview;
  @override
  final String authorNickname;
  @override
  final String? authorProfileImageUrl;
  @override
  final DateTime reviewedAt;

  /// Create a copy of BookReviewDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BookReviewDtoCopyWith<_BookReviewDto> get copyWith =>
      __$BookReviewDtoCopyWithImpl<_BookReviewDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BookReviewDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BookReviewDto &&
            (identical(other.userBookId, userBookId) ||
                other.userBookId == userBookId) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.oneLineReview, oneLineReview) ||
                other.oneLineReview == oneLineReview) &&
            (identical(other.authorNickname, authorNickname) ||
                other.authorNickname == authorNickname) &&
            (identical(other.authorProfileImageUrl, authorProfileImageUrl) ||
                other.authorProfileImageUrl == authorProfileImageUrl) &&
            (identical(other.reviewedAt, reviewedAt) ||
                other.reviewedAt == reviewedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userBookId, rating,
      oneLineReview, authorNickname, authorProfileImageUrl, reviewedAt);

  @override
  String toString() {
    return 'BookReviewDto(userBookId: $userBookId, rating: $rating, oneLineReview: $oneLineReview, authorNickname: $authorNickname, authorProfileImageUrl: $authorProfileImageUrl, reviewedAt: $reviewedAt)';
  }
}

/// @nodoc
abstract mixin class _$BookReviewDtoCopyWith<$Res>
    implements $BookReviewDtoCopyWith<$Res> {
  factory _$BookReviewDtoCopyWith(
          _BookReviewDto value, $Res Function(_BookReviewDto) _then) =
      __$BookReviewDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String userBookId,
      int rating,
      String? oneLineReview,
      String authorNickname,
      String? authorProfileImageUrl,
      DateTime reviewedAt});
}

/// @nodoc
class __$BookReviewDtoCopyWithImpl<$Res>
    implements _$BookReviewDtoCopyWith<$Res> {
  __$BookReviewDtoCopyWithImpl(this._self, this._then);

  final _BookReviewDto _self;
  final $Res Function(_BookReviewDto) _then;

  /// Create a copy of BookReviewDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? userBookId = null,
    Object? rating = null,
    Object? oneLineReview = freezed,
    Object? authorNickname = null,
    Object? authorProfileImageUrl = freezed,
    Object? reviewedAt = null,
  }) {
    return _then(_BookReviewDto(
      userBookId: null == userBookId
          ? _self.userBookId
          : userBookId // ignore: cast_nullable_to_non_nullable
              as String,
      rating: null == rating
          ? _self.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as int,
      oneLineReview: freezed == oneLineReview
          ? _self.oneLineReview
          : oneLineReview // ignore: cast_nullable_to_non_nullable
              as String?,
      authorNickname: null == authorNickname
          ? _self.authorNickname
          : authorNickname // ignore: cast_nullable_to_non_nullable
              as String,
      authorProfileImageUrl: freezed == authorProfileImageUrl
          ? _self.authorProfileImageUrl
          : authorProfileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewedAt: null == reviewedAt
          ? _self.reviewedAt
          : reviewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
mixin _$BookReviewsResponseDto {
  List<BookReviewDto> get items;

  /// Create a copy of BookReviewsResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BookReviewsResponseDtoCopyWith<BookReviewsResponseDto> get copyWith =>
      _$BookReviewsResponseDtoCopyWithImpl<BookReviewsResponseDto>(
          this as BookReviewsResponseDto, _$identity);

  /// Serializes this BookReviewsResponseDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BookReviewsResponseDto &&
            const DeepCollectionEquality().equals(other.items, items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(items));

  @override
  String toString() {
    return 'BookReviewsResponseDto(items: $items)';
  }
}

/// @nodoc
abstract mixin class $BookReviewsResponseDtoCopyWith<$Res> {
  factory $BookReviewsResponseDtoCopyWith(BookReviewsResponseDto value,
          $Res Function(BookReviewsResponseDto) _then) =
      _$BookReviewsResponseDtoCopyWithImpl;
  @useResult
  $Res call({List<BookReviewDto> items});
}

/// @nodoc
class _$BookReviewsResponseDtoCopyWithImpl<$Res>
    implements $BookReviewsResponseDtoCopyWith<$Res> {
  _$BookReviewsResponseDtoCopyWithImpl(this._self, this._then);

  final BookReviewsResponseDto _self;
  final $Res Function(BookReviewsResponseDto) _then;

  /// Create a copy of BookReviewsResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
  }) {
    return _then(_self.copyWith(
      items: null == items
          ? _self.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<BookReviewDto>,
    ));
  }
}

/// Adds pattern-matching-related methods to [BookReviewsResponseDto].
extension BookReviewsResponseDtoPatterns on BookReviewsResponseDto {
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
    TResult Function(_BookReviewsResponseDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BookReviewsResponseDto() when $default != null:
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
    TResult Function(_BookReviewsResponseDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BookReviewsResponseDto():
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
    TResult? Function(_BookReviewsResponseDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BookReviewsResponseDto() when $default != null:
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
    TResult Function(List<BookReviewDto> items)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BookReviewsResponseDto() when $default != null:
        return $default(_that.items);
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
    TResult Function(List<BookReviewDto> items) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BookReviewsResponseDto():
        return $default(_that.items);
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
    TResult? Function(List<BookReviewDto> items)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BookReviewsResponseDto() when $default != null:
        return $default(_that.items);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _BookReviewsResponseDto implements BookReviewsResponseDto {
  const _BookReviewsResponseDto({required final List<BookReviewDto> items})
      : _items = items;
  factory _BookReviewsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$BookReviewsResponseDtoFromJson(json);

  final List<BookReviewDto> _items;
  @override
  List<BookReviewDto> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  /// Create a copy of BookReviewsResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BookReviewsResponseDtoCopyWith<_BookReviewsResponseDto> get copyWith =>
      __$BookReviewsResponseDtoCopyWithImpl<_BookReviewsResponseDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BookReviewsResponseDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BookReviewsResponseDto &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_items));

  @override
  String toString() {
    return 'BookReviewsResponseDto(items: $items)';
  }
}

/// @nodoc
abstract mixin class _$BookReviewsResponseDtoCopyWith<$Res>
    implements $BookReviewsResponseDtoCopyWith<$Res> {
  factory _$BookReviewsResponseDtoCopyWith(_BookReviewsResponseDto value,
          $Res Function(_BookReviewsResponseDto) _then) =
      __$BookReviewsResponseDtoCopyWithImpl;
  @override
  @useResult
  $Res call({List<BookReviewDto> items});
}

/// @nodoc
class __$BookReviewsResponseDtoCopyWithImpl<$Res>
    implements _$BookReviewsResponseDtoCopyWith<$Res> {
  __$BookReviewsResponseDtoCopyWithImpl(this._self, this._then);

  final _BookReviewsResponseDto _self;
  final $Res Function(_BookReviewsResponseDto) _then;

  /// Create a copy of BookReviewsResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? items = null,
  }) {
    return _then(_BookReviewsResponseDto(
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<BookReviewDto>,
    ));
  }
}

// dart format on
