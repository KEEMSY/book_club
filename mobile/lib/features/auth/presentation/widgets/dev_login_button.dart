import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// DEBUG-ONLY widget. Guarded by [kDebugMode] in LoginScreen.
/// Remove once /auth/dev-login is removed from the backend or staging
/// credentials are provisioned for all developers.
///
/// Dev-only CTA surfaced while Kakao/Apple credentials are still being
/// provisioned. Styled as an Airbnb-toned outlined button (Rausch border,
/// Rausch label, pill-ish 12pt radius) so it reads as an intentional
/// placeholder and not a debug affordance we forgot to remove.
class DevLoginButton extends StatelessWidget {
  const DevLoginButton({
    super.key,
    required this.onPressed,
    this.label = '개발용 로그인',
    this.isLoading = false,
  });

  final VoidCallback? onPressed;
  final String label;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final Color brand = theme.colorScheme.primary;

    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: brand,
          side: BorderSide(color: brand, width: 1.4),
          disabledForegroundColor: brand.withValues(alpha: 0.5),
          padding: EdgeInsets.symmetric(horizontal: spacing.md),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          textStyle: theme.textTheme.labelLarge?.copyWith(
            color: brand,
            fontWeight: FontWeight.w600,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.bolt_outlined, size: 18, color: brand),
            SizedBox(width: spacing.sm),
            Text(label),
          ],
        ),
      ),
    );
  }
}
