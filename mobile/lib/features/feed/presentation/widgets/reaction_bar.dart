import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../application/book_feed_notifier.dart';
import '../../application/feed_providers.dart';
import '../../data/feed_repository.dart';
import '../../domain/post.dart';
import '../../domain/reaction_type.dart';

/// Horizontal reaction chip strip — 5 fixed reactions with a count.
///
/// Idle chip uses `surfaceContainerHigh` background + onSurface icon. Active
/// chip (in `myReactions`) uses primary fill + onPrimary icon so the toggle
/// state reads at-a-glance. Tapping fires
/// `feedRepository.toggleReaction` and reconciles the cached post with the
/// server-canonical counts via [BookFeedNotifier.applyReactionResult].
class ReactionBar extends ConsumerStatefulWidget {
  const ReactionBar({
    super.key,
    required this.bookId,
    required this.post,
  });

  final String bookId;
  final Post post;

  @override
  ConsumerState<ReactionBar> createState() => _ReactionBarState();
}

class _ReactionBarState extends ConsumerState<ReactionBar> {
  final Set<ReactionType> _inFlight = <ReactionType>{};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: <Widget>[
        for (final ReactionType type in ReactionType.values)
          _ReactionChip(
            type: type,
            count: widget.post.reactions[type] ?? 0,
            active: widget.post.myReactions.contains(type),
            loading: _inFlight.contains(type),
            onTap: () => _toggle(type, theme),
          ),
      ],
    );
  }

  Future<void> _toggle(ReactionType type, ThemeData theme) async {
    if (_inFlight.contains(type)) return;
    setState(() => _inFlight.add(type));
    final messenger = ScaffoldMessenger.of(context);
    try {
      final result = await ref
          .read(feedRepositoryProvider)
          .toggleReaction(postId: widget.post.id, reactionType: type);
      ref
          .read(bookFeedNotifierProvider(widget.bookId).notifier)
          .applyReactionResult(
            postId: widget.post.id,
            reactionType: type,
            toggleState: result.state,
            counts: result.counts,
          );
      if (result.state == ReactionToggleState.added) {
        HapticFeedback.lightImpact();
      }
    } on FeedRepositoryException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _inFlight.remove(type));
    }
  }
}

class _ReactionChip extends StatelessWidget {
  const _ReactionChip({
    required this.type,
    required this.count,
    required this.active,
    required this.loading,
    required this.onTap,
  });

  final ReactionType type;
  final int count;
  final bool active;
  final bool loading;
  final VoidCallback onTap;

  IconData get _icon {
    switch (type) {
      case ReactionType.idea:
        return Icons.lightbulb_outline_rounded;
      case ReactionType.fire:
        return Icons.local_fire_department_outlined;
      case ReactionType.think:
        return Icons.psychology_outlined;
      case ReactionType.clap:
        return Icons.sign_language_outlined;
      case ReactionType.heart:
        return Icons.favorite_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radii = theme.extension<AppRadius>()!;

    final Color bg = active
        ? theme.colorScheme.primary
        : theme.colorScheme.surfaceContainerHigh;
    final Color fg =
        active ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface;

    return Material(
      color: bg,
      borderRadius: BorderRadius.all(Radius.circular(radii.pill)),
      child: InkWell(
        onTap: loading ? null : onTap,
        borderRadius: BorderRadius.all(Radius.circular(radii.pill)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(_icon, size: 16, color: fg),
              const SizedBox(width: 6),
              Text(
                '$count',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: fg,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
