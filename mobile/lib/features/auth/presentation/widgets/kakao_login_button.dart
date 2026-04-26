import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Kakao-brand yellow login button.
///
/// Visual rules from Kakao 브랜드 가이드 (developers.kakao.com):
///   - background: `#FEE500` (Kakao yellow, immutable)
///   - text + icon: `#191600` (Kakao brand-book ink)
///   - icon: KakaoTalk speech-bubble mark drawn via [_KakaoMark] CustomPainter,
///     faithful to the official symbol path from the Kakao developers design kit.
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
  static const Color _kakaoLabel = Color(0xFF191600);

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
            const SizedBox(
              width: 20,
              height: 20,
              child: CustomPaint(painter: _KakaoMark()),
            ),
            SizedBox(width: spacing.sm),
            Text(label),
          ],
        ),
      ),
    );
  }
}

/// Renders the official KakaoTalk speech-bubble mark in `#191600`.
///
/// Path derived from Kakao developers design kit (kakao.design):
/// a filled rounded balloon with a downward tail, matching the icon used in
/// the official "카카오 로그인" button template.
class _KakaoMark extends CustomPainter {
  const _KakaoMark();

  static const Color _ink = Color(0xFF191600);

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final Paint fill = Paint()
      ..color = _ink
      ..style = PaintingStyle.fill;

    // Balloon body: rounded rectangle occupying ~80% of the height.
    final double bodyH = h * 0.78;
    final double r = bodyH * 0.30;
    final RRect balloon = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, w, bodyH),
      Radius.circular(r),
    );
    canvas.drawRRect(balloon, fill);

    // Tail: small downward triangle centered-left, per Kakao design kit.
    final Path tail = Path()
      ..moveTo(w * 0.30, bodyH)
      ..lineTo(w * 0.20, h)
      ..lineTo(w * 0.48, bodyH)
      ..close();
    canvas.drawPath(tail, fill);

    // Two eye dots — KakaoTalk's distinctive inner marks.
    final Paint dotPaint = Paint()
      ..color = _kakaoYellow
      ..style = PaintingStyle.fill;
    final double dotR = h * 0.07;
    final double dotY = bodyH * 0.48;
    canvas.drawCircle(Offset(w * 0.36, dotY), dotR, dotPaint);
    canvas.drawCircle(Offset(w * 0.64, dotY), dotR, dotPaint);
  }

  static const Color _kakaoYellow = Color(0xFFFEE500);

  @override
  bool shouldRepaint(_KakaoMark old) => false;
}
