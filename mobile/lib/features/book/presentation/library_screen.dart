import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/application/auth_notifier.dart';
import '../../auth/domain/auth_state.dart';
import '../../auth/domain/auth_user.dart';
import '../../feed/application/feed_providers.dart';
import '../../feed/application/highlight_providers.dart';
import '../../feed/data/highlight_models.dart';
import '../../feed/domain/book_highlight_group.dart';
import '../../feed/domain/highlight.dart';
import '../../feed/presentation/widgets/add_highlight_sheet.dart';
import '../application/book_providers.dart';
import '../application/library_notifier.dart';
import '../application/library_state.dart';
import '../domain/book_status.dart';
import '../domain/user_book.dart';
import 'widgets/book_card.dart';
import 'widgets/book_cover.dart';
import 'widgets/empty_states.dart';
import 'widgets/review_modal.dart';
import 'widgets/status_segment.dart';

/// "내 서재" — tab-based library with All / Reading / Completed / Wishlist /
/// Highlights.
///
/// 탭 구성:
///   0. 전체       — 모든 상태의 책을 합산 표시 (잠시 멈춤·포기 포함)
///   1. 읽는 중
///   2. 완독
///   3. 읽고 싶어요
///   4. 하이라이트  — 저장된 인용구를 책별로 그룹핑
///
/// 잠시 멈춤 / 포기 상태는 "전체" 탭에서만 노출된다. 롱프레스 액션 시트로
/// 어떤 상태로도 변경 가능하다.
class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key, this.highlightUserBookId});

  final String? highlightUserBookId;

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  // Scroll controllers for book tabs 0-3 (전체/읽는 중/완독/읽고 싶어요).
  // Highlights tab manages its own scroll internally.
  late final List<ScrollController> _scrolls;

  // tab index → BookStatus (null = 전체, absent = 하이라이트)
  static const List<BookStatus?> _kTabStatuses = [
    null, // 0 전체
    BookStatus.reading, // 1
    BookStatus.completed, // 2
    BookStatus.wishlist, // 3
  ];
  static const int _kHighlightsTab = 4;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 5, vsync: this);
    _tab.addListener(_onTabChange);
    _scrolls = List.generate(4, (i) {
      final ctrl = ScrollController();
      ctrl.addListener(() => _onScroll(i));
      return ctrl;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadTab(0));
  }

  @override
  void dispose() {
    _tab.dispose();
    for (final c in _scrolls) {
      c.dispose();
    }
    super.dispose();
  }

  void _showCaptureSheet(BuildContext context) {
    final map = ref.read(libraryNotifierProvider);
    final List<UserBook> completedBooks = switch (map[BookStatus.completed]) {
      LibraryListLoaded(:final items) => items,
      _ => <UserBook>[],
    };
    final int totalBooks = BookStatus.values.fold(0, (sum, s) {
      return sum +
          switch (map[s]) {
            LibraryListLoaded(:final items) => items.length,
            _ => 0,
          };
    });
    final AuthUser? user = switch (ref.read(authNotifierProvider)) {
      Authenticated(:final user) => user,
      _ => null,
    };

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _LibraryCaptureSheet(
        coverBooks: completedBooks.take(6).toList(),
        totalBooks: totalBooks,
        nickname: user?.nickname ?? '독서가',
      ),
    );
  }

  void _onTabChange() {
    if (_tab.indexIsChanging) return;
    _loadTab(_tab.index);
  }

  void _loadTab(int index) {
    if (index == _kHighlightsTab) return;
    final status = index < _kTabStatuses.length ? _kTabStatuses[index] : null;
    if (status == null) {
      for (final s in BookStatus.values) {
        ref.read(libraryNotifierProvider.notifier).ensureLoaded(s);
      }
    } else {
      ref.read(libraryNotifierProvider.notifier).ensureLoaded(status);
    }
  }

  void _onScroll(int i) {
    final ctrl = _scrolls[i];
    if (!ctrl.hasClients) return;
    if (ctrl.position.maxScrollExtent - ctrl.position.pixels < 200) {
      if (i < _kTabStatuses.length) {
        final status = _kTabStatuses[i];
        if (status != null) {
          ref.read(libraryNotifierProvider.notifier).loadMore(status);
        }
      }
    }
  }

  int _tabIndexFor(BookStatus s) => switch (s) {
        BookStatus.reading => 1,
        BookStatus.completed => 2,
        BookStatus.wishlist => 3,
        _ => 0, // paused / dropped → 전체
      };

  @override
  Widget build(BuildContext context) {
    ref.listen<BookStatus?>(libraryPendingTabProvider, (_, next) {
      if (next == null) return;
      ref.read(libraryPendingTabProvider.notifier).set(null);
      final idx = _tabIndexFor(next);
      _tab.animateTo(idx);
      _loadTab(idx);
    });

    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final map = ref.watch(libraryNotifierProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(
                spacing.lg,
                spacing.md,
                spacing.sm,
                0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      '내 서재',
                      style: theme.textTheme.displaySmall,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.camera_alt_outlined),
                    tooltip: '서재 캡처',
                    onPressed: () => _showCaptureSheet(context),
                  ),
                ],
              ),
            ),
            TabBar(
              controller: _tab,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelPadding: const EdgeInsets.symmetric(horizontal: 16),
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              unselectedLabelStyle: theme.textTheme.labelLarge,
              tabs: const <Tab>[
                Tab(text: '전체'),
                Tab(text: '읽는 중'),
                Tab(text: '완독'),
                Tab(text: '읽고 싶어요'),
                Tab(text: '하이라이트'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tab,
                children: <Widget>[
                  _AllBooksTab(
                    map: map,
                    controller: _scrolls[0],
                    highlightUserBookId: widget.highlightUserBookId,
                    onBrowse: () => context.go('/search'),
                    onRefresh: () async {
                      await Future.wait<void>(<Future<void>>[
                        for (final s in BookStatus.values)
                          ref.read(libraryNotifierProvider.notifier).refresh(s),
                      ]);
                    },
                  ),
                  _StatusTab(
                    status: BookStatus.reading,
                    state: map[BookStatus.reading] ??
                        const LibraryListState.initial(),
                    controller: _scrolls[1],
                    highlightUserBookId: widget.highlightUserBookId,
                    onBrowse: () => context.go('/search'),
                    onRefresh: () => ref
                        .read(libraryNotifierProvider.notifier)
                        .refresh(BookStatus.reading),
                  ),
                  _CompletedTab(
                    state: map[BookStatus.completed] ??
                        const LibraryListState.initial(),
                    controller: _scrolls[2],
                    highlightUserBookId: widget.highlightUserBookId,
                    onBrowse: () => context.go('/search'),
                    onRefresh: () => ref
                        .read(libraryNotifierProvider.notifier)
                        .refresh(BookStatus.completed),
                  ),
                  _StatusTab(
                    status: BookStatus.wishlist,
                    state: map[BookStatus.wishlist] ??
                        const LibraryListState.initial(),
                    controller: _scrolls[3],
                    highlightUserBookId: widget.highlightUserBookId,
                    onBrowse: () => context.go('/search'),
                    onRefresh: () => ref
                        .read(libraryNotifierProvider.notifier)
                        .refresh(BookStatus.wishlist),
                  ),
                  const _HighlightsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 전체 탭
// ---------------------------------------------------------------------------

class _AllBooksTab extends StatelessWidget {
  const _AllBooksTab({
    required this.map,
    required this.controller,
    required this.highlightUserBookId,
    required this.onBrowse,
    required this.onRefresh,
  });

  final Map<BookStatus, LibraryListState> map;
  final ScrollController controller;
  final String? highlightUserBookId;
  final VoidCallback onBrowse;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    // Show spinner while every status is still unloaded / loading.
    final allPending = BookStatus.values.every((s) {
      final st = map[s];
      return st == null || st is LibraryListInitial || st is LibraryListLoading;
    });
    if (allPending) return const Center(child: CircularProgressIndicator());

    // Ordered merge: reading → completed → wishlist → paused → dropped.
    const List<BookStatus> order = <BookStatus>[
      BookStatus.reading,
      BookStatus.completed,
      BookStatus.wishlist,
      BookStatus.paused,
      BookStatus.dropped,
    ];
    final List<UserBook> items = <UserBook>[
      for (final s in order)
        ...switch (map[s]) {
          LibraryListLoaded(:final items) => items,
          _ => <UserBook>[],
        },
    ];

    if (items.isEmpty) {
      return BookEmptyState(
        icon: Icons.auto_stories_outlined,
        title: '서재가 비어있어요',
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
        showFooter: false,
        highlightUserBookId: highlightUserBookId,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 개별 상태 탭
// ---------------------------------------------------------------------------

class _StatusTab extends StatelessWidget {
  const _StatusTab({
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
  Widget build(BuildContext context) {
    return switch (state) {
      LibraryListInitial() ||
      LibraryListLoading() =>
        const Center(child: CircularProgressIndicator()),
      LibraryListError(:final String message) => _ErrorView(
          message: message,
          onRetry: onRefresh,
        ),
      LibraryListLoaded(
        :final List<UserBook> items,
        :final String? nextCursor,
        :final bool isLoadingMore,
      ) =>
        items.isEmpty
            ? BookEmptyState(
                icon: Icons.auto_stories_outlined,
                title: status.emptyMessage,
                subtitle: '검색으로 새 책을 담아보세요.',
                actionLabel: '책 검색하기',
                onAction: onBrowse,
              )
            : RefreshIndicator(
                onRefresh: onRefresh,
                color: Theme.of(context).colorScheme.primary,
                child: _LibraryGrid(
                  items: items,
                  controller: controller,
                  showFooter: nextCursor != null || isLoadingMore,
                  highlightUserBookId: highlightUserBookId,
                ),
              ),
    };
  }
}

// ---------------------------------------------------------------------------
// 공통 그리드
// ---------------------------------------------------------------------------

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
            spacing.md,
            spacing.md,
            spacing.md,
          ),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: spacing.md,
              crossAxisSpacing: spacing.md,
              childAspectRatio: 2 / 4.3,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext ctx, int index) => _LibraryCard(
                userBook: items[index],
                highlight: items[index].id == highlightUserBookId,
              ),
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

// ---------------------------------------------------------------------------
// 개별 책 카드 (그리드 셀)
// ---------------------------------------------------------------------------

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
              border: Border.all(color: theme.colorScheme.primary, width: 2),
            )
          : null,
      padding: highlight ? const EdgeInsets.all(4) : EdgeInsets.zero,
      child: BookCard.grid(
        book: userBook.book,
        status: userBook.status,
        onTap: () => context.push(
          AppRoutes.bookDetail(userBook.book.id),
          extra: userBook.id,
        ),
        onLongPress: () => _showActions(context, ref, userBook),
        onStatusTap: () => _showStatusDirect(context, userBook),
        onMoreTap: () => _showActions(context, ref, userBook),
        onPlayTap: () {
          final router = GoRouter.of(context);
          router.push(
            '/reading/timer?user_book_id=${userBook.id}&auto_start=true',
          );
        },
      ),
    );
  }

  void _showStatusDirect(BuildContext context, UserBook userBook) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _StatusChangeSheet(userBook: userBook),
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

// ---------------------------------------------------------------------------
// 롱프레스 액션 시트
// ---------------------------------------------------------------------------

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
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  final router = GoRouter.of(context);
                  Navigator.of(context).pop();
                  router.push(
                    '/reading/timer?user_book_id=${userBook.id}&auto_start=true',
                  );
                },
                icon: const Icon(Icons.play_circle_outline_rounded),
                label: const Text('읽기 시작'),
              ),
            ),
            SizedBox(height: spacing.xs),
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
              leading: const Icon(Icons.format_quote_rounded),
              title: const Text('하이라이트 추가'),
              onTap: () async {
                Navigator.of(context).pop();
                await _showHighlightSheet(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.delete_outline_rounded,
                color: theme.colorScheme.error,
              ),
              title: Text(
                '서재에서 삭제',
                style: TextStyle(color: theme.colorScheme.error),
              ),
              onTap: () async {
                // Capture messenger/navigator BEFORE any async gap so they
                // remain valid even after this sheet is popped.
                final messenger = ScaffoldMessenger.of(context);
                final navigator = Navigator.of(context);

                final bool? confirmed = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('서재에서 삭제'),
                    content: Text('"${userBook.book.title}"를 서재에서 삭제할까요?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: const Text('취소'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        child: Text(
                          '삭제',
                          style: TextStyle(
                            color: Theme.of(ctx).colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
                if (confirmed != true) return;
                navigator.pop(); // close the actions sheet
                try {
                  await ref
                      .read(libraryNotifierProvider.notifier)
                      .removeFromLibrary(userBook.id);
                  messenger.showSnackBar(
                    const SnackBar(content: Text('서재에서 삭제됐어요')),
                  );
                } on Exception {
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text('삭제에 실패했어요. 다시 시도해주세요.'),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showHighlightSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => AddHighlightSheet(userBookId: userBook.id),
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
      builder: (_) => _StatusChangeSheet(userBook: current),
    );
  }
}

// ---------------------------------------------------------------------------
// 상태 변경 시트
// ---------------------------------------------------------------------------

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
                onPressed: _saving ? null : _save,
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
      if (_selected == BookStatus.completed &&
          widget.userBook.status != BookStatus.completed &&
          updated.rating == null) {
        await ReviewModal.show(context, userBook: updated);
      }
    } catch (_) {
      if (mounted) setState(() => _saving = false);
    }
  }
}

