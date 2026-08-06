import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../application/agenda_editor_notifier.dart';
import '../application/session_agenda_notifier.dart';
import '../application/session_providers.dart';
import '../domain/agenda_topic.dart';
import '../domain/club_session.dart';
import '../domain/session_agenda.dart';

/// Agenda ("발제문") authoring editor for a session's host/presenter (BC-50).
///
/// Body text + an ordered topic list (add / delete / drag-to-reorder), with
/// separate "임시저장" and "게시" actions mirroring `session_agendas.status`
/// (design doc §4.1: draft → published, no unpublish). Topic mutations
/// write straight through the repository and refresh immediately — only the
/// body text is held locally until an explicit save/publish, since a text
/// field can't reasonably autosave on every keystroke.
///
/// Entry is gated on [canAuthorAgendaProvider]: `SessionDetailScreen` only
/// shows the AppBar action that opens this screen to an author, and this
/// screen re-checks the same provider itself so a direct deep link can't
/// bypass the gate.
class AgendaEditorScreen extends ConsumerStatefulWidget {
  const AgendaEditorScreen({super.key, required this.session});

  final ClubSession session;

  @override
  ConsumerState<AgendaEditorScreen> createState() => _AgendaEditorScreenState();
}

class _AgendaEditorScreenState extends ConsumerState<AgendaEditorScreen> {
  final _bodyController = TextEditingController();
  bool _bodyInitialized = false;
  bool _isSavingDraft = false;
  bool _isPublishing = false;
  bool _isFetchingRecommendations = false;

