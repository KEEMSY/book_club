import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Reusable empty-state block: Rausch-tinted icon bubble + primary copy
/// + optional Korean subtitle + optional CTA. Centered on the vertical
/// axis so the same widget fits both a search screen and a library tab.
class BookEmptyState extends StatelessWidget {
  const BookEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final radii = theme.extension<AppRadius>()!;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.all(Radius.circular(radii.md)),
              ),
              child: Icon(
                icon,
                size: 32,
                color: theme.colorScheme.primary.withValues(alpha: 0.85),
              ),
            ),
            SizedBox(height: spacing.md),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge,
            ),
            if (subtitle != null) ...<Widget>[
              SizedBox(height: spacing.xs),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            if (actionLabel != null && onAction != null) ...<Widget>[
              SizedBox(height: spacing.lg),
              FilledButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