// ---------------------------------------------------------------------------
// 에러 뷰
// ---------------------------------------------------------------------------

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
            FilledButton(onPressed: onRetry, child: const Text('다시 시도')),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 하이라이트 탭
// ---------------------------------------------------------------------------

class _HighlightsTab extends ConsumerWidget {
  const _HighlightsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final AsyncValue<List<BookHighlightGroup>> async =
        ref.watch(allHighlightsProvider);

    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (Object e, _) => Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.cloud_off_rounded, size: 40),
              SizedBox(height: spacing.md),
              Text(
                '하이라이트를 불러오지 못했어요.',
                style: theme.textTheme.titleMedium,
              ),
              SizedBox(height: spacing.lg),
              FilledButton(
                onPressed: () => ref.invalidate(allHighlightsProvider),
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
      ),
      data: (List<BookHighlightGroup> groups) {
        if (groups.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing.xl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.format_quote_rounded,
                    size: 52,
                    color: theme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.4),
                  ),
                  SizedBox(height: spacing.md),
                  Text(
                    '저장된 하이라이트가 없어요',
                    style: theme.textTheme.titleMedium,
                  ),
                  SizedBox(height: spacing.sm),
                  Text(
                    '롱프레스 → 하이라이트 추가로\n인상 깊은 문장을 저장해보세요.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return ListView.builder(
          padding: EdgeInsets.fromLTRB(
            spacing.md,
            spacing.md,
            spacing.md,
            spacing.xl,
          ),
          itemCount: groups.length,
          itemBuilder: (BuildContext context, int index) =>
              _HighlightGroup(group: groups[index]),
        );
      },
    );
  }
}

