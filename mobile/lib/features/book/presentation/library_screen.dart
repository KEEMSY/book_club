import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../auth/application/auth_providers.dart';
import '../application/book_providers.dart';
import '../application/library_notifier.dart';
import '../application/library_state.dart';
import '../domain/book_status.dart';
import '../domain/user_book.dart';
import 'widgets/book_card.dart';
import 'widgets/empty_states.dart';
import 'widgets/review_modal.dart';
import 'widgets/status_segment.dart';

/// "내 서재" — Airbnb magazine-style library.
///
/// Top: Playfair displaySmall "내 서재" header. Status segments sit below
/// (읽는 중 · 완독 · 잠시 멈춤 · 포기) and drive the grid. Pagination is
/// cursor-based via LibraryNotifier.loadMore.
class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key, this.highlightUserBookId});

  final String? highlightUserBookId;

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  BookStatus _selected = BookStatus.reading;
  final Map<BookStatus, ScrollController> _controllers =
      <BookStatus, ScrollController>{};

  @override
  void initState() {
    super.initState();
    for (final BookStatus status in BookStatus.values) {
      final ScrollController controller = ScrollController();
      controller.addListener(() => _onScroll(status, controller));
      _controllers[status] = controller;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(libraryNotifierProvider.notifier).ensureLoaded(_selected);
    });
  }

  @override
  void dispose() {
    for (final ScrollController controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onScroll(BookStatus status, ScrollController controller) {
    if (!controller.hasClients) return;
    final double remaining =
        controller.position.maxScrollExtent - controller.position.pixels;
    if (remaining < 200) {
      ref.read(libraryNotifierProvider.notifier).loadMore(status);
    }
  }

  void _selectStatus(BookStatus next) {
    setState(() => _selected = next);
    ref.read(libraryNotifierProvider.notifier).ensureLoaded(next);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final Map<BookStatus, LibraryListState> map =
        ref.watch(libraryNotifierProvider);
    final LibraryListState current =
        map[_selected] ?? const LibraryListState.initial();

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(
                spacing.lg,
                spacing.md,
                spacing.lg,
                spacing.sm,
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text('내 서재', style: theme.textTheme.displaySmall),
                  ),
                  IconButton(
                    tooltip: '로그아웃',
                    onPressed: () =>
                        ref.read(authNotifierProvider.notifier).logout(),
                    icon: const Icon(Icons.logout_outlined),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: spacing.md),
              child: StatusSegment(
                selected: _selected,
                onChanged: _selectStatus,
              ),
            ),
            Expanded(
              child: _TabBody(
                status: _selected,
                state: current,
                controller: _controllers[_selected]!,
                highlightUserBookId: widget.highlightUserBookId,
                onBrowse: () => context.go('/search'),
                onRefresh: () => ref
                    .read(libraryNotifierProvider.notifier)
                    .refresh(_selected),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabBody extends ConsumerWidget {
  const _TabBody({
    required this.status,
    required this.state,
    required this.controller,
    required this.highlightUserBookId,
    required this.onBrowse,
    required this.onRefresh,
  });

  final BookStatus status;
  final LibraryListState state;
  final ScrollController controller;
  final String? highlightUserBookId;
  final VoidCallback onBrowse;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (state) {
      case LibraryListInitial():
      case LibraryListLoading():
        return const Center(child: CircularProgressIndicator());
      case LibraryListError(:final String message):
        return _ErrorView(message: message, onRetry: onRefresh);
      case LibraryListLoaded(
          :final List<UserBook> items,
          :final String? nextCursor,
          :final bool isLoadingMore,
        ):
        if (items.isEmpty) {
          return BookEmptyState(
            icon: Icons.auto_stories_outlined,
            title: status.emptyMessage,
            subtitle: '검색으로 새 책을 담아보세요.',
            actionLabel: '책 검색하기',
            onAction: onBrowse,
          );
        }
        return RefreshIndicator(
          onRefresh: onRefresh,
          color: Theme.of(context).colorScheme.primary,
          child: _LibraryGrid(
            items: items,
            controller: controller,
            showFooter: nextCursor != null || isLoadingMore,
            highlightUserBookId: highlightUserBookId,
          ),
        );
    }
  }
}

class _LibraryGrid extends StatelessWidget {
  const _LibraryGrid({
    required this.items,
    required this.controller,
    required this.showFooter,
    required this.highlightUserBookId,
  });

  final List<UserBook> items;
  final ScrollController controller;
  final bool showFooter;
  final String? highlightUserBookId;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;

    return CustomScrollView(
      controller: controller,
      slivers: <Widget>[
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            spacing.md,
            0,
            spacing.md,
            spacing.md,
          ),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: spacing.md,
              crossAxisSpacing: spacing.md,
              childAspectRatio: 2 / 3.8,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final UserBook userBook = items[index];
                final bool highlight = userBook.id == highlightUserBookId;
                return _LibraryCard(
                  userBook: userBook,
                  highlight: highlight,
                );
              },
              childCount: items.length,
            ),
          ),
        ),
        if (showFooter)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _LibraryCard extends ConsumerWidget {
  const _LibraryCard({required this.userBook, required this.highlight});

  final UserBook userBook;
  final bool highlight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final radii = theme.extension<AppRadius>()!;
    return Container(
      decoration: highlight
          ? BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(radii.md)),
              border: Border.all(
                // Primary picks up rauschDark automatically on dark theme so
                // the highlight ring stays brand-correct and visible.
                color: theme.colorScheme.primary,
                width: 2,
              ),
            )
          : null,
      padding: highlight ? const EdgeInsets.all(4) : EdgeInsets.zero,
      child: BookCard.grid(
        book: userBook.book,
        status: userBook.status,
        onTap: () => _showActions(context, ref, userBook),
      ),
    );
  }

  void _showActions(BuildContext context, WidgetRef ref, UserBook userBook) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _LibraryActionsSheet(userBook: userBook),
    );
  }
}

