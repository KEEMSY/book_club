import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../application/monetization_providers.dart';

const Color _kProPurple = Color(0xFF6B21A8);

/// Compact banner shown while the user is inside their Pro free-trial window.
///
/// Watches [trialStatusProvider]; renders nothing unless the user is currently
/// in trial with at least one day left. Tapping "구독하기" routes to the paywall
/// so the trial can convert before it lapses. Designed to sit at the top of the
/// dashboard list, so it relies on the parent's horizontal padding and only
/// carries a bottom margin to separate itself from the sections below.
class TrialBanner extends ConsumerWidget {
  const TrialBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trial = ref.watch(trialStatusProvider);
    return trial.maybeWhen(
      data: (status) {
        if (!status.isInTrial || status.daysRemaining <= 0) {
          return const SizedBox.shrink();
        }
        return _Banner(daysRemaining: status.daysRemaining);
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({required this.daysRemaining});

  final int daysRemaining;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _kProPurple.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _kProPurple.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          const Icon(Icons.workspace_premium_rounded,
              color: _kProPurple, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Pro 7일 체험 중 · $daysRemaining일 남음',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: _kProPurple,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () => context.push(AppRoutes.paywall),
            style: TextButton.styleFrom(
              foregroundColor: _kProPurple,
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
            child: const Text('구독하기',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
