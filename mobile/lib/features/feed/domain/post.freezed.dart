// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Post {
  String get id;
  String get bookId;
  String? get bookTitle;
  String? get bookCoverUrl;
  PostAuthor get user;
  PostType get postType;
  String get content;
  List<String> get imageUrls;
  Map<ReactionType, int> get reactions;
  Set<ReactionType> get myReactions;
  int get commentCount;
  DateTime
      get createdAt; // Activity-event metadata (M37). Present when [PostType.isActivity] is
// true; null for user-composed posts. Keys vary by event type — consumers
// must guard with null checks.
  Map<String, dynamic>? get metadata;

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PostCopyWith<Post> get copyWith =>
      _$PostCopyWithImpl<Post>(this as Post, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Post &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.bookId, bookId) || other.bookId == bookId) &&
            (identical(other.bookTitle, bookTitle) ||
                other.bookTitle == bookTitle) &&
            (identical(other.bookCoverUrl, bookCoverUrl) ||
                other.bookCoverUrl == bookCoverUrl) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.postType, postType) ||
                other.postType == postType) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality().equals(other.imageUrls, imageUrls) &&
            const DeepCollectionEquality().equals(other.reactions, reactions) &&
            const DeepCollectionEquality()
                .equals(other.myReactions, myReactions) &&
            (identical(other.commentCount, commentCount) ||
                other.commentCount == commentCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.metadata, metadata));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      bookId,
      bookTitle,
      bookCoverUrl,
      user,
      postType,
      content,
      const DeepCollectionEquality().hash(imageUrls),
      const DeepCollectionEquality().hash(reactions),
      const DeepCollectionEquality().hash(myReactions),
      commentCount,
      createdAt,
      const DeepCollectionEquality().hash(metadata));

  @override
  String toString() {
    return 'Post(id: $id, bookId: $bookId, bookTitle: $bookTitle, bookCoverUrl: $bookCoverUrl, user: $user, postType: $postType, content: $content, imageUrls: $imageUrls, reactions: $reactions, myReactions: $myReactions, commentCount: $commentCount, createdAt: $createdAt, metadata: $metadata)';
  }
}

/// @nodoc
abstract mixin class $PostCopyWith<$Res> {
  factory $PostCopyWith(Post value, $Res Function(Post) _then) =
      _$PostCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String bookId,
      String? bookTitle,
      String? bookCoverUrl,
      PostAuthor user,
      PostType postType,
      String content,
      List<String> imageUrls,
      Map<ReactionType, int> reactions,
      Set<ReactionType> myReactions,
      int commentCount,
      DateTime createdAt,
      Map<String, dynamic>? metadata});

  $PostAuthorCopyWith<$Res> get user;
}

/// @nodoc
class _$PostCopyWithImpl<$Res> implements $PostCopyWith<$Res> {
  _$PostCopyWithImpl(this._self, this._then);

  final Post _self;
  final $Res Function(Post) _then;

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bookId = null,
    Object? bookTitle = freezed,
    Object? bookCoverUrl = freezed,
    Object? user = null,
    Object? postType = null,
    Object? content = null,
    Object? imageUrls = null,
    Object? reactions = null,
    Object? myReactions = null,
    Object? commentCount = null,
    Object? createdAt = null,
    Object? metadata = freezed,
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
      user: null == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as PostAuthor,
      postType: null == postType
          ? _self.postType
          : postType // ignore: cast_nullable_to_non_nullable
              as PostType,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrls: null == imageUrls
          ? _self.imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      reactions: null == reactions
          ? _self.reactions
          : reactions // ignore: cast_nullable_to_non_nullable
              as Map<ReactionType, int>,
      myReactions: null == myReactions
          ? _self.myReactions
          : myReactions // ignore: cast_nullable_to_non_nullable
              as Set<ReactionType>,
      commentCount: null == commentCount
          ? _self.commentCount
          : commentCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      metadata: freezed == metadata
          ? _self.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PostAuthorCopyWith<$Res> get user {
    return $PostAuthorCopyWith<$Res>(_self.user, (value) {
      return _then(_self.copyWith(user: value));
    });
  }
}

