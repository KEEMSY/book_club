import 'package:book_club/core/theme/app_theme.dart';
import 'package:book_club/features/auth/application/auth_notifier.dart';
import 'package:book_club/features/auth/application/auth_providers.dart';
import 'package:book_club/features/auth/data/auth_repository.dart';
import 'package:book_club/features/auth/data/social_login_port.dart';
import 'package:book_club/features/book/application/book_providers.dart';
import 'package:book_club/features/book/data/book_repository.dart';
import 'package:book_club/features/book/domain/book_status.dart';
import 'package:book_club/features/book/domain/user_book.dart';
import 'package:book_club/features/book/presentation/library_screen.dart';
import 'package:book_club/features/book/presentation/widgets/book_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import '../auth/fakes.dart' as auth_fakes;
import 'fakes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  Widget buildApp({required BookRepository repo}) {
    // Provide a stubbed AuthRepository so the logout IconButton's dependency
    // chain resolves without pulling in real secure storage.
    final authRepo = AuthRepository(
      api: auth_fakes.FakeAuthApi(),
      secureStorage: auth_fakes.InMemorySecureStorage(),
      socialLogin: auth_fakes.FakeSocialLoginPort(
        kakaoResult: const SocialLoginResult(accessToken: 'x'),
        appleResult: const SocialLoginResult(identityToken: 'x'),
      ),
    );
    return ProviderScope(
      overrides: <Override>[
        bookRepositoryProvider.overrideWithValue(repo),
        authRepositoryProvider.overrideWithValue(authRepo),
        authNotifierProvider
            .overrideWith((ref) => AuthNotifier(authRepo)..bootstrap()),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        home: const LibraryScreen(),
      ),
    );
  }

  testWidgets('renders header + status segment + book cards', (tester) async {
    final repo = FakeBookRepository()
      ..libraryQueue.add(
        LibraryPage(
          items: <UserBook>[
            buildUserBook(id: 'ub1'),
            buildUserBook(
              id: 'ub2',
              book: buildBook(id: 'b2', title: '세컨드 북', author: '저자B'),
            ),
          ],
        ),
      );
    await tester.pumpWidget(buildApp(repo: repo));
    await tester.pumpAndSettle();

    expect(find.text('내 서재'), findsOneWidget);
    expect(find.text('읽는 중'), findsWidgets);
    expect(find.text('완독'), findsOneWidget);
    expect(find.byType(BookCard), findsNWidgets(2));
  });

  testWidgets('tapping completed tab triggers a fetch with that status',
      (tester) async {
    final repo = FakeBookRepository()
      ..libraryQueue.addAll(<LibraryPage>[
        const LibraryPage(items: <UserBook>[]),
        LibraryPage(
          items: <UserBook>[
            buildUserBook(id: 'ub-completed', status: BookStatus.completed),
          ],
        ),
      ]);
    await tester.pumpWidget(buildApp(repo: repo));
    await tester.pumpAndSettle();

    await tester.tap(find.text('완독'));
    await tester.pumpAndSettle();

    expect(
      repo.libraryCalls.any((c) => c.status == BookStatus.completed),
      isTrue,
    );
  });

  testWidgets('empty tab shows empty state CTA', (tester) async {
    final repo = FakeBookRepository()
      ..libraryQueue.add(const LibraryPage(items: <UserBook>[]));
    await tester.pumpWidget(buildApp(repo: repo));
    await tester.pumpAndSettle();

    expect(find.text('아직 읽는 중인 책이 없어요'), findsOneWidget);
    expect(find.text('책 검색하기'), findsOneWidget);
  });
}
