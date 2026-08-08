// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_activity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ActivityCounts {
  int get reviews;
  int get highlights;
  int get agendas;
  int get clubs;
  int get readingBooks;

  /// Create a copy of ActivityCounts
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ActivityCountsCopyWith<ActivityCounts> get copyWith =>
      _$ActivityCountsCopyWithImpl<ActivityCounts>(
          this as ActivityCounts, _$identity);

  /// Serializes this ActivityCounts to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ActivityCounts &&
            (identical(other.reviews, reviews) || other.reviews == reviews) &&
            (identical(other.highlights, highlights) ||
                other.highlights == highlights) &&
            (identical(other.agendas, agendas) || other.agendas == agendas) &&
            (identical(other.clubs, clubs) || other.clubs == clubs) &&
            (identical(other.readingBooks, readingBooks) ||
                other.readingBooks == readingBooks));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, reviews, highlights, agendas, clubs, readingBooks);

  @override
  String toString() {
    return 'ActivityCounts(reviews: $reviews, highlights: $highlights, agendas: $agendas, clubs: $clubs, readingBooks: $readingBooks)';
  }
}

/// @nodoc
abstract mixin class $ActivityCountsCopyWith<$Res> {
  factory $ActivityCountsCopyWith(
          ActivityCounts value, $Res Function(ActivityCounts) _then) =
      _$ActivityCountsCopyWithImpl;
  @useResult
  $Res call(
      {int reviews, int highlights, int agendas, int clubs, int readingBooks});
}