  @override
  void dispose() {
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final session = widget.session;
    final canAuthor = ref.watch(canAuthorAgendaProvider(session));

    if (!canAuthor) {
      return _AccessDeniedScaffold(spacing: spacing, theme: theme);
    }

    final agendaKey = (clubId: session.clubId, sessionId: session.id);
    final agendaAsync = ref.watch(agendaForEditProvider(agendaKey));

    return Scaffold(
      appBar: AppBar(title: const Text('발제문 작성')),
      body: agendaAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        error: (_, __) => Center(
          child: Padding(
            padding: EdgeInsets.all(spacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('발제문을 불러오지 못했어요', style: theme.textTheme.bodyMedium),
                SizedBox(height: spacing.md),
                FilledButton.tonal(
                  onPressed: () =>
                      ref.invalidate(agendaForEditProvider(agendaKey)),
                  child: const Text('다시 시도'),
                ),
              ],
            ),
          ),
        ),
        data: (agenda) {
          if (!_bodyInitialized) {
            _bodyController.text = agenda.body;
            _bodyInitialized = true;
          }
          return _EditorBody(
            session: session,
            agenda: agenda,
            bodyController: _bodyController,
            isSavingDraft: _isSavingDraft,
            isPublishing: _isPublishing,
            isFetchingRecommendations: _isFetchingRecommendations,
            onSaveDraft: () => _saveDraft(agenda),
            onPublish: () => _publish(agenda),
            onAddTopic: () => _addTopic(agenda),
            onRemoveTopic: (topicId) => _removeTopic(agenda, topicId),
            onReorderTopics: (orderedIds) => _reorderTopics(agenda, orderedIds),
            onAiRecommend: () => _showAiRecommendations(agenda),
          );
        },
      ),
    );
  }

  Future<void> _saveDraft(SessionAgenda agenda) async {
    setState(() => _isSavingDraft = true);
    try {
      await ref.read(clubSessionRepositoryProvider).saveAgendaDraft(
            clubId: widget.session.clubId,
            sessionId: widget.session.id,
            agendaId: agenda.id,
            body: _bodyController.text.trim(),
          );
      _refresh();
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('임시저장했어요')));
      }
    } catch (_) {
      _showError('임시저장에 실패했어요. 다시 시도해 주세요.');
    } finally {
      if (mounted) setState(() => _isSavingDraft = false);
    }
  }

  Future<void> _publish(SessionAgenda agenda) async {
    setState(() => _isPublishing = true);
    try {
      final repo = ref.read(clubSessionRepositoryProvider);
      // Publish always carries whatever body is currently on screen, even if
      // the author never explicitly tapped "임시저장" first.
      await repo.saveAgendaDraft(
        clubId: widget.session.clubId,
        sessionId: widget.session.id,
        agendaId: agenda.id,
        body: _bodyController.text.trim(),
      );
      await repo.publishAgenda(
        clubId: widget.session.clubId,
        sessionId: widget.session.id,
        agendaId: agenda.id,
      );
      _refresh();
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('발제문을 게시했어요')));
        Navigator.of(context).pop();
      }
    } catch (_) {
      _showError('게시에 실패했어요. 다시 시도해 주세요.');
    } finally {
      if (mounted) setState(() => _isPublishing = false);
    }
  }

  Future<void> _addTopic(SessionAgenda agenda, {String? initialPrompt}) async {
    final prompt = await showDialog<String>(
      context: context,
      builder: (_) => _TopicPromptDialog(initialText: initialPrompt),
    );
    if (prompt == null || !mounted) return;
    try {
      await ref.read(clubSessionRepositoryProvider).addAgendaTopic(
            clubId: widget.session.clubId,
            sessionId: widget.session.id,
            agendaId: agenda.id,
            prompt: prompt,
          );
      _refresh();
    } catch (_) {
      _showError('논제 추가에 실패했어요. 다시 시도해 주세요.');
    }
  }

  Future<void> _removeTopic(SessionAgenda agenda, String topicId) async {
    try {
      await ref.read(clubSessionRepositoryProvider).removeAgendaTopic(
            clubId: widget.session.clubId,
            sessionId: widget.session.id,
            agendaId: agenda.id,
            topicId: topicId,
          );
      _refresh();
    } catch (_) {
      _showError('논제 삭제에 실패했어요. 다시 시도해 주세요.');
    }
  }

  Future<void> _reorderTopics(
    SessionAgenda agenda,
    List<String> orderedTopicIds,
  ) async {
    try {
      await ref.read(clubSessionRepositoryProvider).reorderAgendaTopics(
            clubId: widget.session.clubId,
            sessionId: widget.session.id,
            agendaId: agenda.id,
            orderedTopicIds: orderedTopicIds,
          );
      _refresh();
    } catch (_) {
      _showError('순서 변경에 실패했어요. 다시 시도해 주세요.');
    }
  }

  /// AI 논제 초안 추천 (BC-53/60) — fetches 3~5 candidates from the book +
  /// session scope, lets the author pick one, and prefills it into the same
  /// "논제 추가" dialog [_addTopic] already uses. The recommendation itself
  /// is never persisted — only the confirmed add via [_addTopic] is.
  Future<void> _showAiRecommendations(SessionAgenda agenda) async {
    setState(() => _isFetchingRecommendations = true);
    List<String> candidates;
    try {
      candidates =
          await ref.read(clubSessionRepositoryProvider).recommendTopicDrafts(
                clubId: widget.session.clubId,
                sessionId: widget.session.id,
                agendaId: agenda.id,
                bookId: widget.session.bookId,
                scope: widget.session.scope?.trim().isNotEmpty == true
                    ? widget.session.scope!
                    : widget.session.title,
              );
    } catch (_) {
      if (mounted) _showError('AI 논제 추천을 불러오지 못했어요. 다시 시도해 주세요.');
      if (mounted) setState(() => _isFetchingRecommendations = false);
      return;
    }
    if (!mounted) return;
    setState(() => _isFetchingRecommendations = false);
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (_) => _AiTopicSuggestionSheet(candidates: candidates),
    );
    if (selected == null || !mounted) return;
    await _addTopic(agenda, initialPrompt: selected);
  }

  void _refresh() {
    final agendaKey =
        (clubId: widget.session.clubId, sessionId: widget.session.id);
    ref.invalidate(agendaForEditProvider(agendaKey));
    // Keeps the read-only detail screen (BC-49) in sync for when the author
    // navigates back to it.
    ref.invalidate(sessionAgendaProvider(agendaKey));
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

class _AccessDeniedScaffold extends StatelessWidget {
  const _AccessDeniedScaffold({required this.spacing, required this.theme});

  final AppSpacing spacing;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('발제문 작성')),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(spacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.lock_outline_rounded,
                size: 52,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              ),
              SizedBox(height: spacing.md),
              Text(
                '호스트 또는 발제자만 발제문을 작성할 수 있어요',
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditorBody extends StatelessWidget {
  const _EditorBody({
    required this.session,
    required this.agenda,
    required this.bodyController,
    required this.isSavingDraft,
    required this.isPublishing,
    required this.isFetchingRecommendations,
    required this.onSaveDraft,
    required this.onPublish,
    required this.onAddTopic,
    required this.onRemoveTopic,
    required this.onReorderTopics,
    required this.onAiRecommend,
  });

  final ClubSession session;
  final SessionAgenda agenda;
  final TextEditingController bodyController;
  final bool isSavingDraft;
  final bool isPublishing;
  final bool isFetchingRecommendations;
  final VoidCallback onSaveDraft;
  final VoidCallback onPublish;
  final VoidCallback onAddTopic;
  final void Function(String topicId) onRemoveTopic;
  final void Function(List<String> orderedTopicIds) onReorderTopics;
  final VoidCallback onAiRecommend;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final topics = agenda.topics;
    final busy = isSavingDraft || isPublishing;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(spacing.md),
            children: [
              Text(
                session.title,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              SizedBox(height: spacing.sm),
              TextField(
                controller: bodyController,
                minLines: 4,
                maxLines: 10,
                decoration: const InputDecoration(
                  labelText: '발제문 본문',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: spacing.lg),
              Row(
                children: [
                  Text(
                    '논제',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: isFetchingRecommendations ? null : onAiRecommend,
                    icon: isFetchingRecommendations
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.auto_awesome_rounded),
                    label: const Text('AI 추천'),
                  ),
                  TextButton.icon(
                    onPressed: onAddTopic,
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('논제 추가'),
                  ),
                ],
              ),
              if (topics.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: spacing.md),
                  child: Text(
                    '아직 논제가 없어요. "논제 추가"로 시작해 보세요.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                )
              else
                ReorderableListView.builder(
                  buildDefaultDragHandles: false,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: topics.length,
                  onReorder: (oldIndex, newIndex) {
                    final ids = topics.map((topic) => topic.id).toList();
                    final movedId = ids.removeAt(oldIndex);
                    final adjustedNewIndex =
                        newIndex > oldIndex ? newIndex - 1 : newIndex;
                    ids.insert(adjustedNewIndex, movedId);
                    onReorderTopics(ids);
                  },
                  itemBuilder: (context, index) {
                    final topic = topics[index];
                    return _TopicEditorTile(
                      key: ValueKey('agenda-topic-${topic.id}'),
                      index: index,
                      topic: topic,
                      onRemove: () => onRemoveTopic(topic.id),
                    );
                  },
                ),
            ],
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.all(spacing.md),
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: bodyController,
              builder: (context, value, _) {
                final canPublish =
                    value.text.trim().isNotEmpty && topics.isNotEmpty;
                return Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: busy ? null : onSaveDraft,
                        child: isSavingDraft
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('임시저장'),
                      ),
                    ),
                    SizedBox(width: spacing.sm),
                    Expanded(
                      child: FilledButton(
                        onPressed: canPublish && !busy ? onPublish : null,
                        child: isPublishing
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('게시'),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

/// One topic row in the editor — a drag handle (immediate drag via
/// [ReorderableDragStartListener], so reordering doesn't depend on the
/// touch-vs-desktop long-press split `ReorderableListView` otherwise
/// defaults to) and a delete action.
class _TopicEditorTile extends StatelessWidget {
  const _TopicEditorTile({
    super.key,
    required this.index,
    required this.topic,
    required this.onRemove,
  });

  final int index;
  final AgendaTopic topic;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: ReorderableDragStartListener(
          index: index,
          child: const Icon(Icons.drag_handle_rounded),
        ),
        title: Text('${topic.position}. ${topic.prompt}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline_rounded),
          tooltip: '논제 삭제',
          onPressed: onRemove,
        ),
      ),
    );
  }
}

/// Modal prompt input for "논제 추가" — pops the trimmed, non-empty prompt
/// string, or `null` on cancel. [initialText], when given (an AI
/// recommendation the author picked — BC-53/60), prefills the field so the
/// author can still edit it before confirming; the recommendation itself is
/// never saved on its own.
class _TopicPromptDialog extends StatefulWidget {
  const _TopicPromptDialog({this.initialText});

  final String? initialText;

  @override
  State<_TopicPromptDialog> createState() => _TopicPromptDialogState();
}

class _TopicPromptDialogState extends State<_TopicPromptDialog> {
  late final _controller = TextEditingController(text: widget.initialText);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('논제 추가'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        minLines: 1,
        maxLines: 3,
        decoration: const InputDecoration(labelText: '논제 질문'),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: _submit,
          child: const Text('추가'),
        ),
      ],
    );
  }

  void _submit() {
    final prompt = _controller.text.trim();
    if (prompt.isEmpty) return;
    Navigator.of(context).pop(prompt);
  }
}

/// Bottom sheet listing AI-drafted topic candidates (BC-53/60) — tapping one
/// pops it back to [_AgendaEditorScreenState._showAiRecommendations], which
/// hands it to [_TopicPromptDialog] as a prefill, never saving it directly.
class _AiTopicSuggestionSheet extends StatelessWidget {
  const _AiTopicSuggestionSheet({required this.candidates});

  final List<String> candidates;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(spacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AI 논제 추천',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            SizedBox(height: spacing.xs),
            Text(
              '마음에 드는 문구를 고르면 논제 입력창에 채워져요. 그대로, 혹은 수정해서 추가할 수 있어요.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            SizedBox(height: spacing.sm),
            if (candidates.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: spacing.md),
                child: Text(
                  '추천할 논제를 찾지 못했어요. 다시 시도해 주세요.',
                  style: theme.textTheme.bodyMedium,
                ),
              )
            else
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: candidates.length,
                  itemBuilder: (context, index) {
                    final candidate = candidates[index];
                    return ListTile(
                      leading: const Icon(Icons.auto_awesome_rounded),
                      title: Text(candidate),
                      onTap: () => Navigator.of(context).pop(candidate),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
