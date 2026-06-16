import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/theme/app_theme.dart';
import '../application/feed_providers.dart';
import '../data/feed_repository.dart';
import '../domain/feed_comment.dart';

part 'feed_comment_sheet.g.dart';

// ---------------------------------------------------------------------------
// Comment thread state + notifier (event-specific, not the book-post one)
// ---------------------------------------------------------------------------

/// Minimal state machine for the event comment thread.
sealed class EventCommentState {
  const EventCommentState();
}

final class EventCommentInitial extends EventCommentState {
  const EventCommentInitial();
}

final class EventCommentLoading extends EventCommentState {
  const EventCommentLoading();
}

final class EventCommentError extends EventCommentState {
  const EventCommentError(this.message);
  final String message;
}

final class EventCommentLoaded extends EventCommentState {
  const EventCommentLoaded({
    required this.comments,
    this.isPosting = false,
    this.postError,
  });

  final List<FeedComment> comments;
  final bool isPosting;
  final String? postError;

  EventCommentLoaded copyWith({
    List<FeedComment>? comments,
    bool? isPosting,
    String? postError,
    bool clearPostError = false,
  }) {
    return EventCommentLoaded(
      comments: comments ?? this.comments,
      isPosting: isPosting ?? this.isPosting,
      postError: clearPostError ? null : (postError ?? this.postError),
    );
  }
}

@riverpod
class EventCommentNotifier extends _$EventCommentNotifier {
  @override
  EventCommentState build(String eventId) => const EventCommentInitial();

  Future<void> load() async {
    state = const EventCommentLoading();
    try {
      final comments =
          await ref.read(feedRepositoryProvider).getFeedComments(eventId);
      state = EventCommentLoaded(comments: comments);
    } on FeedRepositoryException catch (e) {
      state = EventCommentError(e.message);
    }
  }

  /// Posts a root or reply comment. Returns the created [FeedComment] or null
  /// if posting failed.
  Future<FeedComment?> postComment({
    required String body,
    String? parentId,
  }) async {
    final EventCommentState snap = state;
    if (snap is! EventCommentLoaded) return null;
    final String trimmed = body.trim();
    if (trimmed.isEmpty) {
      state = snap.copyWith(postError: '내용을 입력해주세요.');
      return null;
    }
    state = snap.copyWith(isPosting: true, clearPostError: true);
    try {
      final FeedComment created =
          await ref.read(feedRepositoryProvider).createFeedComment(
                eventId: eventId,
                body: trimmed,
                parentId: parentId,
              );
      // Optimistically append the new comment to the flat list. The UI
      // re-groups on next render so the reply lands under its parent.
      state = snap.copyWith(
        comments: <FeedComment>[...snap.comments, created],
        isPosting: false,
      );
      return created;
    } on FeedRepositoryException catch (e) {
      state = snap.copyWith(isPosting: false, postError: e.message);
      return null;
    }
  }

  Future<bool> deleteComment(String commentId) async {
    final EventCommentState snap = state;
    if (snap is! EventCommentLoaded) return false;
    try {
      await ref.read(feedRepositoryProvider).deleteFeedComment(commentId);
    } on FeedRepositoryException catch (e) {
      state = snap.copyWith(postError: e.message);
      return false;
    }
    // Drop the comment and its direct replies from the flat list.
    final Set<String> drop = <String>{commentId};
    for (final FeedComment c in snap.comments) {
      if (c.parentId == commentId) drop.add(c.id);
    }
    // Also remove from nested replies lists.
    final List<FeedComment> updated = snap.comments
        .where((FeedComment c) => !drop.contains(c.id))
        .map(
          (FeedComment c) => c.copyWith(
            replies: c.replies
                .where((FeedComment r) => !drop.contains(r.id))
                .toList(growable: false),
          ),
        )
        .toList(growable: false);
    state = snap.copyWith(comments: updated);
    return true;
  }

