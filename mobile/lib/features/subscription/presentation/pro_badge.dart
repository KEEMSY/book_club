import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../application/subscription_notifier.dart';

/// Small inline "PRO" badge displayed next to the user's nickname when they
/// have an active Pro subscription.
///
/// Watches [subscriptionNotifierProvider] so it updates automatically if the
/// subscription state changes within the current session.
class ProBadge extends ConsumerWidget {
  const ProBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionAsync = ref.watch(subscriptionNotifierProvider);
    final isPro = subscriptionAsync.maybeWhen(
      data: (s) => s.isPro,
      orElse: () => false,
    );

    if (!isPro) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF6B21A8), // deep purple — Pro brand colour
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        'PRO',
        style: theme.textTheme.labelSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
          height: 1.2,
        ),
      ),
    );
  }
}
