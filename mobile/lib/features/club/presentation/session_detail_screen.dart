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
/// [session] is passed via `extra` from the list screen (same no-loader
/// convention as `ClubRoomsScreen`'s `Club`) or resolved by id alone via
/// [SessionLoader] — the deep-link path BC-52 wires for feed-card taps and
/// push-notification routing.
///
/// [focusTopicId], when set, auto-expands and scrolls to the matching topic
/// tile (`ValueKey('topic-tile-$focusTopicId')`) once the agenda loads — the
/// "논제로 스크롤/포커스" part of the same BC-52 deep link.
class SessionDetailScreen extends ConsumerWidget {
  const SessionDetailScreen({
    super.key,
    required this.session,
    this.focusTopicId,
  });

  final ClubSession session;
  final String? focusTopicId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final agendaAsync = ref.watch(
      sessionAgendaProvider((clubId: session.clubId, sessionId: session.id)),
    );
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
                  onPressed: () => ref.invalidate(
                    sessionAgendaProvider(
                      (clubId: session.clubId, sessionId: session.id),
                    ),
                  ),
                  child: const Text('다시 시도'),
                ),
              ],
            ),
          ),
        ),
        data: (agenda) => agenda == null
            ? _NoAgendaState(spacing: spacing, theme: theme)
            : _AgendaBody(
                session: session,
                agenda: agenda,
                focusTopicId: focusTopicId,
              ),
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
  const _AgendaBody({
    required this.session,
    required this.agenda,
    this.focusTopicId,
  });

  final ClubSession session;
  final SessionAgenda agenda;
  final String? focusTopicId;

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
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: spacing.sm),
        ...agenda.topics.map(
          (topic) => _TopicAccordionTile(
            key: ValueKey('topic-tile-${topic.id}'),
            clubId: session.clubId,
            sessionId: session.id,
            topic: topic,
            isFocused: topic.id == focusTopicId,
          ),
        ),
      ],
    );
  }
}

/// One agenda topic rendered as an expandable tile.
///
/// Collapsed state shows the reply count so members can gauge activity at a
/// glance. Expanding reveals the full thread inline (BC-51): every root
/// comment with its at-most-one-level-deep replies, a composer for new top-
/// level replies or a reply-to-root, and edit/delete actions gated per
/// comment by [canModerateCommentProvider]. This inline-expansion approach
/// (rather than a dedicated thread screen) keeps reusing
/// [topicCommentsProvider] as the single fetch path — same provider BC-49
/// used for the reply-count/preview.
class _TopicAccordionTile extends ConsumerStatefulWidget {
  const _TopicAccordionTile({
    super.key,
    required this.clubId,
    required this.sessionId,
    required this.topic,
    this.isFocused = false,
  });

  final String clubId;
  final String sessionId;
  final AgendaTopic topic;

  /// Set when this tile is the target of a BC-52 deep link
  /// (`SessionDetailScreen.focusTopicId`) — the tile auto-expands and
  /// scrolls itself into view once instead of waiting for a manual tap.
  final bool isFocused;

  @override
  ConsumerState<_TopicAccordionTile> createState() =>
      _TopicAccordionTileState();
}

class _TopicAccordionTileState extends ConsumerState<_TopicAccordionTile> {
  final _composerController = TextEditingController();
  final _editController = TextEditingController();
  TopicComment? _replyTarget;
  String? _editingCommentId;
  bool _isSubmitting = false;

  TopicCommentsKey get _commentsKey => (
        clubId: widget.clubId,
        sessionId: widget.sessionId,
        agendaId: widget.topic.agendaId,
        topicId: widget.topic.id,
      );

