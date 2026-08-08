import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../feed/application/my_recent_highlights_notifier.dart';
import '../../feed/data/feed_models.dart';

/// "내 활동 > 내 하이라이트" 더보기 (BC-83) — `GET /me/highlights/recent`, 최신순
/// 오프셋 페이지네이션. Distinct from the library screen's "하이라이트" tab (which
/// is grouped by book and unpaginated); this is a flat newest-first feed.
///
/// Each row deep-links to the book's detail screen ([AppRoutes.bookDetail]).
class MyRecentHighlightsScreen extends ConsumerStatefulWidget {
  const MyRecentHighlightsScreen({super.key});

  @override
  ConsumerState<MyRecentHighlightsScreen> createState() =>
      _MyRecentHighlightsScreenState();
}

class _MyRecentHighlightsScreenState
    extends ConsumerState<MyRecentHighlightsScreen> {
  final ScrollController _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(myRecentHighlightsNotifierProvider.notifier).fetchFirst(),
    );
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll.removeListener(_onScroll);
    _scroll.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;
    if (_scroll.position.maxScrollExtent - _scroll.position.pixels < 200) {
      ref.read(myRecentHighlightsNotifierProvider.notifier).fetchMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final MyRecentHighlightsState state =
        ref.watch(myRecentHighlightsNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: Text('내 하이라이트 (${state.total})')),
      body: _buildBody(context, theme, spacing, state),
    );
  }

  Widget _buildBody(
    BuildContext context,
    ThemeData theme,
    AppSpacing spacing,
    MyRecentHighlightsState state,
  ) {
    if (state.isLoading && state.items.isEmpty) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }
    if (state.error != null && state.items.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(spacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('하이라이트를 불러오지 못했어요', style: theme.textTheme.bodyMedium),
              SizedBox(height: spacing.sm),
              FilledButton(
                onPressed: () => ref
                    .read(myRecentHighlightsNotifierProvider.notifier)
                    .fetchFirst(),
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
      );
    }
    if (state.items.isEmpty) {
      return Center(
        child: Text(
          '저장된 하이라이트가 없어요',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      );
    }
    return ListView.separated(
      controller: _scroll,
      padding: EdgeInsets.all(spacing.lg),
      itemCount: state.items.length + (state.hasMore ? 1 : 0),
      separatorBuilder: (_, __) => SizedBox(height: spacing.sm),
      itemBuilder: (context, index) {
        if (index == state.items.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }
        return _MyHighlightCard(item: state.items[index]);
      },
    );
  }
}

class _MyHighlightCard extends StatelessWidget {
  const _MyHighlightCard({required this.item});

  final MyHighlightItemDto item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    return Material(
      color: theme.colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push(AppRoutes.bookDetail(item.bookId)),
        child: Padding(
          padding: EdgeInsets.all(spacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                CupertinoIcons.quote_bubble,
                size: 16,
                color: theme.colorScheme.primary,
              ),
              SizedBox(width: spacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.quoteText,
                      style: theme.textTheme.bodyMedium,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (item.bookTitle != null) ...[
                      SizedBox(height: spacing.xs),
                      Text(
                        item.bookTitle!,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
