import 'package:book_club/core/theme/app_theme.dart';
import 'package:book_club/features/book/application/book_providers.dart';
import 'package:book_club/features/book/application/book_search_notifier.dart';
import 'package:book_club/features/book/data/book_repository.dart';
import 'package:book_club/features/book/domain/book.dart';
import 'package:book_club/features/book/presentation/search_screen.dart';
import 'package:book_club/features/book/presentation/widgets/book_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'fakes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  // Keep google_fonts offline — same reason as login_screen_test.
  GoogleFonts.config.allowRuntimeFetching = false;

  Widget buildApp({required BookRepository repo}) {
    return ProviderScope(
      overrides: <Override>[
        bookRepositoryProvider.overrideWithValue(repo),
        bookSearchNotifierProvider.overrideWith(
          (ref) => BookSearchNotifier(
            repo,
            debounce: const Duration(milliseconds: 5),
          ),
        ),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        home: const SearchScreen(),
      ),
    );
  }

  testWidgets('shows idle empty state before any query is entered',
      (tester) async {
    final repo = FakeBookRepository();
    await tester.pumpWidget(buildApp(repo: repo));
    await tester.pumpAndSettle();

    expect(find.text('읽고 싶은 책을 검색해보세요'), findsOneWidget);
  });

  testWidgets('entering a query renders result cards', (tester) async {
    final repo = FakeBookRepository()
      ..searchQueue.add(
        buildSearchResult(
          items: <Book>[
            buildBook(id: 'b1', title: '달러구트 꿈 백화점', author: '이미예'),
          ],
        ),
      );
    await tester.pumpWidget(buildApp(repo: repo));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '달러구트');
    // let debounce fire
    await tester.pump(const Duration(milliseconds: 20));
    await tester.pumpAndSettle();

    expect(find.byType(BookCard), findsOneWidget);
    expect(find.text('달러구트 꿈 백화점'), findsOneWidget);
    expect(find.text('이미예'), findsOneWidget);
    expect(repo.searchCalls.single.query, '달러구트');
  });

  testWidgets('502 upstream failure shows retry button', (tester) async {
    final repo = FakeBookRepository()
      ..searchErrors.add(
        const BookRepositoryException(
          code: 'UPSTREAM_UNAVAILABLE',
          message: '잠시 후 다시 시도해주세요.',
          statusCode: 502,
        ),
      );
    await tester.pumpWidget(buildApp(repo: repo));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '네트워크');
    await tester.pump(const Duration(milliseconds: 20));
    await tester.pumpAndSettle();

    expect(find.text('잠시 후 다시 시도해주세요'), findsWidgets);
    expect(find.text('다시 시도'), findsOneWidget);
  });
}
