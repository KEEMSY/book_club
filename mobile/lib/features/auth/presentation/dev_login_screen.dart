import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../application/auth_notifier.dart';
import '../domain/auth_state.dart';
import 'widgets/dev_login_button.dart';
import 'widgets/loading_overlay.dart';

/// Hidden dev/staging-only login screen (BC-86).
///
/// Not linked from anywhere in the UI — the main [LoginScreen] no longer
/// carries any button or affordance that points here. It is reachable only
/// by navigating to `AppRoutes.devLogin` directly (a debug launch config's
/// initial route, a manual deep link, etc). [DevLoginGate] is what actually
/// keeps the route unreachable outside debug/staging builds (enforced in
/// `app_router.dart`'s redirect for this route); this screen assumes that
/// gate already passed and renders unconditionally.
class DevLoginScreen extends ConsumerWidget {
  const DevLoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final AuthState auth = ref.watch(authNotifierProvider);
    final bool isBusy = auth is Authenticating;
    final String? failureMessage = auth is AuthFailure ? auth.message : null;

    return Scaffold(
      appBar: AppBar(title: const Text('개발자 도구')),
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(spacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Dev 환경 전용 · 테스트 데이터 로그인은 샘플 데이터가 자동 생성됩니다',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: spacing.lg),
                  if (failureMessage != null) ...<Widget>[
                    Text(
                      failureMessage,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                    SizedBox(height: spacing.sm),
                  ],
                  DevLoginButton(
                    onPressed: () =>
                        ref.read(authNotifierProvider.notifier).loginDev(),
                    isLoading: isBusy,
                  ),
                  SizedBox(height: spacing.sm),
                  DevLoginButton(
                    onPressed: () =>
                        ref.read(authNotifierProvider.notifier).loginTester(),
                    label: '테스트 데이터 로그인',
                    isLoading: isBusy,
                  ),
                ],
              ),
            ),
            LoadingOverlay(visible: isBusy),
          ],
        ),
      ),
    );
  }
}