class _HighlightGroup extends StatefulWidget {
  const _HighlightGroup({required this.group});

  final BookHighlightGroup group;

  @override
  State<_HighlightGroup> createState() => _HighlightGroupState();
}

class _HighlightGroupState extends State<_HighlightGroup> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final radii = theme.extension<AppRadius>()!;
    final int count = widget.group.highlights.length;

    return Padding(
      padding: EdgeInsets.only(bottom: spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.all(Radius.circular(radii.sm)),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: spacing.xs),
              child: Row(
                children: <Widget>[
                  BookCover(
                    coverUrl: widget.group.bookCoverUrl,
                    width: 44,
                    height: 62,
                    borderRadius: BorderRadius.all(Radius.circular(radii.sm)),
                  ),
                  SizedBox(width: spacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.group.bookTitle ?? '알 수 없는 책',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$count개의 하이라이트',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: _expanded ? 0.25 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_expanded) ...<Widget>[
            SizedBox(height: spacing.xs),
            ...widget.group.highlights.map(
              (Highlight h) => _HighlightCard(highlight: h),
            ),
          ],
        ],
      ),
    );
  }
}

class _HighlightCard extends ConsumerStatefulWidget {
  const _HighlightCard({required this.highlight});

  final Highlight highlight;

  @override
  ConsumerState<_HighlightCard> createState() => _HighlightCardState();
}

