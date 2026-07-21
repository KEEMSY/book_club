import 'package:flutter/material.dart';

import '../../../../core/config/feature_flags.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../shield/presentation/shield_purchase_sheet.dart';

/// "연속 N일 독서 중 🔥" card reused across the dashboard, grade screen,
/// and timer screen. When [streak] is zero we fall back to the longest-
/// ever streak copy so the user still sees a positive framing.
///
/// When [streak] is 0 and [canRecover] is true, a "스트릭 복구하기" button is
/// shown beneath the subtitle. [onRecover] is called when the user confirms
/// the recovery dialog.
class StreakCard extends StatelessWidget {
  const StreakCard({
    super.key,
    required this.streak,
    required this.longest,
    this.compact = false,
    this.canRecover = false,
    this.recoveriesRemaining = 0,
    this.onRecover,
  });

  final int streak;
  final int longest;
  final bool compact;

  /// Whether the user has at least one recovery token remaining.
  final bool canRecover;

  /// Number of recovery tokens remaining — shown in the button label.
  final int recoveriesRemaining;

  /// Called after the user confirms the recovery confirmation dialog.
  final VoidCallback? onRecover;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    final String title;
    final String subtitle;
    if (streak > 0) {
      title = '연속 $streak일 독서 중';
      subtitle = '오늘도 읽으면 기록이 이어져요';
    } else if (longest > 0) {
      title = '최장 기록 $longest일';
      subtitle = '오늘 1분만 읽어도 스트릭 재시작';
    } else {
      title = '아직 연속 기록이 없어요';
      subtitle = '오늘부터 시작해보세요';
    }

    // Only show the recovery affordance when the streak is broken (0) and
    // the user still has tokens remaining.
    final bool showRecover = streak == 0 && canRecover && recoveriesRemaining > 0;

    final AppShadows shadows = theme.extension<AppShadows>()!;
    return Container(
      padding: EdgeInsets.all(compact ? spacing.md : spacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
        ),
        boxShadow: shadows.elevated,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.local_fire_department_rounded,
            color: Color(0xFFE25822),
            size: 32,
          ),
          SizedBox(width: spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  // Secondary reading copy — pull from onSurface at 0.72 so the
                  // line stays AA on both the light parchment card and the
                  // #1F1F1F dark card without flipping between palette tokens.
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
                  ),
                ),
                if (showRecover) ...<Widget>[
                  const SizedBox(height: 4),
                  Row(
                    children: <Widget>[
                      _RecoverButton(
                        recoveriesRemaining: recoveriesRemaining,
                        onRecover: onRecover,
                      ),
                      // Shield IAP deferred (BC-20 scope cleanup): hide the
                      // purchase entry point while the backend router is off.
                      if (FeatureFlags.shield) ...<Widget>[
                        const SizedBox(width: 8),
                        _ShieldPurchaseButton(),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact text button that opens the shield purchase bottom sheet.
class _ShieldPurchaseButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (_) => const ShieldPurchaseSheet(),
      ),
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: const Size(0, 0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
      child: const Text('쉴드 구매'),
    );
  }
}

/// Compact text button that triggers the recovery confirmation dialog.
class _RecoverButton extends StatelessWidget {
  const _RecoverButton({
    required this.recoveriesRemaining,
    required this.onRecover,
  });

  final int recoveriesRemaining;
  final VoidCallback? onRecover;

  Future<void> _confirm(BuildContext context) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('스트릭 복구'),
        content: Text(
          '어제 독서 기록을 복구해 스트릭을 이어갈게요.\n'
          '복구 횟수가 1회 차감됩니다 (남은 횟수: $recoveriesRemaining회).',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('복구하기'),
          ),
        ],
      ),
    );
    if (confirmed == true) onRecover?.call();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => _confirm(context),
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: const Size(0, 0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
      child: Text('스트릭 복구하기 ($recoveriesRemaining회 남음)'),
    );
  }
}
