// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_compose_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PostComposeState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is PostComposeState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'PostComposeState()';
  }
}

/// @nodoc
class $PostComposeStateCopyWith<$Res> {
  $PostComposeStateCopyWith(
      PostComposeState _, $Res Function(PostComposeState) __);
}

/// Adds pattern-matching-related methods to [PostComposeState].
extension PostComposeStatePatterns on PostComposeState {
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
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PostComposeEditing value)? editing,
    TResult Function(PostComposeUploading value)? uploading,
    TResult Function(PostComposePosting value)? posting,
    TResult Function(PostComposeSuccess value)? success,
    TResult Function(PostComposeFailure value)? failure,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case PostComposeEditing() when editing != null:
        return editing(_that);
      case PostComposeUploading() when uploading != null:
        return uploading(_that);
      case PostComposePosting() when posting != null:
        return posting(_that);
      case PostComposeSuccess() when success != null:
        return success(_that);
      case PostComposeFailure() when failure != null:
        return failure(_that);
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
  TResult map<TResult extends Object?>({
    required TResult Function(PostComposeEditing value) editing,
    required TResult Function(PostComposeUploading value) uploading,
    required TResult Function(PostComposePosting value) posting,
    required TResult Function(PostComposeSuccess value) success,
    required TResult Function(PostComposeFailure value) failure,
  }) {
    final _that = this;
    switch (_that) {
      case PostComposeEditing():
        return editing(_that);
      case PostComposeUploading():
        return uploading(_that);
      case PostComposePosting():
        return posting(_that);
      case PostComposeSuccess():
        return success(_that);
      case PostComposeFailure():
        return failure(_that);
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
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PostComposeEditing value)? editing,
    TResult? Function(PostComposeUploading value)? uploading,
    TResult? Function(PostComposePosting value)? posting,
    TResult? Function(PostComposeSuccess value)? success,
    TResult? Function(PostComposeFailure value)? failure,
  }) {
    final _that = this;
    switch (_that) {
      case PostComposeEditing() when editing != null:
        return editing(_that);
      case PostComposeUploading() when uploading != null:
        return uploading(_that);
      case PostComposePosting() when posting != null:
        return posting(_that);
      case PostComposeSuccess() when success != null:
        return success(_that);
      case PostComposeFailure() when failure != null:
        return failure(_that);
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
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            PostType postType, String content, List<PickedImage> images)?
        editing,
    TResult Function(PostType postType, String content,
            List<PickedImage> images, int uploadedCount)?
        uploading,
    TResult Function(
            PostType postType, String content, List<PickedImage> images)?
        posting,
    TResult Function(String postId)? success,
    TResult Function(PostType postType, String content,
            List<PickedImage> images, String code, String message)?
        failure,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case PostComposeEditing() when editing != null:
        return editing(_that.postType, _that.content, _that.images);
      case PostComposeUploading() when uploading != null:
        return uploading(
            _that.postType, _that.content, _that.images, _that.uploadedCount);
      case PostComposePosting() when posting != null:
        return posting(_that.postType, _that.content, _that.images);
      case PostComposeSuccess() when success != null:
        return success(_that.postId);
      case PostComposeFailure() when failure != null:
        return failure(_that.postType, _that.content, _that.images, _that.code,
            _that.message);
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
  TResult when<TResult extends Object?>({
    required TResult Function(
            PostType postType, String content, List<PickedImage> images)
        editing,
    required TResult Function(PostType postType, String content,
            List<PickedImage> images, int uploadedCount)
        uploading,
    required TResult Function(
            PostType postType, String content, List<PickedImage> images)
        posting,
    required TResult Function(String postId) success,
    required TResult Function(PostType postType, String content,
            List<PickedImage> images, String code, String message)
        failure,
  }) {
    final _that = this;
    switch (_that) {
      case PostComposeEditing():
        return editing(_that.postType, _that.content, _that.images);
      case PostComposeUploading():
        return uploading(
            _that.postType, _that.content, _that.images, _that.uploadedCount);
      case PostComposePosting():
        return posting(_that.postType, _that.content, _that.images);
      case PostComposeSuccess():
        return success(_that.postId);
      case PostComposeFailure():
        return failure(_that.postType, _that.content, _that.images, _that.code,
            _that.message);
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
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            PostType postType, String content, List<PickedImage> images)?
        editing,
    TResult? Function(PostType postType, String content,
            List<PickedImage> images, int uploadedCount)?
        uploading,
    TResult? Function(
            PostType postType, String content, List<PickedImage> images)?
        posting,
    TResult? Function(String postId)? success,
    TResult? Function(PostType postType, String content,
            List<PickedImage> images, String code, String message)?
        failure,
  }) {
    final _that = this;
    switch (_that) {
      case PostComposeEditing() when editing != null:
        return editing(_that.postType, _that.content, _that.images);
      case PostComposeUploading() when uploading != null:
        return uploading(
            _that.postType, _that.content, _that.images, _that.uploadedCount);
      case PostComposePosting() when posting != null:
        return posting(_that.postType, _that.content, _that.images);
      case PostComposeSuccess() when success != null:
        return success(_that.postId);
      case PostComposeFailure() when failure != null:
        return failure(_that.postType, _that.content, _that.images, _that.code,
            _that.message);
      case _:
        return null;
    }
  }
}

