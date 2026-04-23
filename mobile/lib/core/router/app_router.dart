import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/application/auth_providers.dart';
import '../../features/auth/domain/auth_state.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/book/presentation/book_detail_screen.dart';
import '../../features/book/presentation/library_screen.dart';
import '../../features/book/presentation/search_screen.dart';
import '../../features/reading/presentation/dashboard_screen.dart';
import '../../features/reading/presentation/goal_screen.dart';
import '../../features/reading/presentation/grade_screen.dart';
import '../../features/reading/presentation/timer_screen.dart';
import 'app_shell.dart';

/// Route paths, kept as constants so feature code does not stringly-type them.
class AppRoutes {
  const AppRoutes._();

  // Entry / auth.
  static const login = '/login';

  // M3 destinations.
  static const home = '/home';
  static const grade = '/grade';
  static const goals = '/goals';
  static String timer(String userBookId) =>
      '/reading/timer?user_book_id=$userBookId';

  // M2 destinations (still reachable through the shell).
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

final _shellHomeKey = GlobalKey<NavigatorState>();
final _shellSearchKey = GlobalKey<NavigatorState>();
final _shellLibraryKey = GlobalKey<NavigatorState>();
final _rootKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  final listenable = _AuthStateListenable(ref);
  return GoRouter(
    initialLocation: AppRoutes.home,
    navigatorKey: _rootKey,
    refreshListenable: listenable,
    redirect: (context, state) {
      final AuthState auth = ref.read(authNotifierProvider);
      final String target = state.matchedLocation;

      // M3 promotes `/home` back to the authenticated landing.
      final String canonical = target == '/' ? AppRoutes.home : target;

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
      // Login sits outside the shell — no bottom nav on the login screen.
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      // Book detail is pushed on top of whichever shell branch the user is on
      // (home vs search vs library), so it lives on the root navigator.
      GoRoute(
        path: '/books/:id',
        parentNavigatorKey: _rootKey,
        builder: (context, state) {
          final String id = state.pathParameters['id']!;
          return BookDetailScreen(bookId: id);
        },
      ),
      // Timer lives above the shell so the session UI takes the full screen
      // without the bottom-nav strip stealing focus.
      GoRoute(
        path: '/reading/timer',
        parentNavigatorKey: _rootKey,
        builder: (context, state) {
          final String userBookId =
              state.uri.queryParameters['user_book_id'] ?? '';
          return TimerScreen(userBookId: userBookId);
        },
      ),
      // Grade + Goals are reachable from the dashboard but render without
      // the shell so their AppBar back-arrow pops cleanly.
      GoRoute(
        path: AppRoutes.grade,
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const GradeScreen(),
      ),
      GoRoute(
        path: AppRoutes.goals,
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const GoalScreen(),
      ),
      // Three-tab StatefulShellRoute — 홈 · 검색 · 서재.
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            navigatorKey: _shellHomeKey,
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
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
