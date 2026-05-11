import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../book/application/book_providers.dart';
import '../../book/data/book_models.dart' show DiscoverSectionDto;
import '../../book/presentation/widgets/book_cover.dart';
import '../application/discovery_providers.dart';
import '../domain/recommended_book.dart';

class DiscoveryScreen extends ConsumerWidget {
  const DiscoveryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final radii = theme.extension<AppRadius>()!;
    final recommendationsAsync = ref.watch(recommendationsProvider);
    final discoverAsync = ref.watch(discoverBooksProvider);

    final List<RecommendedBook> recs = recommendationsAsync.valueOrNull ?? [];
    final List<DiscoverSectionDto> sections =
        discoverAsync.valueOrNull?.sections ?? [];
    // Show spinner only when there is genuinely nothing to display yet.
    final bool showSpinner = discoverAsync is AsyncLoading && recs.isEmpty;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: const Text('탐색'),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  spacing.lg, 0, spacing.lg, spacing.md,
                ),
                child: GestureDetector(
                  onTap: () => context.push(AppRoutes.search),
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(radii.md),
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
          if (showSpinner)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            )
          else ...[
            // ── 맞춤 추천 (personalized, shown only when available) ──────
            if (recs.isNotEmpty) ...[
              const SliverToBoxAdapter(
                child: _SectionHeader(title: '맞춤 추천'),
              ),
              SliverToBoxAdapter(
                child: _BookRow(
                  books: recs
                      .map(
                        (r) => _BookRowItem(
                          id: r.id,
                          title: r.title,
                          author: r.author,
                          coverUrl: r.coverUrl,
                        ),
                      )
                      .toList(growable: false),
                ),
              ),
            ],
            // ── 인기차트 (popular/new sections, always the default) ───────
            for (final section in sections) ...[
              SliverToBoxAdapter(child: _SectionHeader(title: section.title)),
              SliverToBoxAdapter(
                child: _BookRow(
                  books: section.books
                      .map(
                        (dto) => _BookRowItem(
                          id: dto.id,
                          title: dto.title,
                          author: dto.author,
                          coverUrl: dto.coverUrl,
                        ),
                      )
                      .toList(growable: false),
                ),
              ),
            ],
            SliverToBoxAdapter(
              child: SizedBox(height: spacing.xl * 2),
            ),
          ],
        ],
      ),
    );
  }
}

/// Normalised card data so both recommendation and discover books share the
/// same row widget without coupling it to either domain type.
class _BookRowItem {
  const _BookRowItem({
    required this.id,
    required this.title,
    required this.author,
    this.coverUrl,
  });

  final String id;
  final String title;
  final String author;
  final String? coverUrl;
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
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

class _BookRow extends StatelessWidget {
  const _BookRow({required this.books});

  final List<_BookRowItem> books;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: spacing.lg),
        itemCount: books.length,
        itemBuilder: (_, i) => _BookCard(item: books[i]),
      ),
    );
  }
}

class _BookCard extends StatelessWidget {
  const _BookCard({required this.item});

  final _BookRowItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final radii = theme.extension<AppRadius>()!;

    return GestureDetector(
      onTap: () => context.push('/books/${item.id}'),
      child: Container(
        width: 100,
        margin: EdgeInsets.only(right: spacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            BookCover(
              coverUrl: item.coverUrl,
              width: 100,
              borderRadius: BorderRadius.circular(radii.md),
            ),
            SizedBox(height: spacing.xs),
            Text(
              item.title,
              style: theme.textTheme.labelMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              item.author,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
