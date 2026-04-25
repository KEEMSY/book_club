import 'package:book_club/core/theme/app_theme.dart';
import 'package:book_club/features/feed/application/feed_providers.dart';
import 'package:book_club/features/feed/data/feed_repository.dart';
import 'package:book_club/features/feed/domain/comment.dart';
import 'package:book_club/features/feed/presentation/comments_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'fakes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  Widget host({required FakeFeedRepository repo}) {
    return ProviderScope(
      overrides: <Override>[
        feedRepositoryProvider.overrideWithValue(repo),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: Builder(
            builder: (ctx) => Center(
              child: ElevatedButton(
                onPressed: () => CommentsSheet.show(
                  ctx,
                  bookId: 'book-1',
                  postId: 'post-1',
                  initialCommentCount: 0,
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('renders root + reply with indent', (tester) async {
    final repo = FakeFeedRepository()
      ..commentPagesQueue.add(
        CommentPage(
          items: <Comment>[
            buildComment(
              id: 'root-1',
              author: buildAuthor(nickname: '리코'),
              content: '루트 댓글',
            ),
            buildComment(
              id: 'reply-1',
              parentId: 'root-1',
              author: buildAuthor(nickname: '소소'),
              content: '답글이에요',
            ),
          ],
        ),
      );

    await tester.pumpWidget(host(repo: repo));
    await tester.pumpAndSettle();
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('루트 댓글'), findsOneWidget);
    expect(find.text('답글이에요'), findsOneWidget);
    // The reply tile renders inside an indented container.
    expect(find.text('소소'), findsOneWidget);
  });

  testWidgets('depth-exceeded surfaces inline error', (tester) async {
    final repo = FakeFeedRepository()
      ..commentPagesQueue.add(
        CommentPage(
          items: <Comment>[
            buildComment(
              id: 'root-1',
              author: buildAuthor(nickname: '리코'),
              content: '루트 댓글',
            ),
          ],
        ),
      )
      ..createCommentError = const FeedRepositoryException(
        code: 'COMMENT_DEPTH_EXCEEDED',
        message: '답글의 답글은 작성할 수 없어요',
        statusCode: 409,
      );

    await tester.pumpWidget(host(repo: repo));
    await tester.pumpAndSettle();
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '시도');
    await tester.pump();
    await tester.tap(find.text('등록'));
    await tester.pumpAndSettle();

    expect(find.text('답글은 한 번까지만 달 수 있어요.'), findsOneWidget);
  });
}
