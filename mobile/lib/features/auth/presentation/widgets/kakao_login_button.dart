import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Kakao-brand yellow login button.
///
/// Visual rules come from the Kakao 브랜드 가이드 (developers.kakao.com):
///   - background: `#FEE500` (Kakao yellow, immutable)
///   - text: black
///   - rounded rectangle matching the surrounding design language (we reuse
///     `AppRadius.md` = 12 so the button aligns with the other Airbnb-styled
///     CTAs on the login screen)
///
/// The leading chat bubble glyph is rendered as a compact Material icon — we
/// avoid shipping Kakao's raster logo until a licensed SVG is prepped in a
/// later milestone. The shape + color already satisfy Kakao's brand-guide
/// floor requirement for "카카오톡으로 시작하기".
class KakaoLoginButton extends StatelessWidget {
  const KakaoLoginButton({
    super.key,
    required this.onPressed,
    this.label = '카카오로 시작하기',
    this.isLoading = false,
  });

  final VoidCallback? onPressed;
  final String label;
  final bool isLoading;

  static const Color _kakaoYellow = Color(0xFFFEE500);
  static const Color _kakaoLabel = Color(0xFF191600); // Kakao brand-book ink

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    return SizedBox(
      width: double.infinity,
      height: 54,
      child: FilledButton(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: _kakaoYellow,
          foregroundColor: _kakaoLabel,
          disabledBackgroundColor: _kakaoYellow.withValues(alpha: 0.6),
          disabledForegroundColor: _kakaoLabel.withValues(alpha: 0.5),
          padding: EdgeInsets.symmetric(horizontal: spacing.md),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          textStyle: theme.textTheme.labelLarge?.copyWith(
            color: _kakaoLabel,
            fontWeight: FontWeight.w600,
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.chat_bubble, size: 18, color: _kakaoLabel),
            SizedBox(width: spacing.sm),
            Text(label),
          ],
        ),
      ),
    );
  }
}
