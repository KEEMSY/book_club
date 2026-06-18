// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReviewDto {
  String get id;
  String get userId;
  String get bookId;
  double get rating;
  String? get body;
  int get reportCount;
  String? get authorNickname;
  String? get authorProfileImageUrl;
  DateTime get createdAt;
  DateTime get updatedAt;

  /// Create a copy of ReviewDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReviewDtoCopyWith<ReviewDto> get copyWith =>
      _$ReviewDtoCopyWithImpl<ReviewDto>(this as ReviewDto, _$identity);

  /// Serializes this ReviewDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReviewDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.bookId, bookId) || other.bookId == bookId) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.reportCount, reportCount) ||
                other.reportCount == reportCount) &&
            (identical(other.authorNickname, authorNickname) ||
                other.authorNickname == authorNickname) &&
            (identical(other.authorProfileImageUrl, authorProfileImageUrl) ||
                other.authorProfileImageUrl == authorProfileImageUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, bookId, rating, body,
      reportCount, authorNickname, authorProfileImageUrl, createdAt, updatedAt);

  @override
  String toString() {
    return 'ReviewDto(id: $id, userId: $userId, bookId: $bookId, rating: $rating, body: $body, reportCount: $reportCount, authorNickname: $authorNickname, authorProfileImageUrl: $authorProfileImageUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $ReviewDtoCopyWith<$Res> {
  factory $ReviewDtoCopyWith(ReviewDto value, $Res Function(ReviewDto) _then) =
      _$ReviewDtoCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String userId,
      String bookId,
      double rating,
      String? body,
      int reportCount,
      String? authorNickname,
      String? authorProfileImageUrl,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$ReviewDtoCopyWithImpl<$Res> implements $ReviewDtoCopyWith<$Res> {
  _$ReviewDtoCopyWithImpl(this._self, this._then);

  final ReviewDto _self;
  final $Res Function(ReviewDto) _then;

  /// Create a copy of ReviewDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? bookId = null,
    Object? rating = null,
    Object? body = freezed,
    Object? reportCount = null,
    Object? authorNickname = freezed,
    Object? authorProfileImageUrl = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      bookId: null == bookId
          ? _self.bookId
          : bookId // ignore: cast_nullable_to_non_nullable
              as String,
      rating: null == rating
          ? _self.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      body: freezed == body
          ? _self.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
      reportCount: null == reportCount
          ? _self.reportCount
          : reportCount // ignore: cast_nullable_to_non_nullable
              as int,
      authorNickname: freezed == authorNickname
          ? _self.authorNickname
          : authorNickname // ignore: cast_nullable_to_non_nullable
              as String?,
      authorProfileImageUrl: freezed == authorProfileImageUrl
          ? _self.authorProfileImageUrl
          : authorProfileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [ReviewDto].
extension ReviewDtoPatterns on ReviewDto {
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
    TResult Function(_ReviewDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ReviewDto() when $default != null:
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
    TResult Function(_ReviewDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReviewDto():
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
    TResult? Function(_ReviewDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReviewDto() when $default != null:
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
            String userId,
            String bookId,
            double rating,
            String? body,
            int reportCount,
            String? authorNickname,
            String? authorProfileImageUrl,
            DateTime createdAt,
            DateTime updatedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ReviewDto() when $default != null:
        return $default(
            _that.id,
            _that.userId,
            _that.bookId,
            _that.rating,
            _that.body,
            _that.reportCount,
            _that.authorNickname,
            _that.authorProfileImageUrl,
            _that.createdAt,
            _that.updatedAt);
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
            String userId,
            String bookId,
            double rating,
            String? body,
            int reportCount,
            String? authorNickname,
            String? authorProfileImageUrl,
            DateTime createdAt,
            DateTime updatedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReviewDto():
        return $default(
            _that.id,
            _that.userId,
            _that.bookId,
            _that.rating,
            _that.body,
            _that.reportCount,
            _that.authorNickname,
            _that.authorProfileImageUrl,
            _that.createdAt,
            _that.updatedAt);
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
            String userId,
            String bookId,
            double rating,
            String? body,
            int reportCount,
            String? authorNickname,
            String? authorProfileImageUrl,
            DateTime createdAt,
            DateTime updatedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReviewDto() when $default != null:
        return $default(
            _that.id,
            _that.userId,
            _that.bookId,
            _that.rating,
            _that.body,
            _that.reportCount,
            _that.authorNickname,
            _that.authorProfileImageUrl,
            _that.createdAt,
            _that.updatedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ReviewDto implements ReviewDto {
  const _ReviewDto(
      {required this.id,
      required this.userId,
      required this.bookId,
      required this.rating,
      this.body,
      this.reportCount = 0,
      this.authorNickname,
      this.authorProfileImageUrl,
      required this.createdAt,
      required this.updatedAt});
  factory _ReviewDto.fromJson(Map<String, dynamic> json) =>
      _$ReviewDtoFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String bookId;
  @override
  final double rating;
  @override
  final String? body;
  @override
  @JsonKey()
  final int reportCount;
  @override
  final String? authorNickname;
  @override
  final String? authorProfileImageUrl;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  /// Create a copy of ReviewDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ReviewDtoCopyWith<_ReviewDto> get copyWith =>
      __$ReviewDtoCopyWithImpl<_ReviewDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ReviewDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ReviewDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.bookId, bookId) || other.bookId == bookId) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.reportCount, reportCount) ||
                other.reportCount == reportCount) &&
            (identical(other.authorNickname, authorNickname) ||
                other.authorNickname == authorNickname) &&
            (identical(other.authorProfileImageUrl, authorProfileImageUrl) ||
                other.authorProfileImageUrl == authorProfileImageUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, bookId, rating, body,
      reportCount, authorNickname, authorProfileImageUrl, createdAt, updatedAt);

  @override
  String toString() {
    return 'ReviewDto(id: $id, userId: $userId, bookId: $bookId, rating: $rating, body: $body, reportCount: $reportCount, authorNickname: $authorNickname, authorProfileImageUrl: $authorProfileImageUrl, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$ReviewDtoCopyWith<$Res>
    implements $ReviewDtoCopyWith<$Res> {
  factory _$ReviewDtoCopyWith(
          _ReviewDto value, $Res Function(_ReviewDto) _then) =
      __$ReviewDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String bookId,
      double rating,
      String? body,
      int reportCount,
      String? authorNickname,
      String? authorProfileImageUrl,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$ReviewDtoCopyWithImpl<$Res> implements _$ReviewDtoCopyWith<$Res> {
  __$ReviewDtoCopyWithImpl(this._self, this._then);

  final _ReviewDto _self;
  final $Res Function(_ReviewDto) _then;

  /// Create a copy of ReviewDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? bookId = null,
    Object? rating = null,
    Object? body = freezed,
    Object? reportCount = null,
    Object? authorNickname = freezed,
    Object? authorProfileImageUrl = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_ReviewDto(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      bookId: null == bookId
          ? _self.bookId
          : bookId // ignore: cast_nullable_to_non_nullable
              as String,
      rating: null == rating
          ? _self.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      body: freezed == body
          ? _self.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
      reportCount: null == reportCount
          ? _self.reportCount
          : reportCount // ignore: cast_nullable_to_non_nullable
              as int,
      authorNickname: freezed == authorNickname
          ? _self.authorNickname
          : authorNickname // ignore: cast_nullable_to_non_nullable
              as String?,
      authorProfileImageUrl: freezed == authorProfileImageUrl
          ? _self.authorProfileImageUrl
          : authorProfileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
mixin _$BookReviewSummaryDto {
  double get averageRating;
  int get ratingCount;
  Map<String, int> get distribution;
  List<ReviewDto> get reviews;

  /// Create a copy of BookReviewSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BookReviewSummaryDtoCopyWith<BookReviewSummaryDto> get copyWith =>
      _$BookReviewSummaryDtoCopyWithImpl<BookReviewSummaryDto>(
          this as BookReviewSummaryDto, _$identity);

  /// Serializes this BookReviewSummaryDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BookReviewSummaryDto &&
            (identical(other.averageRating, averageRating) ||
                other.averageRating == averageRating) &&
            (identical(other.ratingCount, ratingCount) ||
                other.ratingCount == ratingCount) &&
            const DeepCollectionEquality()
                .equals(other.distribution, distribution) &&
            const DeepCollectionEquality().equals(other.reviews, reviews));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      averageRating,
      ratingCount,
      const DeepCollectionEquality().hash(distribution),
      const DeepCollectionEquality().hash(reviews));

  @override
  String toString() {
    return 'BookReviewSummaryDto(averageRating: $averageRating, ratingCount: $ratingCount, distribution: $distribution, reviews: $reviews)';
  }
}

/// @nodoc
abstract mixin class $BookReviewSummaryDtoCopyWith<$Res> {
  factory $BookReviewSummaryDtoCopyWith(BookReviewSummaryDto value,
          $Res Function(BookReviewSummaryDto) _then) =
      _$BookReviewSummaryDtoCopyWithImpl;
  @useResult
  $Res call(
      {double averageRating,
      int ratingCount,
      Map<String, int> distribution,
      List<ReviewDto> reviews});
}

/// @nodoc
class _$BookReviewSummaryDtoCopyWithImpl<$Res>
    implements $BookReviewSummaryDtoCopyWith<$Res> {
  _$BookReviewSummaryDtoCopyWithImpl(this._self, this._then);

  final BookReviewSummaryDto _self;
  final $Res Function(BookReviewSummaryDto) _then;

  /// Create a copy of BookReviewSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? averageRating = null,
    Object? ratingCount = null,
    Object? distribution = null,
    Object? reviews = null,
  }) {
    return _then(_self.copyWith(
      averageRating: null == averageRating
          ? _self.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
      ratingCount: null == ratingCount
          ? _self.ratingCount
          : ratingCount // ignore: cast_nullable_to_non_nullable
              as int,
      distribution: null == distribution
          ? _self.distribution
          : distribution // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      reviews: null == reviews
          ? _self.reviews
          : reviews // ignore: cast_nullable_to_non_nullable
              as List<ReviewDto>,
    ));
  }
}

/// Adds pattern-matching-related methods to [BookReviewSummaryDto].
extension BookReviewSummaryDtoPatterns on BookReviewSummaryDto {
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
    TResult Function(_BookReviewSummaryDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BookReviewSummaryDto() when $default != null:
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
    TResult Function(_BookReviewSummaryDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BookReviewSummaryDto():
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
    TResult? Function(_BookReviewSummaryDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BookReviewSummaryDto() when $default != null:
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
    TResult Function(double averageRating, int ratingCount,
            Map<String, int> distribution, List<ReviewDto> reviews)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BookReviewSummaryDto() when $default != null:
        return $default(_that.averageRating, _that.ratingCount,
            _that.distribution, _that.reviews);
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
    TResult Function(double averageRating, int ratingCount,
            Map<String, int> distribution, List<ReviewDto> reviews)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BookReviewSummaryDto():
        return $default(_that.averageRating, _that.ratingCount,
            _that.distribution, _that.reviews);
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
    TResult? Function(double averageRating, int ratingCount,
            Map<String, int> distribution, List<ReviewDto> reviews)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BookReviewSummaryDto() when $default != null:
        return $default(_that.averageRating, _that.ratingCount,
            _that.distribution, _that.reviews);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _BookReviewSummaryDto implements BookReviewSummaryDto {
  const _BookReviewSummaryDto(
      {this.averageRating = 0.0,
      this.ratingCount = 0,
      final Map<String, int> distribution = const <String, int>{},
      final List<ReviewDto> reviews = const <ReviewDto>[]})
      : _distribution = distribution,
        _reviews = reviews;
  factory _BookReviewSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$BookReviewSummaryDtoFromJson(json);

  @override
  @JsonKey()
  final double averageRating;
  @override
  @JsonKey()
  final int ratingCount;
  final Map<String, int> _distribution;
  @override
  @JsonKey()
  Map<String, int> get distribution {
    if (_distribution is EqualUnmodifiableMapView) return _distribution;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_distribution);
  }

  final List<ReviewDto> _reviews;
  @override
  @JsonKey()
  List<ReviewDto> get reviews {
    if (_reviews is EqualUnmodifiableListView) return _reviews;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reviews);
  }

  /// Create a copy of BookReviewSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BookReviewSummaryDtoCopyWith<_BookReviewSummaryDto> get copyWith =>
      __$BookReviewSummaryDtoCopyWithImpl<_BookReviewSummaryDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BookReviewSummaryDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BookReviewSummaryDto &&
            (identical(other.averageRating, averageRating) ||
                other.averageRating == averageRating) &&
            (identical(other.ratingCount, ratingCount) ||
                other.ratingCount == ratingCount) &&
            const DeepCollectionEquality()
                .equals(other._distribution, _distribution) &&
            const DeepCollectionEquality().equals(other._reviews, _reviews));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      averageRating,
      ratingCount,
      const DeepCollectionEquality().hash(_distribution),
      const DeepCollectionEquality().hash(_reviews));

  @override
  String toString() {
    return 'BookReviewSummaryDto(averageRating: $averageRating, ratingCount: $ratingCount, distribution: $distribution, reviews: $reviews)';
  }
}

/// @nodoc
abstract mixin class _$BookReviewSummaryDtoCopyWith<$Res>
    implements $BookReviewSummaryDtoCopyWith<$Res> {
  factory _$BookReviewSummaryDtoCopyWith(_BookReviewSummaryDto value,
          $Res Function(_BookReviewSummaryDto) _then) =
      __$BookReviewSummaryDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {double averageRating,
      int ratingCount,
      Map<String, int> distribution,
      List<ReviewDto> reviews});
}

/// @nodoc
class __$BookReviewSummaryDtoCopyWithImpl<$Res>
    implements _$BookReviewSummaryDtoCopyWith<$Res> {
  __$BookReviewSummaryDtoCopyWithImpl(this._self, this._then);

  final _BookReviewSummaryDto _self;
  final $Res Function(_BookReviewSummaryDto) _then;

  /// Create a copy of BookReviewSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? averageRating = null,
    Object? ratingCount = null,
    Object? distribution = null,
    Object? reviews = null,
  }) {
    return _then(_BookReviewSummaryDto(
      averageRating: null == averageRating
          ? _self.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
      ratingCount: null == ratingCount
          ? _self.ratingCount
          : ratingCount // ignore: cast_nullable_to_non_nullable
              as int,
      distribution: null == distribution
          ? _self._distribution
          : distribution // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      reviews: null == reviews
          ? _self._reviews
          : reviews // ignore: cast_nullable_to_non_nullable
              as List<ReviewDto>,
    ));
  }
}

/// @nodoc
mixin _$CreateReviewRequest {
  double get rating;
  String? get body;

  /// Create a copy of CreateReviewRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CreateReviewRequestCopyWith<CreateReviewRequest> get copyWith =>
      _$CreateReviewRequestCopyWithImpl<CreateReviewRequest>(
          this as CreateReviewRequest, _$identity);

  /// Serializes this CreateReviewRequest to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CreateReviewRequest &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.body, body) || other.body == body));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, rating, body);

  @override
  String toString() {
    return 'CreateReviewRequest(rating: $rating, body: $body)';
  }
}

/// @nodoc
abstract mixin class $CreateReviewRequestCopyWith<$Res> {
  factory $CreateReviewRequestCopyWith(
          CreateReviewRequest value, $Res Function(CreateReviewRequest) _then) =
      _$CreateReviewRequestCopyWithImpl;
  @useResult
  $Res call({double rating, String? body});
}

/// @nodoc
class _$CreateReviewRequestCopyWithImpl<$Res>
    implements $CreateReviewRequestCopyWith<$Res> {
  _$CreateReviewRequestCopyWithImpl(this._self, this._then);

  final CreateReviewRequest _self;
  final $Res Function(CreateReviewRequest) _then;

  /// Create a copy of CreateReviewRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rating = null,
    Object? body = freezed,
  }) {
    return _then(_self.copyWith(
      rating: null == rating
          ? _self.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      body: freezed == body
          ? _self.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [CreateReviewRequest].
extension CreateReviewRequestPatterns on CreateReviewRequest {
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
    TResult Function(_CreateReviewRequest value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CreateReviewRequest() when $default != null:
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
    TResult Function(_CreateReviewRequest value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreateReviewRequest():
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
    TResult? Function(_CreateReviewRequest value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreateReviewRequest() when $default != null:
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
    TResult Function(double rating, String? body)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _CreateReviewRequest() when $default != null:
        return $default(_that.rating, _that.body);
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
    TResult Function(double rating, String? body) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreateReviewRequest():
        return $default(_that.rating, _that.body);
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
    TResult? Function(double rating, String? body)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _CreateReviewRequest() when $default != null:
        return $default(_that.rating, _that.body);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _CreateReviewRequest implements CreateReviewRequest {
  const _CreateReviewRequest({required this.rating, this.body});
  factory _CreateReviewRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateReviewRequestFromJson(json);

  @override
  final double rating;
  @override
  final String? body;

  /// Create a copy of CreateReviewRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CreateReviewRequestCopyWith<_CreateReviewRequest> get copyWith =>
      __$CreateReviewRequestCopyWithImpl<_CreateReviewRequest>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CreateReviewRequestToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CreateReviewRequest &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.body, body) || other.body == body));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, rating, body);

  @override
  String toString() {
    return 'CreateReviewRequest(rating: $rating, body: $body)';
  }
}

/// @nodoc
abstract mixin class _$CreateReviewRequestCopyWith<$Res>
    implements $CreateReviewRequestCopyWith<$Res> {
  factory _$CreateReviewRequestCopyWith(_CreateReviewRequest value,
          $Res Function(_CreateReviewRequest) _then) =
      __$CreateReviewRequestCopyWithImpl;
  @override
  @useResult
  $Res call({double rating, String? body});
}

/// @nodoc
class __$CreateReviewRequestCopyWithImpl<$Res>
    implements _$CreateReviewRequestCopyWith<$Res> {
  __$CreateReviewRequestCopyWithImpl(this._self, this._then);

  final _CreateReviewRequest _self;
  final $Res Function(_CreateReviewRequest) _then;

  /// Create a copy of CreateReviewRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? rating = null,
    Object? body = freezed,
  }) {
    return _then(_CreateReviewRequest(
      rating: null == rating
          ? _self.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      body: freezed == body
          ? _self.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$UpdateReviewRequest {
  double? get rating;
  String? get body;

  /// Create a copy of UpdateReviewRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UpdateReviewRequestCopyWith<UpdateReviewRequest> get copyWith =>
      _$UpdateReviewRequestCopyWithImpl<UpdateReviewRequest>(
          this as UpdateReviewRequest, _$identity);

  /// Serializes this UpdateReviewRequest to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UpdateReviewRequest &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.body, body) || other.body == body));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, rating, body);

  @override
  String toString() {
    return 'UpdateReviewRequest(rating: $rating, body: $body)';
  }
}

/// @nodoc
abstract mixin class $UpdateReviewRequestCopyWith<$Res> {
  factory $UpdateReviewRequestCopyWith(
          UpdateReviewRequest value, $Res Function(UpdateReviewRequest) _then) =
      _$UpdateReviewRequestCopyWithImpl;
  @useResult
  $Res call({double? rating, String? body});
}

/// @nodoc
class _$UpdateReviewRequestCopyWithImpl<$Res>
    implements $UpdateReviewRequestCopyWith<$Res> {
  _$UpdateReviewRequestCopyWithImpl(this._self, this._then);

  final UpdateReviewRequest _self;
  final $Res Function(UpdateReviewRequest) _then;

  /// Create a copy of UpdateReviewRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rating = freezed,
    Object? body = freezed,
  }) {
    return _then(_self.copyWith(
      rating: freezed == rating
          ? _self.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      body: freezed == body
          ? _self.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [UpdateReviewRequest].
extension UpdateReviewRequestPatterns on UpdateReviewRequest {
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
    TResult Function(_UpdateReviewRequest value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UpdateReviewRequest() when $default != null:
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
    TResult Function(_UpdateReviewRequest value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UpdateReviewRequest():
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
    TResult? Function(_UpdateReviewRequest value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UpdateReviewRequest() when $default != null:
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
    TResult Function(double? rating, String? body)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UpdateReviewRequest() when $default != null:
        return $default(_that.rating, _that.body);
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
    TResult Function(double? rating, String? body) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UpdateReviewRequest():
        return $default(_that.rating, _that.body);
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
    TResult? Function(double? rating, String? body)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UpdateReviewRequest() when $default != null:
        return $default(_that.rating, _that.body);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _UpdateReviewRequest implements UpdateReviewRequest {
  const _UpdateReviewRequest({this.rating, this.body});
  factory _UpdateReviewRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateReviewRequestFromJson(json);

  @override
  final double? rating;
  @override
  final String? body;

  /// Create a copy of UpdateReviewRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UpdateReviewRequestCopyWith<_UpdateReviewRequest> get copyWith =>
      __$UpdateReviewRequestCopyWithImpl<_UpdateReviewRequest>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UpdateReviewRequestToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UpdateReviewRequest &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.body, body) || other.body == body));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, rating, body);

  @override
  String toString() {
    return 'UpdateReviewRequest(rating: $rating, body: $body)';
  }
}

/// @nodoc
abstract mixin class _$UpdateReviewRequestCopyWith<$Res>
    implements $UpdateReviewRequestCopyWith<$Res> {
  factory _$UpdateReviewRequestCopyWith(_UpdateReviewRequest value,
          $Res Function(_UpdateReviewRequest) _then) =
      __$UpdateReviewRequestCopyWithImpl;
  @override
  @useResult
  $Res call({double? rating, String? body});
}

/// @nodoc
class __$UpdateReviewRequestCopyWithImpl<$Res>
    implements _$UpdateReviewRequestCopyWith<$Res> {
  __$UpdateReviewRequestCopyWithImpl(this._self, this._then);

  final _UpdateReviewRequest _self;
  final $Res Function(_UpdateReviewRequest) _then;

  /// Create a copy of UpdateReviewRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? rating = freezed,
    Object? body = freezed,
  }) {
    return _then(_UpdateReviewRequest(
      rating: freezed == rating
          ? _self.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      body: freezed == body
          ? _self.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
