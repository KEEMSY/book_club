import 'dart:io' show Platform;
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../application/auth_providers.dart';
import '../domain/auth_state.dart';
import 'widgets/apple_login_button.dart';
import 'widgets/dev_login_button.dart';
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

    // Surface the last failure inline — a SnackBar would be dismissed by
    // rebuilds during the auth flow. The caption area below reads the failure
    // state and shows a single-line apology with the backend's message.
    final String? failureMessage = auth is AuthFailure ? auth.message : null;

    // Dev-mode flag: show DevLoginButton in addition to social buttons so local
    // dev flows remain usable without Kakao credentials.
    const bool isDevMode = bool.fromEnvironment('SHOW_DEV_LOGIN', defaultValue: true);
    final bool showApple = !kIsWeb && Platform.isIOS;

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
                    failureMessage: failureMessage,
                    showApple: showApple,
                    showDevLogin: isDevMode,
                    onKakao: () =>
                        ref.read(authNotifierProvider.notifier).loginWithKakao(),
                    onApple: () =>
                        ref.read(authNotifierProvider.notifier).loginWithApple(),
                    onDevLogin: () =>
                        ref.read(authNotifierProvider.notifier).loginDev(),
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
            color: theme.colorScheme.onSurfaceVariant,
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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing.md),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.07),
          borderRadius: BorderRadius.all(Radius.circular(radius.md)),
        ),
        child: CustomPaint(
          painter: _BookStackPainter(
            primary: theme.colorScheme.primary,
            surface: theme.colorScheme.surface,
            onSurface: theme.colorScheme.onSurface,
          ),
          size: const Size(double.infinity, 160),
        ),
      ),
    );
  }
}

/// Paints three stacked books at slight angles — a warm, intentional
/// illustration that scales to any container width.
class _BookStackPainter extends CustomPainter {
  _BookStackPainter({
    required this.primary,
    required this.surface,
    required this.onSurface,
  });

  final Color primary;
  final Color surface;
  final Color onSurface;

  @override
  void paint(Canvas canvas, Size size) {
    final double cx = size.width / 2;
    final double cy = size.height / 2;

    // Book specs: [x-center offset, y-center offset, width, height, rotation-deg, color-alpha]
    // Back book (slightly left, tilted -12°)
    _drawBook(
      canvas,
      cx: cx - 28,
      cy: cy + 6,
      w: 72,
      h: 96,
      angleDeg: -12,
      coverColor: primary.withValues(alpha: 0.28),
      pageColor: surface.withValues(alpha: 0.80),
    );

    // Middle book (slightly right, tilted +8°)
    _drawBook(
      canvas,
      cx: cx + 22,
      cy: cy + 4,
      w: 68,
      h: 92,
      angleDeg: 8,
      coverColor: primary.withValues(alpha: 0.50),
      pageColor: surface.withValues(alpha: 0.85),
    );

    // Front book (center, straight, primary color)
    _drawBook(
      canvas,
      cx: cx - 4,
      cy: cy - 2,
      w: 70,
      h: 96,
      angleDeg: 0,
      coverColor: primary.withValues(alpha: 0.85),
      pageColor: surface.withValues(alpha: 0.92),
      showLines: true,
    );
  }

  void _drawBook(
    Canvas canvas, {
    required double cx,
    required double cy,
    required double w,
    required double h,
    required double angleDeg,
    required Color coverColor,
    required Color pageColor,
    bool showLines = false,
  }) {
    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(angleDeg * math.pi / 180);

    final Rect cover = Rect.fromCenter(
      center: Offset.zero,
      width: w,
      height: h,
    );
    final RRect coverRRect =
        RRect.fromRectAndRadius(cover, const Radius.circular(4));

    // Drop shadow
    final Paint shadowPaint = Paint()
      ..color = onSurface.withValues(alpha: 0.10)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawRRect(
      coverRRect.shift(const Offset(2, 3)),
      shadowPaint,
    );

    // Book cover
    canvas.drawRRect(coverRRect, Paint()..color = coverColor);

    // Page block (right side strip, suggesting page thickness)
    final Rect pageBlock = Rect.fromLTWH(
      w / 2 - 6,
      -h / 2 + 4,
      5,
      h - 8,
    );
    canvas.drawRect(pageBlock, Paint()..color = pageColor);

    // Spine line
    canvas.drawLine(
      Offset(-w / 2 + 7, -h / 2 + 6),
      Offset(-w / 2 + 7, h / 2 - 6),
      Paint()
        ..color = onSurface.withValues(alpha: 0.15)
        ..strokeWidth = 1.5,
    );

    // Text lines on front book
    if (showLines) {
      final Paint linePaint = Paint()
        ..color = pageColor.withValues(alpha: 0.55)
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round;
      for (int i = 0; i < 5; i++) {
        final double y = -22 + i * 11.0;
        final double lineW = i == 4 ? w * 0.30 : w * 0.52;
        canvas.drawLine(
          Offset(-w / 2 + 14, y),
          Offset(-w / 2 + 14 + lineW, y),
          linePaint,
        );
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _BookStackPainter old) =>
      old.primary != primary ||
      old.surface != surface ||
      old.onSurface != onSurface;
}

class _BottomCtas extends StatelessWidget {
  const _BottomCtas({
    required this.spacing,
    required this.isBusy,
    required this.failureMessage,
    required this.showApple,
    required this.showDevLogin,
    required this.onKakao,
    required this.onApple,
    required this.onDevLogin,
  });

  final AppSpacing spacing;
  final bool isBusy;
  final String? failureMessage;
  final bool showApple;
  final bool showDevLogin;
  final VoidCallback onKakao;
  final VoidCallback onApple;
  final VoidCallback onDevLogin;

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
          KakaoLoginButton(onPressed: onKakao, isLoading: isBusy),
          if (showApple) ...<Widget>[
            SizedBox(height: spacing.sm),
            AppleLoginButton(onPressed: onApple, isLoading: isBusy),
          ],
          if (showDevLogin) ...<Widget>[
            SizedBox(height: spacing.sm),
            DevLoginButton(onPressed: onDevLogin, isLoading: isBusy),
            SizedBox(height: spacing.xs),
            Text(
              'Dev 환경 전용',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                fontSize: 11,
              ),
            ),
          ],
          SizedBox(height: spacing.md),
          Text(
            '로그인하면 Book Club 이용약관 및 개인정보처리방침에 동의합니다.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
