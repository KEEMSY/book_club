import 'package:book_club/core/theme/app_theme.dart';
import 'package:book_club/features/auth/application/auth_providers.dart';
import 'package:book_club/features/auth/data/auth_repository.dart';
import 'package:book_club/features/book/application/book_providers.dart';
import 'package:book_club/features/book/data/book_repository.dart'
    show LibraryPage;
import 'package:book_club/features/book/domain/user_book.dart';
import 'package:book_club/features/community/presentation/profile_edit_screen.dart';
import 'package:book_club/features/social/domain/user_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../auth/fakes.dart' as auth_fakes;
import '../book/fakes.dart';

/// BC-84 — profile edit form: the four expressiveness fields (cover image
/// URL, theme, featured book, featured quote) added on top of the existing
/// nickname/bio form. Navigation uses a real nested [GoRouter] (mirrors
/// `my_activity_section_test.dart`) so `context.pop()` on save resolves
/// against an actual previous page instead of throwing for lack of one.
UserProfile _profile({
  String id = 'u1',
  String nickname = '희재',
  String? bio,
  String? coverImageUrl,
  String? theme,
  String? featuredBookId,
  String? featuredQuote,
}) {
  return UserProfile(
    id: id,
    nickname: nickname,
    bio: bio,
    followerCount: 0,
    followingCount: 0,
    isFollowing: false,
    isMe: true,
    coverImageUrl: coverImageUrl,
    theme: theme,
    featuredBookId: featuredBookId,
    featuredQuote: featuredQuote,
  );
}

Future<auth_fakes.FakeAuthApi> _pump(
  WidgetTester tester, {
  required UserProfile profile,
  required FakeBookRepository bookRepo,
}) async {
  // The edit form (nickname, bio, cover URL, theme swatches, featured book,
  // featured quote, hint text) doesn't fit the default 800×600 test surface;
  // grow it so every field/button is on-screen and tappable without an
  // explicit scroll-into-view step (mirrors my_activity_section_test.dart).
  tester.view.physicalSize = const Size(800, 1400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final fakeApi = auth_fakes.FakeAuthApi();
  final authRepo = AuthRepository(
    api: fakeApi,
    secureStorage: auth_fakes.InMemorySecureStorage(),
    socialLogin: auth_fakes.FakeSocialLoginPort(),
  );

  final router = GoRouter(
    initialLocation: '/profile/edit',
    routes: <RouteBase>[
      GoRoute(
        path: '/profile',
        builder: (_, __) => const Scaffold(body: Text('PROFILE_SCREEN')),
        routes: <RouteBase>[
          GoRoute(
            path: 'edit',
            builder: (_, __) => ProfileEditScreen(profile: profile),
          ),
        ],
      ),
    ],
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[
        authRepositoryProvider.overrideWithValue(authRepo),
        bookRepositoryProvider.overrideWithValue(bookRepo),
      ],
      child: MaterialApp.router(theme: AppTheme.light, routerConfig: router),
    ),
  );
  await tester.pumpAndSettle();
  return fakeApi;
}

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets(
    '테마를 선택하고 커버·인용구를 입력해 저장하면 snake_case 필드로 PATCH한다',
    (tester) async {
      final bookRepo = FakeBookRepository();
      final fakeApi = await _pump(
        tester,
        profile: _profile(),
        bookRepo: bookRepo,
      );

      await tester.enterText(
        find.widgetWithText(TextField, 'https://...'),
        'https://example.com/cover.jpg',
      );
      await tester.enterText(
        find.widgetWithText(TextField, '마음에 남은 문장을 남겨보세요'),
        '인생은 짧고 책은 많다',
      );

      // 6개 테마 스와치 중 "미드나잇"을 선택.
      await tester.tap(find.text('미드나잇'));
      await tester.pump();

      await tester.tap(find.text('저장'));
      await tester.pumpAndSettle();

      expect(fakeApi.updateProfileCalls, hasLength(1));
      final body = fakeApi.updateProfileCalls.single;
      expect(body['cover_image_url'], 'https://example.com/cover.jpg');
      expect(body['featured_quote'], '인생은 짧고 책은 많다');
      expect(body['theme'], 'midnight');
      expect(body.containsKey('featured_book_id'), isFalse);

      // Saved successfully → popped back to the previous page.
      expect(find.text('PROFILE_SCREEN'), findsOneWidget);
    },
  );

  testWidgets(
    '기존 대표 책이 있으면 편집 화면에 제목이 미리 보인다',
    (tester) async {
      final bookRepo = FakeBookRepository()
        ..getByIdResult = buildBook(id: 'book-1', title: '피크엔드');

      await _pump(
        tester,
        profile: _profile(featuredBookId: 'book-1'),
        bookRepo: bookRepo,
      );

      expect(find.text('피크엔드'), findsOneWidget);
      expect(bookRepo.getByIdCalls, <String>['book-1']);
    },
  );

  testWidgets(
    '책 선택 시트에서 서재의 책을 고르면 대표 책 미리보기가 갱신되고 저장 시 id가 전송된다',
    (tester) async {
      final bookRepo = FakeBookRepository()
        ..defaultLibraryPage = LibraryPage(
          items: <UserBook>[
            buildUserBook(
              id: 'ub-1',
              book: buildBook(id: 'book-9', title: '아몬드', author: '손원평'),
            ),
          ],
        )
        ..getByIdResult = buildBook(id: 'book-9', title: '아몬드', author: '손원평');

      final fakeApi = await _pump(
        tester,
        profile: _profile(),
        bookRepo: bookRepo,
      );

      expect(find.text('선택된 책이 없어요'), findsOneWidget);

      await tester.tap(find.text('책 선택'));
      await tester.pumpAndSettle();

      expect(find.text('아몬드'), findsOneWidget);
      await tester.tap(find.text('아몬드'));
      await tester.pumpAndSettle();

      // The picker preview now resolves the picked id through the same
      // `featuredBookProvider` the profile header uses.
      expect(find.text('아몬드'), findsOneWidget);
      expect(find.text('선택된 책이 없어요'), findsNothing);

      await tester.tap(find.text('저장'));
      await tester.pumpAndSettle();

      expect(fakeApi.updateProfileCalls.single['featured_book_id'], 'book-9');
    },
  );

  testWidgets(
    '저장이 실패하면 스낵바를 보여주고 화면에 남는다',
    (tester) async {
      final bookRepo = FakeBookRepository();
      final fakeApi = await _pump(
        tester,
        profile: _profile(),
        bookRepo: bookRepo,
      );
      fakeApi.updateProfileError = Exception('network down');

      await tester.tap(find.text('저장'));
      await tester.pumpAndSettle();

      expect(find.text('저장에 실패했습니다. 다시 시도해주세요.'), findsOneWidget);
      expect(find.text('PROFILE_SCREEN'), findsNothing);
    },
  );
}
