import 'package:book_club/core/theme/app_theme.dart';
import 'package:book_club/features/book/application/book_providers.dart';
import 'package:book_club/features/book/domain/user_book.dart';
import 'package:book_club/features/book/presentation/widgets/review_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'fakes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  Widget buildApp({
    required FakeBookRepository repo,
    required UserBook userBook,
  }) {
    return ProviderScope(
      overrides: <Override>[
        bookRepositoryProvider.overrideWithValue(repo),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: Builder(
            builder: (ctx) => Center(
              child: TextButton(
                onPressed: () => ReviewModal.show(ctx, userBook: userBook),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('tapping save without a rating surfaces validation message',
      (tester) async {
    final repo = FakeBookRepository();
    await tester.pumpWidget(buildApp(repo: repo, userBook: buildUserBook()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('저장'));
    await tester.pumpAndSettle();

    expect(find.text('별점을 먼저 매겨주세요'), findsOneWidget);
    expect(repo.submitReviewCalls, isEmpty);
  });

  testWidgets('review counter updates as user types', (tester) async {
    final repo = FakeBookRepository();
    await tester.pumpWidget(buildApp(repo: repo, userBook: buildUserBook()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('0/200'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '재밌었어요');
    await tester.pumpAndSettle();

    expect(find.text('5/200'), findsOneWidget);
  });

  testWidgets('modal can open with a prefilled review', (tester) async {
    final repo = FakeBookRepository();
    await tester.pumpWidget(
      buildApp(
        repo: repo,
        userBook: buildUserBook(rating: 4, oneLineReview: '좋았어요'),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    // Prefilled values appear in the field / counter.
    expect(find.text('좋았어요'), findsOneWidget);
    expect(find.text('4/200'), findsOneWidget); // 4 chars: 좋,았,어,요
  });
}