/// Adds pattern-matching-related methods to [Post].
extension PostPatterns on Post {
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
    TResult Function(_Post value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Post() when $default != null:
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
    TResult Function(_Post value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Post():
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
    TResult? Function(_Post value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Post() when $default != null:
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
            PostAuthor user,
            PostType postType,
            String content,
            List<String> imageUrls,
            Map<ReactionType, int> reactions,
            Set<ReactionType> myReactions,
            int commentCount,
            DateTime createdAt,
            Map<String, dynamic>? metadata)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Post() when $default != null:
        return $default(
            _that.id,
            _that.bookId,
            _that.bookTitle,
            _that.bookCoverUrl,
            _that.user,
            _that.postType,
            _that.content,
            _that.imageUrls,
            _that.reactions,
            _that.myReactions,
            _that.commentCount,
            _that.createdAt,
            _that.metadata);
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
            PostAuthor user,
            PostType postType,
            String content,
            List<String> imageUrls,
            Map<ReactionType, int> reactions,
            Set<ReactionType> myReactions,
            int commentCount,
            DateTime createdAt,
            Map<String, dynamic>? metadata)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Post():
        return $default(
            _that.id,
            _that.bookId,
            _that.bookTitle,
            _that.bookCoverUrl,
            _that.user,
            _that.postType,
            _that.content,
            _that.imageUrls,
            _that.reactions,
            _that.myReactions,
            _that.commentCount,
            _that.createdAt,
            _that.metadata);
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
            PostAuthor user,
            PostType postType,
            String content,
            List<String> imageUrls,
            Map<ReactionType, int> reactions,
            Set<ReactionType> myReactions,
            int commentCount,
            DateTime createdAt,
            Map<String, dynamic>? metadata)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Post() when $default != null:
        return $default(
            _that.id,
            _that.bookId,
            _that.bookTitle,
            _that.bookCoverUrl,
            _that.user,
            _that.postType,
            _that.content,
            _that.imageUrls,
            _that.reactions,
            _that.myReactions,
            _that.commentCount,
            _that.createdAt,
            _that.metadata);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _Post implements Post {
  const _Post(
      {required this.id,
      required this.bookId,
      this.bookTitle,
      this.bookCoverUrl,
      required this.user,
      required this.postType,
      required this.content,
      required final List<String> imageUrls,
      required final Map<ReactionType, int> reactions,
      required final Set<ReactionType> myReactions,
      required this.commentCount,
      required this.createdAt,
      final Map<String, dynamic>? metadata})
      : _imageUrls = imageUrls,
        _reactions = reactions,
        _myReactions = myReactions,
        _metadata = metadata;

  @override
  final String id;
  @override
  final String bookId;
  @override
  final String? bookTitle;
  @override
  final String? bookCoverUrl;
  @override
  final PostAuthor user;
  @override
  final PostType postType;
  @override
  final String content;
  final List<String> _imageUrls;
  @override
  List<String> get imageUrls {
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageUrls);
  }

  final Map<ReactionType, int> _reactions;
  @override
  Map<ReactionType, int> get reactions {
    if (_reactions is EqualUnmodifiableMapView) return _reactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_reactions);
  }

  final Set<ReactionType> _myReactions;
  @override
  Set<ReactionType> get myReactions {
    if (_myReactions is EqualUnmodifiableSetView) return _myReactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_myReactions);
  }

  @override
  final int commentCount;
  @override
  final DateTime createdAt;
// Activity-event metadata (M37). Present when [PostType.isActivity] is
// true; null for user-composed posts. Keys vary by event type — consumers
// must guard with null checks.
  final Map<String, dynamic>? _metadata;
