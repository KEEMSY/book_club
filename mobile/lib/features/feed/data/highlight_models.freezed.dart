// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'highlight_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HighlightDto {
  String get id;
  String get userBookId;
  String get bookId;
  String get bookTitle;
  String get quoteText;
  HighlightVisibility get visibility;
  DateTime get createdAt;
  String? get bookCoverUrl;
  int? get page;
  DateTime? get sharedAt;

  /// Create a copy of HighlightDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HighlightDtoCopyWith<HighlightDto> get copyWith =>
      _$HighlightDtoCopyWithImpl<HighlightDto>(
          this as HighlightDto, _$identity);

  /// Serializes this HighlightDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HighlightDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userBookId, userBookId) ||
                other.userBookId == userBookId) &&
            (identical(other.bookId, bookId) || other.bookId == bookId) &&
            (identical(other.bookTitle, bookTitle) ||
                other.bookTitle == bookTitle) &&
            (identical(other.quoteText, quoteText) ||
                other.quoteText == quoteText) &&
            (identical(other.visibility, visibility) ||
                other.visibility == visibility) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.bookCoverUrl, bookCoverUrl) ||
                other.bookCoverUrl == bookCoverUrl) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.sharedAt, sharedAt) ||
                other.sharedAt == sharedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userBookId,
      bookId,
      bookTitle,
      quoteText,
      visibility,
      createdAt,
      bookCoverUrl,
      page,
      sharedAt);

  @override
  String toString() {
    return 'HighlightDto(id: $id, userBookId: $userBookId, bookId: $bookId, bookTitle: $bookTitle, quoteText: $quoteText, visibility: $visibility, createdAt: $createdAt, bookCoverUrl: $bookCoverUrl, page: $page, sharedAt: $sharedAt)';
  }
}

/// @nodoc
abstract mixin class $HighlightDtoCopyWith<$Res> {
  factory $HighlightDtoCopyWith(
          HighlightDto value, $Res Function(HighlightDto) _then) =
      _$HighlightDtoCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String userBookId,
      String bookId,
      String bookTitle,
      String quoteText,
      HighlightVisibility visibility,
      DateTime createdAt,
      String? bookCoverUrl,
      int? page,
      DateTime? sharedAt});
}

/// @nodoc
class _$HighlightDtoCopyWithImpl<$Res> implements $HighlightDtoCopyWith<$Res> {
  _$HighlightDtoCopyWithImpl(this._self, this._then);

  final HighlightDto _self;
  final $Res Function(HighlightDto) _then;

