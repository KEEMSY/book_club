import 'package:book_club/core/theme/app_theme.dart';
import 'package:book_club/features/book/application/book_providers.dart';
import 'package:book_club/features/book/application/book_search_notifier.dart';
import 'package:book_club/features/book/data/book_models.dart';
import 'package:book_club/features/book/presentation/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'fakes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  // Guards BC-89: the idle-state discover cards (BookCover 2:3 @100w = 150px +
  // 2-line title + author) overflowed the fixed-height horizontal list at
  // 196px. A book with no cover (placeholder, same 150px) and a long 2-line
  // title is the worst case.
  testWidgets('discover section renders book cards without overflow', (
    tester,
  ) async {
    const section = DiscoverResponseDto(
      sections: <DiscoverSectionDto>[
        DiscoverSectionDto(
          id: 's1',
          title: '이번 주 추천',
          books: <BookDto>[
            BookDto(
              id: 'b1',
              isbn13: '9788900000001',
              title: '아주 길어서 두 줄을 꽉 채우는 제목의 책 제목 예시입니다',
              author: '홍길동',
              publisher: '출판사',
              // coverUrl null → placeholder(같은 150px) — 최악 케이스.
            ),
          ],
        ),
      ],
    );

    final repo = FakeBookRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          bookRepositoryProvider.overrideWithValue(repo),
          bookSearchNotifierProvider.overrideWith(
            (ref) => BookSearchNotifier(
              repo,
              debounce: const Duration(milliseconds: 5),
            ),
          ),
          discoverBooksProvider.overrideWith((ref) async => section),
        ],
        child: MaterialApp(theme: AppTheme.light, home: const SearchScreen()),
      ),
    );
    await tester.pumpAndSettle();

    // Section + card rendered, and no RenderFlex overflow was thrown during
    // layout (the pre-fix 196px height would surface one here).
    expect(find.text('이번 주 추천'), findsOneWidget);
    expect(find.textContaining('두 줄을 꽉 채우는'), findsOneWidget);
    expect(
      tester.takeException(),
      isNull,
      reason: '추천 카드가 고정 높이 리스트에서 bottom overflow 되면 안 된다',
    );
  });
}
