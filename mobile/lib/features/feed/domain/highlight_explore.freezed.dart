// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'highlight_explore.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HighlightExplore {
  String get id;
  String get bookId;
  String get bookTitle;
  String get quoteText;
  DateTime get createdAt;
  int get reactionCount;
  String? get userId;
  String? get bookCoverUrl;
  int? get page;

  /// Create a copy of HighlightExplore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HighlightExploreCopyWith<HighlightExplore> get copyWith =>
      _$HighlightExploreCopyWithImpl<HighlightExplore>(
          this as HighlightExplore, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HighlightExplore &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.bookId, bookId) || other.bookId == bookId) &&
            (identical(other.bookTitle, bookTitle) ||
                other.bookTitle == bookTitle) &&
            (identical(other.quoteText, quoteText) ||
                other.quoteText == quoteText) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.reactionCount, reactionCount) ||
                other.reactionCount == reactionCount) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.bookCoverUrl, bookCoverUrl) ||
                other.bookCoverUrl == bookCoverUrl) &&
            (identical(other.page, page) || other.page == page));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, bookId, bookTitle, quoteText,
      createdAt, reactionCount, userId, bookCoverUrl, page);

  @override
  String toString() {
    return 'HighlightExplore(id: $id, bookId: $bookId, bookTitle: $bookTitle, quoteText: $quoteText, createdAt: $createdAt, reactionCount: $reactionCount, userId: $userId, bookCoverUrl: $bookCoverUrl, page: $page)';
  }
}

/// @nodoc
abstract mixin class $HighlightExploreCopyWith<$Res> {
  factory $HighlightExploreCopyWith(
          HighlightExplore value, $Res Function(HighlightExplore) _then) =
      _$HighlightExploreCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String bookId,
      String bookTitle,
      String quoteText,
      DateTime createdAt,
      int reactionCount,
      String? userId,
      String? bookCoverUrl,
      int? page});
}

/// @nodoc
class _$HighlightExploreCopyWithImpl<$Res>
    implements $HighlightExploreCopyWith<$Res> {
  _$HighlightExploreCopyWithImpl(this._self, this._then);

  final HighlightExplore _self;
  final $Res Function(HighlightExplore) _then;

  /// Create a copy of HighlightExplore
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bookId = null,
    Object? bookTitle = null,
    Object? quoteText = null,
    Object? createdAt = null,
    Object? reactionCount = null,
    Object? userId = freezed,
    Object? bookCoverUrl = freezed,
    Object? page = freezed,
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
      userId: freezed == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
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

/// Adds pattern-matching-related methods to [HighlightExplore].
extension HighlightExplorePatterns on HighlightExplore {
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
    TResult Function(_HighlightExplore value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HighlightExplore() when $default != null:
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
    TResult Function(_HighlightExplore value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HighlightExplore():
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
    TResult? Function(_HighlightExplore value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HighlightExplore() when $default != null:
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
            String bookTitle,
            String quoteText,
            DateTime createdAt,
            int reactionCount,
            String? userId,
            String? bookCoverUrl,
            int? page)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HighlightExplore() when $default != null:
        return $default(
            _that.id,
            _that.bookId,
            _that.bookTitle,
            _that.quoteText,
            _that.createdAt,
            _that.reactionCount,
            _that.userId,
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
            String bookId,
            String bookTitle,
            String quoteText,
            DateTime createdAt,
            int reactionCount,
            String? userId,
            String? bookCoverUrl,
            int? page)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HighlightExplore():
        return $default(
            _that.id,
            _that.bookId,
            _that.bookTitle,
            _that.quoteText,
            _that.createdAt,
            _that.reactionCount,
            _that.userId,
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
            String bookId,
            String bookTitle,
            String quoteText,
            DateTime createdAt,
            int reactionCount,
            String? userId,
            String? bookCoverUrl,
            int? page)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HighlightExplore() when $default != null:
        return $default(
            _that.id,
            _that.bookId,
            _that.bookTitle,
            _that.quoteText,
            _that.createdAt,
            _that.reactionCount,
            _that.userId,
            _that.bookCoverUrl,
            _that.page);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _HighlightExplore implements HighlightExplore {
  const _HighlightExplore(
      {required this.id,
      required this.bookId,
      required this.bookTitle,
      required this.quoteText,
      required this.createdAt,
      required this.reactionCount,
      this.userId,
      this.bookCoverUrl,
      this.page});

  @override
  final String id;
  @override
  final String bookId;
  @override
  final String bookTitle;
  @override
  final String quoteText;
  @override
  final DateTime createdAt;
  @override
  final int reactionCount;
  @override
  final String? userId;
  @override
  final String? bookCoverUrl;
  @override
  final int? page;

  /// Create a copy of HighlightExplore
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$HighlightExploreCopyWith<_HighlightExplore> get copyWith =>
      __$HighlightExploreCopyWithImpl<_HighlightExplore>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _HighlightExplore &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.bookId, bookId) || other.bookId == bookId) &&
            (identical(other.bookTitle, bookTitle) ||
                other.bookTitle == bookTitle) &&
            (identical(other.quoteText, quoteText) ||
                other.quoteText == quoteText) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.reactionCount, reactionCount) ||
                other.reactionCount == reactionCount) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.bookCoverUrl, bookCoverUrl) ||
                other.bookCoverUrl == bookCoverUrl) &&
            (identical(other.page, page) || other.page == page));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, bookId, bookTitle, quoteText,
      createdAt, reactionCount, userId, bookCoverUrl, page);

  @override
  String toString() {
    return 'HighlightExplore(id: $id, bookId: $bookId, bookTitle: $bookTitle, quoteText: $quoteText, createdAt: $createdAt, reactionCount: $reactionCount, userId: $userId, bookCoverUrl: $bookCoverUrl, page: $page)';
  }
}

/// @nodoc
abstract mixin class _$HighlightExploreCopyWith<$Res>
    implements $HighlightExploreCopyWith<$Res> {
  factory _$HighlightExploreCopyWith(
          _HighlightExplore value, $Res Function(_HighlightExplore) _then) =
      __$HighlightExploreCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String bookId,
      String bookTitle,
      String quoteText,
      DateTime createdAt,
      int reactionCount,
      String? userId,
      String? bookCoverUrl,
      int? page});
}

/// @nodoc
class __$HighlightExploreCopyWithImpl<$Res>
    implements _$HighlightExploreCopyWith<$Res> {
  __$HighlightExploreCopyWithImpl(this._self, this._then);

  final _HighlightExplore _self;
  final $Res Function(_HighlightExplore) _then;

  /// Create a copy of HighlightExplore
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? bookId = null,
    Object? bookTitle = null,
    Object? quoteText = null,
    Object? createdAt = null,
    Object? reactionCount = null,
    Object? userId = freezed,
    Object? bookCoverUrl = freezed,
    Object? page = freezed,
  }) {
    return _then(_HighlightExplore(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
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
      userId: freezed == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
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

// dart format on
