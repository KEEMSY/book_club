import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../application/notification_notifier.dart';
import '../application/notification_state.dart';
import '../data/notification_models.dart';

/// Deep-link target resolved from a notification's `ntype` + `data` payload.
///
/// [useGo] is `true` only for the `comment`/`reaction` case, which
/// intentionally replaces the stack (lands on the community tab) rather
/// than pushing atop it — every other case pushes.
typedef NotificationDeepLink = ({String path, bool useGo});

/// Resolves [dto]'s tap destination, or `null` when its `ntype` has none.
///
/// Pure — no `BuildContext`/go_router — so it's unit-testable without
/// pumping the full [NotificationScreen], whose notifier opens a live
/// WebSocket connection in `build()`.
NotificationDeepLink? notificationDeepLink(NotificationDto dto) {
  switch (dto.ntype) {
    case 'follow_received':
      final followerId = dto.data['follower_id'];
      if (followerId != null) {
        return (path: AppRoutes.userProfile(followerId), useGo: false);
      }
    case 'badge_earned':
      return (path: AppRoutes.badges, useGo: false);
    case 'grade_up':
      return (path: AppRoutes.grade, useGo: false);
    case 'weekly_report':
      return (path: AppRoutes.weeklyReport, useGo: false);
    case 'comment' || 'reaction':
      // TODO(feed): no standalone post-detail route exists yet; the feed
      // lives inside the community tab, so route there until a
      // `/feed/post/:id` screen ships. (owner: feed team)
      return (path: AppRoutes.community, useGo: true);
    case 'club_chat' || 'chat_mention':
      // Payload carries only the club id (no room id), so open the
      // club-level chat, which loads the club by id.
      final clubId = dto.data['club_id'];
      if (clubId != null) {
        return (path: AppRoutes.clubChat(clubId), useGo: false);
      }
    case 'challenge_started' ||
          'challenge_completed' ||
          'challenge_joined' ||
          'challenge_reminder':
      final challengeId = dto.data['challenge_id'];
      if (challengeId != null) {
        return (path: AppRoutes.challengeDetail(challengeId), useGo: false);
      }
    case 'club_joined' || 'club_invite':
      final clubId = dto.data['club_id'];
      if (clubId != null) {
        return (path: AppRoutes.clubDetail(clubId), useGo: false);
      }
    // BC-52 — club session/agenda/discussion events. These ntype strings
    // are provisional: BC-48 (backend notification integration) hasn't
    // landed yet, so they're chosen to match the feed event types BC-47
    // already shipped (`session_opened`/`agenda_published`/
    // `discussion_commented` in `feed/models.py`'s `FeedEventType`), which
    // follow the same lowercase-snake convention as the existing
    // `club_joined`/`club_chat` ntypes above. Confirm/adjust once BC-48
    // lands with its actual `ntype` values.
    case 'session_opened' || 'agenda_published' || 'discussion_commented':
      final clubId = dto.data['club_id'];
      final sessionId = dto.data['session_id'];
      if (clubId != null && sessionId != null) {
        return (
          path: AppRoutes.sessionDetail(
            clubId,
            sessionId,
            topicId: dto.data['topic_id'],
          ),
          useGo: false,
        );
      }
  }
  return null;
}

/// Notification bell icon with unread badge — placed in AppBar actions.
///
/// Fetches the unread count once on mount. A full real-time approach
/// (WebSocket / FCM badge) is deferred to M6; this covers the M5 contract.
class NotificationBell extends ConsumerStatefulWidget {
  const NotificationBell({super.key});

  @override
  ConsumerState<NotificationBell> createState() => _NotificationBellState();
}

class _NotificationBellState extends ConsumerState<NotificationBell> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationNotifierProvider.notifier).refreshUnreadCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    final int count = ref.watch(
      notificationNotifierProvider.select((s) => s.unreadCount),
    );
    return IconButton(
      tooltip: '알림',
      onPressed: () => context.push(AppRoutes.notifications),
      icon: Badge(
        isLabelVisible: count > 0,
        label: Text(count > 99 ? '99+' : '$count'),
        child: const Icon(Icons.notifications_outlined),
      ),
    );
  }
}

