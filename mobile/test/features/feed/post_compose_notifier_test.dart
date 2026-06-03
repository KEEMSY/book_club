import 'package:book_club/features/feed/application/feed_providers.dart';
import 'package:book_club/features/feed/application/post_compose_notifier.dart';
import 'package:book_club/features/feed/application/post_compose_state.dart';
import 'package:book_club/features/feed/data/feed_repository.dart';
import 'package:book_club/features/feed/data/image_uploader.dart';
import 'package:book_club/features/feed/domain/post_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes.dart';

void main() {
  group('PostComposeNotifier', () {
    test('submit happy path: editing -> uploading -> posting -> success',
        () async {
      final repo = FakeFeedRepository()
        ..uploadKeyQueue.addAll(<String>['k1', 'k2'])
        ..createPostResult = buildPost(id: 'created');

      final c = ProviderContainer(overrides: [
        feedRepositoryProvider.overrideWithValue(repo),
      ]);
      addTearDown(c.dispose);
      final notifier = c.read(postComposeNotifierProvider('book-1').notifier);
      notifier.changeContent('정말 좋았어요');
      notifier.addImage(buildPickedImage());
      notifier.addImage(buildPickedImage(contentType: 'image/png'));
      expect(c.read(postComposeNotifierProvider('book-1')), isA<PostComposeEditing>());

      final created = await notifier.submit();
      expect(created, isNotNull);
      expect(c.read(postComposeNotifierProvider('book-1')), isA<PostComposeSuccess>());
      expect(repo.uploadCalls, hasLength(2));
      expect(repo.createPostCalls.single.imageKeys, <String>['k1', 'k2']);
      expect(repo.createPostCalls.single.content, '정말 좋았어요');
    });

    test('submit fails on empty content', () async {
      final repo = FakeFeedRepository();
      final c = ProviderContainer(overrides: [
        feedRepositoryProvider.overrideWithValue(repo),
      ]);
      addTearDown(c.dispose);
      final notifier = c.read(postComposeNotifierProvider('book-1').notifier);
      notifier.changeContent('   ');

      final result = await notifier.submit();
      expect(result, isNull);
      expect(c.read(postComposeNotifierProvider('book-1')), isA<PostComposeFailure>());
      expect(
        (c.read(postComposeNotifierProvider('book-1')) as PostComposeFailure).code,
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

      final c = ProviderContainer(overrides: [
        feedRepositoryProvider.overrideWithValue(repo),
      ]);
      addTearDown(c.dispose);
      final notifier = c.read(postComposeNotifierProvider('book-1').notifier);
      notifier.changeContent('내용');
      notifier.addImage(buildPickedImage());

      final result = await notifier.submit();
      expect(result, isNull);
      expect(c.read(postComposeNotifierProvider('book-1')), isA<PostComposeFailure>());
      final failure = c.read(postComposeNotifierProvider('book-1')) as PostComposeFailure;
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

      final c = ProviderContainer(overrides: [
        feedRepositoryProvider.overrideWithValue(repo),
      ]);
      addTearDown(c.dispose);
      final notifier = c.read(postComposeNotifierProvider('book-1').notifier);
      notifier.changeContent('내용');
      final result = await notifier.submit();
      expect(result, isNull);
      expect(c.read(postComposeNotifierProvider('book-1')), isA<PostComposeFailure>());
    });

    test('addImage caps at 4 attachments', () async {
      final repo = FakeFeedRepository();
      final c = ProviderContainer(overrides: [
        feedRepositoryProvider.overrideWithValue(repo),
      ]);
      addTearDown(c.dispose);
      final notifier = c.read(postComposeNotifierProvider('book-1').notifier);
      for (int i = 0; i < 4; i++) {
        expect(notifier.addImage(buildPickedImage()), isTrue);
      }
      expect(notifier.addImage(buildPickedImage()), isFalse);
      final editing = c.read(postComposeNotifierProvider('book-1')) as PostComposeEditing;
      expect(editing.images, hasLength(4));
    });

    test('changeType updates the post type', () async {
      final repo = FakeFeedRepository();
      final c = ProviderContainer(overrides: [
        feedRepositoryProvider.overrideWithValue(repo),
      ]);
      addTearDown(c.dispose);
      final notifier = c.read(postComposeNotifierProvider('book-1').notifier);
      notifier.changeType(PostType.discussion);
      final editing = c.read(postComposeNotifierProvider('book-1')) as PostComposeEditing;
      expect(editing.postType, PostType.discussion);
    });

    test('removeImage drops the targeted attachment', () async {
      final repo = FakeFeedRepository();
      final c = ProviderContainer(overrides: [
        feedRepositoryProvider.overrideWithValue(repo),
      ]);
      addTearDown(c.dispose);
      final notifier = c.read(postComposeNotifierProvider('book-1').notifier);
      notifier.addImage(buildPickedImage(contentType: 'image/jpeg'));
      notifier.addImage(buildPickedImage(contentType: 'image/png'));
      notifier.removeImage(0);
      final editing = c.read(postComposeNotifierProvider('book-1')) as PostComposeEditing;
      expect(editing.images, hasLength(1));
      expect(editing.images.single.contentType, 'image/png');
    });
  });
}