/// @nodoc

class PostComposeEditing implements PostComposeState {
  const PostComposeEditing(
      {this.postType = PostType.thought,
      this.content = '',
      final List<PickedImage> images = const <PickedImage>[]})
      : _images = images;

  @JsonKey()
  final PostType postType;
  @JsonKey()
  final String content;
  final List<PickedImage> _images;
  @JsonKey()
  List<PickedImage> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  /// Create a copy of PostComposeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PostComposeEditingCopyWith<PostComposeEditing> get copyWith =>
      _$PostComposeEditingCopyWithImpl<PostComposeEditing>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PostComposeEditing &&
            (identical(other.postType, postType) ||
                other.postType == postType) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality().equals(other._images, _images));
  }

  @override
  int get hashCode => Object.hash(runtimeType, postType, content,
      const DeepCollectionEquality().hash(_images));

  @override
  String toString() {
    return 'PostComposeState.editing(postType: $postType, content: $content, images: $images)';
  }
}

/// @nodoc
abstract mixin class $PostComposeEditingCopyWith<$Res>
    implements $PostComposeStateCopyWith<$Res> {
  factory $PostComposeEditingCopyWith(
          PostComposeEditing value, $Res Function(PostComposeEditing) _then) =
      _$PostComposeEditingCopyWithImpl;
  @useResult
  $Res call({PostType postType, String content, List<PickedImage> images});
}

/// @nodoc
class _$PostComposeEditingCopyWithImpl<$Res>
    implements $PostComposeEditingCopyWith<$Res> {
  _$PostComposeEditingCopyWithImpl(this._self, this._then);

  final PostComposeEditing _self;
  final $Res Function(PostComposeEditing) _then;

  /// Create a copy of PostComposeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? postType = null,
    Object? content = null,
    Object? images = null,
  }) {
    return _then(PostComposeEditing(
      postType: null == postType
          ? _self.postType
          : postType // ignore: cast_nullable_to_non_nullable
              as PostType,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      images: null == images
          ? _self._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<PickedImage>,
    ));
  }
}

/// @nodoc

class PostComposeUploading implements PostComposeState {
  const PostComposeUploading(
      {required this.postType,
      required this.content,
      required final List<PickedImage> images,
      required this.uploadedCount})
      : _images = images;

  final PostType postType;
  final String content;
  final List<PickedImage> _images;
  List<PickedImage> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  final int uploadedCount;

  /// Create a copy of PostComposeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PostComposeUploadingCopyWith<PostComposeUploading> get copyWith =>
      _$PostComposeUploadingCopyWithImpl<PostComposeUploading>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PostComposeUploading &&
            (identical(other.postType, postType) ||
                other.postType == postType) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.uploadedCount, uploadedCount) ||
                other.uploadedCount == uploadedCount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, postType, content,
      const DeepCollectionEquality().hash(_images), uploadedCount);

  @override
  String toString() {
    return 'PostComposeState.uploading(postType: $postType, content: $content, images: $images, uploadedCount: $uploadedCount)';
  }
}

/// @nodoc
abstract mixin class $PostComposeUploadingCopyWith<$Res>
    implements $PostComposeStateCopyWith<$Res> {
  factory $PostComposeUploadingCopyWith(PostComposeUploading value,
          $Res Function(PostComposeUploading) _then) =
      _$PostComposeUploadingCopyWithImpl;
  @useResult
  $Res call(
      {PostType postType,
      String content,
      List<PickedImage> images,
      int uploadedCount});
}

