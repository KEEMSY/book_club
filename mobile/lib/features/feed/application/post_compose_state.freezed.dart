// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_compose_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PostComposeState {
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
  }) =>
      throw _privateConstructorUsedError;
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
  }) =>
      throw _privateConstructorUsedError;
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
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PostComposeEditing value) editing,
    required TResult Function(PostComposeUploading value) uploading,
    required TResult Function(PostComposePosting value) posting,
    required TResult Function(PostComposeSuccess value) success,
    required TResult Function(PostComposeFailure value) failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PostComposeEditing value)? editing,
    TResult? Function(PostComposeUploading value)? uploading,
    TResult? Function(PostComposePosting value)? posting,
    TResult? Function(PostComposeSuccess value)? success,
    TResult? Function(PostComposeFailure value)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PostComposeEditing value)? editing,
    TResult Function(PostComposeUploading value)? uploading,
    TResult Function(PostComposePosting value)? posting,
    TResult Function(PostComposeSuccess value)? success,
    TResult Function(PostComposeFailure value)? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostComposeStateCopyWith<$Res> {
  factory $PostComposeStateCopyWith(
          PostComposeState value, $Res Function(PostComposeState) then) =
      _$PostComposeStateCopyWithImpl<$Res, PostComposeState>;
}

/// @nodoc
class _$PostComposeStateCopyWithImpl<$Res, $Val extends PostComposeState>
    implements $PostComposeStateCopyWith<$Res> {
  _$PostComposeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PostComposeState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$PostComposeEditingImplCopyWith<$Res> {
  factory _$$PostComposeEditingImplCopyWith(_$PostComposeEditingImpl value,
          $Res Function(_$PostComposeEditingImpl) then) =
      __$$PostComposeEditingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({PostType postType, String content, List<PickedImage> images});
}

/// @nodoc
class __$$PostComposeEditingImplCopyWithImpl<$Res>
    extends _$PostComposeStateCopyWithImpl<$Res, _$PostComposeEditingImpl>
    implements _$$PostComposeEditingImplCopyWith<$Res> {
  __$$PostComposeEditingImplCopyWithImpl(_$PostComposeEditingImpl _value,
      $Res Function(_$PostComposeEditingImpl) _then)
      : super(_value, _then);

  /// Create a copy of PostComposeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? postType = null,
    Object? content = null,
    Object? images = null,
  }) {
    return _then(_$PostComposeEditingImpl(
      postType: null == postType
          ? _value.postType
          : postType // ignore: cast_nullable_to_non_nullable
              as PostType,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<PickedImage>,
    ));
  }
}

/// @nodoc

class _$PostComposeEditingImpl implements PostComposeEditing {
  const _$PostComposeEditingImpl(
      {this.postType = PostType.thought,
      this.content = '',
      final List<PickedImage> images = const <PickedImage>[]})
      : _images = images;

  @override
  @JsonKey()
  final PostType postType;
  @override
  @JsonKey()
  final String content;
  final List<PickedImage> _images;
  @override
  @JsonKey()
  List<PickedImage> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  String toString() {
    return 'PostComposeState.editing(postType: $postType, content: $content, images: $images)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostComposeEditingImpl &&
            (identical(other.postType, postType) ||
                other.postType == postType) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality().equals(other._images, _images));
  }

  @override
  int get hashCode => Object.hash(runtimeType, postType, content,
      const DeepCollectionEquality().hash(_images));

  /// Create a copy of PostComposeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostComposeEditingImplCopyWith<_$PostComposeEditingImpl> get copyWith =>
      __$$PostComposeEditingImplCopyWithImpl<_$PostComposeEditingImpl>(
          this, _$identity);

  @override
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
    return editing(postType, content, images);
  }

  @override
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
    return editing?.call(postType, content, images);
  }

  @override
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
    if (editing != null) {
      return editing(postType, content, images);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PostComposeEditing value) editing,
    required TResult Function(PostComposeUploading value) uploading,
    required TResult Function(PostComposePosting value) posting,
    required TResult Function(PostComposeSuccess value) success,
    required TResult Function(PostComposeFailure value) failure,
  }) {
    return editing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PostComposeEditing value)? editing,
    TResult? Function(PostComposeUploading value)? uploading,
    TResult? Function(PostComposePosting value)? posting,
    TResult? Function(PostComposeSuccess value)? success,
    TResult? Function(PostComposeFailure value)? failure,
  }) {
    return editing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PostComposeEditing value)? editing,
    TResult Function(PostComposeUploading value)? uploading,
    TResult Function(PostComposePosting value)? posting,
    TResult Function(PostComposeSuccess value)? success,
    TResult Function(PostComposeFailure value)? failure,
    required TResult orElse(),
  }) {
    if (editing != null) {
      return editing(this);
    }
    return orElse();
  }
}

