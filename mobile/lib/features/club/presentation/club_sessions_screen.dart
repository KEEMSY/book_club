import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../application/club_session_notifier.dart';
import '../domain/club.dart';
import '../domain/club_session.dart';

/// Standalone screen wrapper — shown when navigated via the router.
///
/// The actual content lives in [ClubSessionsBody] so it can also be embedded
/// as the "회차" tab inside `ClubDetailScreen`, same split as
/// `ClubRoomsScreen`/`ClubRoomsBody`.
class ClubSessionsScreen extends StatelessWidget {
  const ClubSessionsScreen({super.key, required this.club});

  final Club club;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('회차')),
      body: ClubSessionsBody(club: club),
    );
  }
}

/// Session list grouped by book (design doc §7 — "책별 그룹").
///
/// A club can carry several books over its lifetime, each with its own run
/// of sessions, so grouping by book keeps older books' sessions from mixing
/// into the current read's list.
class ClubSessionsBody extends ConsumerWidget {
  const ClubSessionsBody({super.key, required this.club});

  final Club club;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final sessionsAsync = ref.watch(clubSessionsProvider(club.id));

    return sessionsAsync.when(
      loading: () =>
          const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      error: (_, __) => Center(
        child: Padding(
          padding: EdgeInsets.all(spacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
              SizedBox(height: spacing.md),
              Text('회차 목록을 불러오지 못했어요', style: theme.textTheme.bodyMedium),
              SizedBox(height: spacing.md),
              FilledButton.tonal(
                onPressed: () => ref.invalidate(clubSessionsProvider(club.id)),
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
      ),
      data: (sessions) {
        if (sessions.isEmpty) {
          return _EmptyState(spacing: spacing, theme: theme);
        }
        final groups = _groupByBook(sessions);
        return ListView.builder(
          padding: EdgeInsets.all(spacing.md),
          itemCount: groups.length,
          itemBuilder: (_, i) => _BookSessionGroupSection(
            group: groups[i],
            clubId: club.id,
          ),
        );
      },
    );
  }
}

/// Sessions for one book, in the order the book first appears in the list.
class _BookSessionGroup {
  const _BookSessionGroup({
    required this.bookId,
    required this.bookTitle,
    required this.sessions,
  });

  final String bookId;
  final String? bookTitle;
  final List<ClubSession> sessions;
}

/// Groups [sessions] by [ClubSession.bookId], preserving the order each book
/// first appears in — the repository already returns newest-first, so the
/// currently-active book naturally sorts to the top.
List<_BookSessionGroup> _groupByBook(List<ClubSession> sessions) {
  final bookOrder = <String>[];
  final byBook = <String, List<ClubSession>>{};
  for (final session in sessions) {
    byBook.putIfAbsent(session.bookId, () {
      bookOrder.add(session.bookId);
      return <ClubSession>[];
    }).add(session);
  }
  return bookOrder
      .map((bookId) => _BookSessionGroup(
            bookId: bookId,
            bookTitle: byBook[bookId]!.first.bookTitle,
            sessions: byBook[bookId]!,
          ))
      .toList();
}

class _BookSessionGroupSection extends StatelessWidget {
  const _BookSessionGroupSection({required this.group, required this.clubId});

  final _BookSessionGroup group;
  final String clubId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    return Padding(
      padding: EdgeInsets.only(bottom: spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: spacing.sm),
            child: Row(
              children: [
                Icon(
                  Icons.menu_book_rounded,
                  size: 18,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                SizedBox(width: spacing.sm),
                Expanded(
                  child: Text(
                    group.bookTitle ?? '책 미정',
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
          ...group.sessions.map(
            (session) => _SessionCard(session: session, clubId: clubId),
          ),
        ],
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  const _SessionCard({required this.session, required this.clubId});

  final ClubSession session;
  final String clubId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    return Card(
      margin: EdgeInsets.only(bottom: spacing.sm),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push(
          AppRoutes.sessionDetail(clubId, session.id),
          extra: session,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: spacing.md,
            vertical: spacing.sm + 2,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(session.title, style: theme.textTheme.titleSmall),
                    if (session.scheduledAt != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        _formatScheduledAt(session.scheduledAt!),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(width: spacing.sm),
              _StatusBadge(status: session.status),
              Icon(
                Icons.chevron_right_rounded,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatScheduledAt(DateTime dt) {
    final month = dt.month.toString().padLeft(2, '0');
    final day = dt.day.toString().padLeft(2, '0');
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$month.$day $hour:$minute';
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final ClubSessionStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (label, background, foreground) = switch (status) {
      ClubSessionStatus.draft => (
          '작성 중',
          theme.colorScheme.surfaceContainerHighest,
          theme.colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ClubSessionStatus.open => (
          '진행 중',
          theme.colorScheme.primaryContainer,
          theme.colorScheme.primary,
        ),
      ClubSessionStatus.closed => (
          '종료',
          theme.colorScheme.surfaceContainerHighest,
          theme.colorScheme.onSurface.withValues(alpha: 0.4),
        ),
    };

    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: foreground,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.spacing, required this.theme});

  final AppSpacing spacing;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.forum_outlined,
              size: 52,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            SizedBox(height: spacing.md),
            Text(
              '아직 등록된 회차가 없어요',
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.sm),
            Text(
              '호스트가 회차를 만들면 여기에 책별로 모여요',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