  void clearPostError() {
    final EventCommentState snap = state;
    if (snap is EventCommentLoaded && snap.postError != null) {
      state = snap.copyWith(clearPostError: true);
    }
  }
}

// ---------------------------------------------------------------------------
// Sheet widget
// ---------------------------------------------------------------------------

/// Bottom sheet for the event comment thread.
///
/// Supports 2-depth nesting: root comments are rendered flush; replies are
/// indented 28 dp under their parent with a left-border accent. Tapping
/// "답글" on a root comment pre-fills `@nickname` in the composer and wires
/// the [parentId] for the next POST.
class FeedCommentSheet extends ConsumerStatefulWidget {
  const FeedCommentSheet({
    super.key,
    required this.eventId,
    required this.currentUserId,
    required this.initialCommentCount,
    this.onCommentCountChanged,
  });

  final String eventId;
  final String currentUserId;
  final int initialCommentCount;

  /// Notified with the new count delta (+1 for add, -1 for delete) so the
  /// parent event card can update its chip without a re-fetch.
  final void Function(int delta)? onCommentCountChanged;

  static Future<void> show(
    BuildContext context, {
    required String eventId,
    required String currentUserId,
    required int initialCommentCount,
    void Function(int delta)? onCommentCountChanged,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => FeedCommentSheet(
        eventId: eventId,
        currentUserId: currentUserId,
        initialCommentCount: initialCommentCount,
        onCommentCountChanged: onCommentCountChanged,
      ),
    );
  }

  @override
  ConsumerState<FeedCommentSheet> createState() => _FeedCommentSheetState();
}

