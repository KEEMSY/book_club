import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/application/auth_providers.dart';
import '../../features/auth/domain/auth_state.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/book/presentation/book_detail_screen.dart';
import '../../features/book/presentation/library_screen.dart';
import '../../features/book/presentation/search_screen.dart';
import '../network/dio_provider.dart';
import '../theme/app_theme.dart';
import 'app_shell.dart';

/// Route paths, kept as constants so feature code does not stringly-type them.
class AppRoutes {
  const AppRoutes._();

  // M0/M1 entry points.
  static const login = '/login';
  static const home = '/home';

  // M2 destinations.
  static const search = '/search';
  static const library = '/library';
  static String bookDetail(String id) => '/books/$id';
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

final _shellSearchKey = GlobalKey<NavigatorState>();
final _shellLibraryKey = GlobalKey<NavigatorState>();
final _rootKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  final listenable = _AuthStateListenable(ref);
  return GoRouter(
    initialLocation: AppRoutes.library,
    navigatorKey: _rootKey,
    refreshListenable: listenable,
    redirect: (context, state) {
      final AuthState auth = ref.read(authNotifierProvider);
      final String target = state.matchedLocation;

      // Root alias — M2 promotes /library to the authenticated landing.
      // /home stays registered for M3 (timer dashboard) but we no longer
      // expose it from the UI.
      final String canonical = target == '/' ? AppRoutes.library : target;

      if (auth is AuthInitial) {
        return canonical == target ? null : canonical;
      }

      final bool authenticated = auth is Authenticated;
      final bool onLogin = canonical == AppRoutes.login;

      if (!authenticated && !onLogin) {
        return AppRoutes.login;
      }
      if (authenticated && onLogin) {
        return AppRoutes.library;
      }
      return canonical == target ? null : canonical;
    },
    routes: <RouteBase>[
      // Login sits outside the shell — no bottom nav on the login screen.
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      // Book detail is pushed on top of whichever shell branch the user is on
      // (search vs library), so it lives on the root navigator.
      GoRoute(
        path: '/books/:id',
        parentNavigatorKey: _rootKey,
        builder: (context, state) {
          final String id = state.pathParameters['id']!;
          return BookDetailScreen(bookId: id);
        },
      ),
      // M3 placeholder: kept present so deep links to /home don't 404 while
      // the timer dashboard is in flight. Hidden from UI navigation.
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const _HomePlaceholderScreen(),
      ),
      // Two-tab StatefulShellRoute — Search · Library.
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            navigatorKey: _shellSearchKey,
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.search,
                builder: (context, state) => const SearchScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _shellLibraryKey,
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.library,
                builder: (context, state) {
                  final String? highlight =
                      state.uri.queryParameters['highlight'];
                  return LibraryScreen(highlightUserBookId: highlight);
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

/// Legacy home placeholder — exists so M3 timer work can drop into this route
/// without a migration. No longer reachable from the app's visible UI.
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
            Text(
              'Book Club',
              style: theme.textTheme.displayLarge,
            ),
            SizedBox(height: spacing.sm),
            Text(
              '오늘 읽은 책을 기록하고, 책으로 사람과 만나요',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isDark
                    ? AppPalette.darkTextSecondary
                    : AppPalette.secondaryGray,
              ),
            ),
            SizedBox(height: spacing.xl),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {},
                child: const Text('시작하기'),
              ),
            ),
            SizedBox(height: spacing.sm),
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
