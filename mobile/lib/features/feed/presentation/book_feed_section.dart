import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../application/book_feed_notifier.dart';
import '../application/book_feed_state.dart';
import '../domain/post.dart';
import 'comments_sheet.dart';
import 'widgets/post_card.dart';

/// "책 그룹 피드" — slot mounted at the bottom of `BookDetailScreen`.
///
/// Renders the per-book feed with cursor pagination. The card list lives
/// inside a `Column` (not a `ListView`) because it sits inside the book
/// detail's parent `SingleChildScrollView`. We use `shrinkWrap` only on the
/// pagination spinner; new pages append as the parent scroll approaches the
/// bottom.
class BookFeedSection extends ConsumerStatefulWidget {
  const BookFeedSection({
    super.key,
    required this.bookId,
    this.scrollController,
  });

  final String bookId;
  final ScrollController? scrollController;

  @override
  ConsumerState<BookFeedSection> createState() => _BookFeedSectionState();
}

class _BookFeedSectionState extends ConsumerState<BookFeedSection> {
  bool _initialLoadKicked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensureInitialLoad();
    });
    widget.scrollController?.addListener(_onScroll);
  }

  void _ensureInitialLoad() {
    if (_initialLoadKicked) return;
    _initialLoadKicked = true;
    ref.read(bookFeedNotifierProvider(widget.bookId).notifier).load();
  }

  void _onScroll() {
    final ScrollController? c = widget.scrollController;
    if (c == null || !c.hasClients) return;
    final double remaining = c.position.maxScrollExtent - c.position.pixels;
    if (remaining < 240) {
      ref.read(bookFeedNotifierProvider(widget.bookId).notifier).loadMore();
    }
  }

  @override
  void dispose() {
    widget.scrollController?.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final state = ref.watch(bookFeedNotifierProvider(widget.bookId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('책 그룹 피드', style: theme.textTheme.headlineSmall),
        SizedBox(height: spacing.xs),
        Text(
          '이 책을 읽은 사람들의 글',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: spacing.md),
        _ComposeCta(bookId: widget.bookId),
        SizedBox(height: spacing.md),
        _Body(bookId: widget.bookId, state: state),
      ],
    );
  }
}

class _ComposeCta extends StatelessWidget {
  const _ComposeCta({required this.bookId});

  final String bookId;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => context.push('/books/$bookId/posts/new'),
        icon: const Icon(Icons.edit_outlined, size: 18),
        label: const Text('글쓰기'),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.bookId, required this.state});

  final String bookId;
  final BookFeedState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    switch (state) {
      case BookFeedInitial():
      case BookFeedLoading():
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: Center(child: CircularProgressIndicator()),
        );
      case BookFeedError(:final String message):
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            children: <Widget>[
              Icon(
                Icons.cloud_off_rounded,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              SizedBox(height: spacing.sm),
              Text(message, style: theme.textTheme.bodyMedium),
            ],
          ),
        );
      case BookFeedLoaded(:final items, :final isLoadingMore):
        if (items.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: spacing.lg),
            child: Center(
              child: Text(
                '아직 첫 번째 글이 없어요. 가장 먼저 남겨보세요.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        return Column(
          children: <Widget>[
            for (final Post post in items)
              Padding(
                padding: EdgeInsets.only(bottom: spacing.md),
                child: PostCard(
                  bookId: bookId,
                  post: post,
                  onTapComments: () => CommentsSheet.show(
                    context,
                    bookId: bookId,
                    postId: post.id,
                    initialCommentCount: post.commentCount,
                  ),
                ),
              ),
            if (isLoadingMore)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
          ],
        );
    }
  }
}
