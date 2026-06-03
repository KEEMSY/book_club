import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../application/recap_notifier.dart';
import '../../application/reading_providers.dart';

/// Seasonal recap banner — shown only in June and December.
///
/// Tapping navigates to [AppRoutes.readingRecap]. The gradient uses the
/// current grade accent color so the banner feels part of the dashboard's
/// color language.
class RecapBanner extends ConsumerWidget {
  const RecapBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final RecapKey? key = currentRecapKey();
    // Hide completely outside the recap window.
    if (key == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final Color accent = ref.watch(gradePrimaryProvider);
    final String halfLabel = key.half == 1 ? '상반기' : '하반기';

    return GestureDetector(
      onTap: () => context.push(
        AppRoutes.readingRecap,
        extra: key,
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: spacing.lg,
          vertical: spacing.md,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              accent,
              accent.withValues(alpha: 0.75),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: accent.withValues(alpha: 0.30),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            const Text('📖', style: TextStyle(fontSize: 28)),
            SizedBox(width: spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${key.year}년 $halfLabel 독서 회고',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '지난 반년의 독서 기록을 돌아봐요',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ],
        ),
      ),
    );
  }
}