class _FeedCommentSheetState extends ConsumerState<FeedCommentSheet> {
  String? _replyParentId;
  String? _replyNickname;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(eventCommentNotifierProvider(widget.eventId).notifier)
          .load();
    });
  }

  void _setReply(String parentId, String nickname) {
    setState(() {
      _replyParentId = parentId;
      _replyNickname = nickname;
    });
  }

  void _clearReply() {
    setState(() {
      _replyParentId = null;
      _replyNickname = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final state =
        ref.watch(eventCommentNotifierProvider(widget.eventId));

    final int displayCount = switch (state) {
      EventCommentLoaded(:final comments) => comments.length,
      _ => widget.initialCommentCount,
    };

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, sheetController) {
        return Column(
          children: <Widget>[
            _SheetHeader(count: displayCount),
            Expanded(
              child: _SheetBody(
                state: state,
                eventId: widget.eventId,
                currentUserId: widget.currentUserId,
                onReplyTo: _setReply,
                onDelete: (commentId) async {
                  final removed = await ref
                      .read(
                        eventCommentNotifierProvider(widget.eventId)
                            .notifier,
                      )
                      .deleteComment(commentId);
                  if (removed) {
                    widget.onCommentCountChanged?.call(-1);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('댓글이 삭제되었어요')),
                      );
                    }
                  }
                },
                scrollController: sheetController,
                onRefresh: () => ref
                    .read(
                      eventCommentNotifierProvider(widget.eventId).notifier,
                    )
                    .load(),
              ),
            ),
            const Divider(height: 1),
            _CommentComposer(
              busy: state is EventCommentLoaded && state.isPosting,
              errorText:
                  state is EventCommentLoaded ? state.postError : null,
              replyNickname: _replyNickname,
              onClearReply: _clearReply,
              onChanged: (_) {
                ref
                    .read(
                      eventCommentNotifierProvider(widget.eventId).notifier,
                    )
                    .clearPostError();
              },
              onSubmit: (String body) async {
                final notifier = ref.read(
                  eventCommentNotifierProvider(widget.eventId).notifier,
                );
                final created = await notifier.postComment(
                  body: body,
                  parentId: _replyParentId,
                );
                if (created != null) {
                  widget.onCommentCountChanged?.call(1);
                  _clearReply();
                  return true;
                }
                return false;
              },
            ),
            SizedBox(height: spacing.xs),
          ],
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Header
// ---------------------------------------------------------------------------

class _SheetHeader extends StatelessWidget {
  const _SheetHeader({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.outline,
              borderRadius: const BorderRadius.all(Radius.circular(2)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text('댓글 $count', style: theme.textTheme.titleLarge),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close_rounded),
                tooltip: '닫기',
              ),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Body
// ---------------------------------------------------------------------------

class _SheetBody extends ConsumerWidget {
  const _SheetBody({
    required this.state,
    required this.eventId,
    required this.currentUserId,
    required this.onReplyTo,
    required this.onDelete,
    required this.scrollController,
    required this.onRefresh,
  });

  final EventCommentState state;
  final String eventId;
  final String currentUserId;
  final void Function(String parentId, String nickname) onReplyTo;
  final void Function(String commentId) onDelete;
  final ScrollController scrollController;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    switch (state) {
      case EventCommentInitial():
      case EventCommentLoading():
        return const Center(child: CircularProgressIndicator());
      case EventCommentError(:final String message):
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(message, textAlign: TextAlign.center),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: onRefresh,
                  child: const Text('다시 시도'),
                ),
              ],
            ),
          ),
        );
      case EventCommentLoaded(:final List<FeedComment> comments):
        if (comments.isEmpty) {
          return ListView(
            controller: scrollController,
            children: const <Widget>[
              SizedBox(height: 64),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    '첫 번째 댓글을 남겨보세요.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          );
        }
        // Group: server returns tree in replies field; also build from flat list.
        final List<_CommentGroup> groups = _buildGroups(comments);
        return ListView.builder(
          controller: scrollController,
          padding: EdgeInsets.symmetric(horizontal: spacing.md),
          itemCount: groups.length,
          itemBuilder: (context, index) {
            final _CommentGroup group = groups[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _CommentTile(
                  comment: group.root,
                  isReply: false,
                  canDelete: currentUserId == group.root.userId,
                  onReply: () => onReplyTo(
                    group.root.id,
                    group.root.userId.substring(0, 6),
                  ),
                  onDelete: currentUserId == group.root.userId
                      ? () => _confirmDelete(context, group.root.id)
                      : null,
                ),
                for (final FeedComment reply in group.replies)
                  Padding(
                    padding: const EdgeInsets.only(left: 28),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: theme.colorScheme.outlineVariant,
                            width: 1,
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.only(left: 12),
                      child: _CommentTile(
                        comment: reply,
                        isReply: true,
                        canDelete: currentUserId == reply.userId,
                        onDelete: currentUserId == reply.userId
                            ? () => _confirmDelete(context, reply.id)
                            : null,
                      ),
                    ),
                  ),
                Divider(
                  height: 1,
                  color: theme.colorScheme.outlineVariant,
                ),
              ],
            );
          },
        );
    }
  }

  Future<void> _confirmDelete(BuildContext context, String commentId) async {
    final bool? ok = await showDialog<bool>(
      context: context,
      builder: (dlg) => AlertDialog(
        title: const Text('댓글을 삭제할까요?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dlg).pop(false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dlg).pop(true),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    if (!context.mounted) return;
    onDelete(commentId);
  }
}

// ---------------------------------------------------------------------------
// Comment tile
// ---------------------------------------------------------------------------

class _CommentTile extends StatelessWidget {
  const _CommentTile({
    required this.comment,
    required this.isReply,
    required this.canDelete,
    this.onReply,
    this.onDelete,
  });

  final FeedComment comment;
  final bool isReply;
  final bool canDelete;
  final VoidCallback? onReply;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHigh,
              shape: BoxShape.circle,
            ),
            child: const Text('👤', style: TextStyle(fontSize: 14)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      comment.userId.substring(0, 8),
                      style: theme.textTheme.labelMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _relativeTime(comment.createdAt),
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(comment.body, style: theme.textTheme.bodyMedium),
                if (!isReply && onReply != null) ...<Widget>[
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: onReply,
                    child: Text(
                      '답글',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (canDelete && onDelete != null)
            IconButton(
              iconSize: 16,
              icon: Icon(
                Icons.delete_outline,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              onPressed: onDelete,
              tooltip: '삭제',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Composer
// ---------------------------------------------------------------------------

class _CommentComposer extends StatefulWidget {
  const _CommentComposer({
    required this.busy,
    required this.onSubmit,
    this.replyNickname,
    this.onClearReply,
    this.onChanged,
    this.errorText,
  });

  final bool busy;
  final String? replyNickname;
  final VoidCallback? onClearReply;
  final void Function(String)? onChanged;
  final String? errorText;
  final Future<bool> Function(String body) onSubmit;

  @override
  State<_CommentComposer> createState() => _CommentComposerState();
}

class _CommentComposerState extends State<_CommentComposer> {
  final TextEditingController _controller = TextEditingController();

  @override
  void didUpdateWidget(_CommentComposer oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Pre-fill @nickname when a reply target is set.
    if (widget.replyNickname != null &&
        widget.replyNickname != oldWidget.replyNickname) {
      final String prefix = '@${widget.replyNickname} ';
      _controller.text = prefix;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: prefix.length),
      );
    }
    if (widget.replyNickname == null && oldWidget.replyNickname != null) {
      // Clear the @prefix if the reply target was cleared externally.
      final String current = _controller.text;
      final String prefix =
          '@${oldWidget.replyNickname} ';
      if (current.startsWith(prefix)) {
        _controller.text = current.substring(prefix.length);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final String text = _controller.text.trim();
    if (text.isEmpty || widget.busy) return;
    final bool ok = await widget.onSubmit(text);
    if (ok && mounted) _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        spacing.md,
        spacing.xs,
        spacing.xs,
        spacing.xs,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (widget.replyNickname != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: <Widget>[
                  Text(
                    '@${widget.replyNickname} 에게 답글',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.onClearReply,
                    child: Icon(
                      Icons.close,
                      size: 14,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          if (widget.errorText != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                widget.errorText!,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _controller,
                  onChanged: widget.onChanged,
                  decoration: const InputDecoration(
                    hintText: '댓글을 입력해주세요',
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                  ),
                  maxLines: null,
                  textInputAction: TextInputAction.newline,
                ),
              ),
              widget.busy
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : IconButton(
                      icon: const Icon(Icons.send_rounded),
                      onPressed: _submit,
                      color: theme.colorScheme.primary,
                      tooltip: '전송',
                    ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

class _CommentGroup {
  const _CommentGroup(this.root, this.replies);
  final FeedComment root;
  final List<FeedComment> replies;
}

/// Builds root → replies groups from a flat list. The server may return
/// [FeedComment.replies] populated directly; we merge both sources.
List<_CommentGroup> _buildGroups(List<FeedComment> comments) {
  // Prefer server-side tree if replies are already nested.
  final List<FeedComment> roots =
      comments.where((FeedComment c) => c.parentId == null).toList();
  if (roots.isNotEmpty) {
    return roots.map((FeedComment root) {
      // Server may embed replies in root.replies or return them as siblings.
      final List<FeedComment> serverReplies = root.replies.isNotEmpty
          ? root.replies
          : comments
              .where((FeedComment c) => c.parentId == root.id)
              .toList();
      return _CommentGroup(root, serverReplies);
    }).toList();
  }
  // Fallback: all items are roots.
  return comments.map((FeedComment c) => _CommentGroup(c, const [])).toList();
}

String _relativeTime(DateTime created) {
  final DateTime now = DateTime.now();
  final Duration diff = now.difference(created);
  if (diff.inSeconds < 60) return '방금 전';
  if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
  if (diff.inHours < 24) return '${diff.inHours}시간 전';
  if (diff.inDays < 7) return '${diff.inDays}일 전';
  return '${created.year}.${created.month.toString().padLeft(2, '0')}.${created.day.toString().padLeft(2, '0')}';
}
