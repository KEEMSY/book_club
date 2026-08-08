import 'package:book_club/core/theme/app_theme.dart';
import 'package:book_club/features/auth/application/auth_notifier.dart';
import 'package:book_club/features/auth/domain/auth_state.dart';
import 'package:book_club/features/auth/domain/auth_user.dart';
import 'package:book_club/features/settings/presentation/settings_screen.dart';
import 'package:book_club/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

/// BC-82 — settings hub: single entry point that absorbed the own-profile
/// overflow menu (언어·개인정보처리방침·이용약관·관리자·로그아웃) plus new
/// entries reusing existing feature screens (알림·차단 목록·계정 관리).
///
/// Navigation is exercised through a real nested [GoRouter] (mirrors
/// `profile_edit_screen_test.dart`) with placeholder destination screens, so
/// tapping an entry can be asserted by the placeholder text landing on
/// screen instead of mocking `context.push`.
class _StubAuth extends AuthNotifier {
  _StubAuth(this._user);

  final AuthUser _user;

  @override
  AuthState build() => AuthState.authenticated(_user);

  @override
  Future<void> bootstrap() async {}
}

AuthUser _user({bool isAdmin = false}) {
  return AuthUser(
    id: 'u1',
    nickname: '희재',
    provider: AuthProvider.kakao,
    createdAt: DateTime.utc(2026, 4, 20, 12),
    isAdmin: isAdmin,
  );
}

Widget _buildApp({required AuthUser user}) {
  final router = GoRouter(
    initialLocation: '/settings',
    routes: <RouteBase>[
      GoRoute(
        path: '/settings',
        builder: (_, __) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (_, __) => const Scaffold(body: Text('NOTIFICATIONS_SCREEN')),
      ),
      GoRoute(
        path: '/settings/blocked',
        builder: (_, __) => const Scaffold(body: Text('BLOCKED_USERS_SCREEN')),
      ),
      GoRoute(
        path: '/settings/account',
        builder: (_, __) => const Scaffold(body: Text('ACCOUNT_SCREEN')),
      ),
      GoRoute(
        path: '/settings/privacy',
        builder: (_, __) => const Scaffold(body: Text('PRIVACY_SCREEN')),
      ),
      GoRoute(
        path: '/settings/terms',
        builder: (_, __) => const Scaffold(body: Text('TERMS_SCREEN')),
      ),
      GoRoute(
        path: '/admin',
        builder: (_, __) => const Scaffold(body: Text('ADMIN_SCREEN')),
      ),
    ],
  );

  return ProviderScope(
    overrides: <Override>[
      authNotifierProvider.overrideWith(() => _StubAuth(user)),
    ],
    child: MaterialApp.router(
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  testWidgets('renders core entries and hides admin when not is_admin', (
    tester,
  ) async {
    await tester.pumpWidget(_buildApp(user: _user()));
    await tester.pumpAndSettle();

    expect(find.text('알림'), findsOneWidget);
    expect(find.text('차단 목록'), findsOneWidget);
    expect(find.text('계정 관리'), findsOneWidget);
    expect(find.text('개인정보처리방침'), findsOneWidget);
    expect(find.text('이용약관'), findsOneWidget);
    expect(find.text('로그아웃'), findsOneWidget);

    // FeatureFlags.subscription is off — the entry must not render at all
    // (matches the paywall CTA gating already used on UserProfileScreen).
    expect(find.text('구독·결제 관리'), findsNothing);
    // Not an admin session — the entry must not render.
    expect(find.text('관리자'), findsNothing);
  });

  testWidgets('is_admin session: admin entry renders and navigates', (
    tester,
  ) async {
    await tester.pumpWidget(_buildApp(user: _user(isAdmin: true)));
    await tester.pumpAndSettle();

    expect(find.text('관리자'), findsOneWidget);

    await tester.tap(find.text('관리자'));
    await tester.pumpAndSettle();

    expect(find.text('ADMIN_SCREEN'), findsOneWidget);
  });

  testWidgets('tapping 알림 pushes the notifications screen', (tester) async {
    await tester.pumpWidget(_buildApp(user: _user()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('알림'));
    await tester.pumpAndSettle();

    expect(find.text('NOTIFICATIONS_SCREEN'), findsOneWidget);
  });

  testWidgets('tapping 차단 목록 pushes the blocked-users screen', (
    tester,
  ) async {
    await tester.pumpWidget(_buildApp(user: _user()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('차단 목록'));
    await tester.pumpAndSettle();

    expect(find.text('BLOCKED_USERS_SCREEN'), findsOneWidget);
  });

  testWidgets('tapping 계정 관리 pushes the account screen', (tester) async {
    await tester.pumpWidget(_buildApp(user: _user()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('계정 관리'));
    await tester.pumpAndSettle();

    expect(find.text('ACCOUNT_SCREEN'), findsOneWidget);
  });
}