class _HighlightCardState extends ConsumerState<_HighlightCard> {
  // The library list endpoint doesn't yet carry per-highlight visibility, so
  // we track the user's last in-session choice optimistically and let the
  // PATCH be the source of truth on the server.
  HighlightVisibility _visibility = HighlightVisibility.private;
  bool _sharing = false;

  Highlight get highlight => widget.highlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radii = theme.extension<AppRadius>()!;
    final spacing = theme.extension<AppSpacing>()!;
    final Color primary = theme.colorScheme.primary;

    return Container(
      margin: EdgeInsets.only(bottom: spacing.sm),
      padding: EdgeInsets.fromLTRB(
        spacing.md,
        spacing.md,
        spacing.md,
        spacing.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.all(Radius.circular(radii.md)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // 인용구 + 삭제 버튼
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 6, top: 2),
                child: Icon(
                  Icons.format_quote_rounded,
                  size: 20,
                  color: primary.withValues(alpha: 0.5),
                ),
              ),
              Expanded(
                child: Text(
                  highlight.quoteText,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.65,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              SizedBox(
                width: 28,
                height: 28,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 18,
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color: theme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.55),
                  ),
                  onPressed: () => _confirmDelete(context, ref),
                ),
              ),
            ],
          ),
          // 페이지 번호
          if (highlight.pageNumber != null) ...<Widget>[
            SizedBox(height: spacing.xs),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.all(
                    Radius.circular(radii.pill),
                  ),
                ),
                child: Text(
                  'p.${highlight.pageNumber}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
          SizedBox(height: spacing.xs),
          _buildFooter(context, theme),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, ThemeData theme) {
    return Row(
      children: <Widget>[
        PopupMenuButton<HighlightVisibility>(
          tooltip: '공개 범위',
          initialValue: _visibility,
          onSelected: _changeVisibility,
          itemBuilder: (_) => <PopupMenuEntry<HighlightVisibility>>[
            _visibilityItem(HighlightVisibility.private),
            _visibilityItem(HighlightVisibility.followers),
            _visibilityItem(HighlightVisibility.public),
          ],
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                _visibilityIcon(_visibility),
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                _visibilityLabel(_visibility),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Icon(
                Icons.arrow_drop_down_rounded,
                size: 18,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
        const Spacer(),
        TextButton.icon(
          onPressed: _sharing ? null : _shareToFeed,
          icon: _sharing
              ? const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.ios_share_rounded, size: 16),
          label: const Text('피드에 공유'),
        ),
      ],
    );
  }

  PopupMenuItem<HighlightVisibility> _visibilityItem(
    HighlightVisibility visibility,
  ) {
    return PopupMenuItem<HighlightVisibility>(
      value: visibility,
      child: Row(
        children: <Widget>[
          Icon(_visibilityIcon(visibility), size: 18),
          const SizedBox(width: 8),
          Text(_visibilityLabel(visibility)),
        ],
      ),
    );
  }

  Future<void> _changeVisibility(HighlightVisibility visibility) async {
    if (visibility == _visibility) return;
    final messenger = ScaffoldMessenger.of(context);
    final HighlightVisibility previous = _visibility;
    setState(() => _visibility = visibility);
    try {
      await ref
          .read(highlightRepositoryProvider)
          .updateVisibility(highlight.id, visibility);
      messenger.showSnackBar(
        SnackBar(
            content: Text('공개 범위를 ${_visibilityLabel(visibility)}(으)로 바꿨어요')),
      );
    } on Exception {
      if (!mounted) return;
      setState(() => _visibility = previous);
      messenger.showSnackBar(
        const SnackBar(content: Text('공개 범위를 바꾸지 못했어요. 다시 시도해주세요.')),
      );
    }
  }

  Future<void> _shareToFeed() async {
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _sharing = true);
    try {
      await ref.read(highlightRepositoryProvider).shareToFeed(highlight.id);
      if (!mounted) return;
      setState(() => _sharing = false);
      messenger.showSnackBar(
        const SnackBar(content: Text('피드에 공유했어요')),
      );
    } on Exception {
      if (!mounted) return;
      setState(() => _sharing = false);
      messenger.showSnackBar(
        const SnackBar(content: Text('공유에 실패했어요. 다시 시도해주세요.')),
      );
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    // Capture messenger BEFORE any async gap.
    final messenger = ScaffoldMessenger.of(context);

    final bool? confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('하이라이트 삭제'),
        content: const Text('이 하이라이트를 삭제할까요?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              '삭제',
              style: TextStyle(
                color: Theme.of(ctx).colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await ref.read(feedRepositoryProvider).deleteHighlight(
            userBookId: highlight.userBookId,
            highlightId: highlight.id,
          );
      ref.invalidate(allHighlightsProvider);
      messenger.showSnackBar(
        const SnackBar(content: Text('하이라이트가 삭제됐어요')),
      );
    } on Exception {
      messenger.showSnackBar(
        const SnackBar(content: Text('삭제에 실패했어요. 다시 시도해주세요.')),
      );
    }
  }
}

IconData _visibilityIcon(HighlightVisibility visibility) {
  switch (visibility) {
    case HighlightVisibility.private:
      return Icons.lock_outline_rounded;
    case HighlightVisibility.followers:
      return Icons.group_outlined;
    case HighlightVisibility.public:
      return Icons.public_rounded;
  }
}

String _visibilityLabel(HighlightVisibility visibility) {
  switch (visibility) {
    case HighlightVisibility.private:
      return '비공개';
    case HighlightVisibility.followers:
      return '팔로워';
    case HighlightVisibility.public:
      return '전체 공개';
  }
}

// ---------------------------------------------------------------------------
// 완독 탭 — 별점·완독일이 포함된 2열 그리드
// ---------------------------------------------------------------------------

class _CompletedTab extends StatelessWidget {
  const _CompletedTab({
    required this.state,
    required this.controller,
    required this.highlightUserBookId,
    required this.onBrowse,
    required this.onRefresh,
  });

  final LibraryListState state;
  final ScrollController controller;
  final String? highlightUserBookId;
  final VoidCallback onBrowse;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      LibraryListInitial() ||
      LibraryListLoading() =>
        const Center(child: CircularProgressIndicator()),
      LibraryListError(:final String message) => _ErrorView(
          message: message,
          onRetry: onRefresh,
        ),
      LibraryListLoaded(
        :final List<UserBook> items,
        :final String? nextCursor,
        :final bool isLoadingMore,
      ) =>
        items.isEmpty
            ? BookEmptyState(
                icon: Icons.auto_stories_outlined,
                title: BookStatus.completed.emptyMessage,
                subtitle: '검색으로 새 책을 담아보세요.',
                actionLabel: '책 검색하기',
                onAction: onBrowse,
              )
            : RefreshIndicator(
                onRefresh: onRefresh,
                color: Theme.of(context).colorScheme.primary,
                child: _CompletedGrid(
                  items: items,
                  controller: controller,
                  showFooter: nextCursor != null || isLoadingMore,
                  highlightUserBookId: highlightUserBookId,
                ),
              ),
    };
  }
}

