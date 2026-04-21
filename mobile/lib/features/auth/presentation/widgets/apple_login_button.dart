import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Apple-brand black login button.
///
/// Apple's Human Interface Guidelines mandate the specific "Continue with
/// Apple" button treatment when Apple Sign In is offered alongside other
/// providers. We follow the two most-enforced rules at M1:
///   - black background with white label on light mode
///   - corner radius matches surrounding buttons (12px) — HIG allows this
///     as long as the Apple logo and "Continue with Apple" wording are
///     preserved, which we do via the leading glyph + localized label.
///
/// When a real SVG of the Apple logo is prepped (M2+), replace the icon
/// child with the glyph; rendering the rest of the button stays identical.
class AppleLoginButton extends StatelessWidget {
  const AppleLoginButton({
    super.key,
    required this.onPressed,
    this.label = 'Apple로 계속하기',
    this.isLoading = false,
  });

  final VoidCallback? onPressed;
  final String label;
  final bool isLoading;

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
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.black.withValues(alpha: 0.7),
          disabledForegroundColor: Colors.white.withValues(alpha: 0.6),
          padding: EdgeInsets.symmetric(horizontal: spacing.md),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          textStyle: theme.textTheme.labelLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.apple, size: 20, color: Colors.white),
            SizedBox(width: spacing.sm),
            Text(label),
          ],
        ),
      ),
    );
  }
}
