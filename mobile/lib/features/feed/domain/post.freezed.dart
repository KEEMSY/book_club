// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Post {
  String get id => throw _privateConstructorUsedError;
  String get bookId => throw _privateConstructorUsedError;
  PostAuthor get user => throw _privateConstructorUsedError;
  PostType get postType => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  List<String> get imageUrls => throw _privateConstructorUsedError;
  Map<ReactionType, int> get reactions => throw _privateConstructorUsedError;
  Set<ReactionType> get myReactions => throw _privateConstructorUsedError;
  int get commentCount => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostCopyWith<Post> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostCopyWith<$Res> {
  factory $PostCopyWith(Post value, $Res Function(Post) then) =
      _$PostCopyWithImpl<$Res, Post>;
  @useResult
  $Res call(
      {String id,
      String bookId,
      PostAuthor user,
      PostType postType,
      String content,
      List<String> imageUrls,
      Map<ReactionType, int> reactions,
      Set<ReactionType> myReactions,
      int commentCount,
      DateTime createdAt});

  $PostAuthorCopyWith<$Res> get user;
}

/// @nodoc
class _$PostCopyWithImpl<$Res, $Val extends Post>
    implements $PostCopyWith<$Res> {
  _$PostCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bookId = null,
    Object? user = null,
    Object? postType = null,
    Object? content = null,
    Object? imageUrls = null,
    Object? reactions = null,
    Object? myReactions = null,
    Object? commentCount = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      bookId: null == bookId
          ? _value.bookId
          : bookId // ignore: cast_nullable_to_non_nullable
              as String,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as PostAuthor,
      postType: null == postType
          ? _value.postType
          : postType // ignore: cast_nullable_to_non_nullable
              as PostType,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrls: null == imageUrls
          ? _value.imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      reactions: null == reactions
          ? _value.reactions
          : reactions // ignore: cast_nullable_to_non_nullable
              as Map<ReactionType, int>,
      myReactions: null == myReactions
          ? _value.myReactions
          : myReactions // ignore: cast_nullable_to_non_nullable
              as Set<ReactionType>,
      commentCount: null == commentCount
          ? _value.commentCount
          : commentCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PostAuthorCopyWith<$Res> get user {
    return $PostAuthorCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PostImplCopyWith<$Res> implements $PostCopyWith<$Res> {
  factory _$$PostImplCopyWith(
          _$PostImpl value, $Res Function(_$PostImpl) then) =
      __$$PostImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String bookId,
      PostAuthor user,
      PostType postType,
      String content,
      List<String> imageUrls,
      Map<ReactionType, int> reactions,
      Set<ReactionType> myReactions,
      int commentCount,
      DateTime createdAt});

  @override
  $PostAuthorCopyWith<$Res> get user;
}

