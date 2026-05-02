import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../application/club_providers.dart';
import '../domain/club.dart';
import 'create_event_sheet.dart';

// Club events provider — keyed by club id.
final _clubEventsProvider =
    FutureProvider.autoDispose.family<List<ClubEvent>, String>(
  (ref, clubId) => ref.watch(clubRepositoryProvider).listEvents(clubId),
);

class ClubDetailScreen extends ConsumerWidget {
  const ClubDetailScreen({super.key, required this.club});

  final Club club;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final eventsAsync = ref.watch(_clubEventsProvider(club.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(club.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('초대 코드: ${club.inviteCode}')),
              );
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(spacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (club.description != null) ...[
                    Text(club.description!, style: theme.textTheme.bodyMedium),
                    SizedBox(height: spacing.md),
                  ],
                  Text(
                    '${club.memberCount}/${club.maxMembers}명 참여 중',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  SizedBox(height: spacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '모임 일정',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      TextButton.icon(
                        onPressed: () async {
                          await CreateEventSheet.show(
                            context,
                            clubId: club.id,
                          );
                          ref.invalidate(_clubEventsProvider(club.id));
                        },
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('일정 추가'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          eventsAsync.when(
            loading: () => const SliverToBoxAdapter(
              child: Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            error: (_, __) => SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(spacing.lg),
                child: Text(
                  '모임을 불러오지 못했어요',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ),
            data: (events) => events.isEmpty
                ? SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(spacing.lg),
                      child: Text(
                        '아직 예정된 모임이 없어요',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.5),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : SliverPadding(
                    padding:
                        EdgeInsets.symmetric(horizontal: spacing.md),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (_, i) => _EventCard(
                          event: events[i],
                          clubId: club.id,
                        ),
                        childCount: events.length,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _EventCard extends ConsumerWidget {
  const _EventCard({required this.event, required this.clubId});

  final ClubEvent event;
  final String clubId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final isOnline = event.eventType == 'online';

    return Card(
      margin: EdgeInsets.only(bottom: spacing.sm),
      child: Padding(
        padding: EdgeInsets.all(spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isOnline
                      ? Icons.videocam_rounded
                      : Icons.place_rounded,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  isOnline ? '온라인' : '오프라인',
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: theme.colorScheme.primary),
                ),
              ],
            ),
            SizedBox(height: spacing.xs),
            Text(event.title, style: theme.textTheme.titleSmall),
            if (event.location != null) ...[
              SizedBox(height: spacing.xs),
              Text(
                event.location!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
            SizedBox(height: spacing.xs),
            Text(
              _formatDate(event.scheduledAt),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            SizedBox(height: spacing.sm),
            _RsvpButtons(event: event, clubId: clubId),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) =>
      '${dt.year}.${dt.month.toString().padLeft(2, '0')}.${dt.day.toString().padLeft(2, '0')} '
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}

class _RsvpButtons extends ConsumerWidget {
  const _RsvpButtons({required this.event, required this.clubId});

  final ClubEvent event;
  final String clubId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Text(
          '${event.goingCount}명 참석',
          style: theme.textTheme.labelSmall,
        ),
        if (event.maybeCount > 0) ...[
          const SizedBox(width: 8),
          Text(
            '${event.maybeCount}명 미정',
            style: theme.textTheme.labelSmall?.copyWith(
              color:
                  theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
        const Spacer(),
        _RsvpChip(
          label: '갈게요',
          value: 'going',
          selected: event.myRsvp == 'going',
          onTap: () => _rsvp(ref, context, 'going'),
        ),
        const SizedBox(width: 4),
        _RsvpChip(
          label: '미정',
          value: 'maybe',
          selected: event.myRsvp == 'maybe',
          onTap: () => _rsvp(ref, context, 'maybe'),
        ),
      ],
    );
  }

  Future<void> _rsvp(WidgetRef ref, BuildContext context, String status) async {
    try {
      await ref.read(clubRepositoryProvider).rsvp(clubId, event.id, status);
      ref.invalidate(_clubEventsProvider(clubId));
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('RSVP 처리에 실패했습니다.')),
        );
      }
    }
  }
}

class _RsvpChip extends StatelessWidget {
  const _RsvpChip({
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String value;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: selected
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: selected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