/// @nodoc
class _$ActivityCountsCopyWithImpl<$Res>
    implements $ActivityCountsCopyWith<$Res> {
  _$ActivityCountsCopyWithImpl(this._self, this._then);

  final ActivityCounts _self;
  final $Res Function(ActivityCounts) _then;

  /// Create a copy of ActivityCounts
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reviews = null,
    Object? highlights = null,
    Object? agendas = null,
    Object? clubs = null,
    Object? readingBooks = null,
  }) {
    return _then(_self.copyWith(
      reviews: null == reviews
          ? _self.reviews
          : reviews // ignore: cast_nullable_to_non_nullable
              as int,
      highlights: null == highlights
          ? _self.highlights
          : highlights // ignore: cast_nullable_to_non_nullable
              as int,
      agendas: null == agendas
          ? _self.agendas
          : agendas // ignore: cast_nullable_to_non_nullable
              as int,
      clubs: null == clubs
          ? _self.clubs
          : clubs // ignore: cast_nullable_to_non_nullable
              as int,
      readingBooks: null == readingBooks
          ? _self.readingBooks
          : readingBooks // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [ActivityCounts].
extension ActivityCountsPatterns on ActivityCounts {
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
    TResult Function(_ActivityCounts value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ActivityCounts() when $default != null:
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
    TResult Function(_ActivityCounts value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActivityCounts():
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
    TResult? Function(_ActivityCounts value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActivityCounts() when $default != null:
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
    TResult Function(int reviews, int highlights, int agendas, int clubs,
            int readingBooks)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ActivityCounts() when $default != null:
        return $default(_that.reviews, _that.highlights, _that.agendas,
            _that.clubs, _that.readingBooks);
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
    TResult Function(int reviews, int highlights, int agendas, int clubs,
            int readingBooks)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActivityCounts():
        return $default(_that.reviews, _that.highlights, _that.agendas,
            _that.clubs, _that.readingBooks);
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
    TResult? Function(int reviews, int highlights, int agendas, int clubs,
            int readingBooks)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActivityCounts() when $default != null:
        return $default(_that.reviews, _that.highlights, _that.agendas,
            _that.clubs, _that.readingBooks);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ActivityCounts implements ActivityCounts {
  const _ActivityCounts(
      {required this.reviews,
      required this.highlights,
      required this.agendas,
      required this.clubs,
      required this.readingBooks});
  factory _ActivityCounts.fromJson(Map<String, dynamic> json) =>
      _$ActivityCountsFromJson(json);

  @override
  final int reviews;
  @override
  final int highlights;
  @override
  final int agendas;
  @override
  final int clubs;
  @override
  final int readingBooks;

  /// Create a copy of ActivityCounts
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ActivityCountsCopyWith<_ActivityCounts> get copyWith =>
      __$ActivityCountsCopyWithImpl<_ActivityCounts>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ActivityCountsToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ActivityCounts &&
            (identical(other.reviews, reviews) || other.reviews == reviews) &&
            (identical(other.highlights, highlights) ||
                other.highlights == highlights) &&
            (identical(other.agendas, agendas) || other.agendas == agendas) &&
            (identical(other.clubs, clubs) || other.clubs == clubs) &&
            (identical(other.readingBooks, readingBooks) ||
                other.readingBooks == readingBooks));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, reviews, highlights, agendas, clubs, readingBooks);

  @override
  String toString() {
    return 'ActivityCounts(reviews: $reviews, highlights: $highlights, agendas: $agendas, clubs: $clubs, readingBooks: $readingBooks)';
  }
}

/// @nodoc
abstract mixin class _$ActivityCountsCopyWith<$Res>
    implements $ActivityCountsCopyWith<$Res> {
  factory _$ActivityCountsCopyWith(
          _ActivityCounts value, $Res Function(_ActivityCounts) _then) =
      __$ActivityCountsCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int reviews, int highlights, int agendas, int clubs, int readingBooks});
}

/// @nodoc
class __$ActivityCountsCopyWithImpl<$Res>
    implements _$ActivityCountsCopyWith<$Res> {
  __$ActivityCountsCopyWithImpl(this._self, this._then);

  final _ActivityCounts _self;
  final $Res Function(_ActivityCounts) _then;

  /// Create a copy of ActivityCounts
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? reviews = null,
    Object? highlights = null,
    Object? agendas = null,
    Object? clubs = null,
    Object? readingBooks = null,
  }) {
    return _then(_ActivityCounts(
      reviews: null == reviews
          ? _self.reviews
          : reviews // ignore: cast_nullable_to_non_nullable
              as int,
      highlights: null == highlights
          ? _self.highlights
          : highlights // ignore: cast_nullable_to_non_nullable
              as int,
      agendas: null == agendas
          ? _self.agendas
          : agendas // ignore: cast_nullable_to_non_nullable
              as int,
      clubs: null == clubs
          ? _self.clubs
          : clubs // ignore: cast_nullable_to_non_nullable
              as int,
      readingBooks: null == readingBooks
          ? _self.readingBooks
          : readingBooks // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$ActivityReviewItem {
  String get id;
  String get bookId;
  String? get bookTitle;
  String? get bookCoverUrl;
  double get rating;
  String? get body;
  DateTime get createdAt;

  /// Create a copy of ActivityReviewItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ActivityReviewItemCopyWith<ActivityReviewItem> get copyWith =>
      _$ActivityReviewItemCopyWithImpl<ActivityReviewItem>(
          this as ActivityReviewItem, _$identity);

  /// Serializes this ActivityReviewItem to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ActivityReviewItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.bookId, bookId) || other.bookId == bookId) &&
            (identical(other.bookTitle, bookTitle) ||
                other.bookTitle == bookTitle) &&
            (identical(other.bookCoverUrl, bookCoverUrl) ||
                other.bookCoverUrl == bookCoverUrl) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, bookId, bookTitle,
      bookCoverUrl, rating, body, createdAt);

  @override
  String toString() {
    return 'ActivityReviewItem(id: $id, bookId: $bookId, bookTitle: $bookTitle, bookCoverUrl: $bookCoverUrl, rating: $rating, body: $body, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $ActivityReviewItemCopyWith<$Res> {
  factory $ActivityReviewItemCopyWith(
          ActivityReviewItem value, $Res Function(ActivityReviewItem) _then) =
      _$ActivityReviewItemCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String bookId,
      String? bookTitle,
      String? bookCoverUrl,
      double rating,
      String? body,
      DateTime createdAt});
}

/// @nodoc
class _$ActivityReviewItemCopyWithImpl<$Res>
    implements $ActivityReviewItemCopyWith<$Res> {
  _$ActivityReviewItemCopyWithImpl(this._self, this._then);

  final ActivityReviewItem _self;
  final $Res Function(ActivityReviewItem) _then;

  /// Create a copy of ActivityReviewItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bookId = null,
    Object? bookTitle = freezed,
    Object? bookCoverUrl = freezed,
    Object? rating = null,
    Object? body = freezed,
    Object? createdAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      bookId: null == bookId
          ? _self.bookId
          : bookId // ignore: cast_nullable_to_non_nullable
              as String,
      bookTitle: freezed == bookTitle
          ? _self.bookTitle
          : bookTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      bookCoverUrl: freezed == bookCoverUrl
          ? _self.bookCoverUrl
          : bookCoverUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: null == rating
          ? _self.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      body: freezed == body
          ? _self.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [ActivityReviewItem].
extension ActivityReviewItemPatterns on ActivityReviewItem {
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
    TResult Function(_ActivityReviewItem value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ActivityReviewItem() when $default != null:
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
    TResult Function(_ActivityReviewItem value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActivityReviewItem():
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
    TResult? Function(_ActivityReviewItem value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActivityReviewItem() when $default != null:
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
            String bookId,
            String? bookTitle,
            String? bookCoverUrl,
            double rating,
            String? body,
            DateTime createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ActivityReviewItem() when $default != null:
        return $default(_that.id, _that.bookId, _that.bookTitle,
            _that.bookCoverUrl, _that.rating, _that.body, _that.createdAt);
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
            String bookId,
            String? bookTitle,
            String? bookCoverUrl,
            double rating,
            String? body,
            DateTime createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActivityReviewItem():
        return $default(_that.id, _that.bookId, _that.bookTitle,
            _that.bookCoverUrl, _that.rating, _that.body, _that.createdAt);
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
            String bookId,
            String? bookTitle,
            String? bookCoverUrl,
            double rating,
            String? body,
            DateTime createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActivityReviewItem() when $default != null:
        return $default(_that.id, _that.bookId, _that.bookTitle,
            _that.bookCoverUrl, _that.rating, _that.body, _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ActivityReviewItem implements ActivityReviewItem {
  const _ActivityReviewItem(
      {required this.id,
      required this.bookId,
      this.bookTitle,
      this.bookCoverUrl,
      required this.rating,
      this.body,
      required this.createdAt});
  factory _ActivityReviewItem.fromJson(Map<String, dynamic> json) =>
      _$ActivityReviewItemFromJson(json);

  @override
  final String id;
  @override
  final String bookId;
  @override
  final String? bookTitle;
  @override
  final String? bookCoverUrl;
  @override
  final double rating;
  @override
  final String? body;
  @override
  final DateTime createdAt;

  /// Create a copy of ActivityReviewItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ActivityReviewItemCopyWith<_ActivityReviewItem> get copyWith =>
      __$ActivityReviewItemCopyWithImpl<_ActivityReviewItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ActivityReviewItemToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ActivityReviewItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.bookId, bookId) || other.bookId == bookId) &&
            (identical(other.bookTitle, bookTitle) ||
                other.bookTitle == bookTitle) &&
            (identical(other.bookCoverUrl, bookCoverUrl) ||
                other.bookCoverUrl == bookCoverUrl) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, bookId, bookTitle,
      bookCoverUrl, rating, body, createdAt);

  @override
  String toString() {
    return 'ActivityReviewItem(id: $id, bookId: $bookId, bookTitle: $bookTitle, bookCoverUrl: $bookCoverUrl, rating: $rating, body: $body, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$ActivityReviewItemCopyWith<$Res>
    implements $ActivityReviewItemCopyWith<$Res> {
  factory _$ActivityReviewItemCopyWith(
          _ActivityReviewItem value, $Res Function(_ActivityReviewItem) _then) =
      __$ActivityReviewItemCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String bookId,
      String? bookTitle,
      String? bookCoverUrl,
      double rating,
      String? body,
      DateTime createdAt});
}

/// @nodoc
class __$ActivityReviewItemCopyWithImpl<$Res>
    implements _$ActivityReviewItemCopyWith<$Res> {
  __$ActivityReviewItemCopyWithImpl(this._self, this._then);

  final _ActivityReviewItem _self;
  final $Res Function(_ActivityReviewItem) _then;

  /// Create a copy of ActivityReviewItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? bookId = null,
    Object? bookTitle = freezed,
    Object? bookCoverUrl = freezed,
    Object? rating = null,
    Object? body = freezed,
    Object? createdAt = null,
  }) {
    return _then(_ActivityReviewItem(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      bookId: null == bookId
          ? _self.bookId
          : bookId // ignore: cast_nullable_to_non_nullable
              as String,
      bookTitle: freezed == bookTitle
          ? _self.bookTitle
          : bookTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      bookCoverUrl: freezed == bookCoverUrl
          ? _self.bookCoverUrl
          : bookCoverUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: null == rating
          ? _self.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double,
      body: freezed == body
          ? _self.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
mixin _$ActivityHighlightItem {
  String get id;
  String get bookId;
  String? get bookTitle;
  String? get bookCoverUrl;
  String get quoteText;
  DateTime get createdAt;

  /// Create a copy of ActivityHighlightItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ActivityHighlightItemCopyWith<ActivityHighlightItem> get copyWith =>
      _$ActivityHighlightItemCopyWithImpl<ActivityHighlightItem>(
          this as ActivityHighlightItem, _$identity);

  /// Serializes this ActivityHighlightItem to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ActivityHighlightItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.bookId, bookId) || other.bookId == bookId) &&
            (identical(other.bookTitle, bookTitle) ||
                other.bookTitle == bookTitle) &&
            (identical(other.bookCoverUrl, bookCoverUrl) ||
                other.bookCoverUrl == bookCoverUrl) &&
            (identical(other.quoteText, quoteText) ||
                other.quoteText == quoteText) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, bookId, bookTitle, bookCoverUrl, quoteText, createdAt);

  @override
  String toString() {
    return 'ActivityHighlightItem(id: $id, bookId: $bookId, bookTitle: $bookTitle, bookCoverUrl: $bookCoverUrl, quoteText: $quoteText, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $ActivityHighlightItemCopyWith<$Res> {
  factory $ActivityHighlightItemCopyWith(ActivityHighlightItem value,
          $Res Function(ActivityHighlightItem) _then) =
      _$ActivityHighlightItemCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String bookId,
      String? bookTitle,
      String? bookCoverUrl,
      String quoteText,
      DateTime createdAt});
}

/// @nodoc
class _$ActivityHighlightItemCopyWithImpl<$Res>
    implements $ActivityHighlightItemCopyWith<$Res> {
  _$ActivityHighlightItemCopyWithImpl(this._self, this._then);

  final ActivityHighlightItem _self;
  final $Res Function(ActivityHighlightItem) _then;

  /// Create a copy of ActivityHighlightItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bookId = null,
    Object? bookTitle = freezed,
    Object? bookCoverUrl = freezed,
    Object? quoteText = null,
    Object? createdAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      bookId: null == bookId
          ? _self.bookId
          : bookId // ignore: cast_nullable_to_non_nullable
              as String,
      bookTitle: freezed == bookTitle
          ? _self.bookTitle
          : bookTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      bookCoverUrl: freezed == bookCoverUrl
          ? _self.bookCoverUrl
          : bookCoverUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      quoteText: null == quoteText
          ? _self.quoteText
          : quoteText // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [ActivityHighlightItem].
extension ActivityHighlightItemPatterns on ActivityHighlightItem {
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
    TResult Function(_ActivityHighlightItem value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ActivityHighlightItem() when $default != null:
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
    TResult Function(_ActivityHighlightItem value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActivityHighlightItem():
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
    TResult? Function(_ActivityHighlightItem value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActivityHighlightItem() when $default != null:
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
    TResult Function(String id, String bookId, String? bookTitle,
            String? bookCoverUrl, String quoteText, DateTime createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ActivityHighlightItem() when $default != null:
        return $default(_that.id, _that.bookId, _that.bookTitle,
            _that.bookCoverUrl, _that.quoteText, _that.createdAt);
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
    TResult Function(String id, String bookId, String? bookTitle,
            String? bookCoverUrl, String quoteText, DateTime createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActivityHighlightItem():
        return $default(_that.id, _that.bookId, _that.bookTitle,
            _that.bookCoverUrl, _that.quoteText, _that.createdAt);
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
    TResult? Function(String id, String bookId, String? bookTitle,
            String? bookCoverUrl, String quoteText, DateTime createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActivityHighlightItem() when $default != null:
        return $default(_that.id, _that.bookId, _that.bookTitle,
            _that.bookCoverUrl, _that.quoteText, _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ActivityHighlightItem implements ActivityHighlightItem {
  const _ActivityHighlightItem(
      {required this.id,
      required this.bookId,
      this.bookTitle,
      this.bookCoverUrl,
      required this.quoteText,
      required this.createdAt});
  factory _ActivityHighlightItem.fromJson(Map<String, dynamic> json) =>
      _$ActivityHighlightItemFromJson(json);

  @override
  final String id;
  @override
  final String bookId;
  @override
  final String? bookTitle;
  @override
  final String? bookCoverUrl;
  @override
  final String quoteText;
  @override
  final DateTime createdAt;

  /// Create a copy of ActivityHighlightItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ActivityHighlightItemCopyWith<_ActivityHighlightItem> get copyWith =>
      __$ActivityHighlightItemCopyWithImpl<_ActivityHighlightItem>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ActivityHighlightItemToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ActivityHighlightItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.bookId, bookId) || other.bookId == bookId) &&
            (identical(other.bookTitle, bookTitle) ||
                other.bookTitle == bookTitle) &&
            (identical(other.bookCoverUrl, bookCoverUrl) ||
                other.bookCoverUrl == bookCoverUrl) &&
            (identical(other.quoteText, quoteText) ||
                other.quoteText == quoteText) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, bookId, bookTitle, bookCoverUrl, quoteText, createdAt);

  @override
  String toString() {
    return 'ActivityHighlightItem(id: $id, bookId: $bookId, bookTitle: $bookTitle, bookCoverUrl: $bookCoverUrl, quoteText: $quoteText, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$ActivityHighlightItemCopyWith<$Res>
    implements $ActivityHighlightItemCopyWith<$Res> {
  factory _$ActivityHighlightItemCopyWith(_ActivityHighlightItem value,
          $Res Function(_ActivityHighlightItem) _then) =
      __$ActivityHighlightItemCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String bookId,
      String? bookTitle,
      String? bookCoverUrl,
      String quoteText,
      DateTime createdAt});
}

/// @nodoc
class __$ActivityHighlightItemCopyWithImpl<$Res>
    implements _$ActivityHighlightItemCopyWith<$Res> {
  __$ActivityHighlightItemCopyWithImpl(this._self, this._then);

  final _ActivityHighlightItem _self;
  final $Res Function(_ActivityHighlightItem) _then;

  /// Create a copy of ActivityHighlightItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? bookId = null,
    Object? bookTitle = freezed,
    Object? bookCoverUrl = freezed,
    Object? quoteText = null,
    Object? createdAt = null,
  }) {
    return _then(_ActivityHighlightItem(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      bookId: null == bookId
          ? _self.bookId
          : bookId // ignore: cast_nullable_to_non_nullable
              as String,
      bookTitle: freezed == bookTitle
          ? _self.bookTitle
          : bookTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      bookCoverUrl: freezed == bookCoverUrl
          ? _self.bookCoverUrl
          : bookCoverUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      quoteText: null == quoteText
          ? _self.quoteText
          : quoteText // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
mixin _$ActivityAgendaItem {
  String get id;
  String get clubId;
  String get clubName;
  String get sessionId;
  String get sessionTitle;
  String get status;
  DateTime? get publishedAt;
  DateTime get createdAt;

  /// Create a copy of ActivityAgendaItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ActivityAgendaItemCopyWith<ActivityAgendaItem> get copyWith =>
      _$ActivityAgendaItemCopyWithImpl<ActivityAgendaItem>(
          this as ActivityAgendaItem, _$identity);

  /// Serializes this ActivityAgendaItem to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ActivityAgendaItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.clubId, clubId) || other.clubId == clubId) &&
            (identical(other.clubName, clubName) ||
                other.clubName == clubName) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.sessionTitle, sessionTitle) ||
                other.sessionTitle == sessionTitle) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.publishedAt, publishedAt) ||
                other.publishedAt == publishedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, clubId, clubName, sessionId,
      sessionTitle, status, publishedAt, createdAt);

  @override
  String toString() {
    return 'ActivityAgendaItem(id: $id, clubId: $clubId, clubName: $clubName, sessionId: $sessionId, sessionTitle: $sessionTitle, status: $status, publishedAt: $publishedAt, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $ActivityAgendaItemCopyWith<$Res> {
  factory $ActivityAgendaItemCopyWith(
          ActivityAgendaItem value, $Res Function(ActivityAgendaItem) _then) =
      _$ActivityAgendaItemCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String clubId,
      String clubName,
      String sessionId,
      String sessionTitle,
      String status,
      DateTime? publishedAt,
      DateTime createdAt});
}

/// @nodoc
class _$ActivityAgendaItemCopyWithImpl<$Res>
    implements $ActivityAgendaItemCopyWith<$Res> {
  _$ActivityAgendaItemCopyWithImpl(this._self, this._then);

  final ActivityAgendaItem _self;
  final $Res Function(ActivityAgendaItem) _then;

  /// Create a copy of ActivityAgendaItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clubId = null,
    Object? clubName = null,
    Object? sessionId = null,
    Object? sessionTitle = null,
    Object? status = null,
    Object? publishedAt = freezed,
    Object? createdAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      clubId: null == clubId
          ? _self.clubId
          : clubId // ignore: cast_nullable_to_non_nullable
              as String,
      clubName: null == clubName
          ? _self.clubName
          : clubName // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _self.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      sessionTitle: null == sessionTitle
          ? _self.sessionTitle
          : sessionTitle // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      publishedAt: freezed == publishedAt
          ? _self.publishedAt
          : publishedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [ActivityAgendaItem].
extension ActivityAgendaItemPatterns on ActivityAgendaItem {
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
    TResult Function(_ActivityAgendaItem value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ActivityAgendaItem() when $default != null:
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
    TResult Function(_ActivityAgendaItem value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActivityAgendaItem():
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
    TResult? Function(_ActivityAgendaItem value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActivityAgendaItem() when $default != null:
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
            String clubId,
            String clubName,
            String sessionId,
            String sessionTitle,
            String status,
            DateTime? publishedAt,
            DateTime createdAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ActivityAgendaItem() when $default != null:
        return $default(
            _that.id,
            _that.clubId,
            _that.clubName,
            _that.sessionId,
            _that.sessionTitle,
            _that.status,
            _that.publishedAt,
            _that.createdAt);
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
            String clubId,
            String clubName,
            String sessionId,
            String sessionTitle,
            String status,
            DateTime? publishedAt,
            DateTime createdAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActivityAgendaItem():
        return $default(
            _that.id,
            _that.clubId,
            _that.clubName,
            _that.sessionId,
            _that.sessionTitle,
            _that.status,
            _that.publishedAt,
            _that.createdAt);
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
            String clubId,
            String clubName,
            String sessionId,
            String sessionTitle,
            String status,
            DateTime? publishedAt,
            DateTime createdAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActivityAgendaItem() when $default != null:
        return $default(
            _that.id,
            _that.clubId,
            _that.clubName,
            _that.sessionId,
            _that.sessionTitle,
            _that.status,
            _that.publishedAt,
            _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ActivityAgendaItem implements ActivityAgendaItem {
  const _ActivityAgendaItem(
      {required this.id,
      required this.clubId,
      required this.clubName,
      required this.sessionId,
      required this.sessionTitle,
      required this.status,
      this.publishedAt,
      required this.createdAt});
  factory _ActivityAgendaItem.fromJson(Map<String, dynamic> json) =>
      _$ActivityAgendaItemFromJson(json);

  @override
  final String id;
  @override
  final String clubId;
  @override
  final String clubName;
  @override
  final String sessionId;
  @override
  final String sessionTitle;
  @override
  final String status;
  @override
  final DateTime? publishedAt;
  @override
  final DateTime createdAt;

  /// Create a copy of ActivityAgendaItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ActivityAgendaItemCopyWith<_ActivityAgendaItem> get copyWith =>
      __$ActivityAgendaItemCopyWithImpl<_ActivityAgendaItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ActivityAgendaItemToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ActivityAgendaItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.clubId, clubId) || other.clubId == clubId) &&
            (identical(other.clubName, clubName) ||
                other.clubName == clubName) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.sessionTitle, sessionTitle) ||
                other.sessionTitle == sessionTitle) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.publishedAt, publishedAt) ||
                other.publishedAt == publishedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, clubId, clubName, sessionId,
      sessionTitle, status, publishedAt, createdAt);

  @override
  String toString() {
    return 'ActivityAgendaItem(id: $id, clubId: $clubId, clubName: $clubName, sessionId: $sessionId, sessionTitle: $sessionTitle, status: $status, publishedAt: $publishedAt, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$ActivityAgendaItemCopyWith<$Res>
    implements $ActivityAgendaItemCopyWith<$Res> {
  factory _$ActivityAgendaItemCopyWith(
          _ActivityAgendaItem value, $Res Function(_ActivityAgendaItem) _then) =
      __$ActivityAgendaItemCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String clubId,
      String clubName,
      String sessionId,
      String sessionTitle,
      String status,
      DateTime? publishedAt,
      DateTime createdAt});
}

/// @nodoc
class __$ActivityAgendaItemCopyWithImpl<$Res>
    implements _$ActivityAgendaItemCopyWith<$Res> {
  __$ActivityAgendaItemCopyWithImpl(this._self, this._then);

  final _ActivityAgendaItem _self;
  final $Res Function(_ActivityAgendaItem) _then;

  /// Create a copy of ActivityAgendaItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? clubId = null,
    Object? clubName = null,
    Object? sessionId = null,
    Object? sessionTitle = null,
    Object? status = null,
    Object? publishedAt = freezed,
    Object? createdAt = null,
  }) {
    return _then(_ActivityAgendaItem(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      clubId: null == clubId
          ? _self.clubId
          : clubId // ignore: cast_nullable_to_non_nullable
              as String,
      clubName: null == clubName
          ? _self.clubName
          : clubName // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _self.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      sessionTitle: null == sessionTitle
          ? _self.sessionTitle
          : sessionTitle // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      publishedAt: freezed == publishedAt
          ? _self.publishedAt
          : publishedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
mixin _$ActivityClubItem {
  String get id;
  String get name;
  DateTime get createdAt;

  /// Create a copy of ActivityClubItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ActivityClubItemCopyWith<ActivityClubItem> get copyWith =>
      _$ActivityClubItemCopyWithImpl<ActivityClubItem>(
          this as ActivityClubItem, _$identity);

  /// Serializes this ActivityClubItem to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ActivityClubItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, createdAt);

  @override
  String toString() {
    return 'ActivityClubItem(id: $id, name: $name, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $ActivityClubItemCopyWith<$Res> {
  factory $ActivityClubItemCopyWith(
          ActivityClubItem value, $Res Function(ActivityClubItem) _then) =
      _$ActivityClubItemCopyWithImpl;
  @useResult
  $Res call({String id, String name, DateTime createdAt});
}

/// @nodoc
class _$ActivityClubItemCopyWithImpl<$Res>
    implements $ActivityClubItemCopyWith<$Res> {
  _$ActivityClubItemCopyWithImpl(this._self, this._then);

  final ActivityClubItem _self;
  final $Res Function(ActivityClubItem) _then;

  /// Create a copy of ActivityClubItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? createdAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// Adds pattern-matching-related methods to [ActivityClubItem].
extension ActivityClubItemPatterns on ActivityClubItem {
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
    TResult Function(_ActivityClubItem value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ActivityClubItem() when $default != null:
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
    TResult Function(_ActivityClubItem value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActivityClubItem():
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
    TResult? Function(_ActivityClubItem value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActivityClubItem() when $default != null:
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
    TResult Function(String id, String name, DateTime createdAt)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ActivityClubItem() when $default != null:
        return $default(_that.id, _that.name, _that.createdAt);
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
    TResult Function(String id, String name, DateTime createdAt) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActivityClubItem():
        return $default(_that.id, _that.name, _that.createdAt);
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
    TResult? Function(String id, String name, DateTime createdAt)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActivityClubItem() when $default != null:
        return $default(_that.id, _that.name, _that.createdAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ActivityClubItem implements ActivityClubItem {
  const _ActivityClubItem(
      {required this.id, required this.name, required this.createdAt});
  factory _ActivityClubItem.fromJson(Map<String, dynamic> json) =>
      _$ActivityClubItemFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final DateTime createdAt;

  /// Create a copy of ActivityClubItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ActivityClubItemCopyWith<_ActivityClubItem> get copyWith =>
      __$ActivityClubItemCopyWithImpl<_ActivityClubItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ActivityClubItemToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ActivityClubItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, createdAt);

  @override
  String toString() {
    return 'ActivityClubItem(id: $id, name: $name, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$ActivityClubItemCopyWith<$Res>
    implements $ActivityClubItemCopyWith<$Res> {
  factory _$ActivityClubItemCopyWith(
          _ActivityClubItem value, $Res Function(_ActivityClubItem) _then) =
      __$ActivityClubItemCopyWithImpl;
  @override
  @useResult
  $Res call({String id, String name, DateTime createdAt});
}

/// @nodoc
class __$ActivityClubItemCopyWithImpl<$Res>
    implements _$ActivityClubItemCopyWith<$Res> {
  __$ActivityClubItemCopyWithImpl(this._self, this._then);

  final _ActivityClubItem _self;
  final $Res Function(_ActivityClubItem) _then;

  /// Create a copy of ActivityClubItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? createdAt = null,
  }) {
    return _then(_ActivityClubItem(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
mixin _$ActivityBookItem {
  String get userBookId;
  String get bookId;
  String get title;
  String? get coverUrl;
  int get currentChapter;
  DateTime? get startedAt;

  /// Create a copy of ActivityBookItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ActivityBookItemCopyWith<ActivityBookItem> get copyWith =>
      _$ActivityBookItemCopyWithImpl<ActivityBookItem>(
          this as ActivityBookItem, _$identity);

  /// Serializes this ActivityBookItem to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ActivityBookItem &&
            (identical(other.userBookId, userBookId) ||
                other.userBookId == userBookId) &&
            (identical(other.bookId, bookId) || other.bookId == bookId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.coverUrl, coverUrl) ||
                other.coverUrl == coverUrl) &&
            (identical(other.currentChapter, currentChapter) ||
                other.currentChapter == currentChapter) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userBookId, bookId, title,
      coverUrl, currentChapter, startedAt);

  @override
  String toString() {
    return 'ActivityBookItem(userBookId: $userBookId, bookId: $bookId, title: $title, coverUrl: $coverUrl, currentChapter: $currentChapter, startedAt: $startedAt)';
  }
}

/// @nodoc
abstract mixin class $ActivityBookItemCopyWith<$Res> {
  factory $ActivityBookItemCopyWith(
          ActivityBookItem value, $Res Function(ActivityBookItem) _then) =
      _$ActivityBookItemCopyWithImpl;
  @useResult
  $Res call(
      {String userBookId,
      String bookId,
      String title,
      String? coverUrl,
      int currentChapter,
      DateTime? startedAt});
}

/// @nodoc
class _$ActivityBookItemCopyWithImpl<$Res>
    implements $ActivityBookItemCopyWith<$Res> {
  _$ActivityBookItemCopyWithImpl(this._self, this._then);

  final ActivityBookItem _self;
  final $Res Function(ActivityBookItem) _then;

  /// Create a copy of ActivityBookItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userBookId = null,
    Object? bookId = null,
    Object? title = null,
    Object? coverUrl = freezed,
    Object? currentChapter = null,
    Object? startedAt = freezed,
  }) {
    return _then(_self.copyWith(
      userBookId: null == userBookId
          ? _self.userBookId
          : userBookId // ignore: cast_nullable_to_non_nullable
              as String,
      bookId: null == bookId
          ? _self.bookId
          : bookId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      coverUrl: freezed == coverUrl
          ? _self.coverUrl
          : coverUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      currentChapter: null == currentChapter
          ? _self.currentChapter
          : currentChapter // ignore: cast_nullable_to_non_nullable
              as int,
      startedAt: freezed == startedAt
          ? _self.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [ActivityBookItem].
extension ActivityBookItemPatterns on ActivityBookItem {
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
    TResult Function(_ActivityBookItem value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ActivityBookItem() when $default != null:
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
    TResult Function(_ActivityBookItem value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActivityBookItem():
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
    TResult? Function(_ActivityBookItem value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActivityBookItem() when $default != null:
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
    TResult Function(String userBookId, String bookId, String title,
            String? coverUrl, int currentChapter, DateTime? startedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ActivityBookItem() when $default != null:
        return $default(_that.userBookId, _that.bookId, _that.title,
            _that.coverUrl, _that.currentChapter, _that.startedAt);
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
    TResult Function(String userBookId, String bookId, String title,
            String? coverUrl, int currentChapter, DateTime? startedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActivityBookItem():
        return $default(_that.userBookId, _that.bookId, _that.title,
            _that.coverUrl, _that.currentChapter, _that.startedAt);
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
    TResult? Function(String userBookId, String bookId, String title,
            String? coverUrl, int currentChapter, DateTime? startedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActivityBookItem() when $default != null:
        return $default(_that.userBookId, _that.bookId, _that.title,
            _that.coverUrl, _that.currentChapter, _that.startedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ActivityBookItem implements ActivityBookItem {
  const _ActivityBookItem(
      {required this.userBookId,
      required this.bookId,
      required this.title,
      this.coverUrl,
      required this.currentChapter,
      this.startedAt});
  factory _ActivityBookItem.fromJson(Map<String, dynamic> json) =>
      _$ActivityBookItemFromJson(json);

  @override
  final String userBookId;
  @override
  final String bookId;
  @override
  final String title;
  @override
  final String? coverUrl;
  @override
  final int currentChapter;
  @override
  final DateTime? startedAt;

  /// Create a copy of ActivityBookItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ActivityBookItemCopyWith<_ActivityBookItem> get copyWith =>
      __$ActivityBookItemCopyWithImpl<_ActivityBookItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ActivityBookItemToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ActivityBookItem &&
            (identical(other.userBookId, userBookId) ||
                other.userBookId == userBookId) &&
            (identical(other.bookId, bookId) || other.bookId == bookId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.coverUrl, coverUrl) ||
                other.coverUrl == coverUrl) &&
            (identical(other.currentChapter, currentChapter) ||
                other.currentChapter == currentChapter) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userBookId, bookId, title,
      coverUrl, currentChapter, startedAt);

  @override
  String toString() {
    return 'ActivityBookItem(userBookId: $userBookId, bookId: $bookId, title: $title, coverUrl: $coverUrl, currentChapter: $currentChapter, startedAt: $startedAt)';
  }
}

/// @nodoc
abstract mixin class _$ActivityBookItemCopyWith<$Res>
    implements $ActivityBookItemCopyWith<$Res> {
  factory _$ActivityBookItemCopyWith(
          _ActivityBookItem value, $Res Function(_ActivityBookItem) _then) =
      __$ActivityBookItemCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String userBookId,
      String bookId,
      String title,
      String? coverUrl,
      int currentChapter,
      DateTime? startedAt});
}

/// @nodoc
class __$ActivityBookItemCopyWithImpl<$Res>
    implements _$ActivityBookItemCopyWith<$Res> {
  __$ActivityBookItemCopyWithImpl(this._self, this._then);

  final _ActivityBookItem _self;
  final $Res Function(_ActivityBookItem) _then;

  /// Create a copy of ActivityBookItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? userBookId = null,
    Object? bookId = null,
    Object? title = null,
    Object? coverUrl = freezed,
    Object? currentChapter = null,
    Object? startedAt = freezed,
  }) {
    return _then(_ActivityBookItem(
      userBookId: null == userBookId
          ? _self.userBookId
          : userBookId // ignore: cast_nullable_to_non_nullable
              as String,
      bookId: null == bookId
          ? _self.bookId
          : bookId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      coverUrl: freezed == coverUrl
          ? _self.coverUrl
          : coverUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      currentChapter: null == currentChapter
          ? _self.currentChapter
          : currentChapter // ignore: cast_nullable_to_non_nullable
              as int,
      startedAt: freezed == startedAt
          ? _self.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
mixin _$MyActivitySummary {
  ActivityCounts get counts;
  List<ActivityReviewItem> get reviews;
  List<ActivityHighlightItem> get highlights;
  List<ActivityAgendaItem> get agendas;
  List<ActivityClubItem> get clubs;
  List<ActivityBookItem> get readingBooks;

  /// Create a copy of MyActivitySummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MyActivitySummaryCopyWith<MyActivitySummary> get copyWith =>
      _$MyActivitySummaryCopyWithImpl<MyActivitySummary>(
          this as MyActivitySummary, _$identity);

  /// Serializes this MyActivitySummary to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MyActivitySummary &&
            (identical(other.counts, counts) || other.counts == counts) &&
            const DeepCollectionEquality().equals(other.reviews, reviews) &&
            const DeepCollectionEquality()
                .equals(other.highlights, highlights) &&
            const DeepCollectionEquality().equals(other.agendas, agendas) &&
            const DeepCollectionEquality().equals(other.clubs, clubs) &&
            const DeepCollectionEquality()
                .equals(other.readingBooks, readingBooks));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      counts,
      const DeepCollectionEquality().hash(reviews),
      const DeepCollectionEquality().hash(highlights),
      const DeepCollectionEquality().hash(agendas),
      const DeepCollectionEquality().hash(clubs),
      const DeepCollectionEquality().hash(readingBooks));

  @override
  String toString() {
    return 'MyActivitySummary(counts: $counts, reviews: $reviews, highlights: $highlights, agendas: $agendas, clubs: $clubs, readingBooks: $readingBooks)';
  }
}

/// @nodoc
abstract mixin class $MyActivitySummaryCopyWith<$Res> {
  factory $MyActivitySummaryCopyWith(
          MyActivitySummary value, $Res Function(MyActivitySummary) _then) =
      _$MyActivitySummaryCopyWithImpl;
  @useResult
  $Res call(
      {ActivityCounts counts,
      List<ActivityReviewItem> reviews,
      List<ActivityHighlightItem> highlights,
      List<ActivityAgendaItem> agendas,
      List<ActivityClubItem> clubs,
      List<ActivityBookItem> readingBooks});

  $ActivityCountsCopyWith<$Res> get counts;
}

/// @nodoc
class _$MyActivitySummaryCopyWithImpl<$Res>
    implements $MyActivitySummaryCopyWith<$Res> {
  _$MyActivitySummaryCopyWithImpl(this._self, this._then);

  final MyActivitySummary _self;
  final $Res Function(MyActivitySummary) _then;

  /// Create a copy of MyActivitySummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? counts = null,
    Object? reviews = null,
    Object? highlights = null,
    Object? agendas = null,
    Object? clubs = null,
    Object? readingBooks = null,
  }) {
    return _then(_self.copyWith(
      counts: null == counts
          ? _self.counts
          : counts // ignore: cast_nullable_to_non_nullable
              as ActivityCounts,
      reviews: null == reviews
          ? _self.reviews
          : reviews // ignore: cast_nullable_to_non_nullable
              as List<ActivityReviewItem>,
      highlights: null == highlights
          ? _self.highlights
          : highlights // ignore: cast_nullable_to_non_nullable
              as List<ActivityHighlightItem>,
      agendas: null == agendas
          ? _self.agendas
          : agendas // ignore: cast_nullable_to_non_nullable
              as List<ActivityAgendaItem>,
      clubs: null == clubs
          ? _self.clubs
          : clubs // ignore: cast_nullable_to_non_nullable
              as List<ActivityClubItem>,
      readingBooks: null == readingBooks
          ? _self.readingBooks
          : readingBooks // ignore: cast_nullable_to_non_nullable
              as List<ActivityBookItem>,
    ));
  }

  /// Create a copy of MyActivitySummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ActivityCountsCopyWith<$Res> get counts {
    return $ActivityCountsCopyWith<$Res>(_self.counts, (value) {
      return _then(_self.copyWith(counts: value));
    });
  }
}

/// Adds pattern-matching-related methods to [MyActivitySummary].
extension MyActivitySummaryPatterns on MyActivitySummary {
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
    TResult Function(_MyActivitySummary value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MyActivitySummary() when $default != null:
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
    TResult Function(_MyActivitySummary value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MyActivitySummary():
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
    TResult? Function(_MyActivitySummary value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MyActivitySummary() when $default != null:
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
            ActivityCounts counts,
            List<ActivityReviewItem> reviews,
            List<ActivityHighlightItem> highlights,
            List<ActivityAgendaItem> agendas,
            List<ActivityClubItem> clubs,
            List<ActivityBookItem> readingBooks)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MyActivitySummary() when $default != null:
        return $default(_that.counts, _that.reviews, _that.highlights,
            _that.agendas, _that.clubs, _that.readingBooks);
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
            ActivityCounts counts,
            List<ActivityReviewItem> reviews,
            List<ActivityHighlightItem> highlights,
            List<ActivityAgendaItem> agendas,
            List<ActivityClubItem> clubs,
            List<ActivityBookItem> readingBooks)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MyActivitySummary():
        return $default(_that.counts, _that.reviews, _that.highlights,
            _that.agendas, _that.clubs, _that.readingBooks);
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
            ActivityCounts counts,
            List<ActivityReviewItem> reviews,
            List<ActivityHighlightItem> highlights,
            List<ActivityAgendaItem> agendas,
            List<ActivityClubItem> clubs,
            List<ActivityBookItem> readingBooks)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MyActivitySummary() when $default != null:
        return $default(_that.counts, _that.reviews, _that.highlights,
            _that.agendas, _that.clubs, _that.readingBooks);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MyActivitySummary implements MyActivitySummary {
  const _MyActivitySummary(
      {required this.counts,
      final List<ActivityReviewItem> reviews = const <ActivityReviewItem>[],
      final List<ActivityHighlightItem> highlights =
          const <ActivityHighlightItem>[],
      final List<ActivityAgendaItem> agendas = const <ActivityAgendaItem>[],
      final List<ActivityClubItem> clubs = const <ActivityClubItem>[],
      final List<ActivityBookItem> readingBooks = const <ActivityBookItem>[]})
      : _reviews = reviews,
        _highlights = highlights,
        _agendas = agendas,
        _clubs = clubs,
        _readingBooks = readingBooks;
  factory _MyActivitySummary.fromJson(Map<String, dynamic> json) =>
      _$MyActivitySummaryFromJson(json);

  @override
  final ActivityCounts counts;
  final List<ActivityReviewItem> _reviews;
  @override
  @JsonKey()
  List<ActivityReviewItem> get reviews {
    if (_reviews is EqualUnmodifiableListView) return _reviews;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reviews);
  }

  final List<ActivityHighlightItem> _highlights;
  @override
  @JsonKey()
  List<ActivityHighlightItem> get highlights {
    if (_highlights is EqualUnmodifiableListView) return _highlights;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_highlights);
  }

  final List<ActivityAgendaItem> _agendas;
  @override
  @JsonKey()
  List<ActivityAgendaItem> get agendas {
    if (_agendas is EqualUnmodifiableListView) return _agendas;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_agendas);
  }

  final List<ActivityClubItem> _clubs;
  @override
  @JsonKey()
  List<ActivityClubItem> get clubs {
    if (_clubs is EqualUnmodifiableListView) return _clubs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_clubs);
  }

  final List<ActivityBookItem> _readingBooks;
  @override
  @JsonKey()
  List<ActivityBookItem> get readingBooks {
    if (_readingBooks is EqualUnmodifiableListView) return _readingBooks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_readingBooks);
  }

  /// Create a copy of MyActivitySummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MyActivitySummaryCopyWith<_MyActivitySummary> get copyWith =>
      __$MyActivitySummaryCopyWithImpl<_MyActivitySummary>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MyActivitySummaryToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MyActivitySummary &&
            (identical(other.counts, counts) || other.counts == counts) &&
            const DeepCollectionEquality().equals(other._reviews, _reviews) &&
            const DeepCollectionEquality()
                .equals(other._highlights, _highlights) &&
            const DeepCollectionEquality().equals(other._agendas, _agendas) &&
            const DeepCollectionEquality().equals(other._clubs, _clubs) &&
            const DeepCollectionEquality()
                .equals(other._readingBooks, _readingBooks));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      counts,
      const DeepCollectionEquality().hash(_reviews),
      const DeepCollectionEquality().hash(_highlights),
      const DeepCollectionEquality().hash(_agendas),
      const DeepCollectionEquality().hash(_clubs),
      const DeepCollectionEquality().hash(_readingBooks));

  @override
  String toString() {
    return 'MyActivitySummary(counts: $counts, reviews: $reviews, highlights: $highlights, agendas: $agendas, clubs: $clubs, readingBooks: $readingBooks)';
  }
}

/// @nodoc
abstract mixin class _$MyActivitySummaryCopyWith<$Res>
    implements $MyActivitySummaryCopyWith<$Res> {
  factory _$MyActivitySummaryCopyWith(
          _MyActivitySummary value, $Res Function(_MyActivitySummary) _then) =
      __$MyActivitySummaryCopyWithImpl;
  @override
  @useResult
  $Res call(
      {ActivityCounts counts,
      List<ActivityReviewItem> reviews,
      List<ActivityHighlightItem> highlights,
      List<ActivityAgendaItem> agendas,
      List<ActivityClubItem> clubs,
      List<ActivityBookItem> readingBooks});

  @override
  $ActivityCountsCopyWith<$Res> get counts;
}

/// @nodoc
class __$MyActivitySummaryCopyWithImpl<$Res>
    implements _$MyActivitySummaryCopyWith<$Res> {
  __$MyActivitySummaryCopyWithImpl(this._self, this._then);

  final _MyActivitySummary _self;
  final $Res Function(_MyActivitySummary) _then;

  /// Create a copy of MyActivitySummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? counts = null,
    Object? reviews = null,
    Object? highlights = null,
    Object? agendas = null,
    Object? clubs = null,
    Object? readingBooks = null,
  }) {
    return _then(_MyActivitySummary(
      counts: null == counts
          ? _self.counts
          : counts // ignore: cast_nullable_to_non_nullable
              as ActivityCounts,
      reviews: null == reviews
          ? _self._reviews
          : reviews // ignore: cast_nullable_to_non_nullable
              as List<ActivityReviewItem>,
      highlights: null == highlights
          ? _self._highlights
          : highlights // ignore: cast_nullable_to_non_nullable
              as List<ActivityHighlightItem>,
      agendas: null == agendas
          ? _self._agendas
          : agendas // ignore: cast_nullable_to_non_nullable
              as List<ActivityAgendaItem>,
      clubs: null == clubs
          ? _self._clubs
          : clubs // ignore: cast_nullable_to_non_nullable
              as List<ActivityClubItem>,
      readingBooks: null == readingBooks
          ? _self._readingBooks
          : readingBooks // ignore: cast_nullable_to_non_nullable
              as List<ActivityBookItem>,
    ));
  }

  /// Create a copy of MyActivitySummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ActivityCountsCopyWith<$Res> get counts {
    return $ActivityCountsCopyWith<$Res>(_self.counts, (value) {
      return _then(_self.copyWith(counts: value));
    });
  }
}

// dart format on
