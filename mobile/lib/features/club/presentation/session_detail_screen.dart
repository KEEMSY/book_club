import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../application/session_agenda_notifier.dart';
import '../application/session_providers.dart';
import '../application/topic_comments_notifier.dart';
import '../domain/agenda_topic.dart';
import '../domain/club_session.dart';
import '../domain/session_agenda.dart';
import '../domain/topic_comment.dart';

/// Session detail — agenda body + a per-topic discussion accordion.
///
/// [session] is always passed via `extra` from the list screen (same
/// no-loader convention as `ClubRoomsScreen`'s `Club` — deep-link resolution
/// by id alone is left to BC-52, which wires notification/feed-card taps).
class SessionDetailScreen extends ConsumerWidget {
  const SessionDetailScreen({super.key, required this.session});

  final ClubSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final agendaAsync = ref.watch(sessionAgendaProvider(session.id));
    final canAuthorAgenda = ref.watch(canAuthorAgendaProvider(session));

    return Scaffold(
      appBar: AppBar(
        title: Text(session.title),
        actions: [
          if (canAuthorAgenda)
            IconButton(
              // Distinct from _NoAgendaState's edit_note_rounded below, so
              // widget tests can tell the AppBar action apart from the
              // empty-state illustration.
              icon: const Icon(Icons.edit_rounded),
              tooltip: '발제문 작성',
              onPressed: () => context.push(
                AppRoutes.agendaEditor(session.clubId, session.id),
                extra: session,
              ),
            ),
        ],
      ),
      body: agendaAsync.when(
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
                Text('발제문을 불러오지 못했어요', style: theme.textTheme.bodyMedium),
                SizedBox(height: spacing.md),
                FilledButton.tonal(
                  onPressed: () =>
                      ref.invalidate(sessionAgendaProvider(session.id)),
                  child: const Text('다시 시도'),
                ),
              ],
            ),
          ),
        ),
        data: (agenda) => agenda == null
            ? _NoAgendaState(spacing: spacing, theme: theme)
            : _AgendaBody(session: session, agenda: agenda),
      ),
    );
  }
}

class _NoAgendaState extends StatelessWidget {
  const _NoAgendaState({required this.spacing, required this.theme});

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
              Icons.edit_note_rounded,
              size: 52,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            SizedBox(height: spacing.md),
            Text(
              '아직 발제문이 게시되지 않았어요',
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _AgendaBody extends StatelessWidget {
  const _AgendaBody({required this.session, required this.agenda});

  final ClubSession session;
  final SessionAgenda agenda;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    return ListView(
      padding: EdgeInsets.all(spacing.md),
      children: [
        if (session.scope != null || agenda.authorName != null)
          Padding(
            padding: EdgeInsets.only(bottom: spacing.sm),
            child: Text(
              [
                if (session.scope != null) '범위 ${session.scope}',
                if (agenda.authorName != null) '발제자 ${agenda.authorName}',
              ].join(' · '),
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
        Card(
          child: Padding(
            padding: EdgeInsets.all(spacing.md),
            child: Text(agenda.body, style: theme.textTheme.bodyMedium),
          ),
        ),
        SizedBox(height: spacing.lg),
        Text(
          '논제',
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        SizedBox(height: spacing.sm),
        ...agenda.topics.map(
          (topic) => _TopicAccordionTile(topic: topic),
        ),
      ],
    );
  }
}

/// One agenda topic rendered as an expandable tile.
///
/// Collapsed state shows the reply count so members can gauge activity at a
/// glance; expanding reveals the latest reply as a preview. The full
/// threaded reply UI (composer, nested rendering, edit/delete) is BC-51,
/// which reuses [topicCommentsProvider] rather than adding a new fetch path.
class _TopicAccordionTile extends ConsumerWidget {
  const _TopicAccordionTile({required this.topic});

  final AgendaTopic topic;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final commentsAsync = ref.watch(topicCommentsProvider(topic.id));

    return Card(
      margin: EdgeInsets.only(bottom: spacing.sm),
      child: commentsAsync.when(
        loading: () => ListTile(
          title: Text(_topicTitle(topic)),
          trailing: const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        error: (_, __) => ListTile(
          title: Text(_topicTitle(topic)),
          subtitle: const Text('답글을 불러오지 못했어요'),
        ),
        data: (comments) {
          final TopicComment? preview = comments.isEmpty ? null : comments.last;
          return ExpansionTile(
            key: PageStorageKey('topic-${topic.id}'),
            title: Text(_topicTitle(topic)),
            subtitle: Text('답글 ${comments.length}개'),
            childrenPadding: EdgeInsets.fromLTRB(
              spacing.md,
              0,
              spacing.md,
              spacing.md,
            ),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (preview == null)
                Text(
                  '아직 답글이 없어요',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      preview.authorName ?? '익명',
                      style: theme.textTheme.labelMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(preview.body, style: theme.textTheme.bodyMedium),
                  ],
                ),
              // TODO(BC-51): reply composer + full nested-thread rendering
              // (all comments, 1-depth replies, edit/delete) replace this
              // single-preview block once the topic-thread screen exists.
            ],
          );
        },
      ),
    );
  }

  String _topicTitle(AgendaTopic topic) => '${topic.position}. ${topic.prompt}';
}
