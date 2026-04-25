import 'package:book_club/core/theme/app_theme.dart';
import 'package:book_club/features/feed/application/book_feed_notifier.dart';
import 'package:book_club/features/feed/application/book_feed_state.dart';
import 'package:book_club/features/feed/application/feed_providers.dart';
import 'package:book_club/features/feed/domain/post.dart';
import 'package:book_club/features/feed/presentation/book_feed_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'fakes.dart';

/// Integration-light test for the BookFeedSection mounted under a host widget
/// approximating BookDetailScreen. Asserts:
///   * initial load triggers `listPosts` and renders cards
///   * "글쓰기" CTA exists and routes elsewhere via go_router (link presence)
///   * `prependPost` after a successful compose puts the new post on top
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  testWidgets('feed loads on mount and renders post cards', (tester) async {
    final repo = FakeFeedRepository()
      ..postPagesQueue.add(
        PostPage(
          items: <Post>[
            buildPost(id: 'p1', content: '첫 번째 글'),
            buildPost(id: 'p2', content: '두 번째 글'),
          ],
          nextCursor: null,
        ),
      );

    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          feedRepositoryProvider.overrideWithValue(repo),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(
            body: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: BookFeedSection(bookId: 'book-1'),
            ),
          ),
        ),
      ),
    );
    // Initial mount + post-frame load callback.
    await tester.pumpAndSettle();

    expect(find.text('책 그룹 피드'), findsOneWidget);
    expect(find.text('첫 번째 글'), findsOneWidget);
    expect(find.text('두 번째 글'), findsOneWidget);
    expect(find.widgetWithText(OutlinedButton, '글쓰기'), findsOneWidget);
    expect(repo.listPostsCalls, hasLength(1));
  });

  testWidgets('prependPost surfaces the new post at the top of the cache',
      (tester) async {
    final repo = FakeFeedRepository()
      ..postPagesQueue.add(
        PostPage(
          items: <Post>[buildPost(id: 'old', content: '이전 글')],
          nextCursor: null,
        ),
      );

    final container = ProviderContainer(
      overrides: <Override>[
        feedRepositoryProvider.overrideWithValue(repo),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(
            body: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: BookFeedSection(bookId: 'book-1'),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    container.read(bookFeedNotifierProvider('book-1').notifier).prependPost(
          buildPost(id: 'new', content: '방금 올린 글'),
        );
    await tester.pumpAndSettle();

    final state = container.read(bookFeedNotifierProvider('book-1'));
    expect(state, isA<BookFeedLoaded>());
    final loaded = state as BookFeedLoaded;
    expect(loaded.items.first.id, 'new');
    expect(find.text('방금 올린 글'), findsOneWidget);
    expect(find.text('이전 글'), findsOneWidget);
  });

  testWidgets('empty state shows the "first post" prompt', (tester) async {
    final repo = FakeFeedRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          feedRepositoryProvider.overrideWithValue(repo),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(
            body: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: BookFeedSection(bookId: 'book-1'),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('아직 첫 번째 글이 없어요. 가장 먼저 남겨보세요.'), findsOneWidget);
  });
}
