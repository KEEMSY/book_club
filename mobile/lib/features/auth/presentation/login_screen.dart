import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../application/auth_providers.dart';
import '../domain/auth_state.dart';
import 'widgets/apple_login_button.dart';
import 'widgets/kakao_login_button.dart';
import 'widgets/loading_overlay.dart';

/// Airbnb-toned login screen.
///
/// Layout follows the M1 spec:
///   - Top flex 2 · Playfair Display 40pt "Book Club" + soft gray subhead
///     ("책으로 연결되는 모든 순간"). Warm serif tone targets 한국 2030 여성.
///   - Middle flex 1 · illustration placeholder (Rausch 10% tint, 12px radius).
///   - Bottom · KakaoTalk yellow button (always visible), Apple black button
///     (iOS only), followed by the legal caption.
///
/// The whole surface uses the existing Foggy canvas from [AppTheme.light];
/// no new color or typography constants are introduced.
class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final AuthState auth = ref.watch(authNotifierProvider);
    final bool isBusy = auth is Authenticating;

    // iOS-only Apple button. On web/desktop we keep the check safe — Kakao is
    // still visible there for debugging via the SDK's web flow.
    final bool showAppleButton = !kIsWeb && Platform.isIOS;

    // Surface the last failure inline — a SnackBar would be dismissed by
    // rebuilds during the auth flow. The caption area below reads the failure
    // state and shows a single-line apology with the backend's message.
    final String? failureMessage = auth is AuthFailure ? auth.message : null;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: _Hero(spacing: spacing),
                  ),
                  Expanded(
                    flex: 1,
                    child: _Illustration(spacing: spacing),
                  ),
                  _BottomCtas(
                    spacing: spacing,
                    isBusy: isBusy,
                    showAppleButton: showAppleButton,
                    failureMessage: failureMessage,
                    onKakao: () => ref
                        .read(authNotifierProvider.notifier)
                        .loginWithKakao(),
                    onApple: () => ref
                        .read(authNotifierProvider.notifier)
                        .loginWithApple(),
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

class _Hero extends StatelessWidget {
  const _Hero({required this.spacing});

  final AppSpacing spacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          'Book Club',
          style: theme.textTheme.displayLarge,
        ),
        SizedBox(height: spacing.sm),
        Text(
          '책으로 연결되는 모든 순간',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: AppPalette.secondaryGray,
          ),
        ),
        SizedBox(height: spacing.lg),
      ],
    );
  }
}

class _Illustration extends StatelessWidget {
  const _Illustration({required this.spacing});

  final AppSpacing spacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = theme.extension<AppRadius>()!;
    // M2 drops a real SVG here; for M1 we ship a Rausch-tinted panel that
    // still reads on-brand (warm, intentional negative space around the
    // headline). Height is intrinsic so the flex layout stays honest.
    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing.md),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppPalette.rausch.withValues(alpha: 0.10),
          borderRadius: BorderRadius.all(Radius.circular(radius.md)),
        ),
        child: Center(
          child: Icon(
            Icons.auto_stories_outlined,
            size: 56,
            color: theme.colorScheme.primary.withValues(alpha: 0.85),
          ),
        ),
      ),
    );
  }
}

class _BottomCtas extends StatelessWidget {
  const _BottomCtas({
    required this.spacing,
    required this.isBusy,
    required this.showAppleButton,
    required this.failureMessage,
    required this.onKakao,
    required this.onApple,
  });

  final AppSpacing spacing;
  final bool isBusy;
  final bool showAppleButton;
  final String? failureMessage;
  final VoidCallback onKakao;
  final VoidCallback onApple;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(
        top: spacing.md,
        bottom: spacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (failureMessage != null) ...<Widget>[
            Text(
              failureMessage!,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
            SizedBox(height: spacing.sm),
          ],
          KakaoLoginButton(
            onPressed: onKakao,
            isLoading: isBusy,
          ),
          if (showAppleButton) ...<Widget>[
            SizedBox(height: spacing.sm),
            AppleLoginButton(
              onPressed: onApple,
              isLoading: isBusy,
            ),
          ],
          SizedBox(height: spacing.md),
          Text(
            '로그인하면 Book Club 이용약관 및 개인정보처리방침에 동의합니다.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppPalette.secondaryGray,
            ),
          ),
        ],
      ),
    );
  }
}