  /// Create a copy of HighlightDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userBookId = null,
    Object? bookId = null,
    Object? bookTitle = null,
    Object? quoteText = null,
    Object? visibility = null,
    Object? createdAt = null,
    Object? bookCoverUrl = freezed,
    Object? page = freezed,
    Object? sharedAt = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userBookId: null == userBookId
          ? _self.userBookId
          : userBookId // ignore: cast_nullable_to_non_nullable
              as String,
      bookId: null == bookId
          ? _self.bookId
          : bookId // ignore: cast_nullable_to_non_nullable
              as String,
      bookTitle: null == bookTitle
          ? _self.bookTitle
          : bookTitle // ignore: cast_nullable_to_non_nullable
              as String,
      quoteText: null == quoteText
          ? _self.quoteText
          : quoteText // ignore: cast_nullable_to_non_nullable
              as String,
      visibility: null == visibility
          ? _self.visibility
          : visibility // ignore: cast_nullable_to_non_nullable
              as HighlightVisibility,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      bookCoverUrl: freezed == bookCoverUrl
          ? _self.bookCoverUrl
          : bookCoverUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      page: freezed == page
          ? _self.page
          : page // ignore: cast_nullable_to_non_nullable
              as int?,
      sharedAt: freezed == sharedAt
          ? _self.sharedAt
          : sharedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [HighlightDto].
extension HighlightDtoPatterns on HighlightDto {
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
    TResult Function(_HighlightDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HighlightDto() when $default != null:
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
    TResult Function(_HighlightDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HighlightDto():
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
    TResult? Function(_HighlightDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HighlightDto() when $default != null:
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
            String userBookId,
            String bookId,
            String bookTitle,
            String quoteText,
            HighlightVisibility visibility,
            DateTime createdAt,
            String? bookCoverUrl,
            int? page,
            DateTime? sharedAt)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HighlightDto() when $default != null:
        return $default(
            _that.id,
            _that.userBookId,
            _that.bookId,
            _that.bookTitle,
            _that.quoteText,
            _that.visibility,
            _that.createdAt,
            _that.bookCoverUrl,
            _that.page,
            _that.sharedAt);
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
            String userBookId,
            String bookId,
            String bookTitle,
            String quoteText,
            HighlightVisibility visibility,
            DateTime createdAt,
            String? bookCoverUrl,
            int? page,
            DateTime? sharedAt)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HighlightDto():
        return $default(
            _that.id,
            _that.userBookId,
            _that.bookId,
            _that.bookTitle,
            _that.quoteText,
            _that.visibility,
            _that.createdAt,
            _that.bookCoverUrl,
            _that.page,
            _that.sharedAt);
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
            String userBookId,
            String bookId,
            String bookTitle,
            String quoteText,
            HighlightVisibility visibility,
            DateTime createdAt,
            String? bookCoverUrl,
            int? page,
            DateTime? sharedAt)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HighlightDto() when $default != null:
        return $default(
            _that.id,
            _that.userBookId,
            _that.bookId,
            _that.bookTitle,
            _that.quoteText,
            _that.visibility,
            _that.createdAt,
            _that.bookCoverUrl,
            _that.page,
            _that.sharedAt);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _HighlightDto implements HighlightDto {
  const _HighlightDto(
      {required this.id,
      required this.userBookId,
      required this.bookId,
      required this.bookTitle,
      required this.quoteText,
      required this.visibility,
      required this.createdAt,
      this.bookCoverUrl,
      this.page,
      this.sharedAt});
  factory _HighlightDto.fromJson(Map<String, dynamic> json) =>
      _$HighlightDtoFromJson(json);

  @override
  final String id;
  @override
  final String userBookId;
  @override
  final String bookId;
  @override
  final String bookTitle;
  @override
  final String quoteText;
  @override
  final HighlightVisibility visibility;
  @override
  final DateTime createdAt;
  @override
  final String? bookCoverUrl;
  @override
  final int? page;
  @override
  final DateTime? sharedAt;

  /// Create a copy of HighlightDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$HighlightDtoCopyWith<_HighlightDto> get copyWith =>
      __$HighlightDtoCopyWithImpl<_HighlightDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$HighlightDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _HighlightDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userBookId, userBookId) ||
                other.userBookId == userBookId) &&
            (identical(other.bookId, bookId) || other.bookId == bookId) &&
            (identical(other.bookTitle, bookTitle) ||
                other.bookTitle == bookTitle) &&
            (identical(other.quoteText, quoteText) ||
                other.quoteText == quoteText) &&
            (identical(other.visibility, visibility) ||
                other.visibility == visibility) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.bookCoverUrl, bookCoverUrl) ||
                other.bookCoverUrl == bookCoverUrl) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.sharedAt, sharedAt) ||
                other.sharedAt == sharedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userBookId,
      bookId,
      bookTitle,
      quoteText,
      visibility,
      createdAt,
      bookCoverUrl,
      page,
      sharedAt);

  @override
  String toString() {
    return 'HighlightDto(id: $id, userBookId: $userBookId, bookId: $bookId, bookTitle: $bookTitle, quoteText: $quoteText, visibility: $visibility, createdAt: $createdAt, bookCoverUrl: $bookCoverUrl, page: $page, sharedAt: $sharedAt)';
  }
}