/// @nodoc
class __$$PostImplCopyWithImpl<$Res>
    extends _$PostCopyWithImpl<$Res, _$PostImpl>
    implements _$$PostImplCopyWith<$Res> {
  __$$PostImplCopyWithImpl(_$PostImpl _value, $Res Function(_$PostImpl) _then)
      : super(_value, _then);

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? bookId = null,
    Object? user = null,
    Object? postType = null,
    Object? content = null,
    Object? imageUrls = null,
    Object? reactions = null,
    Object? myReactions = null,
    Object? commentCount = null,
    Object? createdAt = null,
  }) {
    return _then(_$PostImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      bookId: null == bookId
          ? _value.bookId
          : bookId // ignore: cast_nullable_to_non_nullable
              as String,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as PostAuthor,
      postType: null == postType
          ? _value.postType
          : postType // ignore: cast_nullable_to_non_nullable
              as PostType,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrls: null == imageUrls
          ? _value._imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      reactions: null == reactions
          ? _value._reactions
          : reactions // ignore: cast_nullable_to_non_nullable
              as Map<ReactionType, int>,
      myReactions: null == myReactions
          ? _value._myReactions
          : myReactions // ignore: cast_nullable_to_non_nullable
              as Set<ReactionType>,
      commentCount: null == commentCount
          ? _value.commentCount
          : commentCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$PostImpl implements _Post {
  const _$PostImpl(
      {required this.id,
      required this.bookId,
      required this.user,
      required this.postType,
      required this.content,
      required final List<String> imageUrls,
      required final Map<ReactionType, int> reactions,
      required final Set<ReactionType> myReactions,
      required this.commentCount,
      required this.createdAt})
      : _imageUrls = imageUrls,
        _reactions = reactions,
        _myReactions = myReactions;

  @override
  final String id;
  @override
  final String bookId;
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

  @override
  String toString() {
    return 'Post(id: $id, bookId: $bookId, user: $user, postType: $postType, content: $content, imageUrls: $imageUrls, reactions: $reactions, myReactions: $myReactions, commentCount: $commentCount, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.bookId, bookId) || other.bookId == bookId) &&
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
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      bookId,
      user,
      postType,
      content,
      const DeepCollectionEquality().hash(_imageUrls),
      const DeepCollectionEquality().hash(_reactions),
      const DeepCollectionEquality().hash(_myReactions),
      commentCount,
      createdAt);

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostImplCopyWith<_$PostImpl> get copyWith =>
      __$$PostImplCopyWithImpl<_$PostImpl>(this, _$identity);
}

abstract class _Post implements Post {
  const factory _Post(
      {required final String id,
      required final String bookId,
      required final PostAuthor user,
      required final PostType postType,
      required final String content,
      required final List<String> imageUrls,
      required final Map<ReactionType, int> reactions,
      required final Set<ReactionType> myReactions,
      required final int commentCount,
      required final DateTime createdAt}) = _$PostImpl;

  @override
  String get id;
  @override
  String get bookId;
  @override
  PostAuthor get user;
  @override
  PostType get postType;
  @override
  String get content;
  @override
  List<String> get imageUrls;
  @override
  Map<ReactionType, int> get reactions;
  @override
  Set<ReactionType> get myReactions;
  @override
  int get commentCount;
  @override
  DateTime get createdAt;

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostImplCopyWith<_$PostImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PostPage {
  List<Post> get items => throw _privateConstructorUsedError;
  String? get nextCursor => throw _privateConstructorUsedError;

  /// Create a copy of PostPage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PostPageCopyWith<PostPage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostPageCopyWith<$Res> {
  factory $PostPageCopyWith(PostPage value, $Res Function(PostPage) then) =
      _$PostPageCopyWithImpl<$Res, PostPage>;
  @useResult
  $Res call({List<Post> items, String? nextCursor});
}

/// @nodoc
class _$PostPageCopyWithImpl<$Res, $Val extends PostPage>
    implements $PostPageCopyWith<$Res> {
  _$PostPageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PostPage
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
              as List<Post>,
      nextCursor: freezed == nextCursor
          ? _value.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PostPageImplCopyWith<$Res>
    implements $PostPageCopyWith<$Res> {
  factory _$$PostPageImplCopyWith(
          _$PostPageImpl value, $Res Function(_$PostPageImpl) then) =
      __$$PostPageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Post> items, String? nextCursor});
}

/// @nodoc
class __$$PostPageImplCopyWithImpl<$Res>
    extends _$PostPageCopyWithImpl<$Res, _$PostPageImpl>
    implements _$$PostPageImplCopyWith<$Res> {
  __$$PostPageImplCopyWithImpl(
      _$PostPageImpl _value, $Res Function(_$PostPageImpl) _then)
      : super(_value, _then);

  /// Create a copy of PostPage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? nextCursor = freezed,
  }) {
    return _then(_$PostPageImpl(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<Post>,
      nextCursor: freezed == nextCursor
          ? _value.nextCursor
          : nextCursor // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$PostPageImpl implements _PostPage {
  const _$PostPageImpl({required final List<Post> items, this.nextCursor})
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

  @override
  String toString() {
    return 'PostPage(items: $items, nextCursor: $nextCursor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostPageImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_items), nextCursor);

  /// Create a copy of PostPage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostPageImplCopyWith<_$PostPageImpl> get copyWith =>
      __$$PostPageImplCopyWithImpl<_$PostPageImpl>(this, _$identity);
}

abstract class _PostPage implements PostPage {
  const factory _PostPage(
      {required final List<Post> items,
      final String? nextCursor}) = _$PostPageImpl;

  @override
  List<Post> get items;
  @override
  String? get nextCursor;

  /// Create a copy of PostPage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostPageImplCopyWith<_$PostPageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ReactionToggleResult {
  ReactionToggleState get state => throw _privateConstructorUsedError;
  Map<ReactionType, int> get counts => throw _privateConstructorUsedError;

  /// Create a copy of ReactionToggleResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReactionToggleResultCopyWith<ReactionToggleResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReactionToggleResultCopyWith<$Res> {
  factory $ReactionToggleResultCopyWith(ReactionToggleResult value,
          $Res Function(ReactionToggleResult) then) =
      _$ReactionToggleResultCopyWithImpl<$Res, ReactionToggleResult>;
  @useResult
  $Res call({ReactionToggleState state, Map<ReactionType, int> counts});
}

/// @nodoc
class _$ReactionToggleResultCopyWithImpl<$Res,
        $Val extends ReactionToggleResult>
    implements $ReactionToggleResultCopyWith<$Res> {
  _$ReactionToggleResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReactionToggleResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? state = null,
    Object? counts = null,
  }) {
    return _then(_value.copyWith(
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as ReactionToggleState,
      counts: null == counts
          ? _value.counts
          : counts // ignore: cast_nullable_to_non_nullable
              as Map<ReactionType, int>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReactionToggleResultImplCopyWith<$Res>
    implements $ReactionToggleResultCopyWith<$Res> {
  factory _$$ReactionToggleResultImplCopyWith(_$ReactionToggleResultImpl value,
          $Res Function(_$ReactionToggleResultImpl) then) =
      __$$ReactionToggleResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ReactionToggleState state, Map<ReactionType, int> counts});
}

/// @nodoc
class __$$ReactionToggleResultImplCopyWithImpl<$Res>
    extends _$ReactionToggleResultCopyWithImpl<$Res, _$ReactionToggleResultImpl>
    implements _$$ReactionToggleResultImplCopyWith<$Res> {
  __$$ReactionToggleResultImplCopyWithImpl(_$ReactionToggleResultImpl _value,
      $Res Function(_$ReactionToggleResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReactionToggleResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? state = null,
    Object? counts = null,
  }) {
    return _then(_$ReactionToggleResultImpl(
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as ReactionToggleState,
      counts: null == counts
          ? _value._counts
          : counts // ignore: cast_nullable_to_non_nullable
              as Map<ReactionType, int>,
    ));
  }
}

/// @nodoc

class _$ReactionToggleResultImpl implements _ReactionToggleResult {
  const _$ReactionToggleResultImpl(
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

  @override
  String toString() {
    return 'ReactionToggleResult(state: $state, counts: $counts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReactionToggleResultImpl &&
            (identical(other.state, state) || other.state == state) &&
            const DeepCollectionEquality().equals(other._counts, _counts));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, state, const DeepCollectionEquality().hash(_counts));

  /// Create a copy of ReactionToggleResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReactionToggleResultImplCopyWith<_$ReactionToggleResultImpl>
      get copyWith =>
          __$$ReactionToggleResultImplCopyWithImpl<_$ReactionToggleResultImpl>(
              this, _$identity);
}

abstract class _ReactionToggleResult implements ReactionToggleResult {
  const factory _ReactionToggleResult(
          {required final ReactionToggleState state,
          required final Map<ReactionType, int> counts}) =
      _$ReactionToggleResultImpl;

  @override
  ReactionToggleState get state;
  @override
  Map<ReactionType, int> get counts;

  /// Create a copy of ReactionToggleResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReactionToggleResultImplCopyWith<_$ReactionToggleResultImpl>
      get copyWith => throw _privateConstructorUsedError;
}
