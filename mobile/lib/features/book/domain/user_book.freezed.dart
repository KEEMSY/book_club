// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_book.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UserBook {
  String get id => throw _privateConstructorUsedError;
  Book get book => throw _privateConstructorUsedError;
  BookStatus get status => throw _privateConstructorUsedError;
  DateTime get startedAt => throw _privateConstructorUsedError;
  DateTime? get finishedAt => throw _privateConstructorUsedError;
  int? get rating => throw _privateConstructorUsedError;
  String? get oneLineReview => throw _privateConstructorUsedError;

  /// Create a copy of UserBook
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserBookCopyWith<UserBook> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserBookCopyWith<$Res> {
  factory $UserBookCopyWith(UserBook value, $Res Function(UserBook) then) =
      _$UserBookCopyWithImpl<$Res, UserBook>;
  @useResult
  $Res call(
      {String id,
      Book book,
      BookStatus status,
      DateTime startedAt,
      DateTime? finishedAt,
      int? rating,
      String? oneLineReview});

  $BookCopyWith<$Res> get book;
}

/// @nodoc
class _$UserBookCopyWithImpl<$Res, $Val extends UserBook>
    implements $UserBookCopyWith<$Res> {
  _$UserBookCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserBook
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
              as Book,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as BookStatus,
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

  /// Create a copy of UserBook
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BookCopyWith<$Res> get book {
    return $BookCopyWith<$Res>(_value.book, (value) {
      return _then(_value.copyWith(book: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserBookImplCopyWith<$Res>
    implements $UserBookCopyWith<$Res> {
  factory _$$UserBookImplCopyWith(
          _$UserBookImpl value, $Res Function(_$UserBookImpl) then) =
      __$$UserBookImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      Book book,
      BookStatus status,
      DateTime startedAt,
      DateTime? finishedAt,
      int? rating,
      String? oneLineReview});

  @override
  $BookCopyWith<$Res> get book;
}

/// @nodoc
class __$$UserBookImplCopyWithImpl<$Res>
    extends _$UserBookCopyWithImpl<$Res, _$UserBookImpl>
    implements _$$UserBookImplCopyWith<$Res> {
  __$$UserBookImplCopyWithImpl(
      _$UserBookImpl _value, $Res Function(_$UserBookImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserBook
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
    return _then(_$UserBookImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      book: null == book
          ? _value.book
          : book // ignore: cast_nullable_to_non_nullable
              as Book,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as BookStatus,
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

class _$UserBookImpl implements _UserBook {
  const _$UserBookImpl(
      {required this.id,
      required this.book,
      required this.status,
      required this.startedAt,
      this.finishedAt,
      this.rating,
      this.oneLineReview});

  @override
  final String id;
  @override
  final Book book;
  @override
  final BookStatus status;
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
    return 'UserBook(id: $id, book: $book, status: $status, startedAt: $startedAt, finishedAt: $finishedAt, rating: $rating, oneLineReview: $oneLineReview)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserBookImpl &&
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

  @override
  int get hashCode => Object.hash(runtimeType, id, book, status, startedAt,
      finishedAt, rating, oneLineReview);

  /// Create a copy of UserBook
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserBookImplCopyWith<_$UserBookImpl> get copyWith =>
      __$$UserBookImplCopyWithImpl<_$UserBookImpl>(this, _$identity);
}

abstract class _UserBook implements UserBook {
  const factory _UserBook(
      {required final String id,
      required final Book book,
      required final BookStatus status,
      required final DateTime startedAt,
      final DateTime? finishedAt,
      final int? rating,
      final String? oneLineReview}) = _$UserBookImpl;

  @override
  String get id;
  @override
  Book get book;
  @override
  BookStatus get status;
  @override
  DateTime get startedAt;
  @override
  DateTime? get finishedAt;
  @override
  int? get rating;
  @override
  String? get oneLineReview;

  /// Create a copy of UserBook
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserBookImplCopyWith<_$UserBookImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