// Activity-event metadata (M37). Present when [PostType.isActivity] is
// true; null for user-composed posts. Keys vary by event type — consumers
// must guard with null checks.
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PostCopyWith<_Post> get copyWith =>
      __$PostCopyWithImpl<_Post>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Post &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.bookId, bookId) || other.bookId == bookId) &&
            (identical(other.bookTitle, bookTitle) ||
                other.bookTitle == bookTitle) &&
            (identical(other.bookCoverUrl, bookCoverUrl) ||
                other.bookCoverUrl == bookCoverUrl) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.postType, postType) ||
                other.postType == postType) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality()
                .equals(other._imageUrls, _imageUrls) &&
            const DeepCollectionEquality()
                .equals(other._reactions, _reactions) &&
            const DeepCollectionEquality()
                .equals(other._myReactions, _myReactions) &&
            (identical(other.commentCount, commentCount) ||
                other.commentCount == commentCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      bookId,
      bookTitle,
      bookCoverUrl,
      user,
      postType,
      content,
      const DeepCollectionEquality().hash(_imageUrls),
      const DeepCollectionEquality().hash(_reactions),
      const DeepCollectionEquality().hash(_myReactions),
      commentCount,
      createdAt,
      const DeepCollectionEquality().hash(_metadata));

  @override
  String toString() {
    return 'Post(id: $id, bookId: $bookId, bookTitle: $bookTitle, bookCoverUrl: $bookCoverUrl, user: $user, postType: $postType, content: $content, imageUrls: $imageUrls, reactions: $reactions, myReactions: $myReactions, commentCount: $commentCount, createdAt: $createdAt, metadata: $metadata)';
  }
}

/// @nodoc
abstract mixin class _$PostCopyWith<$Res> implements $PostCopyWith<$Res> {
  factory _$PostCopyWith(_Post value, $Res Function(_Post) _then) =
      __$PostCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String bookId,
      String? bookTitle,
      String? bookCoverUrl,
      PostAuthor user,
      PostType postType,
      String content,
      List<String> imageUrls,
      Map<ReactionType, int> reactions,
      Set<ReactionType> myReactions,
      int commentCount,
      DateTime createdAt,
      Map<String, dynamic>? metadata});

  @override
  $PostAuthorCopyWith<$Res> get user;
}

/// @nodoc
class __$PostCopyWithImpl<$Res> implements _$PostCopyWith<$Res> {
  __$PostCopyWithImpl(this._self, this._then);