/// @nodoc
abstract mixin class _$HighlightDtoCopyWith<$Res>
    implements $HighlightDtoCopyWith<$Res> {
  factory _$HighlightDtoCopyWith(
          _HighlightDto value, $Res Function(_HighlightDto) _then) =
      __$HighlightDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String userBookId,
      String bookId,
      String bookTitle,
      String quoteText,
      HighlightVisibility visibility,
      DateTime createdAt,
      String? bookCoverUrl,
      int? page,
      DateTime? sharedAt});
}

/// @nodoc
class __$HighlightDtoCopyWithImpl<$Res>
    implements _$HighlightDtoCopyWith<$Res> {
  __$HighlightDtoCopyWithImpl(this._self, this._then);

  final _HighlightDto _self;
  final $Res Function(_HighlightDto) _then;

  /// Create a copy of HighlightDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? userBookId = null,
    Object? bookId = null,
    Object? bookTitle = null,
    Object? quoteText = null,
    Object? visibility = null,
    Object? createdAt = null,
    Object? bookCoverUrl = freezed,
    Object? page = freezed,
    Object? sharedAt = freezed,
  }) {
    return _then(_HighlightDto(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userBookId: null == userBookId
          ? _self.userBookId
          : userBookId // ignore: cast_nullable_to_non_nullable
              as String,
      bookId: null == bookId
          ? _self.bookId
          : bookId // ignore: cast_nullable_to_non_nullable
              as String,
      bookTitle: null == bookTitle
          ? _self.bookTitle
          : bookTitle // ignore: cast_nullable_to_non_nullable
              as String,
      quoteText: null == quoteText
          ? _self.quoteText
          : quoteText // ignore: cast_nullable_to_non_nullable
              as String,
      visibility: null == visibility
          ? _self.visibility
          : visibility // ignore: cast_nullable_to_non_nullable
              as HighlightVisibility,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      bookCoverUrl: freezed == bookCoverUrl
          ? _self.bookCoverUrl
          : bookCoverUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      page: freezed == page
          ? _self.page
          : page // ignore: cast_nullable_to_non_nullable
              as int?,
      sharedAt: freezed == sharedAt
          ? _self.sharedAt
          : sharedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
mixin _$HighlightExploreDto {
  String get id;
  String get userId;
  String get bookId;
  String get bookTitle;
  String get quoteText;
  DateTime get createdAt;
  int get reactionCount;
  String? get bookCoverUrl;
  int? get page;

  /// Create a copy of HighlightExploreDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HighlightExploreDtoCopyWith<HighlightExploreDto> get copyWith =>
      _$HighlightExploreDtoCopyWithImpl<HighlightExploreDto>(
          this as HighlightExploreDto, _$identity);

  /// Serializes this HighlightExploreDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HighlightExploreDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.bookId, bookId) || other.bookId == bookId) &&
            (identical(other.bookTitle, bookTitle) ||
                other.bookTitle == bookTitle) &&
            (identical(other.quoteText, quoteText) ||
                other.quoteText == quoteText) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.reactionCount, reactionCount) ||
                other.reactionCount == reactionCount) &&
            (identical(other.bookCoverUrl, bookCoverUrl) ||
                other.bookCoverUrl == bookCoverUrl) &&
            (identical(other.page, page) || other.page == page));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, bookId, bookTitle,
      quoteText, createdAt, reactionCount, bookCoverUrl, page);

  @override
  String toString() {
    return 'HighlightExploreDto(id: $id, userId: $userId, bookId: $bookId, bookTitle: $bookTitle, quoteText: $quoteText, createdAt: $createdAt, reactionCount: $reactionCount, bookCoverUrl: $bookCoverUrl, page: $page)';
  }
}

/// @nodoc
abstract mixin class $HighlightExploreDtoCopyWith<$Res> {
  factory $HighlightExploreDtoCopyWith(
          HighlightExploreDto value, $Res Function(HighlightExploreDto) _then) =
      _$HighlightExploreDtoCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String userId,
      String bookId,
      String bookTitle,
      String quoteText,
      DateTime createdAt,
      int reactionCount,
      String? bookCoverUrl,
      int? page});
}

