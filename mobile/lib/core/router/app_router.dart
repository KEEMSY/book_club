import 'package:flutter/cupertino.dart';
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

/// M0 home placeholder — exists primarily to verify the Apple-themed
/// [AppTheme] is plumbed end-to-end (iOS-system typography, secondaryLabel
/// subtitle, tinted CTA, AppSpacing extension). The real home screen lands in
/// later milestones.
class _HomePlaceholderScreen extends StatelessWidget {
  const _HomePlaceholderScreen();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final env = currentEnvLabel();
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        // Keep the bar compact and flat — HIG uses a tall stack for the Large
        // Title below, not a centered title on the bar itself.
        toolbarHeight: 44,
        leading: Padding(
          padding: EdgeInsets.only(left: spacing.md),
          child: Icon(
            CupertinoIcons.book,
            color: theme.colorScheme.primary,
          ),
        ),
        leadingWidth: 40,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.md,
          vertical: spacing.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // HIG Large Title — stacked below the bar (displayLarge is 34/bold
            // with HIG's -0.374 tracking, matching the system Large Title).
            Text(
              'Book Club',
              style: theme.textTheme.displayLarge,
            ),
            SizedBox(height: spacing.xs),
            Text(
              '독서를 기록하고, 책으로 대화하세요',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isDark
                    ? AppPalette.secondaryLabelDark
                    : AppPalette.secondaryLabel,
              ),
            ),
            SizedBox(height: spacing.lg),
            FilledButton(
              onPressed: () {},
              child: const Text('시작하기'),
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
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
    );
  }
}
