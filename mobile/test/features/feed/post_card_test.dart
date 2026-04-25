import 'package:book_club/core/theme/app_theme.dart';
import 'package:book_club/features/feed/application/feed_providers.dart';
import 'package:book_club/features/feed/domain/post.dart';
import 'package:book_club/features/feed/domain/post_type.dart';
import 'package:book_club/features/feed/domain/reaction_type.dart';
import 'package:book_club/features/feed/presentation/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'fakes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  Widget host(Post post) {
    return ProviderScope(
      overrides: <Override>[
        feedRepositoryProvider.overrideWithValue(FakeFeedRepository()),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: PostCard(
                bookId: post.bookId,
                post: post,
                onTapComments: () {},
              ),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('renders nickname, content, type pill, and comment count',
      (tester) async {
    final post = buildPost(
      content: '내용 본문',
      author: buildAuthor(nickname: '리코'),
      type: PostType.discussion,
      reactions: <ReactionType, int>{ReactionType.idea: 2},
      commentCount: 3,
    );
    await tester.pumpWidget(host(post));

    expect(find.text('리코'), findsOneWidget);
    expect(find.text('내용 본문'), findsOneWidget);
    expect(find.text('토론'), findsOneWidget);
    expect(find.text('댓글 3'), findsOneWidget);
    expect(find.text('2'), findsOneWidget); // idea reaction count
  });

  testWidgets('comment-count tap fires onTapComments', (tester) async {
    bool tapped = false;
    final post = buildPost(commentCount: 1);
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          feedRepositoryProvider.overrideWithValue(FakeFeedRepository()),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: PostCard(
              bookId: post.bookId,
              post: post,
              onTapComments: () => tapped = true,
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('댓글 1'));
    await tester.pump();
    expect(tapped, isTrue);
  });
}