class _LibraryActionsSheet extends ConsumerWidget {
  const _LibraryActionsSheet({required this.userBook});

  final UserBook userBook;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          spacing.lg,
          spacing.sm,
          spacing.lg,
          spacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              userBook.book.title,
              style: theme.textTheme.titleLarge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: spacing.sm),
            ListTile(
              leading: const Icon(Icons.swap_horiz_rounded),
              title: const Text('상태 변경'),
              onTap: () async {
                Navigator.of(context).pop();
                await _showStatusSheet(context, ref, userBook);
              },
            ),
            ListTile(
              leading: const Icon(Icons.rate_review_outlined),
              title: const Text('리뷰 작성'),
              onTap: () async {
                Navigator.of(context).pop();
                await ReviewModal.show(context, userBook: userBook);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline_rounded),
              title: const Text('서재에서 삭제'),
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('준비중', style: theme.textTheme.labelMedium),
              ),
              enabled: false,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showStatusSheet(
    BuildContext context,
    WidgetRef ref,
    UserBook current,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return _StatusChangeSheet(userBook: current);
      },
    );
  }
}

class _StatusChangeSheet extends ConsumerStatefulWidget {
  const _StatusChangeSheet({required this.userBook});

  final UserBook userBook;

  @override
  ConsumerState<_StatusChangeSheet> createState() => _StatusChangeSheetState();
}

class _StatusChangeSheetState extends ConsumerState<_StatusChangeSheet> {
  late BookStatus _selected = widget.userBook.status;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          spacing.lg,
          spacing.sm,
          spacing.lg,
          spacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('상태 변경', style: theme.textTheme.headlineMedium),
            SizedBox(height: spacing.md),
            StatusSegment(
              selected: _selected,
              onChanged: (BookStatus next) => setState(() => _selected = next),
            ),
            SizedBox(height: spacing.lg),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _saving ? null : () => _save(),
                child: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('저장'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final repository = ref.read(bookRepositoryProvider);
      final updated = await repository.updateStatus(
        userBookId: widget.userBook.id,
        status: _selected,
      );
      ref.read(libraryNotifierProvider.notifier).upsert(updated);
      if (!mounted) return;
      Navigator.of(context).pop();
      // Trigger review modal automatically on first transition into completed.
      if (_selected == BookStatus.completed &&
          widget.userBook.status != BookStatus.completed &&
          updated.rating == null) {
        await ReviewModal.show(context, userBook: updated);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing.xl),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.cloud_off_rounded, size: 40),
            SizedBox(height: spacing.md),
            Text(message, style: theme.textTheme.titleLarge),
            SizedBox(height: spacing.lg),
            FilledButton(
              onPressed: () {
                onRetry();
              },
              child: const Text('다시 시도'),
            ),
          ],
        ),
      ),
    );
  }
}