class _CompletedGrid extends StatelessWidget {
  const _CompletedGrid({
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
            spacing.sm,
            spacing.md,
            spacing.md,
          ),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: spacing.md,
              crossAxisSpacing: spacing.md,
              childAspectRatio: 2 / 5.0,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext ctx, int index) => _CompletedCard(
                userBook: items[index],
                highlight: items[index].id == highlightUserBookId,
              ),
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

// ---------------------------------------------------------------------------
// 완독 카드 — 별점 + 완독일 표시
// ---------------------------------------------------------------------------

class _CompletedCard extends ConsumerWidget {
  const _CompletedCard({required this.userBook, required this.highlight});

  final UserBook userBook;
  final bool highlight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final radii = theme.extension<AppRadius>()!;
    final Color primary = theme.colorScheme.primary;

    return Container(
      decoration: highlight
          ? BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(radii.md)),
              border: Border.all(color: primary, width: 2),
            )
          : null,
      padding: highlight ? const EdgeInsets.all(4) : EdgeInsets.zero,
      child: InkWell(
        onTap: () => context.push(
          AppRoutes.bookDetail(userBook.book.id),
          extra: userBook.id,
        ),
        onLongPress: () => _showActions(context, ref, userBook),
        borderRadius: BorderRadius.all(Radius.circular(radii.md)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            BookCover(
              coverUrl: userBook.book.coverUrl,
              borderRadius: BorderRadius.all(Radius.circular(radii.md)),
            ),
            SizedBox(height: spacing.sm),
            Text(
              userBook.book.title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              userBook.book.author,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            if (userBook.rating != null && userBook.rating! > 0)
              Row(
                children: List<Widget>.generate(
                  userBook.rating!.clamp(0, 5),
                  (_) => Icon(Icons.star_rounded, size: 13, color: primary),
                ),
              )
            else
              Text(
                '별점 주기',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant
                      .withValues(alpha: 0.55),
                ),
              ),
            if (userBook.finishedAt != null) ...<Widget>[
              const SizedBox(height: 2),
              Text(
                _fmtDate(userBook.finishedAt!),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 10,
                ),
              ),
            ],
          ],
        ),
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

  String _fmtDate(DateTime dt) {
    final DateTime local = dt.toLocal();
    if (local.year == DateTime.now().year) {
      return '${local.month}월 ${local.day}일 완독';
    }
    return '${local.year}.${local.month}.${local.day} 완독';
  }
}