  @override
  void initState() {
    super.initState();
    if (widget.isFocused) {
      // Deferred to the next frame so the ExpansionTile (and the topics
      // above it) have already laid out — Scrollable.ensureVisible needs a
      // built RenderObject to compute the scroll offset against.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Scrollable.ensureVisible(
          context,
          alignment: 0.1,
          duration: const Duration(milliseconds: 300),
        );
      });
    }
  }

  @override
  void dispose() {
    _composerController.dispose();
    _editController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final topic = widget.topic;
    final commentsAsync = ref.watch(topicCommentsProvider(_commentsKey));

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
          final roots =
              comments.where((c) => c.parentCommentId == null).toList();
          final repliesByParent = <String, List<TopicComment>>{};
          for (final comment in comments) {
            final parentId = comment.parentCommentId;
            if (parentId == null) continue;
            (repliesByParent[parentId] ??= []).add(comment);
          }

          return ExpansionTile(
            key: PageStorageKey('topic-${topic.id}'),
            initiallyExpanded: widget.isFocused,
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
              if (roots.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: spacing.sm),
                  child: Text(
                    '아직 답글이 없어요',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                )
              else
                for (final root in roots) ...[
                  _CommentTile(
                    comment: root,
                    canModerate: ref.watch(
                      canModerateCommentProvider(
                        (comment: root, clubId: widget.clubId),
                      ),
                    ),
                    isEditing: _editingCommentId == root.id,
                    editController: _editController,
                    onReply: () => _startReply(root),
                    onEdit: () => _startEdit(root),
                    onCancelEdit: _cancelEdit,
                    onSaveEdit: () => _saveEdit(root),
                    onDelete: () => _delete(root),
                  ),
                  for (final reply in repliesByParent[root.id] ?? const [])
                    Padding(
                      padding: EdgeInsets.only(left: spacing.lg),
                      child: _CommentTile(
                        comment: reply,
                        // Replies never get a reply action — the design doc
                        // caps threads at one level (§2 비목표).
                        onReply: null,
                        canModerate: ref.watch(
                          canModerateCommentProvider(
                            (comment: reply, clubId: widget.clubId),
                          ),
                        ),
                        isEditing: _editingCommentId == reply.id,
                        editController: _editController,
                        onEdit: () => _startEdit(reply),
                        onCancelEdit: _cancelEdit,
                        onSaveEdit: () => _saveEdit(reply),
                        onDelete: () => _delete(reply),
                      ),
                    ),
                ],
              SizedBox(height: spacing.sm),
              if (ref.watch(canReplyToTopicProvider(widget.clubId)))
                _ReplyComposer(
                  topicId: topic.id,
                  controller: _composerController,
                  replyTarget: _replyTarget,
                  isSubmitting: _isSubmitting,
                  onCancelReply: _cancelReply,
                  onSubmit: _submitComposer,
                ),
            ],
          );
        },
      ),
    );
  }

  void _startReply(TopicComment root) {
    setState(() {
      _replyTarget = root;
      _editingCommentId = null;
    });
  }

  void _cancelReply() => setState(() => _replyTarget = null);

  void _startEdit(TopicComment comment) {
    _editController.text = comment.body;
    setState(() {
      _editingCommentId = comment.id;
      _replyTarget = null;
    });
  }

  void _cancelEdit() => setState(() => _editingCommentId = null);

  Future<void> _saveEdit(TopicComment comment) async {
    final body = _editController.text.trim();
    if (body.isEmpty) return;
    setState(() => _isSubmitting = true);
    try {
      await ref.read(clubSessionRepositoryProvider).editComment(
            clubId: widget.clubId,
            sessionId: widget.sessionId,
            agendaId: widget.topic.agendaId,
            topicId: widget.topic.id,
            commentId: comment.id,
            body: body,
          );
      ref.invalidate(topicCommentsProvider(_commentsKey));
      if (mounted) setState(() => _editingCommentId = null);
    } catch (_) {
      _showError('답글 수정에 실패했어요. 다시 시도해 주세요.');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _delete(TopicComment comment) async {
    try {
      await ref.read(clubSessionRepositoryProvider).deleteComment(
            clubId: widget.clubId,
            sessionId: widget.sessionId,
            agendaId: widget.topic.agendaId,
            topicId: widget.topic.id,
            commentId: comment.id,
          );
      ref.invalidate(topicCommentsProvider(_commentsKey));
    } catch (_) {
      _showError('답글 삭제에 실패했어요. 다시 시도해 주세요.');
    }
  }

  Future<void> _submitComposer() async {
    final body = _composerController.text.trim();
    if (body.isEmpty) return;
    setState(() => _isSubmitting = true);
    try {
      await ref.read(clubSessionRepositoryProvider).addComment(
            clubId: widget.clubId,
            sessionId: widget.sessionId,
            agendaId: widget.topic.agendaId,
            topicId: widget.topic.id,
            body: body,
            parentCommentId: _replyTarget?.id,
          );
      ref.invalidate(topicCommentsProvider(_commentsKey));
      _composerController.clear();
      if (mounted) setState(() => _replyTarget = null);
    } catch (_) {
      _showError('답글 등록에 실패했어요. 다시 시도해 주세요.');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String _topicTitle(AgendaTopic topic) => '${topic.position}. ${topic.prompt}';
}

/// One comment (root or 1-depth reply) — either its read view (author,
/// body, "(수정됨)" marker, reply/edit/delete actions) or, while
/// [isEditing], an inline body-editing field.
class _CommentTile extends StatelessWidget {
  const _CommentTile({
    required this.comment,
    required this.canModerate,
    required this.isEditing,
    required this.editController,
    required this.onReply,
    required this.onEdit,
    required this.onCancelEdit,
    required this.onSaveEdit,
    required this.onDelete,
  });

  final TopicComment comment;
  final bool canModerate;
  final bool isEditing;
  final TextEditingController editController;

  /// `null` for replies — enforces the design doc's 1-depth cap by simply
  /// not offering a reply action on anything that is itself a reply.
  final VoidCallback? onReply;
  final VoidCallback onEdit;
  final VoidCallback onCancelEdit;
  final VoidCallback onSaveEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    if (isEditing) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: spacing.xs),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              // Distinguishes this field's internal Scrollable from the
              // ExpansionTile's own `PageStorageKey('topic-...')` — without
              // it, PageStorage's ancestor-key walk resolves both to the
              // same identifier and a stored `bool` (expanded state) gets
              // read back where a scroll-offset `double?` is expected.
              key: PageStorageKey('reply-edit-${comment.id}'),
              controller: editController,
              autofocus: true,
              minLines: 1,
              maxLines: 4,
              decoration: const InputDecoration(isDense: true),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: onCancelEdit, child: const Text('취소')),
                TextButton(onPressed: onSaveEdit, child: const Text('저장')),
              ],
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                comment.authorName ?? '익명',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (comment.editedAt != null) ...[
                const SizedBox(width: 4),
                Text(
                  '(수정됨)',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 2),
          Text(comment.body, style: theme.textTheme.bodyMedium),
          Row(
            children: [
              if (onReply != null)
                TextButton(
                  onPressed: onReply,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(48, 32),
                  ),
                  child: const Text('답글'),
                ),
              if (canModerate) ...[
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  tooltip: '답글 수정',
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, size: 18),
                  tooltip: '답글 삭제',
                  onPressed: onDelete,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// Composer for a new top-level reply, or a reply-to-[replyTarget] when one
/// is selected via a root comment's "답글" action.
class _ReplyComposer extends StatelessWidget {
  const _ReplyComposer({
    required this.topicId,
    required this.controller,
    required this.replyTarget,
    required this.isSubmitting,
    required this.onCancelReply,
    required this.onSubmit,
  });

  final String topicId;
  final TextEditingController controller;
  final TopicComment? replyTarget;
  final bool isSubmitting;
  final VoidCallback onCancelReply;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final target = replyTarget;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (target != null)
          Padding(
            padding: EdgeInsets.only(bottom: spacing.xs),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${target.authorName ?? "익명"}님에게 답글 작성 중',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: onCancelReply,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(48, 32),
                  ),
                  child: const Text('취소'),
                ),
              ],
            ),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                // See the matching comment on the edit TextField above —
                // without a distinguishing PageStorageKey this collides
                // with the ExpansionTile's own `PageStorageKey('topic-...')`.
                key: PageStorageKey('reply-composer-$topicId'),
                controller: controller,
                minLines: 1,
                maxLines: 4,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: target != null ? '답글 작성' : '답글을 남겨보세요',
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(width: spacing.sm),
            IconButton.filled(
              icon: isSubmitting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.send_rounded, size: 18),
              tooltip: '등록',
              onPressed: isSubmitting ? null : onSubmit,
            ),
          ],
        ),
      ],
    );
  }
}
