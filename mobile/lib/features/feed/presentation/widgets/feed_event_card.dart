import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/feed_repository.dart';
import '../../domain/feed_event.dart';
import '../../domain/feed_reaction.dart';
import '../../application/feed_providers.dart';

/// Card that renders a single [FeedEvent] (activity-event feed entry).
///
/// Layout:
///   * Header — user id chip · event-type label · relative time
///   * Activity body — emoji + human-readable summary from [event_metadata]
///   * Emoji reaction bar (5 fixed emoji: ❤️ 🔥 👏 📚 💪)
///   * Comment count chip → opens [FeedCommentSheet]
class FeedEventCard extends ConsumerWidget {
  const FeedEventCard({
    super.key,
    required this.event,
    required this.currentUserId,
    required this.onTapComments,
    required this.onReactionToggled,
  });

  final FeedEvent event;
  final String currentUserId;
  final VoidCallback onTapComments;

  /// Called after a successful toggle with (emoji, added).
  final void Function(String emoji, bool added) onReactionToggled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final shadows = theme.extension<AppShadows>()!;
    final radii = theme.extension<AppRadius>()!;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.all(Radius.circular(radii.md)),
        boxShadow: shadows.elevated,
      ),
      padding: EdgeInsets.fromLTRB(
        spacing.md,
        spacing.md,
        spacing.md,
        spacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _EventHeader(event: event),
          SizedBox(height: spacing.sm),
          _EventBody(event: event),
          SizedBox(height: spacing.sm),
          _FeedReactionBar(
            event: event,
            currentUserId: currentUserId,
            onReactionToggled: onReactionToggled,
          ),
          SizedBox(height: spacing.xs),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: onTapComments,
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.onSurfaceVariant,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              icon: const Icon(Icons.mode_comment_outlined, size: 16),
              label: Text('댓글 ${event.commentCount}'),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Header
// ---------------------------------------------------------------------------

class _EventHeader extends StatelessWidget {
  const _EventHeader({required this.event});

  final FeedEvent event;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: <Widget>[
        // User id shortened chip — real user data lives in a future profile
        // provider; for now we show the first 8 chars of the UUID.
        Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHigh,
            shape: BoxShape.circle,
          ),
          child: const Text(
            '👤',
            style: TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _eventTypeLabel(event.eventType),
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                _relativeTime(event.createdAt),
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
        _EventTypePill(eventType: event.eventType),
      ],
    );
  }

  static String _eventTypeLabel(String eventType) {
    switch (eventType) {
      case 'BOOK_COMPLETED':
        return '완독 달성';
      case 'CHAPTER_MILESTONE':
        return '챕터 완료';
      case 'STREAK_MILESTONE':
        return '연속 독서';
      case 'CLUB_JOINED':
        return '클럽 참여';
      default:
        return '독서 활동';
    }
  }
}

class _EventTypePill extends StatelessWidget {
  const _EventTypePill({required this.eventType});

  final String eventType;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (String label, Color color) = _pillStyle(eventType, theme);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static (String, Color) _pillStyle(String eventType, ThemeData theme) {
    switch (eventType) {
      case 'BOOK_COMPLETED':
        return ('완독', theme.colorScheme.primary);
      case 'CHAPTER_MILESTONE':
        return ('챕터', theme.colorScheme.tertiary);
      case 'STREAK_MILESTONE':
        return ('스트릭', Colors.orange);
      case 'CLUB_JOINED':
        return ('클럽', theme.colorScheme.secondary);
      default:
        return ('활동', theme.colorScheme.onSurfaceVariant);
    }
  }
}

// ---------------------------------------------------------------------------
// Body — event-type-specific summary
// ---------------------------------------------------------------------------

class _EventBody extends StatelessWidget {
  const _EventBody({required this.event});

  final FeedEvent event;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radii = theme.extension<AppRadius>()!;
    final spacing = theme.extension<AppSpacing>()!;