// ---------------------------------------------------------------------------
// 서재 캡처 시트
// ---------------------------------------------------------------------------

/// Aspect ratio options for the capture card.
enum _CaptureAspect {
  square, // 1:1
  portrait, // 9:16
}

class _LibraryCaptureSheet extends StatefulWidget {
  const _LibraryCaptureSheet({
    required this.coverBooks,
    required this.totalBooks,
    required this.nickname,
  });

  final List<UserBook> coverBooks;
  final int totalBooks;
  final String nickname;

  @override
  State<_LibraryCaptureSheet> createState() => _LibraryCaptureSheetState();
}

class _LibraryCaptureSheetState extends State<_LibraryCaptureSheet> {
  final GlobalKey _captureKey = GlobalKey();
  _CaptureAspect _aspect = _CaptureAspect.square;
  bool _sharing = false;

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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              '서재 공유',
              style: theme.textTheme.headlineMedium,
            ),
            SizedBox(height: spacing.md),
            // Capture preview
            Center(
              child: RepaintBoundary(
                key: _captureKey,
                child: _LibraryCaptureWidget(
                  coverBooks: widget.coverBooks,
                  totalBooks: widget.totalBooks,
                  nickname: widget.nickname,
                  aspect: _aspect,
                ),
              ),
            ),
            SizedBox(height: spacing.md),
            // Aspect ratio toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _AspectButton(
                  label: '정사각형',
                  selected: _aspect == _CaptureAspect.square,
                  onTap: () => setState(() => _aspect = _CaptureAspect.square),
                ),
                SizedBox(width: spacing.sm),
                _AspectButton(
                  label: '세로형',
                  selected: _aspect == _CaptureAspect.portrait,
                  onTap: () =>
                      setState(() => _aspect = _CaptureAspect.portrait),
                ),
              ],
            ),
            SizedBox(height: spacing.md),
            // Share button
            FilledButton.icon(
              onPressed: _sharing ? null : _captureAndShare,
              icon: _sharing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.share_rounded),
              label: const Text('캡처 & 공유'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _captureAndShare() async {
    setState(() => _sharing = true);
    try {
      final boundary = _captureKey.currentContext!.findRenderObject()!
          as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? data =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (data == null) {
        setState(() => _sharing = false);
        return;
      }
      final List<int> pngBytes = data.buffer.asUint8List();
      await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile.fromData(
              Uint8List.fromList(pngBytes),
              name: 'my_library.png',
              mimeType: 'image/png',
            ),
          ],
          subject: '내 서재 — 골방',
        ),
      );
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }
}