abstract class PostComposeEditing implements PostComposeState {
  const factory PostComposeEditing(
      {final PostType postType,
      final String content,
      final List<PickedImage> images}) = _$PostComposeEditingImpl;

  PostType get postType;
  String get content;
  List<PickedImage> get images;

  /// Create a copy of PostComposeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostComposeEditingImplCopyWith<_$PostComposeEditingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PostComposeUploadingImplCopyWith<$Res> {
  factory _$$PostComposeUploadingImplCopyWith(_$PostComposeUploadingImpl value,
          $Res Function(_$PostComposeUploadingImpl) then) =
      __$$PostComposeUploadingImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {PostType postType,
      String content,
      List<PickedImage> images,
      int uploadedCount});
}

/// @nodoc
class __$$PostComposeUploadingImplCopyWithImpl<$Res>
    extends _$PostComposeStateCopyWithImpl<$Res, _$PostComposeUploadingImpl>
    implements _$$PostComposeUploadingImplCopyWith<$Res> {
  __$$PostComposeUploadingImplCopyWithImpl(_$PostComposeUploadingImpl _value,
      $Res Function(_$PostComposeUploadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of PostComposeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? postType = null,
    Object? content = null,
    Object? images = null,
    Object? uploadedCount = null,
  }) {
    return _then(_$PostComposeUploadingImpl(
      postType: null == postType
          ? _value.postType
          : postType // ignore: cast_nullable_to_non_nullable
              as PostType,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<PickedImage>,
      uploadedCount: null == uploadedCount
          ? _value.uploadedCount
          : uploadedCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$PostComposeUploadingImpl implements PostComposeUploading {
  const _$PostComposeUploadingImpl(
      {required this.postType,
      required this.content,
      required final List<PickedImage> images,
      required this.uploadedCount})
      : _images = images;

  @override
  final PostType postType;
  @override
  final String content;
  final List<PickedImage> _images;
  @override
  List<PickedImage> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  final int uploadedCount;

  @override
  String toString() {
    return 'PostComposeState.uploading(postType: $postType, content: $content, images: $images, uploadedCount: $uploadedCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostComposeUploadingImpl &&
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

  /// Create a copy of PostComposeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostComposeUploadingImplCopyWith<_$PostComposeUploadingImpl>
      get copyWith =>
          __$$PostComposeUploadingImplCopyWithImpl<_$PostComposeUploadingImpl>(
              this, _$identity);

  @override
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
    return uploading(postType, content, images, uploadedCount);
  }

  @override
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
    return uploading?.call(postType, content, images, uploadedCount);
  }

  @override
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
    if (uploading != null) {
      return uploading(postType, content, images, uploadedCount);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PostComposeEditing value) editing,
    required TResult Function(PostComposeUploading value) uploading,
    required TResult Function(PostComposePosting value) posting,
    required TResult Function(PostComposeSuccess value) success,
    required TResult Function(PostComposeFailure value) failure,
  }) {
    return uploading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PostComposeEditing value)? editing,
    TResult? Function(PostComposeUploading value)? uploading,
    TResult? Function(PostComposePosting value)? posting,
    TResult? Function(PostComposeSuccess value)? success,
    TResult? Function(PostComposeFailure value)? failure,
  }) {
    return uploading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PostComposeEditing value)? editing,
    TResult Function(PostComposeUploading value)? uploading,
    TResult Function(PostComposePosting value)? posting,
    TResult Function(PostComposeSuccess value)? success,
    TResult Function(PostComposeFailure value)? failure,
    required TResult orElse(),
  }) {
    if (uploading != null) {
      return uploading(this);
    }
    return orElse();
  }
}

abstract class PostComposeUploading implements PostComposeState {
  const factory PostComposeUploading(
      {required final PostType postType,
      required final String content,
      required final List<PickedImage> images,
      required final int uploadedCount}) = _$PostComposeUploadingImpl;

  PostType get postType;
  String get content;
  List<PickedImage> get images;
  int get uploadedCount;

  /// Create a copy of PostComposeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostComposeUploadingImplCopyWith<_$PostComposeUploadingImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PostComposePostingImplCopyWith<$Res> {
  factory _$$PostComposePostingImplCopyWith(_$PostComposePostingImpl value,
          $Res Function(_$PostComposePostingImpl) then) =
      __$$PostComposePostingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({PostType postType, String content, List<PickedImage> images});
}

