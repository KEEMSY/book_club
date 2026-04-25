import 'package:book_club/features/feed/application/post_compose_notifier.dart';
import 'package:book_club/features/feed/application/post_compose_state.dart';
import 'package:book_club/features/feed/data/feed_repository.dart';
import 'package:book_club/features/feed/data/image_uploader.dart';
import 'package:book_club/features/feed/domain/post_type.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes.dart';

void main() {
  group('PostComposeNotifier', () {
    test('submit happy path: editing -> uploading -> posting -> success',
        () async {
      final repo = FakeFeedRepository()
        ..uploadKeyQueue.addAll(<String>['k1', 'k2'])
        ..createPostResult = buildPost(id: 'created');

      final notifier = PostComposeNotifier(repo, 'book-1');
      notifier.changeContent('정말 좋았어요');
      notifier.addImage(buildPickedImage());
      notifier.addImage(buildPickedImage(contentType: 'image/png'));
      expect(notifier.state, isA<PostComposeEditing>());

      final created = await notifier.submit();
      expect(created, isNotNull);
      expect(notifier.state, isA<PostComposeSuccess>());
      expect(repo.uploadCalls, hasLength(2));
      expect(repo.createPostCalls.single.imageKeys, <String>['k1', 'k2']);
      expect(repo.createPostCalls.single.content, '정말 좋았어요');
    });

    test('submit fails on empty content', () async {
      final repo = FakeFeedRepository();
      final notifier = PostComposeNotifier(repo, 'book-1');
      notifier.changeContent('   ');

      final result = await notifier.submit();
      expect(result, isNull);
      expect(notifier.state, isA<PostComposeFailure>());
      expect(
        (notifier.state as PostComposeFailure).code,
        'POST_CONTENT_REQUIRED',
      );
      expect(repo.createPostCalls, isEmpty);
    });

    test('submit upload failure preserves typed content + images', () async {
      final repo = FakeFeedRepository()
        ..uploadErrors.add(
          const ImageUploadException(
            code: 'UPLOAD_FAILED',
            message: '이미지를 업로드하지 못했어요. 다시 시도해주세요.',
          ),
        );

      final notifier = PostComposeNotifier(repo, 'book-1');
      notifier.changeContent('내용');
      notifier.addImage(buildPickedImage());

      final result = await notifier.submit();
      expect(result, isNull);
      expect(notifier.state, isA<PostComposeFailure>());
      final failure = notifier.state as PostComposeFailure;
      expect(failure.code, 'UPLOAD_FAILED');
      expect(failure.content, '내용');
      expect(failure.images, hasLength(1));
      expect(repo.createPostCalls, isEmpty);
    });

    test('submit createPost failure preserves typed content', () async {
      final repo = FakeFeedRepository()
        ..createPostError = const FeedRepositoryException(
          code: 'POST_CONTENT_REQUIRED',
          message: '내용을 입력해주세요.',
        );

      final notifier = PostComposeNotifier(repo, 'book-1');
      notifier.changeContent('내용');
      final result = await notifier.submit();
      expect(result, isNull);
      expect(notifier.state, isA<PostComposeFailure>());
    });

    test('addImage caps at 4 attachments', () async {
      final repo = FakeFeedRepository();
      final notifier = PostComposeNotifier(repo, 'book-1');
      for (int i = 0; i < 4; i++) {
        expect(notifier.addImage(buildPickedImage()), isTrue);
      }
      expect(notifier.addImage(buildPickedImage()), isFalse);
      final editing = notifier.state as PostComposeEditing;
      expect(editing.images, hasLength(4));
    });

    test('changeType updates the post type', () async {
      final repo = FakeFeedRepository();
      final notifier = PostComposeNotifier(repo, 'book-1');
      notifier.changeType(PostType.discussion);
      final editing = notifier.state as PostComposeEditing;
      expect(editing.postType, PostType.discussion);
    });

    test('removeImage drops the targeted attachment', () async {
      final repo = FakeFeedRepository();
      final notifier = PostComposeNotifier(repo, 'book-1');
      notifier.addImage(buildPickedImage(contentType: 'image/jpeg'));
      notifier.addImage(buildPickedImage(contentType: 'image/png'));
      notifier.removeImage(0);
      final editing = notifier.state as PostComposeEditing;
      expect(editing.images, hasLength(1));
      expect(editing.images.single.contentType, 'image/png');
    });
  });
}
