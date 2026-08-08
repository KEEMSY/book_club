import 'package:book_club/core/theme/app_theme.dart';
import 'package:book_club/features/auth/application/auth_notifier.dart';
import 'package:book_club/features/auth/domain/auth_state.dart';
import 'package:book_club/features/auth/domain/auth_user.dart';
import 'package:book_club/features/book/application/book_providers.dart';
import 'package:book_club/features/community/presentation/user_profile_screen.dart';
import 'package:book_club/features/reading/application/reading_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../auth/fakes.dart' show buildUser;
import '../book/fakes.dart';
import '../reading/fakes.dart';

/// BC-82 — the own-profile AppBar used to show a `PopupMenuButton` with five
/// items (언어·개인정보처리방침·이용약관·관리자·로그아웃); it now collapses
/// into a single settings-gear entry that pushes the settings hub. This
/// guards that collapse: exactly one action icon renders, no popup menu
/// survives, and tapping it navigates to `/settings`.
class _StubAuth extends AuthNotifier {
  _StubAuth(this._user);

  final AuthUser _user;

  @override
  AuthState build() => AuthState.authenticated(_user);

  @override
  Future<void> bootstrap() async {}
}

/// Bounded pumps — mirrors `user_profile_header_test.dart`'s `_settle`.
/// `pumpAndSettle()` hangs because `GradeBadge`'s glow animation never stops
/// scheduling frames.
Future<void> _settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
  await tester.pump(const Duration(milliseconds: 300));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  Widget buildApp() {
    final user = buildUser(id: 'u1', nickname: '희재');
    final readingRepo = FakeReadingRepository()
      ..gradeResult = buildGradeSummary(
        grade: 2,
        totalBooks: 3,
        totalSeconds: 1800,
        streakDays: 1,
      );
    final bookRepo = FakeBookRepository();

    final router = GoRouter(
      initialLocation: '/profile/u1',
      routes: <RouteBase>[
        GoRoute(
          path: '/profile/u1',
          builder: (_, __) => const UserProfileScreen(userId: 'u1'),
        ),
        GoRoute(
          path: '/settings',
          builder: (_, __) => const Scaffold(body: Text('SETTINGS_SCREEN')),
        ),
      ],
    );

    return ProviderScope(
      overrides: <Override>[
        authNotifierProvider.overrideWith(() => _StubAuth(user)),
        readingRepositoryProvider.overrideWithValue(readingRepo),
        bookRepositoryProvider.overrideWithValue(bookRepo),
      ],
      child: MaterialApp.router(theme: AppTheme.light, routerConfig: router),
    );
  }

  testWidgets(
    'own profile shows a single settings action and no popup menu',
    (tester) async {
      await tester.pumpWidget(buildApp());
      await _settle(tester);

      expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
      // PopupMenuButton is generic (`PopupMenuButton<_OwnProfileAction>`
      // before this change); match on the runtime `is` check rather than a
      // concrete type argument so this still catches any popup menu variant.
      expect(
        find.byWidgetPredicate((widget) => widget is PopupMenuButton),
        findsNothing,
      );
    },
  );

  testWidgets(
    'tapping the settings action pushes the settings hub',
    (tester) async {
      await tester.pumpWidget(buildApp());
      await _settle(tester);

      await tester.tap(find.byIcon(Icons.settings_outlined));
      await _settle(tester);

      expect(find.text('SETTINGS_SCREEN'), findsOneWidget);
    },
  );
}
