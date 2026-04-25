import 'package:book_club/features/feed/application/comment_thread_notifier.dart';
import 'package:book_club/features/feed/application/comment_thread_state.dart';
import 'package:book_club/features/feed/data/feed_repository.dart';
import 'package:book_club/features/feed/domain/comment.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes.dart';

void main() {
  group('CommentThreadNotifier', () {
    test('load empty thread surfaces empty Loaded state', () async {
      final repo = FakeFeedRepository();
      final notifier = CommentThreadNotifier(repo, 'post-1');
      await notifier.load();
      expect(notifier.state, isA<CommentThreadLoaded>());
      expect((notifier.state as CommentThreadLoaded).items, isEmpty);
    });

    test('postComment appends to the items list', () async {
      final repo = FakeFeedRepository()
        ..commentPagesQueue.add(
          CommentPage(
            items: <Comment>[buildComment(id: 'c1')],
            nextCursor: null,
          ),
        )
        ..createCommentResult = buildComment(id: 'c2');
      final notifier = CommentThreadNotifier(repo, 'post-1');
      await notifier.load();
      expect((notifier.state as CommentThreadLoaded).items, hasLength(1));

      final created = await notifier.postComment(content: '재밌어요');
      expect(created, isNotNull);
      final loaded = notifier.state as CommentThreadLoaded;
      expect(loaded.items, hasLength(2));
      expect(loaded.items.last.id, 'c2');
      expect(loaded.postError, isNull);
    });

    test('postComment surfaces depth-exceeded as inline error', () async {
      final repo = FakeFeedRepository()
        ..commentPagesQueue.add(const CommentPage(items: <Comment>[]))
        ..createCommentError = const FeedRepositoryException(
          code: 'COMMENT_DEPTH_EXCEEDED',
          message: '답글의 답글은 작성할 수 없어요',
          statusCode: 409,
        );
      final notifier = CommentThreadNotifier(repo, 'post-1');
      await notifier.load();

      final result = await notifier.postComment(
        content: '답글의 답글',
        parentId: 'c1',
      );
      expect(result, isNull);
      final loaded = notifier.state as CommentThreadLoaded;
      expect(loaded.postError, '답글은 한 번까지만 달 수 있어요.');
    });

    test('deleteComment removes the comment + replies under it', () async {
      final repo = FakeFeedRepository()
        ..commentPagesQueue.add(
          CommentPage(
            items: <Comment>[
              buildComment(id: 'root-1'),
              buildComment(id: 'reply-1', parentId: 'root-1'),
              buildComment(id: 'root-2'),
            ],
            nextCursor: null,
          ),
        );
      final notifier = CommentThreadNotifier(repo, 'post-1');
      await notifier.load();

      final ok = await notifier.deleteComment('root-1');
      expect(ok, isTrue);
      final loaded = notifier.state as CommentThreadLoaded;
      expect(loaded.items.map((c) => c.id), <String>['root-2']);
    });

    test('clearPostError resets the inline error surface', () async {
      final repo = FakeFeedRepository()
        ..commentPagesQueue.add(const CommentPage(items: <Comment>[]))
        ..createCommentError = const FeedRepositoryException(
          code: 'NETWORK_ERROR',
          message: '네트워크 오류',
        );
      final notifier = CommentThreadNotifier(repo, 'post-1');
      await notifier.load();
      await notifier.postComment(content: 'hi');
      expect((notifier.state as CommentThreadLoaded).postError, isNotNull);

      notifier.clearPostError();
      expect((notifier.state as CommentThreadLoaded).postError, isNull);
    });

    test('loadMore appends and stops at null cursor', () async {
      final repo = FakeFeedRepository()
        ..commentPagesQueue.addAll(<CommentPage>[
          CommentPage(
            items: <Comment>[buildComment(id: 'c1')],
            nextCursor: '2026-04-25T12:00:00Z',
          ),
          CommentPage(
            items: <Comment>[buildComment(id: 'c2')],
            nextCursor: null,
          ),
        ]);
      final notifier = CommentThreadNotifier(repo, 'post-1');
      await notifier.load();
      await notifier.loadMore();
      final loaded = notifier.state as CommentThreadLoaded;
      expect(loaded.items.map((c) => c.id), <String>['c1', 'c2']);
      expect(loaded.nextCursor, isNull);
    });
  });
}