/// @nodoc
class __$$PostComposePostingImplCopyWithImpl<$Res>
    extends _$PostComposeStateCopyWithImpl<$Res, _$PostComposePostingImpl>
    implements _$$PostComposePostingImplCopyWith<$Res> {
  __$$PostComposePostingImplCopyWithImpl(_$PostComposePostingImpl _value,
      $Res Function(_$PostComposePostingImpl) _then)
      : super(_value, _then);

  /// Create a copy of PostComposeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? postType = null,
    Object? content = null,
    Object? images = null,
  }) {
    return _then(_$PostComposePostingImpl(
      postType: null == postType
          ? _value.postType
          : postType // ignore: cast_nullable_to_non_nullable
              as PostType,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<PickedImage>,
    ));
  }
}

/// @nodoc

class _$PostComposePostingImpl implements PostComposePosting {
  const _$PostComposePostingImpl(
      {required this.postType,
      required this.content,
      required final List<PickedImage> images})
      : _images = images;

  @override
  final PostType postType;
  @override
  final String content;
  final List<PickedImage> _images;
  @override
  List<PickedImage> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  String toString() {
    return 'PostComposeState.posting(postType: $postType, content: $content, images: $images)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostComposePostingImpl &&
            (identical(other.postType, postType) ||
                other.postType == postType) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality().equals(other._images, _images));
  }

  @override
  int get hashCode => Object.hash(runtimeType, postType, content,
      const DeepCollectionEquality().hash(_images));

  /// Create a copy of PostComposeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostComposePostingImplCopyWith<_$PostComposePostingImpl> get copyWith =>
      __$$PostComposePostingImplCopyWithImpl<_$PostComposePostingImpl>(
          this, _$identity);

  @override
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
    return posting(postType, content, images);
  }

  @override
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
    return posting?.call(postType, content, images);
  }

  @override
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
    if (posting != null) {
      return posting(postType, content, images);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PostComposeEditing value) editing,
    required TResult Function(PostComposeUploading value) uploading,
    required TResult Function(PostComposePosting value) posting,
    required TResult Function(PostComposeSuccess value) success,
    required TResult Function(PostComposeFailure value) failure,
  }) {
    return posting(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PostComposeEditing value)? editing,
    TResult? Function(PostComposeUploading value)? uploading,
    TResult? Function(PostComposePosting value)? posting,
    TResult? Function(PostComposeSuccess value)? success,
    TResult? Function(PostComposeFailure value)? failure,
  }) {
    return posting?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PostComposeEditing value)? editing,
    TResult Function(PostComposeUploading value)? uploading,
    TResult Function(PostComposePosting value)? posting,
    TResult Function(PostComposeSuccess value)? success,
    TResult Function(PostComposeFailure value)? failure,
    required TResult orElse(),
  }) {
    if (posting != null) {
      return posting(this);
    }
    return orElse();
  }
}

abstract class PostComposePosting implements PostComposeState {
  const factory PostComposePosting(
      {required final PostType postType,
      required final String content,
      required final List<PickedImage> images}) = _$PostComposePostingImpl;

  PostType get postType;
  String get content;
  List<PickedImage> get images;

  /// Create a copy of PostComposeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostComposePostingImplCopyWith<_$PostComposePostingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PostComposeSuccessImplCopyWith<$Res> {
  factory _$$PostComposeSuccessImplCopyWith(_$PostComposeSuccessImpl value,
          $Res Function(_$PostComposeSuccessImpl) then) =
      __$$PostComposeSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String postId});
}