/// @nodoc
class _$PostComposeUploadingCopyWithImpl<$Res>
    implements $PostComposeUploadingCopyWith<$Res> {
  _$PostComposeUploadingCopyWithImpl(this._self, this._then);

  final PostComposeUploading _self;
  final $Res Function(PostComposeUploading) _then;

  /// Create a copy of PostComposeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? postType = null,
    Object? content = null,
    Object? images = null,
    Object? uploadedCount = null,
  }) {
    return _then(PostComposeUploading(
      postType: null == postType
          ? _self.postType
          : postType // ignore: cast_nullable_to_non_nullable
              as PostType,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      images: null == images
          ? _self._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<PickedImage>,
      uploadedCount: null == uploadedCount
          ? _self.uploadedCount
          : uploadedCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class PostComposePosting implements PostComposeState {
  const PostComposePosting(
      {required this.postType,
      required this.content,
      required final List<PickedImage> images})
      : _images = images;

  final PostType postType;
  final String content;
  final List<PickedImage> _images;
  List<PickedImage> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  /// Create a copy of PostComposeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PostComposePostingCopyWith<PostComposePosting> get copyWith =>
      _$PostComposePostingCopyWithImpl<PostComposePosting>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PostComposePosting &&
            (identical(other.postType, postType) ||
                other.postType == postType) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality().equals(other._images, _images));
  }

  @override
  int get hashCode => Object.hash(runtimeType, postType, content,
      const DeepCollectionEquality().hash(_images));

  @override
  String toString() {
    return 'PostComposeState.posting(postType: $postType, content: $content, images: $images)';
  }
}

/// @nodoc
abstract mixin class $PostComposePostingCopyWith<$Res>
    implements $PostComposeStateCopyWith<$Res> {
  factory $PostComposePostingCopyWith(
          PostComposePosting value, $Res Function(PostComposePosting) _then) =
      _$PostComposePostingCopyWithImpl;
  @useResult
  $Res call({PostType postType, String content, List<PickedImage> images});
}

/// @nodoc
class _$PostComposePostingCopyWithImpl<$Res>
    implements $PostComposePostingCopyWith<$Res> {
  _$PostComposePostingCopyWithImpl(this._self, this._then);

  final PostComposePosting _self;
  final $Res Function(PostComposePosting) _then;

  /// Create a copy of PostComposeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? postType = null,
    Object? content = null,
    Object? images = null,
  }) {
    return _then(PostComposePosting(
      postType: null == postType
          ? _self.postType
          : postType // ignore: cast_nullable_to_non_nullable
              as PostType,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      images: null == images
          ? _self._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<PickedImage>,
    ));
  }
}

/// @nodoc

class PostComposeSuccess implements PostComposeState {
  const PostComposeSuccess({required this.postId});

  final String postId;

  /// Create a copy of PostComposeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PostComposeSuccessCopyWith<PostComposeSuccess> get copyWith =>
      _$PostComposeSuccessCopyWithImpl<PostComposeSuccess>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PostComposeSuccess &&
            (identical(other.postId, postId) || other.postId == postId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, postId);

  @override
  String toString() {
    return 'PostComposeState.success(postId: $postId)';
  }
}

/// @nodoc
abstract mixin class $PostComposeSuccessCopyWith<$Res>
    implements $PostComposeStateCopyWith<$Res> {
  factory $PostComposeSuccessCopyWith(
          PostComposeSuccess value, $Res Function(PostComposeSuccess) _then) =
      _$PostComposeSuccessCopyWithImpl;
  @useResult
  $Res call({String postId});
}

/// @nodoc
class _$PostComposeSuccessCopyWithImpl<$Res>
    implements $PostComposeSuccessCopyWith<$Res> {
  _$PostComposeSuccessCopyWithImpl(this._self, this._then);

  final PostComposeSuccess _self;
  final $Res Function(PostComposeSuccess) _then;

  /// Create a copy of PostComposeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? postId = null,
  }) {
    return _then(PostComposeSuccess(
      postId: null == postId
          ? _self.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class PostComposeFailure implements PostComposeState {
  const PostComposeFailure(
      {required this.postType,
      required this.content,
      required final List<PickedImage> images,
      required this.code,
      required this.message})
      : _images = images;

  final PostType postType;
  final String content;
  final List<PickedImage> _images;
  List<PickedImage> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  final String code;
  final String message;

  /// Create a copy of PostComposeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PostComposeFailureCopyWith<PostComposeFailure> get copyWith =>
      _$PostComposeFailureCopyWithImpl<PostComposeFailure>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PostComposeFailure &&
            (identical(other.postType, postType) ||
                other.postType == postType) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, postType, content,
      const DeepCollectionEquality().hash(_images), code, message);

  @override
  String toString() {
    return 'PostComposeState.failure(postType: $postType, content: $content, images: $images, code: $code, message: $message)';
  }
}

/// @nodoc
abstract mixin class $PostComposeFailureCopyWith<$Res>
    implements $PostComposeStateCopyWith<$Res> {
  factory $PostComposeFailureCopyWith(
          PostComposeFailure value, $Res Function(PostComposeFailure) _then) =
      _$PostComposeFailureCopyWithImpl;
  @useResult
  $Res call(
      {PostType postType,
      String content,
      List<PickedImage> images,
      String code,
      String message});
}

/// @nodoc
class _$PostComposeFailureCopyWithImpl<$Res>
    implements $PostComposeFailureCopyWith<$Res> {
  _$PostComposeFailureCopyWithImpl(this._self, this._then);

  final PostComposeFailure _self;
  final $Res Function(PostComposeFailure) _then;

  /// Create a copy of PostComposeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? postType = null,
    Object? content = null,
    Object? images = null,
    Object? code = null,
    Object? message = null,
  }) {
    return _then(PostComposeFailure(
      postType: null == postType
          ? _self.postType
          : postType // ignore: cast_nullable_to_non_nullable
              as PostType,
      content: null == content
          ? _self.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      images: null == images
          ? _self._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<PickedImage>,
      code: null == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
