import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/recap_notifier.dart';
import '../../domain/monthly_recap.dart';

/// Persisted key tracking which milestone types have already been shown to the
/// user in-session. Prevents double-toasting within a single app launch.
///
/// This is intentionally an in-memory set — milestones older than the current
/// app session are not re-shown even if the backing provider hasn't been
/// invalidated yet.
final _acknowledgedMilestonesProvider =
    StateProvider<Set<String>>((ref) => <String>{});

/// Icon mapping for each [MilestoneType].
IconData _iconFor(MilestoneType type) {
  switch (type) {
    case MilestoneType.books5:
    case MilestoneType.books10:
    case MilestoneType.books20:
    case MilestoneType.books50:
      return Icons.menu_book_rounded;
    case MilestoneType.hours10:
    case MilestoneType.hours50:
    case MilestoneType.hours100:
      return Icons.timer_rounded;
    case MilestoneType.streak7:
    case MilestoneType.streak30:
      return Icons.local_fire_department_rounded;
  }
}

/// Shows an overlay SnackBar for each unacknowledged [MilestoneItem] in the
/// list returned by [milestonesProvider].
///
/// Call this from a `ref.listen` hook **inside** a [ConsumerStatefulWidget]'s
/// `initState` / `didChangeDependencies`, passing the current [BuildContext]
/// and [WidgetRef]:
///
/// ```dart
/// @override
/// void initState() {
///   super.initState();
///   WidgetsBinding.instance.addPostFrameCallback((_) {
///     checkAndShowMilestoneToasts(context, ref);
///   });
/// }
/// ```
void checkAndShowMilestoneToasts(BuildContext context, WidgetRef ref) {
  final AsyncValue<List<MilestoneItem>> async = ref.read(milestonesProvider);
  async.whenData((items) {
    final Set<String> acknowledged =
        ref.read(_acknowledgedMilestonesProvider);

    // Sort descending by achievedAt so the most-recent milestone is shown last
    // (SnackBars stack; last enqueued appears on top).
    final List<MilestoneItem> unseen = items
        .where((m) => !acknowledged.contains(m.type.wire))
        .toList()
      ..sort((a, b) => a.achievedAt.compareTo(b.achievedAt));

    if (unseen.isEmpty) return;

    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    for (final MilestoneItem milestone in unseen) {
      messenger.showSnackBar(
        SnackBar(
          content: MilestoneToastContent(milestone: milestone),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }

    // Mark all shown milestones as acknowledged for this session.
    ref.read(_acknowledgedMilestonesProvider.notifier).update(
          (s) => {...s, ...unseen.map((m) => m.type.wire)},
        );
  });
}

/// The visual content displayed inside the milestone SnackBar.
class MilestoneToastContent extends StatelessWidget {
  const MilestoneToastContent({super.key, required this.milestone});

  final MilestoneItem milestone;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      children: <Widget>[
        Icon(
          _iconFor(milestone.type),
          color: theme.colorScheme.onInverseSurface,
          size: 22,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            '${milestone.type.celebrationText} 🎉',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onInverseSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
