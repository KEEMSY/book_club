import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../application/discovery_providers.dart';
import '../domain/recommended_book.dart';

class DiscoveryScreen extends ConsumerWidget {
  const DiscoveryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final recommendationsAsync = ref.watch(recommendationsProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: const Text('탐색'),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: Padding(
                padding:
                    EdgeInsets.fromLTRB(spacing.lg, 0, spacing.lg, spacing.md),
                child: GestureDetector(
                  onTap: () => context.push(AppRoutes.search),
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: spacing.md),
                        Icon(
                          Icons.search_rounded,
                          color: theme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                        SizedBox(width: spacing.sm),
                        Text(
                          '책 제목, 저자, ISBN 검색',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          recommendationsAsync.when(
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
            error: (_, __) => SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(spacing.lg),
                child: Text(
                  '추천을 불러오지 못했어요',
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            data: (items) => items.isEmpty
                ? SliverFillRemaining(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(spacing.lg),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.auto_awesome_rounded,
                              size: 48,
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.3),
                            ),
                            SizedBox(height: spacing.md),
                            Text(
                              '더 많은 책을 읽으면\n맞춤 추천이 생겨요',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.5),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : _RecommendationSliver(items: items),
          ),
        ],
      ),
    );
  }
}

class _RecommendationSliver extends StatelessWidget {
  const _RecommendationSliver({required this.items});

  final List<RecommendedBook> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    final popular =
        items.where((b) => b.reason == 'community_popular').toList();
    final similar =
        items.where((b) => b.reason == 'similar_readers').toList();
    final recent =
        items.where((b) => b.reason == 'recently_added').toList();

    return SliverPadding(
      padding: EdgeInsets.only(bottom: spacing.xl),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          if (popular.isNotEmpty) ...[
            _SectionHeader(
              title: '커뮤니티에서 화제',
              spacing: spacing,
              theme: theme,
            ),
            _HorizontalBookScroll(books: popular),
          ],
          if (similar.isNotEmpty) ...[
            _SectionHeader(
              title: '비슷한 독자들이 읽는 책',
              spacing: spacing,
              theme: theme,
            ),
            _HorizontalBookScroll(books: similar),
          ],
          if (recent.isNotEmpty) ...[
            _SectionHeader(
              title: '요즘 많이 추가하는 책',
              spacing: spacing,
              theme: theme,
            ),
            _HorizontalBookScroll(books: recent),
          ],
        ]),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.spacing,
    required this.theme,
  });

  final String title;
  final AppSpacing spacing;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        spacing.lg,
        spacing.lg,
        spacing.lg,
        spacing.sm,
      ),
      child: Text(
        title,
        style: theme.textTheme.titleMedium
            ?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _HorizontalBookScroll extends StatelessWidget {
  const _HorizontalBookScroll({required this.books});

  final List<RecommendedBook> books;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: books.length,
        itemBuilder: (context, i) => _BookCard(book: books[i]),
      ),
    );
  }
}

class _BookCard extends StatelessWidget {
  const _BookCard({required this.book});

  final RecommendedBook book;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => context.push(AppRoutes.bookDetail(book.id)),
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: book.coverUrl != null
                  ? CachedNetworkImage(
                      imageUrl: book.coverUrl!,
                      width: 120,
                      height: 160,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) =>
                          _CoverPlaceholder(theme: theme),
                    )
                  : _CoverPlaceholder(theme: theme),
            ),
            const SizedBox(height: 6),
            Text(
              book.title,
              style: theme.textTheme.labelSmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _CoverPlaceholder extends StatelessWidget {
  const _CoverPlaceholder({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 160,
      color: theme.colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.book_rounded,
        color: theme.colorScheme.onSurfaceVariant,
        size: 40,
      ),
    );
  }
}