/// @nodoc
class _$HighlightExploreDtoCopyWithImpl<$Res>
    implements $HighlightExploreDtoCopyWith<$Res> {
  _$HighlightExploreDtoCopyWithImpl(this._self, this._then);

  final HighlightExploreDto _self;
  final $Res Function(HighlightExploreDto) _then;

  /// Create a copy of HighlightExploreDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? bookId = null,
    Object? bookTitle = null,
    Object? quoteText = null,
    Object? createdAt = null,
    Object? reactionCount = null,
    Object? bookCoverUrl = freezed,
    Object? page = freezed,
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
      bookTitle: null == bookTitle
          ? _self.bookTitle
          : bookTitle // ignore: cast_nullable_to_non_nullable
              as String,
      quoteText: null == quoteText
          ? _self.quoteText
          : quoteText // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      reactionCount: null == reactionCount
          ? _self.reactionCount
          : reactionCount // ignore: cast_nullable_to_non_nullable
              as int,
      bookCoverUrl: freezed == bookCoverUrl
          ? _self.bookCoverUrl
          : bookCoverUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      page: freezed == page
          ? _self.page
          : page // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// Adds pattern-matching-related methods to [HighlightExploreDto].
extension HighlightExploreDtoPatterns on HighlightExploreDto {
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
    TResult Function(_HighlightExploreDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HighlightExploreDto() when $default != null:
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
    TResult Function(_HighlightExploreDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HighlightExploreDto():
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
    TResult? Function(_HighlightExploreDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HighlightExploreDto() when $default != null:
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
            String bookTitle,
            String quoteText,
            DateTime createdAt,
            int reactionCount,
            String? bookCoverUrl,
            int? page)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HighlightExploreDto() when $default != null:
        return $default(
            _that.id,
            _that.userId,
            _that.bookId,
            _that.bookTitle,
            _that.quoteText,
            _that.createdAt,
            _that.reactionCount,
            _that.bookCoverUrl,
            _that.page);
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
            String bookTitle,
            String quoteText,
            DateTime createdAt,
            int reactionCount,
            String? bookCoverUrl,
            int? page)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HighlightExploreDto():
        return $default(
            _that.id,
            _that.userId,
            _that.bookId,
            _that.bookTitle,
            _that.quoteText,
            _that.createdAt,
            _that.reactionCount,
            _that.bookCoverUrl,
            _that.page);
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
            String bookTitle,
            String quoteText,
            DateTime createdAt,
            int reactionCount,
            String? bookCoverUrl,
            int? page)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HighlightExploreDto() when $default != null:
        return $default(
            _that.id,
            _that.userId,
            _that.bookId,
            _that.bookTitle,
            _that.quoteText,
            _that.createdAt,
            _that.reactionCount,
            _that.bookCoverUrl,
            _that.page);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _HighlightExploreDto extends HighlightExploreDto {
  const _HighlightExploreDto(
      {required this.id,
      required this.userId,
      required this.bookId,
      required this.bookTitle,
      required this.quoteText,
      required this.createdAt,
      this.reactionCount = 0,
      this.bookCoverUrl,
      this.page})
      : super._();
  factory _HighlightExploreDto.fromJson(Map<String, dynamic> json) =>
      _$HighlightExploreDtoFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String bookId;
  @override
  final String bookTitle;
  @override
  final String quoteText;
  @override
  final DateTime createdAt;
  @override
  @JsonKey()
  final int reactionCount;
  @override
  final String? bookCoverUrl;
  @override
  final int? page;

  /// Create a copy of HighlightExploreDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$HighlightExploreDtoCopyWith<_HighlightExploreDto> get copyWith =>
      __$HighlightExploreDtoCopyWithImpl<_HighlightExploreDto>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$HighlightExploreDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _HighlightExploreDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.bookId, bookId) || other.bookId == bookId) &&
            (identical(other.bookTitle, bookTitle) ||
                other.bookTitle == bookTitle) &&
            (identical(other.quoteText, quoteText) ||
                other.quoteText == quoteText) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.reactionCount, reactionCount) ||
                other.reactionCount == reactionCount) &&
            (identical(other.bookCoverUrl, bookCoverUrl) ||
                other.bookCoverUrl == bookCoverUrl) &&
            (identical(other.page, page) || other.page == page));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, bookId, bookTitle,
      quoteText, createdAt, reactionCount, bookCoverUrl, page);

  @override
  String toString() {
    return 'HighlightExploreDto(id: $id, userId: $userId, bookId: $bookId, bookTitle: $bookTitle, quoteText: $quoteText, createdAt: $createdAt, reactionCount: $reactionCount, bookCoverUrl: $bookCoverUrl, page: $page)';
  }
}