  final _Post _self;
  final $Res Function(_Post) _then;

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? bookId = null,
    Object? bookTitle = freezed,
    Object? bookCoverUrl = freezed,
    Object? user = null,
    Object? postType = null,
    Object? content = null,
    Object? imageUrls = null,
    Object? reactions = null,
    Object? myReactions = null,
    Object? commentCount = null,
    Object? createdAt = null,
    Object? metadata = freezed,
  }) {
    return _then(_Post(
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
      user: null == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as PostAuthor,
      postType: null == postType
          ? _self.postType
          : postType // ignore: cast_nullable_to_non_nullable
              as PostType,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrls: null == imageUrls
          ? _self._imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      reactions: null == reactions
          ? _self._reactions
          : reactions // ignore: cast_nullable_to_non_nullable
              as Map<ReactionType, int>,
      myReactions: null == myReactions
          ? _self._myReactions
          : myReactions // ignore: cast_nullable_to_non_nullable
              as Set<ReactionType>,
      commentCount: null == commentCount
          ? _self.commentCount
          : commentCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      metadata: freezed == metadata
          ? _self._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PostAuthorCopyWith<$Res> get user {
    return $PostAuthorCopyWith<$Res>(_self.user, (value) {
      return _then(_self.copyWith(user: value));
    });
  }
}

/// @nodoc
mixin _$PostPage {
  List<Post> get items;
  String? get nextCursor;

  /// Create a copy of PostPage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PostPageCopyWith<PostPage> get copyWith =>
      _$PostPageCopyWithImpl<PostPage>(this as PostPage, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PostPage &&
            const DeepCollectionEquality().equals(other.items, items) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(items), nextCursor);

  @override
  String toString() {
    return 'PostPage(items: $items, nextCursor: $nextCursor)';
  }
}

/// @nodoc
abstract mixin class $PostPageCopyWith<$Res> {
  factory $PostPageCopyWith(PostPage value, $Res Function(PostPage) _then) =
      _$PostPageCopyWithImpl;
  @useResult
  $Res call({List<Post> items, String? nextCursor});
}

/// @nodoc
class _$PostPageCopyWithImpl<$Res> implements $PostPageCopyWith<$Res> {
  _$PostPageCopyWithImpl(this._self, this._then);

  final PostPage _self;
  final $Res Function(PostPage) _then;

  /// Create a copy of PostPage
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
              as List<Post>,
      nextCursor: freezed == nextCursor
          ? _self.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [PostPage].
extension PostPagePatterns on PostPage {
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
    TResult Function(_PostPage value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PostPage() when $default != null:
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
    TResult Function(_PostPage value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PostPage():
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
    TResult? Function(_PostPage value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PostPage() when $default != null:
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
    TResult Function(List<Post> items, String? nextCursor)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _PostPage() when $default != null:
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
    TResult Function(List<Post> items, String? nextCursor) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PostPage():
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
    TResult? Function(List<Post> items, String? nextCursor)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _PostPage() when $default != null:
        return $default(_that.items, _that.nextCursor);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _PostPage implements PostPage {
  const _PostPage({required final List<Post> items, this.nextCursor})
      : _items = items;

  final List<Post> _items;
  @override
  List<Post> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final String? nextCursor;

  /// Create a copy of PostPage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PostPageCopyWith<_PostPage> get copyWith =>
      __$PostPageCopyWithImpl<_PostPage>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PostPage &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_items), nextCursor);

  @override
  String toString() {
    return 'PostPage(items: $items, nextCursor: $nextCursor)';
  }
}

/// @nodoc
abstract mixin class _$PostPageCopyWith<$Res>
    implements $PostPageCopyWith<$Res> {
  factory _$PostPageCopyWith(_PostPage value, $Res Function(_PostPage) _then) =
      __$PostPageCopyWithImpl;
  @override
  @useResult
  $Res call({List<Post> items, String? nextCursor});
}

/// @nodoc
class __$PostPageCopyWithImpl<$Res> implements _$PostPageCopyWith<$Res> {
  __$PostPageCopyWithImpl(this._self, this._then);

  final _PostPage _self;
  final $Res Function(_PostPage) _then;

  /// Create a copy of PostPage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? items = null,
    Object? nextCursor = freezed,
  }) {
    return _then(_PostPage(
      items: null == items
          ? _self._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Post>,
      nextCursor: freezed == nextCursor
          ? _self.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$ReactionToggleResult {
  ReactionToggleState get state;
  Map<ReactionType, int> get counts;

  /// Create a copy of ReactionToggleResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReactionToggleResultCopyWith<ReactionToggleResult> get copyWith =>
      _$ReactionToggleResultCopyWithImpl<ReactionToggleResult>(
          this as ReactionToggleResult, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReactionToggleResult &&
            (identical(other.state, state) || other.state == state) &&
            const DeepCollectionEquality().equals(other.counts, counts));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, state, const DeepCollectionEquality().hash(counts));

  @override
  String toString() {
    return 'ReactionToggleResult(state: $state, counts: $counts)';
  }
}

/// @nodoc
abstract mixin class $ReactionToggleResultCopyWith<$Res> {
  factory $ReactionToggleResultCopyWith(ReactionToggleResult value,
          $Res Function(ReactionToggleResult) _then) =
      _$ReactionToggleResultCopyWithImpl;
  @useResult
  $Res call({ReactionToggleState state, Map<ReactionType, int> counts});
}

/// @nodoc
class _$ReactionToggleResultCopyWithImpl<$Res>
    implements $ReactionToggleResultCopyWith<$Res> {
  _$ReactionToggleResultCopyWithImpl(this._self, this._then);

  final ReactionToggleResult _self;
  final $Res Function(ReactionToggleResult) _then;

  /// Create a copy of ReactionToggleResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? state = null,
    Object? counts = null,
  }) {
    return _then(_self.copyWith(
      state: null == state
          ? _self.state
          : state // ignore: cast_nullable_to_non_nullable
              as ReactionToggleState,
      counts: null == counts
          ? _self.counts
          : counts // ignore: cast_nullable_to_non_nullable
              as Map<ReactionType, int>,
    ));
  }
}

/// Adds pattern-matching-related methods to [ReactionToggleResult].
extension ReactionToggleResultPatterns on ReactionToggleResult {
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
    TResult Function(_ReactionToggleResult value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ReactionToggleResult() when $default != null:
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
    TResult Function(_ReactionToggleResult value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReactionToggleResult():
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
    TResult? Function(_ReactionToggleResult value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReactionToggleResult() when $default != null:
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
    TResult Function(ReactionToggleState state, Map<ReactionType, int> counts)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ReactionToggleResult() when $default != null:
        return $default(_that.state, _that.counts);
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
    TResult Function(ReactionToggleState state, Map<ReactionType, int> counts)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReactionToggleResult():
        return $default(_that.state, _that.counts);
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
    TResult? Function(ReactionToggleState state, Map<ReactionType, int> counts)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReactionToggleResult() when $default != null:
        return $default(_that.state, _that.counts);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _ReactionToggleResult implements ReactionToggleResult {
  const _ReactionToggleResult(
      {required this.state, required final Map<ReactionType, int> counts})
      : _counts = counts;

  @override
  final ReactionToggleState state;
  final Map<ReactionType, int> _counts;
  @override
  Map<ReactionType, int> get counts {
    if (_counts is EqualUnmodifiableMapView) return _counts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_counts);
  }

  /// Create a copy of ReactionToggleResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ReactionToggleResultCopyWith<_ReactionToggleResult> get copyWith =>
      __$ReactionToggleResultCopyWithImpl<_ReactionToggleResult>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ReactionToggleResult &&
            (identical(other.state, state) || other.state == state) &&
            const DeepCollectionEquality().equals(other._counts, _counts));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, state, const DeepCollectionEquality().hash(_counts));

  @override
  String toString() {
    return 'ReactionToggleResult(state: $state, counts: $counts)';
  }
}

/// @nodoc
abstract mixin class _$ReactionToggleResultCopyWith<$Res>
    implements $ReactionToggleResultCopyWith<$Res> {
  factory _$ReactionToggleResultCopyWith(_ReactionToggleResult value,
          $Res Function(_ReactionToggleResult) _then) =
      __$ReactionToggleResultCopyWithImpl;
  @override
  @useResult
  $Res call({ReactionToggleState state, Map<ReactionType, int> counts});
}

/// @nodoc
class __$ReactionToggleResultCopyWithImpl<$Res>
    implements _$ReactionToggleResultCopyWith<$Res> {
  __$ReactionToggleResultCopyWithImpl(this._self, this._then);

  final _ReactionToggleResult _self;
  final $Res Function(_ReactionToggleResult) _then;

  /// Create a copy of ReactionToggleResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? state = null,
    Object? counts = null,
  }) {
    return _then(_ReactionToggleResult(
      state: null == state
          ? _self.state
          : state // ignore: cast_nullable_to_non_nullable
              as ReactionToggleState,
      counts: null == counts
          ? _self._counts
          : counts // ignore: cast_nullable_to_non_nullable
              as Map<ReactionType, int>,
    ));
  }
}

// dart format on
