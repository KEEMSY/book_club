import 'package:book_club/core/theme/app_theme.dart';
import 'package:book_club/features/auth/application/auth_notifier.dart';
import 'package:book_club/features/auth/domain/auth_state.dart';
import 'package:book_club/features/auth/domain/auth_user.dart';
import 'package:book_club/features/book/application/book_providers.dart';
import 'package:book_club/features/book/data/book_repository.dart'
    show BookRepositoryException;
import 'package:book_club/features/community/application/community_providers.dart';
import 'package:book_club/features/community/presentation/user_profile_screen.dart';
import 'package:book_club/features/reading/application/reading_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import '../auth/fakes.dart' show buildUser;
import '../book/fakes.dart';
import '../reading/fakes.dart';

/// Stubs auth as already-authenticated so [UserProfileScreen] renders
/// immediately without going through the login/bootstrap flow.
class _StubAuth extends AuthNotifier {
  _StubAuth(this._user);

  final AuthUser _user;

  @override
  AuthState build() => AuthState.authenticated(_user);

  @override
  Future<void> bootstrap() async {}
}

/// Flushes pending futures without waiting for animations to finish.
///
/// `pumpAndSettle()` would hang forever here: [UserProfileScreen] renders
/// [GradeBadge] whenever `gradeStats` is set (always, in these tests), and
/// its `_AnimatedBadge` glow runs an unconditional `repeat(reverse: true)`
/// `AnimationController` (see `grade_badge.dart`) that never stops scheduling
/// frames outside a reduce-motion `MediaQuery`. A few bounded pumps are
/// enough for the fake repositories' futures (`getGrade`, `getById`) to
/// resolve without waiting on that animation.
Future<void> _settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
  await tester.pump(const Duration(milliseconds: 300));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  // BC-84 header expressiveness (cover/theme/featured book/quote) only ever
  // renders through this degrade branch today: `FeatureFlags.community` is
  // false, so `userProfileProvider` always builds the profile from `/me` +
  // grade (see community_providers.dart) rather than the community endpoint.
  Widget buildApp({
    required AuthUser user,
    required FakeBookRepository bookRepo,
  }) {
    final readingRepo = FakeReadingRepository()
      ..gradeResult = buildGradeSummary(
        grade: 2,
        totalBooks: 3,
        totalSeconds: 1800,
        streakDays: 1,
      );
    return ProviderScope(
      overrides: <Override>[
        authNotifierProvider.overrideWith(() => _StubAuth(user)),
        readingRepositoryProvider.overrideWithValue(readingRepo),
        bookRepositoryProvider.overrideWithValue(bookRepo),
        // BC-90: MyActivitySection now renders regardless of
        // FeatureFlags.community (it's own-profile-only, not community-only),
        // so the profile screen watches myActivityProvider here too. Fail it
        // locally rather than let a real, un-mocked dio call reach the network
        // — the section renders nothing on error and isn't under test here.
        myActivityProvider.overrideWith(
          (ref) async => throw Exception('not exercised by this test'),
        ),
      ],
      child: MaterialApp(
        theme: AppTheme.light,
        home: UserProfileScreen(userId: user.id),
      ),
    );
  }

  testWidgets(
    'renders featured book and featured quote when set on the profile',
    (tester) async {
      final bookRepo = FakeBookRepository()
        ..getByIdResult = buildBook(
          id: 'book-1',
          title: '달러구트 꿈 백화점',
          author: '이미예',
        );
      final user = buildUser(
        id: 'u1',
        nickname: '테스터',
        theme: 'sunset',
        featuredBookId: 'book-1',
        featuredQuote: '인생은 짧고 책은 많다',
      );

      await tester.pumpWidget(buildApp(user: user, bookRepo: bookRepo));
      await _settle(tester);

      expect(find.text('대표 책'), findsOneWidget);
      expect(find.text('달러구트 꿈 백화점'), findsOneWidget);
      expect(find.text('인생은 짧고 책은 많다'), findsOneWidget);
      expect(bookRepo.getByIdCalls, <String>['book-1']);
    },
  );

  testWidgets(
    'no expressiveness fields set: neither featured section renders',
    (tester) async {
      final bookRepo = FakeBookRepository();
      final user = buildUser(id: 'u2', nickname: '민지');

      await tester.pumpWidget(buildApp(user: user, bookRepo: bookRepo));
      await _settle(tester);

      // Appears twice: the AppBar title and the header both render the
      // nickname.
      expect(find.text('민지'), findsWidgets);
      expect(find.text('대표 책'), findsNothing);
      expect(bookRepo.getByIdCalls, isEmpty);
    },
  );

  testWidgets(
    'featured book fetch fails: profile still renders (fails quiet)',
    (tester) async {
      final bookRepo = FakeBookRepository()
        ..getByIdError = const BookRepositoryException(
          code: 'NOT_FOUND',
          message: '책을 찾을 수 없습니다.',
        );
      final user = buildUser(
        id: 'u3',
        nickname: '수진',
        featuredBookId: 'missing-book',
      );

      await tester.pumpWidget(buildApp(user: user, bookRepo: bookRepo));
      await _settle(tester);

      expect(find.text('수진'), findsWidgets);
      expect(find.text('대표 책'), findsNothing);
    },
  );
}
