import 'package:freezed_annotation/freezed_annotation.dart';

import '../data/image_uploader.dart';
import '../domain/post_type.dart';

part 'post_compose_state.freezed.dart';

/// Sealed state for the post composer screen.
///
/// Transitions:
///   - [editing]   — user is typing; not yet submitted.
///   - [uploading] — image PUTs in progress (`uploadedCount / totalCount`).
///   - [posting]   — POST /books/{id}/posts in flight.
///   - [success]   — server returned 201; screen can pop.
///   - [failure]   — recoverable failure; user can retry without losing
///                   typed content / picked images.
@freezed
sealed class PostComposeState with _$PostComposeState {
  const factory PostComposeState.editing({
    @Default(PostType.thought) PostType postType,
    @Default('') String content,
    @Default(<PickedImage>[]) List<PickedImage> images,
  }) = PostComposeEditing;

  const factory PostComposeState.uploading({
    required PostType postType,
    required String content,
    required List<PickedImage> images,
    required int uploadedCount,
  }) = PostComposeUploading;

  const factory PostComposeState.posting({
    required PostType postType,
    required String content,
    required List<PickedImage> images,
  }) = PostComposePosting;

  const factory PostComposeState.success({
    required String postId,
  }) = PostComposeSuccess;

  const factory PostComposeState.failure({
    required PostType postType,
    required String content,
    required List<PickedImage> images,
    required String code,
    required String message,
  }) = PostComposeFailure;
}
