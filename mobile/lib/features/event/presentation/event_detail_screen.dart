import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../auth/application/auth_notifier.dart';
import '../../auth/domain/auth_state.dart';
import '../application/event_providers.dart';
import '../data/event_repository.dart';
import '../domain/event.dart';

/// Detail view for a single location-based meetup (M68).
///
/// Shows the event's particulars, a join (waitlist) action, the review list,
/// and a creator-only cancel action. The caller's prior waitlist standing is
/// not returned by the backend, so the join state is tracked locally from the
/// join/leave responses this screen issues.
class EventDetailScreen extends ConsumerStatefulWidget {
  const EventDetailScreen({super.key, required this.eventId});

  final String eventId;

  @override
  ConsumerState<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends ConsumerState<EventDetailScreen> {
  // Local join standing, set after a join/leave this session. Null = unknown.
  EventWaitlistStatus? _waitlist;
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final detailAsync = ref.watch(eventDetailProvider(widget.eventId));

    return Scaffold(
      appBar: AppBar(title: const Text('모임 상세')),
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const _CenteredMessage(
          icon: Icons.cloud_off_rounded,
          title: '모임을 불러오지 못했어요',
          subtitle: '다시 시도해 주세요.',
        ),
        data: (EventDetail detail) =>
            _Content(detail: detail, screen: this, spacing: spacing),
      ),
    );
  }

  bool _isHost(EventDetail detail) {
    final auth = ref.read(authNotifierProvider);
    return switch (auth) {
      Authenticated(:final user) => user.id == detail.event.creatorId,
      _ => false,
    };
  }

  Future<void> _join() async {
    setState(() => _busy = true);
    try {
      final status =
          await ref.read(eventRepositoryProvider).joinWaitlist(widget.eventId);
      ref.invalidate(eventDetailProvider(widget.eventId));
      if (!mounted) return;
      setState(() => _waitlist = status);
    } on EventRepositoryException catch (e) {
      _snack(e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _leave() async {
    setState(() => _busy = true);
    try {
      await ref.read(eventRepositoryProvider).leaveWaitlist(widget.eventId);
      ref.invalidate(eventDetailProvider(widget.eventId));
      if (!mounted) return;
      setState(() => _waitlist = null);
    } on EventRepositoryException catch (e) {
      _snack(e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _cancelEvent() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('모임 취소'),
        content: const Text('이 모임을 취소할까요? 되돌릴 수 없습니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('닫기'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('모임 취소'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    setState(() => _busy = true);
    try {
      await ref.read(eventRepositoryProvider).cancelEvent(widget.eventId);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } on EventRepositoryException catch (e) {
      _snack(e.message);
      if (mounted) setState(() => _busy = false);
    }
  }

  void _snack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.detail,
    required this.screen,
    required this.spacing,
  });

  final EventDetail detail;
  final _EventDetailScreenState screen;
  final AppSpacing spacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Event e = detail.event;
    final bool isHost = screen._isHost(detail);

    return ListView(
      padding: EdgeInsets.all(spacing.lg),
      children: <Widget>[
        Text(e.title, style: theme.textTheme.headlineSmall),
        SizedBox(height: spacing.md),
        if (e.description != null && e.description!.isNotEmpty) ...<Widget>[
          Text(e.description!, style: theme.textTheme.bodyMedium),
          SizedBox(height: spacing.md),
        ],
        _InfoLine(
          icon: Icons.schedule_rounded,
          text: _formatDateTime(e.eventAt),
        ),
        if (e.address != null && e.address!.isNotEmpty)
          _InfoLine(icon: Icons.place_outlined, text: e.address!),
        _InfoLine(
          icon: Icons.group_outlined,
          text: e.maxAttendees == null
              ? '${e.joinedCount}명 참여'
              : '${e.joinedCount}/${e.maxAttendees}명 참여',
        ),
        _InfoLine(
          icon: Icons.person_outline_rounded,
          text: isHost ? '내가 주최한 모임' : '주최자가 등록한 모임',
        ),
        SizedBox(height: spacing.lg),
        _JoinButton(screen: screen),
        SizedBox(height: spacing.xl),
        Divider(height: spacing.lg),
        _ReviewsSection(reviews: detail.reviews, spacing: spacing),
        if (isHost) ...<Widget>[
          SizedBox(height: spacing.xl),
          OutlinedButton.icon(
            onPressed: screen._busy ? null : screen._cancelEvent,
            icon: const Icon(Icons.cancel_outlined, size: 18),
            label: const Text('모임 취소'),
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
            ),
          ),
        ],
      ],
    );
  }

  String _formatDateTime(DateTime dt) {
    final DateTime l = dt.toLocal();
    return '${l.year}.${l.month.toString().padLeft(2, '0')}.${l.day.toString().padLeft(2, '0')} '
        '${l.hour.toString().padLeft(2, '0')}:${l.minute.toString().padLeft(2, '0')}';
  }
}

class _JoinButton extends StatelessWidget {
  const _JoinButton({required this.screen});

  final _EventDetailScreenState screen;

  @override
  Widget build(BuildContext context) {
    final EventWaitlistStatus? status = screen._waitlist;
    if (screen._busy) {
      return const Center(child: CircularProgressIndicator());
    }
    if (status == null) {
      return FilledButton.icon(
        onPressed: screen._join,
        icon: const Icon(Icons.how_to_reg_rounded),
        label: const Text('참가 신청'),
      );
    }
    final String label =
        status.confirmed ? '참가 확정됨' : '대기 중 (${status.position}번)';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        FilledButton.tonalIcon(
          onPressed: null,
          icon: Icon(
            status.confirmed
                ? Icons.check_circle_rounded
                : Icons.hourglass_top_rounded,
          ),
          label: Text(label),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: screen._leave,
          child: const Text('참가 취소'),
        ),
      ],
    );
  }
}

class _ReviewsSection extends StatelessWidget {
  const _ReviewsSection({required this.reviews, required this.spacing});

  final EventReviewsResult reviews;
  final AppSpacing spacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text('후기', style: theme.textTheme.titleMedium),
            const Spacer(),
            if (reviews.averageRating != null) ...<Widget>[
              Icon(
                Icons.star_rounded,
                size: 18,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 4),
              Text(
                '${reviews.averageRating!.toStringAsFixed(1)} (${reviews.count})',
                style: theme.textTheme.labelLarge,
              ),
            ],
          ],
        ),
        SizedBox(height: spacing.sm),
        if (reviews.items.isEmpty)
          Text(
            '아직 후기가 없어요.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          )
        else
          for (final EventReview r in reviews.items)
            Padding(
              padding: EdgeInsets.only(bottom: spacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.star_rounded,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        r.rating.toStringAsFixed(1),
                        style: theme.textTheme.labelLarge,
                      ),
                    ],
                  ),
                  if (r.body != null && r.body!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(r.body!, style: theme.textTheme.bodyMedium),
                    ),
                ],
              ),
            ),
      ],
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: <Widget>[
          Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: theme.textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}

class _CenteredMessage extends StatelessWidget {
  const _CenteredMessage({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 48, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(height: 12),
          Text(title, style: theme.textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
