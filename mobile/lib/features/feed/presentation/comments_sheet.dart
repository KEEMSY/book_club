import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../auth/application/auth_providers.dart';
import '../../auth/domain/auth_state.dart';
import '../application/book_feed_notifier.dart';
import '../application/comment_thread_notifier.dart';
import '../application/comment_thread_state.dart';
import '../domain/comment.dart';
import 'widgets/comment_composer.dart';
import 'widgets/comment_tile.dart';

/// Modal bottom sheet that hosts the comment thread.
///
/// Layout:
///   * `DraggableScrollableSheet` (initial 0.6, max 0.95).
///   * Drag handle + "댓글 N" title + close icon header.
///   * `ListView` of grouped comments. Replies indent under their root by
///     28dp + lighter divider.
///   * Persistent composer at the bottom; switches `parent_id` when the user
///     hits "답글" on a root tile.
class CommentsSheet extends ConsumerStatefulWidget {
  const CommentsSheet({
    super.key,
    required this.bookId,
    required this.postId,
    required this.initialCommentCount,
  });

  final String bookId;
  final String postId;
  final int initialCommentCount;

  static Future<void> show(
    BuildContext context, {
    required String bookId,
    required String postId,
    required int initialCommentCount,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => CommentsSheet(
        bookId: bookId,
        postId: postId,
        initialCommentCount: initialCommentCount,
      ),
    );
  }

  @override
  ConsumerState<CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends ConsumerState<CommentsSheet> {
  String? _replyParentId;
  String? _replyTargetNickname;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(commentThreadNotifierProvider(widget.postId).notifier).load();
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final double remaining = _scrollController.position.maxScrollExtent -
        _scrollController.position.pixels;
    if (remaining < 200) {
      ref
          .read(commentThreadNotifierProvider(widget.postId).notifier)
          .loadMore();
    }
  }

  void _setReplyTarget(Comment target) {
    setState(() {
      _replyParentId = target.id;
      _replyTargetNickname = target.user.nickname;
    });
  }

  void _clearReplyTarget() {
    setState(() {
      _replyParentId = null;
      _replyTargetNickname = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final state = ref.watch(commentThreadNotifierProvider(widget.postId));

    final int displayCount = switch (state) {
      CommentThreadLoaded(:final items) => items.length,
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
            _Header(count: displayCount),
            Expanded(
              child: _Body(
                state: state,
                bookId: widget.bookId,
                postId: widget.postId,
                onReplyTo: _setReplyTarget,
                outerScroll: sheetController,
                listScroll: _scrollController,
                onRefresh: () => ref
                    .read(commentThreadNotifierProvider(widget.postId).notifier)
                    .load(),
              ),
            ),
            const Divider(height: 1),
            CommentComposer(
              busy: state is CommentThreadLoaded && state.isPosting,
              errorText: state is CommentThreadLoaded ? state.postError : null,
              replyTargetNickname: _replyTargetNickname,
              onClearReply: _clearReplyTarget,
              onSubmit: (String content) async {
                final notifier = ref.read(
                  commentThreadNotifierProvider(widget.postId).notifier,
                );
                final created = await notifier.postComment(
                  content: content,
                  parentId: _replyParentId,
                );
                if (created != null) {
                  ref
                      .read(bookFeedNotifierProvider(widget.bookId).notifier)
                      .incrementCommentCount(widget.postId);
                  _clearReplyTarget();
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

class _Header extends StatelessWidget {
  const _Header({required this.count});

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

class _Body extends ConsumerWidget {
  const _Body({
    required this.state,
    required this.bookId,
    required this.postId,
    required this.onReplyTo,
    required this.outerScroll,
    required this.listScroll,
    required this.onRefresh,
  });

  final CommentThreadState state;
  final String bookId;
  final String postId;
  final ValueChanged<Comment> onReplyTo;
  final ScrollController outerScroll;
  final ScrollController listScroll;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (state) {
      case CommentThreadInitial():
      case CommentThreadLoading():
        return const Center(child: CircularProgressIndicator());
      case CommentThreadError(:final String message):
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
      case CommentThreadLoaded(:final items, :final isLoadingMore):
        if (items.isEmpty) {
          return ListView(
            controller: outerScroll,
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
        return _ThreadList(
          items: items,
          bookId: bookId,
          postId: postId,
          isLoadingMore: isLoadingMore,
          onReplyTo: onReplyTo,
          listScroll: listScroll,
        );
    }
  }
}

class _ThreadList extends ConsumerWidget {
  const _ThreadList({
    required this.items,
    required this.bookId,
    required this.postId,
    required this.isLoadingMore,
    required this.onReplyTo,
    required this.listScroll,
  });

  final List<Comment> items;
  final String bookId;
  final String postId;
  final bool isLoadingMore;
  final ValueChanged<Comment> onReplyTo;
  final ScrollController listScroll;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final auth = ref.watch(authNotifierProvider);
    final String? meId = auth is Authenticated ? auth.user.id : null;
    final List<_Group> groups = _groupComments(items);

    return ListView.builder(
      controller: listScroll,
      padding: EdgeInsets.symmetric(horizontal: spacing.md),
      itemCount: groups.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == groups.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }
        final _Group group = groups[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            CommentTile(
              comment: group.root,
              isReply: false,
              canDelete: meId == group.root.user.id,
              onReply: () => onReplyTo(group.root),
              onDelete: meId == group.root.user.id
                  ? () => _confirmDelete(context, ref, group.root.id)
                  : null,
            ),
            for (final Comment reply in group.replies)
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
                  child: CommentTile(
                    comment: reply,
                    isReply: true,
                    canDelete: meId == reply.user.id,
                    onDelete: meId == reply.user.id
                        ? () => _confirmDelete(context, ref, reply.id)
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

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    String commentId,
  ) async {
    final bool? ok = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('댓글을 삭제할까요?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogCtx).pop(true),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    if (!context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    final removed = await ref
        .read(commentThreadNotifierProvider(postId).notifier)
        .deleteComment(commentId);
    if (removed) {
      ref
          .read(bookFeedNotifierProvider(bookId).notifier)
          .incrementCommentCount(postId, -1);
      messenger.showSnackBar(
        const SnackBar(content: Text('댓글이 삭제되었어요')),
      );
    }
  }
}

class _Group {
  const _Group(this.root, this.replies);
  final Comment root;
  final List<Comment> replies;
}

List<_Group> _groupComments(List<Comment> items) {
  final List<Comment> roots = <Comment>[];
  final Map<String, List<Comment>> repliesByParent = <String, List<Comment>>{};
  for (final Comment c in items) {
    if (c.parentId == null) {
      roots.add(c);
    } else {
      repliesByParent.putIfAbsent(c.parentId!, () => <Comment>[]).add(c);
    }
  }
  // Orphaned replies (parent missing on this page) surface as roots so they
  // remain visible. Server pagination is ASC so this is rare in practice.
  for (final String parentId in repliesByParent.keys.toList()) {
    if (!roots.any((Comment r) => r.id == parentId)) {
      for (final Comment orphan in repliesByParent.remove(parentId)!) {
        roots.add(orphan);
      }
    }
  }
  return <_Group>[
    for (final Comment root in roots)
      _Group(root, repliesByParent[root.id] ?? const <Comment>[]),
  ];
}
