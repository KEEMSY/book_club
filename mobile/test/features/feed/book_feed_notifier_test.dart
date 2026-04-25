import 'package:book_club/features/feed/application/book_feed_notifier.dart';
import 'package:book_club/features/feed/application/book_feed_state.dart';
import 'package:book_club/features/feed/data/feed_repository.dart';
import 'package:book_club/features/feed/domain/post.dart';
import 'package:book_club/features/feed/domain/reaction_type.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes.dart';

void main() {
  group('BookFeedNotifier', () {
    test('load() transitions through loading -> loaded', () async {
      final repo = FakeFeedRepository()
        ..postPagesQueue.add(
          PostPage(items: <Post>[buildPost(id: 'p1')], nextCursor: null),
        );
      final notifier = BookFeedNotifier(repo, 'book-1');

      expect(notifier.state, isA<BookFeedInitial>());
      final future = notifier.load();
      expect(notifier.state, isA<BookFeedLoading>());
      await future;
      expect(notifier.state, isA<BookFeedLoaded>());
      final loaded = notifier.state as BookFeedLoaded;
      expect(loaded.items, hasLength(1));
      expect(loaded.nextCursor, isNull);
    });

    test('loadMore appends with the previous cursor and stops at null',
        () async {
      final repo = FakeFeedRepository()
        ..postPagesQueue.addAll(<PostPage>[
          PostPage(
            items: <Post>[buildPost(id: 'p1')],
            nextCursor: '2026-04-24T12:00:00Z',
          ),
          PostPage(
            items: <Post>[buildPost(id: 'p2')],
            nextCursor: null,
          ),
        ]);
      final notifier = BookFeedNotifier(repo, 'book-1');
      await notifier.load();
      expect((notifier.state as BookFeedLoaded).items, hasLength(1));
      await notifier.loadMore();
      final loaded = notifier.state as BookFeedLoaded;
      expect(loaded.items.map((p) => p.id), <String>['p1', 'p2']);
      expect(loaded.nextCursor, isNull);

      // Calling loadMore again is a no-op.
      final callsBefore = repo.listPostsCalls.length;
      await notifier.loadMore();
      expect(repo.listPostsCalls.length, callsBefore);
    });

    test('load failure transitions to error', () async {
      final repo = FakeFeedRepository()
        ..postPagesErrors.add(
          const FeedRepositoryException(
            code: 'UPSTREAM_UNAVAILABLE',
            message: '잠시 후 다시 시도해주세요.',
          ),
        );
      final notifier = BookFeedNotifier(repo, 'book-1');
      await notifier.load();
      expect(notifier.state, isA<BookFeedError>());
      expect((notifier.state as BookFeedError).code, 'UPSTREAM_UNAVAILABLE');
    });

    test('prependPost inserts at the top of the loaded list', () async {
      final repo = FakeFeedRepository()
        ..postPagesQueue.add(
          PostPage(items: <Post>[buildPost(id: 'old')], nextCursor: null),
        );
      final notifier = BookFeedNotifier(repo, 'book-1');
      await notifier.load();

      notifier.prependPost(buildPost(id: 'new'));
      final loaded = notifier.state as BookFeedLoaded;
      expect(loaded.items.first.id, 'new');
      expect(loaded.items.last.id, 'old');
    });

    test('applyReactionResult merges counts and toggles myReactions', () async {
      final repo = FakeFeedRepository()
        ..postPagesQueue.add(
          PostPage(
            items: <Post>[
              buildPost(
                id: 'p1',
                reactions: <ReactionType, int>{ReactionType.idea: 0},
                myReactions: <ReactionType>{},
              ),
            ],
            nextCursor: null,
          ),
        );
      final notifier = BookFeedNotifier(repo, 'book-1');
      await notifier.load();

      notifier.applyReactionResult(
        postId: 'p1',
        reactionType: ReactionType.idea,
        toggleState: ReactionToggleState.added,
        counts: <ReactionType, int>{ReactionType.idea: 1},
      );

      final loaded = notifier.state as BookFeedLoaded;
      expect(loaded.items.single.myReactions, contains(ReactionType.idea));
      expect(loaded.items.single.reactions[ReactionType.idea], 1);

      notifier.applyReactionResult(
        postId: 'p1',
        reactionType: ReactionType.idea,
        toggleState: ReactionToggleState.removed,
        counts: <ReactionType, int>{ReactionType.idea: 0},
      );
      final after = notifier.state as BookFeedLoaded;
      expect(after.items.single.myReactions, isEmpty);
    });

    test('incrementCommentCount adjusts the targeted post only', () async {
      final repo = FakeFeedRepository()
        ..postPagesQueue.add(
          PostPage(
            items: <Post>[
              buildPost(id: 'p1', commentCount: 0),
              buildPost(id: 'p2', commentCount: 5),
            ],
            nextCursor: null,
          ),
        );
      final notifier = BookFeedNotifier(repo, 'book-1');
      await notifier.load();
      notifier.incrementCommentCount('p1');
      final loaded = notifier.state as BookFeedLoaded;
      expect(loaded.items[0].commentCount, 1);
      expect(loaded.items[1].commentCount, 5);

      notifier.incrementCommentCount('p2', -2);
      final next = notifier.state as BookFeedLoaded;
      expect(next.items[1].commentCount, 3);
    });
  });
}
