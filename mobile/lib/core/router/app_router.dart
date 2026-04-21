import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/application/auth_providers.dart';
import '../../features/auth/domain/auth_state.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../network/dio_provider.dart';
import '../theme/app_theme.dart';

/// Route paths, kept as constants so feature code does not stringly-type them.
class AppRoutes {
  const AppRoutes._();

  static const login = '/login';
  static const home = '/home';
}

/// Adapter that bridges a Riverpod [ValueNotifier]-free state stream into a
/// [Listenable] `go_router` can watch. Emits a tick every time the underlying
/// provider produces a new value.
class _AuthStateListenable extends ChangeNotifier {
  _AuthStateListenable(Ref ref) {
    _sub = ref.listen<AuthState>(
      authNotifierProvider,
      (_, __) => notifyListeners(),
      fireImmediately: false,
    );
    ref.onDispose(() => _sub.close());
  }

  late final ProviderSubscription<AuthState> _sub;
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final listenable = _AuthStateListenable(ref);
  return GoRouter(
    initialLocation: AppRoutes.home,
    refreshListenable: listenable,
    redirect: (context, state) {
      final AuthState auth = ref.read(authNotifierProvider);
      final String target = state.matchedLocation;

      // Root alias — send anyone hitting `/` onto the home route; the state
      // machine still evaluates below so unauthenticated users bounce to
      // `/login` in the next pass.
      final String canonical = target == '/' ? AppRoutes.home : target;

      // AuthInitial means bootstrap is still in flight. Keep the user on
      // whatever route they were trying to reach — once the notifier resolves
      // to Authenticated / Unauthenticated the listenable fires another pass.
      if (auth is AuthInitial) {
        return canonical == target ? null : canonical;
      }

      final bool authenticated = auth is Authenticated;
      final bool onLogin = canonical == AppRoutes.login;

      if (!authenticated && !onLogin) {
        return AppRoutes.login;
      }
      if (authenticated && onLogin) {
        return AppRoutes.home;
      }
      return canonical == target ? null : canonical;
    },
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const _HomePlaceholderScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
    ],
  );
});

/// M0 home placeholder — exists primarily to verify the Airbnb-themed
/// [AppTheme] is plumbed end-to-end (editorial serif hero, warm Foggy canvas,
/// Rausch Red FilledButton, pill OutlinedButton, AppSpacing extension). The
/// real home screen lands in later milestones.
class _HomePlaceholderScreen extends ConsumerWidget {
  const _HomePlaceholderScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final env = currentEnvLabel();
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56,
        leading: Padding(
          padding: EdgeInsets.only(left: spacing.md),
          child: Icon(
            CupertinoIcons.book,
            color: theme.colorScheme.primary,
          ),
        ),
        leadingWidth: 44,
        actions: <Widget>[
          IconButton(
            tooltip: '로그아웃',
            onPressed: () => ref.read(authNotifierProvider.notifier).logout(),
            icon: const Icon(Icons.logout_outlined),
          ),
          SizedBox(width: spacing.sm),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.lg,
          vertical: spacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Editorial serif hero — Playfair Display 40 / w500 with
            // Airbnb's negative tracking (-0.44px) for the intimate,
            // magazine-style headline voice.
            Text(
              'Book Club',
              style: theme.textTheme.displayLarge,
            ),
            SizedBox(height: spacing.sm),
            // Korean subhead softened from the previous copy to better
            // match the 감성적 / 따뜻 tone the brief calls for. Original
            // was "독서를 기록하고, 책으로 대화하세요" — kept meaning, added
            // warmth with "오늘" + "사람과 만나요".
            Text(
              '오늘 읽은 책을 기록하고, 책으로 사람과 만나요',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isDark
                    ? AppPalette.darkTextSecondary
                    : AppPalette.secondaryGray,
              ),
            ),
            SizedBox(height: spacing.xl),
            // Primary CTA — Rausch Red filled, 12px radius, w500 label.
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {},
                child: const Text('시작하기'),
              ),
            ),
            SizedBox(height: spacing.sm),
            // Secondary CTA — pill outlined (radius 1000), neutral border,
            // Rausch text, matching Airbnb's "Become a host"-style link.
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                child: const Text('어떤 책이 있을까?'),
              ),
            ),
            const Spacer(),
            Text(
              'API: $env',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