/// @nodoc
abstract mixin class _$HighlightExploreDtoCopyWith<$Res>
    implements $HighlightExploreDtoCopyWith<$Res> {
  factory _$HighlightExploreDtoCopyWith(_HighlightExploreDto value,
          $Res Function(_HighlightExploreDto) _then) =
      __$HighlightExploreDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String bookId,
      String bookTitle,
      String quoteText,
      DateTime createdAt,
      int reactionCount,
      String? bookCoverUrl,
      int? page});
}

/// @nodoc
class __$HighlightExploreDtoCopyWithImpl<$Res>
    implements _$HighlightExploreDtoCopyWith<$Res> {
  __$HighlightExploreDtoCopyWithImpl(this._self, this._then);

  final _HighlightExploreDto _self;
  final $Res Function(_HighlightExploreDto) _then;

  /// Create a copy of HighlightExploreDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? bookId = null,
    Object? bookTitle = null,
    Object? quoteText = null,
    Object? createdAt = null,
    Object? reactionCount = null,
    Object? bookCoverUrl = freezed,
    Object? page = freezed,
  }) {
    return _then(_HighlightExploreDto(
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
      bookTitle: null == bookTitle
          ? _self.bookTitle
          : bookTitle // ignore: cast_nullable_to_non_nullable
              as String,
      quoteText: null == quoteText
          ? _self.quoteText
          : quoteText // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      reactionCount: null == reactionCount
          ? _self.reactionCount
          : reactionCount // ignore: cast_nullable_to_non_nullable
              as int,
      bookCoverUrl: freezed == bookCoverUrl
          ? _self.bookCoverUrl
          : bookCoverUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      page: freezed == page
          ? _self.page
          : page // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
mixin _$UpdateHighlightVisibilityRequest {
  HighlightVisibility get visibility;

  /// Create a copy of UpdateHighlightVisibilityRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UpdateHighlightVisibilityRequestCopyWith<UpdateHighlightVisibilityRequest>
      get copyWith => _$UpdateHighlightVisibilityRequestCopyWithImpl<
              UpdateHighlightVisibilityRequest>(
          this as UpdateHighlightVisibilityRequest, _$identity);

  /// Serializes this UpdateHighlightVisibilityRequest to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UpdateHighlightVisibilityRequest &&
            (identical(other.visibility, visibility) ||
                other.visibility == visibility));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, visibility);

  @override
  String toString() {
    return 'UpdateHighlightVisibilityRequest(visibility: $visibility)';
  }
}

/// @nodoc
abstract mixin class $UpdateHighlightVisibilityRequestCopyWith<$Res> {
  factory $UpdateHighlightVisibilityRequestCopyWith(
          UpdateHighlightVisibilityRequest value,
          $Res Function(UpdateHighlightVisibilityRequest) _then) =
      _$UpdateHighlightVisibilityRequestCopyWithImpl;
  @useResult
  $Res call({HighlightVisibility visibility});
}

/// @nodoc
class _$UpdateHighlightVisibilityRequestCopyWithImpl<$Res>
    implements $UpdateHighlightVisibilityRequestCopyWith<$Res> {
  _$UpdateHighlightVisibilityRequestCopyWithImpl(this._self, this._then);

  final UpdateHighlightVisibilityRequest _self;
  final $Res Function(UpdateHighlightVisibilityRequest) _then;

  /// Create a copy of UpdateHighlightVisibilityRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? visibility = null,
  }) {
    return _then(_self.copyWith(
      visibility: null == visibility
          ? _self.visibility
          : visibility // ignore: cast_nullable_to_non_nullable
              as HighlightVisibility,
    ));
  }
}

