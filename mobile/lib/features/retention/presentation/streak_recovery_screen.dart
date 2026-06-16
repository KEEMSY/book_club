import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../reading/presentation/widgets/streak_card.dart';
import '../../retention/application/retention_providers.dart';
import '../../retention/data/retention_repository.dart';
import '../../shield/presentation/shield_purchase_sheet.dart';

/// Dedicated screen surfacing both streak recovery and shield purchase actions.
///
/// Shown when the user has a broken streak (streak == 0) and navigates to a
/// full-page recovery affordance — as opposed to the inline card on the
/// dashboard. Combining both actions here keeps the navigation model flat: one
/// destination owns all "fix my streak" intent.
class StreakRecoveryScreen extends ConsumerWidget {
  const StreakRecoveryScreen({
    super.key,
    required this.longest,
  });

  final int longest;

  Future<void> _recover(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(retentionRepositoryProvider).recoverStreak();
      ref.invalidate(streakRecoveryStatusProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('스트릭이 복구되었어요!')),
        );
      }
    } on RetentionRepositoryException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    final recoveryAsync = ref.watch(streakRecoveryStatusProvider);
    final bool canRecover = recoveryAsync.valueOrNull?.canRecover ?? false;
    final int remaining = recoveryAsync.valueOrNull?.recoveriesRemaining ?? 0;

    return Scaffold(
      appBar: AppBar(title: const Text('스트릭 관리')),
      body: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreakCard(
              streak: 0,
              longest: longest,
              canRecover: canRecover,
              recoveriesRemaining: remaining,
              onRecover: canRecover ? () => _recover(context, ref) : null,
            ),
            SizedBox(height: spacing.lg),
            OutlinedButton.icon(
              onPressed: () => showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                builder: (_) => const ShieldPurchaseSheet(),
              ),
              icon: const Text('🛡️'),
              label: const Text('쉴드 구매'),
            ),
          ],
        ),
      ),
    );
  }
}