    final (String emoji, String label, String sub) =
        _eventSummary(event.eventType, event.eventMetadata);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.md,
        vertical: spacing.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.all(Radius.circular(radii.sm)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(emoji, style: const TextStyle(fontSize: 28)),
          SizedBox(width: spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  label,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
                if (sub.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 2),
                  Text(
                    sub,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  static (String, String, String) _eventSummary(
    String eventType,
    Map<String, dynamic> meta,
  ) {
    switch (eventType) {
      case 'BOOK_COMPLETED':
        final bookTitle = (meta['book_title'] as String?) ?? '';
        return ('✅', '완독했어요!', bookTitle);
      case 'CHAPTER_MILESTONE':
        final chapter = meta['chapter_number'];
        final bookTitle = (meta['book_title'] as String?) ?? '';
        final chapterStr = chapter != null ? '$chapter장 완료' : '챕터 완료';
        return ('📖', chapterStr, bookTitle);
      case 'STREAK_MILESTONE':
        final days = meta['streak_days'];
        final daysStr = days != null ? '$days일 연속 독서!' : '연속 독서 달성!';
        return ('🔥', daysStr, '');
      case 'CLUB_JOINED':
        final clubName = (meta['club_name'] as String?) ?? '';
        return ('👋', '북클럽에 참여했어요!', clubName);
      default:
        return ('📚', '독서 활동', '');
    }
  }
}

// ---------------------------------------------------------------------------
// Reaction bar — 5 fixed emoji
// ---------------------------------------------------------------------------

const List<String> _kFeedEmoji = ['❤️', '🔥', '👏', '📚', '💪'];

class _FeedReactionBar extends ConsumerStatefulWidget {
  const _FeedReactionBar({
    required this.event,
    required this.currentUserId,
    required this.onReactionToggled,
  });

  final FeedEvent event;
  final String currentUserId;
  final void Function(String emoji, bool added) onReactionToggled;

  @override
  ConsumerState<_FeedReactionBar> createState() => _FeedReactionBarState();
}

class _FeedReactionBarState extends ConsumerState<_FeedReactionBar> {
  final Set<String> _inFlight = <String>{};

  @override
  Widget build(BuildContext context) {
    // Count each emoji and check whether the current user has applied it.
    final Map<String, int> counts = <String, int>{};
    final Set<String> mine = <String>{};
    for (final FeedReaction r in widget.event.reactions) {
      counts[r.emoji] = (counts[r.emoji] ?? 0) + 1;
      if (r.userId == widget.currentUserId) {
        mine.add(r.emoji);
      }
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: <Widget>[
        for (final String emoji in _kFeedEmoji)
          _EmojiChip(
            emoji: emoji,
            count: counts[emoji] ?? 0,
            active: mine.contains(emoji),
            loading: _inFlight.contains(emoji),
            onTap: () => _toggle(emoji, mine.contains(emoji)),
          ),
      ],
    );
  }

  Future<void> _toggle(String emoji, bool currentlyActive) async {
    if (_inFlight.contains(emoji)) return;
    setState(() => _inFlight.add(emoji));
    final messenger = ScaffoldMessenger.of(context);
    try {
      final result = await ref
          .read(feedRepositoryProvider)
          .toggleFeedReaction(eventId: widget.event.id, emoji: emoji);
      widget.onReactionToggled(emoji, result.added);
      if (result.added) HapticFeedback.lightImpact();
    } on FeedRepositoryException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _inFlight.remove(emoji));
    }
  }
}

class _EmojiChip extends StatelessWidget {
  const _EmojiChip({
    required this.emoji,
    required this.count,
    required this.active,
    required this.loading,
    required this.onTap,
  });

  final String emoji;
  final int count;
  final bool active;
  final bool loading;
  final VoidCallback onTap;

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
              Text(emoji, style: const TextStyle(fontSize: 14)),
              if (count > 0) ...<Widget>[
                const SizedBox(width: 4),
                Text(
                  '$count',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: fg,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

String _relativeTime(DateTime created) {
  final DateTime now = DateTime.now();
  final Duration diff = now.difference(created);
  if (diff.inSeconds < 60) return '방금 전';
  if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
  if (diff.inHours < 24) return '${diff.inHours}시간 전';
  if (diff.inDays < 7) return '${diff.inDays}일 전';
  return '${created.year}.${created.month.toString().padLeft(2, '0')}.${created.day.toString().padLeft(2, '0')}';
}
