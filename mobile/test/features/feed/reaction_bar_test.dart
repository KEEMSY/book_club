import 'package:book_club/core/theme/app_theme.dart';
import 'package:book_club/features/feed/application/book_feed_notifier.dart';
import 'package:book_club/features/feed/application/feed_providers.dart';
import 'package:book_club/features/feed/data/feed_repository.dart';
import 'package:book_club/features/feed/domain/post.dart';
import 'package:book_club/features/feed/domain/reaction_type.dart';
import 'package:book_club/features/feed/presentation/widgets/reaction_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'fakes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  testWidgets('toggling a reaction reflects updated counts inline',
      (tester) async {
    final repo = FakeFeedRepository()
      ..toggleReactionResult = const ReactionToggleResult(
        state: ReactionToggleState.added,
        counts: <ReactionType, int>{ReactionType.idea: 1},
      );
    final post = buildPost(
      id: 'p1',
      reactions: <ReactionType, int>{ReactionType.idea: 0},
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          feedRepositoryProvider.overrideWithValue(repo),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: Consumer(
            builder: (context, ref, _) {
              // Pre-seed the bookFeed notifier with this post so applyReactionResult
              // updates the cached card.
              ref.read(bookFeedNotifierProvider(post.bookId).notifier);
              return Scaffold(
                body: ReactionBar(bookId: post.bookId, post: post),
              );
            },
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.lightbulb_outline_rounded), findsOneWidget);
    expect(find.text('0'), findsWidgets);

    await tester.tap(find.byIcon(Icons.lightbulb_outline_rounded));
    await tester.pumpAndSettle();
    expect(repo.toggleCalls, hasLength(1));
  });

  testWidgets('typed failure surfaces a snackbar without crashing',
      (tester) async {
    final repo = FakeFeedRepository()
      ..toggleReactionError = const FeedRepositoryException(
        code: 'NETWORK_ERROR',
        message: '네트워크 오류가 발생했어요.',
      );
    final post = buildPost(id: 'p1');

    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          feedRepositoryProvider.overrideWithValue(repo),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(body: ReactionBar(bookId: post.bookId, post: post)),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.local_fire_department_outlined));
    await tester.pumpAndSettle();
    expect(find.text('네트워크 오류가 발생했어요.'), findsOneWidget);
  });
}