/// Full-page notification list reachable via `AppRoutes.notifications`.
///
/// Uses a `CustomScrollView` + `SliverList` so the AppBar pin and the
/// infinite-scroll trigger coexist without a nested `ListView`.
class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  final ScrollController _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationNotifierProvider.notifier).load();
    });
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 200) {
      ref.read(notificationNotifierProvider.notifier).loadMore();
    }
  }

  VoidCallback? _buildNavigate(BuildContext context, NotificationDto dto) {
    final target = notificationDeepLink(dto);
    if (target == null) return null;
    return target.useGo
        ? () => context.go(target.path)
        : () => context.push(target.path);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final NotificationState state = ref.watch(notificationNotifierProvider);

    return Scaffold(
      body: RefreshIndicator(
        color: theme.colorScheme.primary,
        onRefresh: () => ref.read(notificationNotifierProvider.notifier).load(),
        child: CustomScrollView(
          controller: _scroll,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              pinned: true,
              title: Row(
                children: [
                  Text('알림', style: theme.textTheme.titleLarge),
                  if (state.unreadCount > 0) ...[
                    SizedBox(width: spacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(1000),
                      ),
                      child: Text(
                        '${state.unreadCount}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              actions: [
                if (state.unreadCount > 0)
                  TextButton(
                    onPressed: () => ref
                        .read(notificationNotifierProvider.notifier)
                        .markAllRead(),
                    child: Text(
                      '모두 읽음',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
              ],
            ),
            if (state.isLoading && state.items.isEmpty)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (state.error != null && state.items.isEmpty)
              SliverFillRemaining(
                child: _EmptyOrError(message: state.error!, isError: true),
              )
            else if (state.items.isEmpty)
              const SliverFillRemaining(
                child: _EmptyOrError(message: '아직 알림이 없어요', isError: false),
              )
            else ...[
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final item = state.items[index];
                  return _NotificationCard(
                    dto: item,
                    onTap: () => ref
                        .read(notificationNotifierProvider.notifier)
                        .markRead(item.id),
                    onNavigate: _buildNavigate(context, item),
                  );
                }, childCount: state.items.length),
              ),
              if (state.isLoading)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _EmptyOrError extends StatelessWidget {
  const _EmptyOrError({required this.message, required this.isError});

  final String message;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isError ? Icons.error_outline : Icons.notifications_none_outlined,
            size: 48,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Single notification row card.
///
/// Unread items use `primaryContainer` tinted surface so they stand out
/// without shouting — Airbnb's "subtle highlight on a light canvas" principle.
class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.dto,
    required this.onTap,
    required this.onNavigate,
  });

  final NotificationDto dto;
  final VoidCallback onTap;
  final VoidCallback? onNavigate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final bool unread = dto.readAt == null;

    return InkWell(
      onTap: () {
        onTap();
        onNavigate?.call();
      },
      child: Container(
        color:
            unread ? theme.colorScheme.primary.withValues(alpha: 0.06) : null,
        padding: EdgeInsets.symmetric(
          horizontal: spacing.lg,
          vertical: spacing.md,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _NtypeIcon(ntype: dto.ntype),
            SizedBox(width: spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          dto.title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight:
                                unread ? FontWeight.w600 : FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: spacing.sm),
                      Text(
                        _relativeTime(dto.createdAt),
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dto.body,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _relativeTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) {
      return '방금';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}분 전';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}시간 전';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}일 전';
    }
    return DateFormat('M월 d일', 'ko').format(dt);
  }
}

class _NtypeIcon extends StatelessWidget {
  const _NtypeIcon({required this.ntype});

  final String ntype;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (String emoji, Color bg) = switch (ntype) {
      'reaction' => ('❤️', const Color(0xFFFFEBEE)),
      'comment' => ('💬', const Color(0xFFE3F2FD)),
      'grade_up' => ('🌱', const Color(0xFFE8F5E9)),
      'weekly_report' => ('📊', const Color(0xFFF3E5F5)),
      'follow_received' => ('👥', const Color(0xFFE3F2FD)),
      'badge_earned' => ('🏅', const Color(0xFFFFF8E1)),
      // Chat / club types
      'club_chat' || 'chat_mention' => ('💬', const Color(0xFFE8EAF6)),
      // Challenge types
      'challenge_started' || 'challenge_completed' || 'challenge_joined' => (
          '🏆',
          const Color(0xFFFFF3E0)
        ),
      'challenge_reminder' => ('⏰', const Color(0xFFFFF3E0)),
      // Club activity
      'club_joined' || 'club_invite' => ('📚', const Color(0xFFE8F5E9)),
      // BC-52 — club session/agenda/discussion events.
      'session_opened' => ('🗓️', const Color(0xFFE8F5E9)),
      'agenda_published' => ('✍️', const Color(0xFFFFF3E0)),
      'discussion_commented' => ('💬', const Color(0xFFE3F2FD)),
      _ => ('🔔', theme.colorScheme.surfaceContainer),
    };

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(emoji, style: const TextStyle(fontSize: 20)),
    );
  }
}