/// @nodoc
class __$$PostComposeSuccessImplCopyWithImpl<$Res>
    extends _$PostComposeStateCopyWithImpl<$Res, _$PostComposeSuccessImpl>
    implements _$$PostComposeSuccessImplCopyWith<$Res> {
  __$$PostComposeSuccessImplCopyWithImpl(_$PostComposeSuccessImpl _value,
      $Res Function(_$PostComposeSuccessImpl) _then)
      : super(_value, _then);

  /// Create a copy of PostComposeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? postId = null,
  }) {
    return _then(_$PostComposeSuccessImpl(
      postId: null == postId
          ? _value.postId
          : postId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$PostComposeSuccessImpl implements PostComposeSuccess {
  const _$PostComposeSuccessImpl({required this.postId});

  @override
  final String postId;

  @override
  String toString() {
    return 'PostComposeState.success(postId: $postId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostComposeSuccessImpl &&
            (identical(other.postId, postId) || other.postId == postId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, postId);

  /// Create a copy of PostComposeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostComposeSuccessImplCopyWith<_$PostComposeSuccessImpl> get copyWith =>
      __$$PostComposeSuccessImplCopyWithImpl<_$PostComposeSuccessImpl>(
          this, _$identity);

  @override
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
    return success(postId);
  }

  @override
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
    return success?.call(postId);
  }

  @override
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
    if (success != null) {
      return success(postId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PostComposeEditing value) editing,
    required TResult Function(PostComposeUploading value) uploading,
    required TResult Function(PostComposePosting value) posting,
    required TResult Function(PostComposeSuccess value) success,
    required TResult Function(PostComposeFailure value) failure,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PostComposeEditing value)? editing,
    TResult? Function(PostComposeUploading value)? uploading,
    TResult? Function(PostComposePosting value)? posting,
    TResult? Function(PostComposeSuccess value)? success,
    TResult? Function(PostComposeFailure value)? failure,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PostComposeEditing value)? editing,
    TResult Function(PostComposeUploading value)? uploading,
    TResult Function(PostComposePosting value)? posting,
    TResult Function(PostComposeSuccess value)? success,
    TResult Function(PostComposeFailure value)? failure,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class PostComposeSuccess implements PostComposeState {
  const factory PostComposeSuccess({required final String postId}) =
      _$PostComposeSuccessImpl;

  String get postId;

  /// Create a copy of PostComposeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostComposeSuccessImplCopyWith<_$PostComposeSuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PostComposeFailureImplCopyWith<$Res> {
  factory _$$PostComposeFailureImplCopyWith(_$PostComposeFailureImpl value,
          $Res Function(_$PostComposeFailureImpl) then) =
      __$$PostComposeFailureImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {PostType postType,
      String content,
      List<PickedImage> images,
      String code,
      String message});
}

/// @nodoc
class __$$PostComposeFailureImplCopyWithImpl<$Res>
    extends _$PostComposeStateCopyWithImpl<$Res, _$PostComposeFailureImpl>
    implements _$$PostComposeFailureImplCopyWith<$Res> {
  __$$PostComposeFailureImplCopyWithImpl(_$PostComposeFailureImpl _value,
      $Res Function(_$PostComposeFailureImpl) _then)
      : super(_value, _then);

  /// Create a copy of PostComposeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? postType = null,
    Object? content = null,
    Object? images = null,
    Object? code = null,
    Object? message = null,
  }) {
    return _then(_$PostComposeFailureImpl(
      postType: null == postType
          ? _value.postType
          : postType // ignore: cast_nullable_to_non_nullable
              as PostType,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<PickedImage>,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$PostComposeFailureImpl implements PostComposeFailure {
  const _$PostComposeFailureImpl(
      {required this.postType,
      required this.content,
      required final List<PickedImage> images,
      required this.code,
      required this.message})
      : _images = images;

  @override
  final PostType postType;
  @override
  final String content;
  final List<PickedImage> _images;
  @override
  List<PickedImage> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  final String code;
  @override
  final String message;

  @override
  String toString() {
    return 'PostComposeState.failure(postType: $postType, content: $content, images: $images, code: $code, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostComposeFailureImpl &&
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

  /// Create a copy of PostComposeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PostComposeFailureImplCopyWith<_$PostComposeFailureImpl> get copyWith =>
      __$$PostComposeFailureImplCopyWithImpl<_$PostComposeFailureImpl>(
          this, _$identity);

  @override
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
    return failure(postType, content, images, code, message);
  }

  @override
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
    return failure?.call(postType, content, images, code, message);
  }

  @override
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
    if (failure != null) {
      return failure(postType, content, images, code, message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PostComposeEditing value) editing,
    required TResult Function(PostComposeUploading value) uploading,
    required TResult Function(PostComposePosting value) posting,
    required TResult Function(PostComposeSuccess value) success,
    required TResult Function(PostComposeFailure value) failure,
  }) {
    return failure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PostComposeEditing value)? editing,
    TResult? Function(PostComposeUploading value)? uploading,
    TResult? Function(PostComposePosting value)? posting,
    TResult? Function(PostComposeSuccess value)? success,
    TResult? Function(PostComposeFailure value)? failure,
  }) {
    return failure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PostComposeEditing value)? editing,
    TResult Function(PostComposeUploading value)? uploading,
    TResult Function(PostComposePosting value)? posting,
    TResult Function(PostComposeSuccess value)? success,
    TResult Function(PostComposeFailure value)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(this);
    }
    return orElse();
  }
}

abstract class PostComposeFailure implements PostComposeState {
  const factory PostComposeFailure(
      {required final PostType postType,
      required final String content,
      required final List<PickedImage> images,
      required final String code,
      required final String message}) = _$PostComposeFailureImpl;

  PostType get postType;
  String get content;
  List<PickedImage> get images;
  String get code;
  String get message;

  /// Create a copy of PostComposeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PostComposeFailureImplCopyWith<_$PostComposeFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