class _AspectButton extends StatelessWidget {
  const _AspectButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radii = theme.extension<AppRadius>()!;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.all(Radius.circular(radii.pill)),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: selected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 캡처 전용 위젯 — RepaintBoundary 내부에 렌더링되는 실제 카드
// ---------------------------------------------------------------------------

class _LibraryCaptureWidget extends StatelessWidget {
  const _LibraryCaptureWidget({
    required this.coverBooks,
    required this.totalBooks,
    required this.nickname,
    required this.aspect,
  });

  final List<UserBook> coverBooks;
  final int totalBooks;
  final String nickname;
  final _CaptureAspect aspect;

  static const double _cardWidth = 300.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double height =
        aspect == _CaptureAspect.portrait ? _cardWidth * 16 / 9 : _cardWidth;

    return Container(
      width: _cardWidth,
      height: height,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Header: nickname + label
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        nickname,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '내 서재',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.menu_book_rounded,
                  color: theme.colorScheme.primary,
                  size: 22,
                ),
              ],
            ),
          ),
          // Book cover grid — 2 columns × 3 rows
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _CoverGrid(books: coverBooks),
            ),
          ),
          // Footer: stats + watermark
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.06),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    '읽은 책 $totalBooks권',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                Text(
                  '골방',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CoverGrid extends StatelessWidget {
  const _CoverGrid({required this.books});

  final List<UserBook> books;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radii = theme.extension<AppRadius>()!;

    // Fill up to 6 slots; empty slots render a placeholder tint.
    final List<UserBook?> slots = List<UserBook?>.generate(
      6,
      (i) => i < books.length ? books[i] : null,
    );

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        childAspectRatio: 2 / 3,
      ),
      itemCount: 6,
      itemBuilder: (_, i) {
        final UserBook? book = slots[i];
        if (book == null) {
          return Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.all(Radius.circular(radii.sm)),
            ),
          );
        }
        return BookCover(
          coverUrl: book.book.coverUrl,
          borderRadius: BorderRadius.all(Radius.circular(radii.sm)),
        );
      },
    );
  }
}
