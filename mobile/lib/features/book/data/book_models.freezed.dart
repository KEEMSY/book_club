// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'book_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BookDto _$BookDtoFromJson(Map<String, dynamic> json) {
  return _BookDto.fromJson(json);
}

/// @nodoc
mixin _$BookDto {
  String get id => throw _privateConstructorUsedError;
  String get isbn13 => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get author => throw _privateConstructorUsedError;
  String get publisher => throw _privateConstructorUsedError;
  String? get coverUrl => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Serializes this BookDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BookDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookDtoCopyWith<BookDto> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookDtoCopyWith<$Res> {
  factory $BookDtoCopyWith(BookDto value, $Res Function(BookDto) then) =
      _$BookDtoCopyWithImpl<$Res, BookDto>;
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
class _$BookDtoCopyWithImpl<$Res, $Val extends BookDto>
    implements $BookDtoCopyWith<$Res> {
  _$BookDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      isbn13: null == isbn13
          ? _value.isbn13
          : isbn13 // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      author: null == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String,
      publisher: null == publisher
          ? _value.publisher
          : publisher // ignore: cast_nullable_to_non_nullable
              as String,
      coverUrl: freezed == coverUrl
          ? _value.coverUrl
          : coverUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BookDtoImplCopyWith<$Res> implements $BookDtoCopyWith<$Res> {
  factory _$$BookDtoImplCopyWith(
          _$BookDtoImpl value, $Res Function(_$BookDtoImpl) then) =
      __$$BookDtoImplCopyWithImpl<$Res>;
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
class __$$BookDtoImplCopyWithImpl<$Res>
    extends _$BookDtoCopyWithImpl<$Res, _$BookDtoImpl>
    implements _$$BookDtoImplCopyWith<$Res> {
  __$$BookDtoImplCopyWithImpl(
      _$BookDtoImpl _value, $Res Function(_$BookDtoImpl) _then)
      : super(_value, _then);

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
    return _then(_$BookDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      isbn13: null == isbn13
          ? _value.isbn13
          : isbn13 // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      author: null == author
          ? _value.author
          : author // ignore: cast_nullable_to_non_nullable
              as String,
      publisher: null == publisher
          ? _value.publisher
          : publisher // ignore: cast_nullable_to_non_nullable
              as String,
      coverUrl: freezed == coverUrl
          ? _value.coverUrl
          : coverUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BookDtoImpl extends _BookDto {
  const _$BookDtoImpl(
      {required this.id,
      required this.isbn13,
      required this.title,
      required this.author,
      required this.publisher,
      this.coverUrl,
      this.description})
      : super._();

  factory _$BookDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookDtoImplFromJson(json);

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

  @override
  String toString() {
    return 'BookDto(id: $id, isbn13: $isbn13, title: $title, author: $author, publisher: $publisher, coverUrl: $coverUrl, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookDtoImpl &&
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

  /// Create a copy of BookDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookDtoImplCopyWith<_$BookDtoImpl> get copyWith =>
      __$$BookDtoImplCopyWithImpl<_$BookDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookDtoImplToJson(
      this,
    );
  }
}

abstract class _BookDto extends BookDto {
  const factory _BookDto(
      {required final String id,
      required final String isbn13,
      required final String title,
      required final String author,
      required final String publisher,
      final String? coverUrl,
      final String? description}) = _$BookDtoImpl;
  const _BookDto._() : super._();

  factory _BookDto.fromJson(Map<String, dynamic> json) = _$BookDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get isbn13;
  @override
  String get title;
  @override
  String get author;
  @override
  String get publisher;
  @override
  String? get coverUrl;
  @override
  String? get description;

  /// Create a copy of BookDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookDtoImplCopyWith<_$BookDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserBookDto _$UserBookDtoFromJson(Map<String, dynamic> json) {
  return _UserBookDto.fromJson(json);
}

/// @nodoc
mixin _$UserBookDto {
  String get id => throw _privateConstructorUsedError;
  BookDto get book => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  DateTime get startedAt => throw _privateConstructorUsedError;
  DateTime? get finishedAt => throw _privateConstructorUsedError;
  int? get rating => throw _privateConstructorUsedError;
  String? get oneLineReview => throw _privateConstructorUsedError;

  /// Serializes this UserBookDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserBookDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserBookDtoCopyWith<UserBookDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserBookDtoCopyWith<$Res> {
  factory $UserBookDtoCopyWith(
          UserBookDto value, $Res Function(UserBookDto) then) =
      _$UserBookDtoCopyWithImpl<$Res, UserBookDto>;
  @useResult
  $Res call(
      {String id,
      BookDto book,
      String status,
      DateTime startedAt,
      DateTime? finishedAt,
      int? rating,
      String? oneLineReview});

  $BookDtoCopyWith<$Res> get book;
}

/// @nodoc
class _$UserBookDtoCopyWithImpl<$Res, $Val extends UserBookDto>
    implements $UserBookDtoCopyWith<$Res> {
  _$UserBookDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserBookDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? book = null,
    Object? status = null,
    Object? startedAt = null,
    Object? finishedAt = freezed,
    Object? rating = freezed,
    Object? oneLineReview = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      book: null == book
          ? _value.book
          : book // ignore: cast_nullable_to_non_nullable
              as BookDto,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      finishedAt: freezed == finishedAt
          ? _value.finishedAt
          : finishedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as int?,
      oneLineReview: freezed == oneLineReview
          ? _value.oneLineReview
          : oneLineReview // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of UserBookDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BookDtoCopyWith<$Res> get book {
    return $BookDtoCopyWith<$Res>(_value.book, (value) {
      return _then(_value.copyWith(book: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserBookDtoImplCopyWith<$Res>
    implements $UserBookDtoCopyWith<$Res> {
  factory _$$UserBookDtoImplCopyWith(
          _$UserBookDtoImpl value, $Res Function(_$UserBookDtoImpl) then) =
      __$$UserBookDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      BookDto book,
      String status,
      DateTime startedAt,
      DateTime? finishedAt,
      int? rating,
      String? oneLineReview});

  @override
  $BookDtoCopyWith<$Res> get book;
}

/// @nodoc
class __$$UserBookDtoImplCopyWithImpl<$Res>
    extends _$UserBookDtoCopyWithImpl<$Res, _$UserBookDtoImpl>
    implements _$$UserBookDtoImplCopyWith<$Res> {
  __$$UserBookDtoImplCopyWithImpl(
      _$UserBookDtoImpl _value, $Res Function(_$UserBookDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserBookDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? book = null,
    Object? status = null,
    Object? startedAt = null,
    Object? finishedAt = freezed,
    Object? rating = freezed,
    Object? oneLineReview = freezed,
  }) {
    return _then(_$UserBookDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      book: null == book
          ? _value.book
          : book // ignore: cast_nullable_to_non_nullable
              as BookDto,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      finishedAt: freezed == finishedAt
          ? _value.finishedAt
          : finishedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as int?,
      oneLineReview: freezed == oneLineReview
          ? _value.oneLineReview
          : oneLineReview // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserBookDtoImpl extends _UserBookDto {
  const _$UserBookDtoImpl(
      {required this.id,
      required this.book,
      required this.status,
      required this.startedAt,
      this.finishedAt,
      this.rating,
      this.oneLineReview})
      : super._();

  factory _$UserBookDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserBookDtoImplFromJson(json);

  @override
  final String id;
  @override
  final BookDto book;
  @override
  final String status;
  @override
  final DateTime startedAt;
  @override
  final DateTime? finishedAt;
  @override
  final int? rating;
  @override
  final String? oneLineReview;

  @override
  String toString() {
    return 'UserBookDto(id: $id, book: $book, status: $status, startedAt: $startedAt, finishedAt: $finishedAt, rating: $rating, oneLineReview: $oneLineReview)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserBookDtoImpl &&
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

  /// Create a copy of UserBookDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserBookDtoImplCopyWith<_$UserBookDtoImpl> get copyWith =>
      __$$UserBookDtoImplCopyWithImpl<_$UserBookDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserBookDtoImplToJson(
      this,
    );
  }
}

abstract class _UserBookDto extends UserBookDto {
  const factory _UserBookDto(
      {required final String id,
      required final BookDto book,
      required final String status,
      required final DateTime startedAt,
      final DateTime? finishedAt,
      final int? rating,
      final String? oneLineReview}) = _$UserBookDtoImpl;
  const _UserBookDto._() : super._();

  factory _UserBookDto.fromJson(Map<String, dynamic> json) =
      _$UserBookDtoImpl.fromJson;

  @override
  String get id;
  @override
  BookDto get book;
  @override
  String get status;
  @override
  DateTime get startedAt;
  @override
  DateTime? get finishedAt;
  @override
  int? get rating;
  @override
  String? get oneLineReview;

  /// Create a copy of UserBookDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserBookDtoImplCopyWith<_$UserBookDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BookSearchResponse _$BookSearchResponseFromJson(Map<String, dynamic> json) {
  return _BookSearchResponse.fromJson(json);
}

/// @nodoc
mixin _$BookSearchResponse {
  List<BookDto> get items => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  int get size => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;

  /// Serializes this BookSearchResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BookSearchResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookSearchResponseCopyWith<BookSearchResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookSearchResponseCopyWith<$Res> {
  factory $BookSearchResponseCopyWith(
          BookSearchResponse value, $Res Function(BookSearchResponse) then) =
      _$BookSearchResponseCopyWithImpl<$Res, BookSearchResponse>;
  @useResult
  $Res call({List<BookDto> items, int page, int size, bool hasMore});
}

/// @nodoc
class _$BookSearchResponseCopyWithImpl<$Res, $Val extends BookSearchResponse>
    implements $BookSearchResponseCopyWith<$Res> {
  _$BookSearchResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<BookDto>,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BookSearchResponseImplCopyWith<$Res>
    implements $BookSearchResponseCopyWith<$Res> {
  factory _$$BookSearchResponseImplCopyWith(_$BookSearchResponseImpl value,
          $Res Function(_$BookSearchResponseImpl) then) =
      __$$BookSearchResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<BookDto> items, int page, int size, bool hasMore});
}

/// @nodoc
class __$$BookSearchResponseImplCopyWithImpl<$Res>
    extends _$BookSearchResponseCopyWithImpl<$Res, _$BookSearchResponseImpl>
    implements _$$BookSearchResponseImplCopyWith<$Res> {
  __$$BookSearchResponseImplCopyWithImpl(_$BookSearchResponseImpl _value,
      $Res Function(_$BookSearchResponseImpl) _then)
      : super(_value, _then);

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
    return _then(_$BookSearchResponseImpl(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<BookDto>,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BookSearchResponseImpl implements _BookSearchResponse {
  const _$BookSearchResponseImpl(
      {required final List<BookDto> items,
      required this.page,
      required this.size,
      required this.hasMore})
      : _items = items;

  factory _$BookSearchResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookSearchResponseImplFromJson(json);

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

  @override
  String toString() {
    return 'BookSearchResponse(items: $items, page: $page, size: $size, hasMore: $hasMore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookSearchResponseImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_items), page, size, hasMore);

  /// Create a copy of BookSearchResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookSearchResponseImplCopyWith<_$BookSearchResponseImpl> get copyWith =>
      __$$BookSearchResponseImplCopyWithImpl<_$BookSearchResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookSearchResponseImplToJson(
      this,
    );
  }
}

abstract class _BookSearchResponse implements BookSearchResponse {
  const factory _BookSearchResponse(
      {required final List<BookDto> items,
      required final int page,
      required final int size,
      required final bool hasMore}) = _$BookSearchResponseImpl;

  factory _BookSearchResponse.fromJson(Map<String, dynamic> json) =
      _$BookSearchResponseImpl.fromJson;

  @override
  List<BookDto> get items;
  @override
  int get page;
  @override
  int get size;
  @override
  bool get hasMore;

  /// Create a copy of BookSearchResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookSearchResponseImplCopyWith<_$BookSearchResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LibraryPageDto _$LibraryPageDtoFromJson(Map<String, dynamic> json) {
  return _LibraryPageDto.fromJson(json);
}

/// @nodoc
mixin _$LibraryPageDto {
  List<UserBookDto> get items => throw _privateConstructorUsedError;
  String? get nextCursor => throw _privateConstructorUsedError;

  /// Serializes this LibraryPageDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LibraryPageDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LibraryPageDtoCopyWith<LibraryPageDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LibraryPageDtoCopyWith<$Res> {
  factory $LibraryPageDtoCopyWith(
          LibraryPageDto value, $Res Function(LibraryPageDto) then) =
      _$LibraryPageDtoCopyWithImpl<$Res, LibraryPageDto>;
  @useResult
  $Res call({List<UserBookDto> items, String? nextCursor});
}

/// @nodoc
class _$LibraryPageDtoCopyWithImpl<$Res, $Val extends LibraryPageDto>
    implements $LibraryPageDtoCopyWith<$Res> {
  _$LibraryPageDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LibraryPageDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? nextCursor = freezed,
  }) {
    return _then(_value.copyWith(
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<UserBookDto>,
      nextCursor: freezed == nextCursor
          ? _value.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LibraryPageDtoImplCopyWith<$Res>
    implements $LibraryPageDtoCopyWith<$Res> {
  factory _$$LibraryPageDtoImplCopyWith(_$LibraryPageDtoImpl value,
          $Res Function(_$LibraryPageDtoImpl) then) =
      __$$LibraryPageDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<UserBookDto> items, String? nextCursor});
}

/// @nodoc
class __$$LibraryPageDtoImplCopyWithImpl<$Res>
    extends _$LibraryPageDtoCopyWithImpl<$Res, _$LibraryPageDtoImpl>
    implements _$$LibraryPageDtoImplCopyWith<$Res> {
  __$$LibraryPageDtoImplCopyWithImpl(
      _$LibraryPageDtoImpl _value, $Res Function(_$LibraryPageDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of LibraryPageDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? nextCursor = freezed,
  }) {
    return _then(_$LibraryPageDtoImpl(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<UserBookDto>,
      nextCursor: freezed == nextCursor
          ? _value.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LibraryPageDtoImpl implements _LibraryPageDto {
  const _$LibraryPageDtoImpl(
      {required final List<UserBookDto> items, this.nextCursor})
      : _items = items;

  factory _$LibraryPageDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$LibraryPageDtoImplFromJson(json);

  final List<UserBookDto> _items;
  @override
  List<UserBookDto> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final String? nextCursor;

  @override
  String toString() {
    return 'LibraryPageDto(items: $items, nextCursor: $nextCursor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LibraryPageDtoImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_items), nextCursor);

  /// Create a copy of LibraryPageDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LibraryPageDtoImplCopyWith<_$LibraryPageDtoImpl> get copyWith =>
      __$$LibraryPageDtoImplCopyWithImpl<_$LibraryPageDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LibraryPageDtoImplToJson(
      this,
    );
  }
}

abstract class _LibraryPageDto implements LibraryPageDto {
  const factory _LibraryPageDto(
      {required final List<UserBookDto> items,
      final String? nextCursor}) = _$LibraryPageDtoImpl;

  factory _LibraryPageDto.fromJson(Map<String, dynamic> json) =
      _$LibraryPageDtoImpl.fromJson;

  @override
  List<UserBookDto> get items;
  @override
  String? get nextCursor;

  /// Create a copy of LibraryPageDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LibraryPageDtoImplCopyWith<_$LibraryPageDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AddToLibraryRequest _$AddToLibraryRequestFromJson(Map<String, dynamic> json) {
  return _AddToLibraryRequest.fromJson(json);
}

/// @nodoc
mixin _$AddToLibraryRequest {
  String get bookId => throw _privateConstructorUsedError;

  /// Serializes this AddToLibraryRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AddToLibraryRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddToLibraryRequestCopyWith<AddToLibraryRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddToLibraryRequestCopyWith<$Res> {
  factory $AddToLibraryRequestCopyWith(
          AddToLibraryRequest value, $Res Function(AddToLibraryRequest) then) =
      _$AddToLibraryRequestCopyWithImpl<$Res, AddToLibraryRequest>;
  @useResult
  $Res call({String bookId});
}

/// @nodoc
class _$AddToLibraryRequestCopyWithImpl<$Res, $Val extends AddToLibraryRequest>
    implements $AddToLibraryRequestCopyWith<$Res> {
  _$AddToLibraryRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AddToLibraryRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookId = null,
  }) {
    return _then(_value.copyWith(
      bookId: null == bookId
          ? _value.bookId
          : bookId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AddToLibraryRequestImplCopyWith<$Res>
    implements $AddToLibraryRequestCopyWith<$Res> {
  factory _$$AddToLibraryRequestImplCopyWith(_$AddToLibraryRequestImpl value,
          $Res Function(_$AddToLibraryRequestImpl) then) =
      __$$AddToLibraryRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String bookId});
}

/// @nodoc
class __$$AddToLibraryRequestImplCopyWithImpl<$Res>
    extends _$AddToLibraryRequestCopyWithImpl<$Res, _$AddToLibraryRequestImpl>
    implements _$$AddToLibraryRequestImplCopyWith<$Res> {
  __$$AddToLibraryRequestImplCopyWithImpl(_$AddToLibraryRequestImpl _value,
      $Res Function(_$AddToLibraryRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of AddToLibraryRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookId = null,
  }) {
    return _then(_$AddToLibraryRequestImpl(
      bookId: null == bookId
          ? _value.bookId
          : bookId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AddToLibraryRequestImpl implements _AddToLibraryRequest {
  const _$AddToLibraryRequestImpl({required this.bookId});

  factory _$AddToLibraryRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddToLibraryRequestImplFromJson(json);

  @override
  final String bookId;

  @override
  String toString() {
    return 'AddToLibraryRequest(bookId: $bookId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddToLibraryRequestImpl &&
            (identical(other.bookId, bookId) || other.bookId == bookId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, bookId);

  /// Create a copy of AddToLibraryRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddToLibraryRequestImplCopyWith<_$AddToLibraryRequestImpl> get copyWith =>
      __$$AddToLibraryRequestImplCopyWithImpl<_$AddToLibraryRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AddToLibraryRequestImplToJson(
      this,
    );
  }
}

abstract class _AddToLibraryRequest implements AddToLibraryRequest {
  const factory _AddToLibraryRequest({required final String bookId}) =
      _$AddToLibraryRequestImpl;

  factory _AddToLibraryRequest.fromJson(Map<String, dynamic> json) =
      _$AddToLibraryRequestImpl.fromJson;

  @override
  String get bookId;

  /// Create a copy of AddToLibraryRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddToLibraryRequestImplCopyWith<_$AddToLibraryRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UpdateStatusRequest _$UpdateStatusRequestFromJson(Map<String, dynamic> json) {
  return _UpdateStatusRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdateStatusRequest {
  String get status => throw _privateConstructorUsedError;

  /// Serializes this UpdateStatusRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateStatusRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateStatusRequestCopyWith<UpdateStatusRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateStatusRequestCopyWith<$Res> {
  factory $UpdateStatusRequestCopyWith(
          UpdateStatusRequest value, $Res Function(UpdateStatusRequest) then) =
      _$UpdateStatusRequestCopyWithImpl<$Res, UpdateStatusRequest>;
  @useResult
  $Res call({String status});
}

/// @nodoc
class _$UpdateStatusRequestCopyWithImpl<$Res, $Val extends UpdateStatusRequest>
    implements $UpdateStatusRequestCopyWith<$Res> {
  _$UpdateStatusRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateStatusRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UpdateStatusRequestImplCopyWith<$Res>
    implements $UpdateStatusRequestCopyWith<$Res> {
  factory _$$UpdateStatusRequestImplCopyWith(_$UpdateStatusRequestImpl value,
          $Res Function(_$UpdateStatusRequestImpl) then) =
      __$$UpdateStatusRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String status});
}

/// @nodoc
class __$$UpdateStatusRequestImplCopyWithImpl<$Res>
    extends _$UpdateStatusRequestCopyWithImpl<$Res, _$UpdateStatusRequestImpl>
    implements _$$UpdateStatusRequestImplCopyWith<$Res> {
  __$$UpdateStatusRequestImplCopyWithImpl(_$UpdateStatusRequestImpl _value,
      $Res Function(_$UpdateStatusRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of UpdateStatusRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
  }) {
    return _then(_$UpdateStatusRequestImpl(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateStatusRequestImpl implements _UpdateStatusRequest {
  const _$UpdateStatusRequestImpl({required this.status});

  factory _$UpdateStatusRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateStatusRequestImplFromJson(json);

  @override
  final String status;

  @override
  String toString() {
    return 'UpdateStatusRequest(status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateStatusRequestImpl &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, status);

  /// Create a copy of UpdateStatusRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateStatusRequestImplCopyWith<_$UpdateStatusRequestImpl> get copyWith =>
      __$$UpdateStatusRequestImplCopyWithImpl<_$UpdateStatusRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateStatusRequestImplToJson(
      this,
    );
  }
}

abstract class _UpdateStatusRequest implements UpdateStatusRequest {
  const factory _UpdateStatusRequest({required final String status}) =
      _$UpdateStatusRequestImpl;

  factory _UpdateStatusRequest.fromJson(Map<String, dynamic> json) =
      _$UpdateStatusRequestImpl.fromJson;

  @override
  String get status;

  /// Create a copy of UpdateStatusRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateStatusRequestImplCopyWith<_$UpdateStatusRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SubmitReviewRequest _$SubmitReviewRequestFromJson(Map<String, dynamic> json) {
  return _SubmitReviewRequest.fromJson(json);
}

/// @nodoc
mixin _$SubmitReviewRequest {
  int get rating => throw _privateConstructorUsedError;
  String? get oneLineReview => throw _privateConstructorUsedError;

  /// Serializes this SubmitReviewRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SubmitReviewRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubmitReviewRequestCopyWith<SubmitReviewRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubmitReviewRequestCopyWith<$Res> {
  factory $SubmitReviewRequestCopyWith(
          SubmitReviewRequest value, $Res Function(SubmitReviewRequest) then) =
      _$SubmitReviewRequestCopyWithImpl<$Res, SubmitReviewRequest>;
  @useResult
  $Res call({int rating, String? oneLineReview});
}

/// @nodoc
class _$SubmitReviewRequestCopyWithImpl<$Res, $Val extends SubmitReviewRequest>
    implements $SubmitReviewRequestCopyWith<$Res> {
  _$SubmitReviewRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubmitReviewRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rating = null,
    Object? oneLineReview = freezed,
  }) {
    return _then(_value.copyWith(
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as int,
      oneLineReview: freezed == oneLineReview
          ? _value.oneLineReview
          : oneLineReview // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SubmitReviewRequestImplCopyWith<$Res>
    implements $SubmitReviewRequestCopyWith<$Res> {
  factory _$$SubmitReviewRequestImplCopyWith(_$SubmitReviewRequestImpl value,
          $Res Function(_$SubmitReviewRequestImpl) then) =
      __$$SubmitReviewRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int rating, String? oneLineReview});
}

/// @nodoc
class __$$SubmitReviewRequestImplCopyWithImpl<$Res>
    extends _$SubmitReviewRequestCopyWithImpl<$Res, _$SubmitReviewRequestImpl>
    implements _$$SubmitReviewRequestImplCopyWith<$Res> {
  __$$SubmitReviewRequestImplCopyWithImpl(_$SubmitReviewRequestImpl _value,
      $Res Function(_$SubmitReviewRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of SubmitReviewRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rating = null,
    Object? oneLineReview = freezed,
  }) {
    return _then(_$SubmitReviewRequestImpl(
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as int,
      oneLineReview: freezed == oneLineReview
          ? _value.oneLineReview
          : oneLineReview // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SubmitReviewRequestImpl implements _SubmitReviewRequest {
  const _$SubmitReviewRequestImpl({required this.rating, this.oneLineReview});

  factory _$SubmitReviewRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubmitReviewRequestImplFromJson(json);

  @override
  final int rating;
  @override
  final String? oneLineReview;

  @override
  String toString() {
    return 'SubmitReviewRequest(rating: $rating, oneLineReview: $oneLineReview)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubmitReviewRequestImpl &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.oneLineReview, oneLineReview) ||
                other.oneLineReview == oneLineReview));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, rating, oneLineReview);

  /// Create a copy of SubmitReviewRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubmitReviewRequestImplCopyWith<_$SubmitReviewRequestImpl> get copyWith =>
      __$$SubmitReviewRequestImplCopyWithImpl<_$SubmitReviewRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubmitReviewRequestImplToJson(
      this,
    );
  }
}

abstract class _SubmitReviewRequest implements SubmitReviewRequest {
  const factory _SubmitReviewRequest(
      {required final int rating,
      final String? oneLineReview}) = _$SubmitReviewRequestImpl;

  factory _SubmitReviewRequest.fromJson(Map<String, dynamic> json) =
      _$SubmitReviewRequestImpl.fromJson;

  @override
  int get rating;
  @override
  String? get oneLineReview;

  /// Create a copy of SubmitReviewRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubmitReviewRequestImplCopyWith<_$SubmitReviewRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
