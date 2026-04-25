import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/feed_repository.dart';
import '../data/image_uploader.dart';
import '../domain/post.dart';
import '../domain/post_type.dart';
import 'feed_providers.dart';
import 'post_compose_state.dart';

/// Drives the compose screen state machine.
///
/// Editing → Uploading(N images) → Posting → Success | Failure(retry)
///
/// On failure, content / type / picked-images are preserved so the user can
/// re-tap "공유" without losing what they typed. Maximum image attachments
/// is 4 — backend rejects anything more with `IMAGE_LIMIT_EXCEEDED`, but we
/// also cap on the client to avoid wasting the failing presign step.
class PostComposeNotifier extends StateNotifier<PostComposeState> {
  PostComposeNotifier(this._repository, this.bookId)
      : super(const PostComposeState.editing());

  final FeedRepository _repository;
  final String bookId;

  static const int maxImages = 4;
  static const int maxContentLength = 2000;

  void changeType(PostType type) {
    final PostComposeState snapshot = state;
    if (snapshot is PostComposeEditing) {
      state = snapshot.copyWith(postType: type);
    } else if (snapshot is PostComposeFailure) {
      state = snapshot.copyWith(postType: type);
    }
  }

  void changeContent(String content) {
    final PostComposeState snapshot = state;
    if (snapshot is PostComposeEditing) {
      state = snapshot.copyWith(content: content);
    } else if (snapshot is PostComposeFailure) {
      state = snapshot.copyWith(content: content);
    }
  }

  bool addImage(PickedImage image) {
    final PostComposeState snapshot = state;
    if (snapshot is PostComposeEditing) {
      if (snapshot.images.length >= maxImages) return false;
      state = snapshot.copyWith(
        images: <PickedImage>[...snapshot.images, image],
      );
      return true;
    }
    if (snapshot is PostComposeFailure) {
      if (snapshot.images.length >= maxImages) return false;
      state = snapshot.copyWith(
        images: <PickedImage>[...snapshot.images, image],
      );
      return true;
    }
    return false;
  }

  void removeImage(int index) {
    final PostComposeState snapshot = state;
    if (snapshot is PostComposeEditing) {
      if (index < 0 || index >= snapshot.images.length) return;
      final List<PickedImage> next = <PickedImage>[...snapshot.images]
        ..removeAt(index);
      state = snapshot.copyWith(images: next);
    } else if (snapshot is PostComposeFailure) {
      if (index < 0 || index >= snapshot.images.length) return;
      final List<PickedImage> next = <PickedImage>[...snapshot.images]
        ..removeAt(index);
      state = snapshot.copyWith(images: next);
    }
  }

  /// Submits the composed post. Drives the state machine through Uploading
  /// (one tick per image) → Posting → Success / Failure. Returns the
  /// server-canonical [Post] on success so the caller can prepend it into
  /// the feed list cache without a refetch.
  Future<Post?> submit() async {
    final PostComposeState snapshot = state;
    final PostType postType;
    final String content;
    final List<PickedImage> images;
    if (snapshot is PostComposeEditing) {
      postType = snapshot.postType;
      content = snapshot.content;
      images = snapshot.images;
    } else if (snapshot is PostComposeFailure) {
      postType = snapshot.postType;
      content = snapshot.content;
      images = snapshot.images;
    } else {
      return null;
    }

    final String trimmed = content.trim();
    if (trimmed.isEmpty) {
      state = PostComposeState.failure(
        postType: postType,
        content: content,
        images: images,
        code: 'POST_CONTENT_REQUIRED',
        message: '내용을 입력해주세요.',
      );
      return null;
    }
    if (trimmed.length > maxContentLength) {
      state = PostComposeState.failure(
        postType: postType,
        content: content,
        images: images,
        code: 'POST_CONTENT_TOO_LONG',
        message: '내용은 최대 2,000자까지 작성할 수 있어요.',
      );
      return null;
    }

    final List<String> uploadedKeys = <String>[];
    for (int i = 0; i < images.length; i++) {
      state = PostComposeState.uploading(
        postType: postType,
        content: content,
        images: images,
        uploadedCount: i,
      );
      try {
        final String key = await _repository.uploadImage(images[i]);
        uploadedKeys.add(key);
      } on ImageUploadException catch (e) {
        state = PostComposeState.failure(
          postType: postType,
          content: content,
          images: images,
          code: e.code,
          message: e.message,
        );
        return null;
      }
    }

    state = PostComposePosting(
      postType: postType,
      content: content,
      images: images,
    );
    try {
      final Post created = await _repository.createPost(
        bookId: bookId,
        postType: postType,
        content: trimmed,
        imageKeys: uploadedKeys,
      );
      state = PostComposeState.success(postId: created.id);
      return created;
    } on FeedRepositoryException catch (e) {
      state = PostComposeState.failure(
        postType: postType,
        content: content,
        images: images,
        code: e.code,
        message: e.message,
      );
      return null;
    }
  }
}

/// Family keyed by bookId so multiple book detail screens cannot stomp on
/// each other's compose state.
final postComposeNotifierProvider = StateNotifierProvider.autoDispose
    .family<PostComposeNotifier, PostComposeState, String>((ref, bookId) {
  return PostComposeNotifier(ref.watch(feedRepositoryProvider), bookId);
});
