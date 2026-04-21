import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../network/dio_provider.dart';
import '../theme/app_theme.dart';

/// Route paths, kept as constants so feature code does not stringly-type them.
class AppRoutes {
  const AppRoutes._();

  static const login = '/login';
  static const home = '/home';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    redirect: (context, state) {
      // TODO(m1/auth): gate protected routes on AuthNotifier state. For M0
      // there is no auth state yet, so we only handle the `/` → `/home` alias.
      if (state.matchedLocation == '/') {
        return AppRoutes.home;
      }
      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const _HomePlaceholderScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const _LoginPlaceholderScreen(),
      ),
    ],
  );
});

/// M0 home placeholder — exists primarily to verify the Claude-themed
/// [AppTheme] is plumbed end-to-end (serif headline, muted subtitle, branded
/// CTA, AppSpacing extension). The real home screen lands in later milestones.
class _HomePlaceholderScreen extends StatelessWidget {
  const _HomePlaceholderScreen();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final env = currentEnvLabel();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Club'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.lg,
          vertical: spacing.xl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Book Club',
              style: theme.textTheme.headlineMedium,
            ),
            SizedBox(height: spacing.sm),
            Text(
              '독서를 기록하고, 책으로 대화하세요',
              style: theme.textTheme.bodyLarge,
            ),
            SizedBox(height: spacing.lg),
            FilledButton(
              onPressed: () {},
              child: const Text('독서 시작하기'),
            ),
            SizedBox(height: spacing.md),
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

class _LoginPlaceholderScreen extends StatelessWidget {
  const _LoginPlaceholderScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '로그인',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