/// Adds pattern-matching-related methods to [UpdateHighlightVisibilityRequest].
extension UpdateHighlightVisibilityRequestPatterns
    on UpdateHighlightVisibilityRequest {
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
    TResult Function(_UpdateHighlightVisibilityRequest value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UpdateHighlightVisibilityRequest() when $default != null:
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
    TResult Function(_UpdateHighlightVisibilityRequest value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UpdateHighlightVisibilityRequest():
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
    TResult? Function(_UpdateHighlightVisibilityRequest value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UpdateHighlightVisibilityRequest() when $default != null:
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
    TResult Function(HighlightVisibility visibility)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UpdateHighlightVisibilityRequest() when $default != null:
        return $default(_that.visibility);
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
    TResult Function(HighlightVisibility visibility) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UpdateHighlightVisibilityRequest():
        return $default(_that.visibility);
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
    TResult? Function(HighlightVisibility visibility)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UpdateHighlightVisibilityRequest() when $default != null:
        return $default(_that.visibility);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _UpdateHighlightVisibilityRequest
    implements UpdateHighlightVisibilityRequest {
  const _UpdateHighlightVisibilityRequest({required this.visibility});
  factory _UpdateHighlightVisibilityRequest.fromJson(
          Map<String, dynamic> json) =>
      _$UpdateHighlightVisibilityRequestFromJson(json);

  @override
  final HighlightVisibility visibility;

  /// Create a copy of UpdateHighlightVisibilityRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UpdateHighlightVisibilityRequestCopyWith<_UpdateHighlightVisibilityRequest>
      get copyWith => __$UpdateHighlightVisibilityRequestCopyWithImpl<
          _UpdateHighlightVisibilityRequest>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UpdateHighlightVisibilityRequestToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UpdateHighlightVisibilityRequest &&
            (identical(other.visibility, visibility) ||
                other.visibility == visibility));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, visibility);

  @override
  String toString() {
    return 'UpdateHighlightVisibilityRequest(visibility: $visibility)';
  }
}

/// @nodoc
abstract mixin class _$UpdateHighlightVisibilityRequestCopyWith<$Res>
    implements $UpdateHighlightVisibilityRequestCopyWith<$Res> {
  factory _$UpdateHighlightVisibilityRequestCopyWith(
          _UpdateHighlightVisibilityRequest value,
          $Res Function(_UpdateHighlightVisibilityRequest) _then) =
      __$UpdateHighlightVisibilityRequestCopyWithImpl;
  @override
  @useResult
  $Res call({HighlightVisibility visibility});
}

/// @nodoc
class __$UpdateHighlightVisibilityRequestCopyWithImpl<$Res>
    implements _$UpdateHighlightVisibilityRequestCopyWith<$Res> {
  __$UpdateHighlightVisibilityRequestCopyWithImpl(this._self, this._then);

  final _UpdateHighlightVisibilityRequest _self;
  final $Res Function(_UpdateHighlightVisibilityRequest) _then;

  /// Create a copy of UpdateHighlightVisibilityRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? visibility = null,
  }) {
    return _then(_UpdateHighlightVisibilityRequest(
      visibility: null == visibility
          ? _self.visibility
          : visibility // ignore: cast_nullable_to_non_nullable
              as HighlightVisibility,
    ));
  }
}

// dart format on
