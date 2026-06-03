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
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                spacing.lg,
                spacing.md,
                spacing.lg,
                spacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('탐색', style: theme.textTheme.displaySmall),
                  SizedBox(height: spacing.md),
                  GestureDetector(
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
                ],
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
                child: _SectionHeader(
                  title: '당신만을 위한 추천',
                  subtitle: '읽기 기록을 바탕으로 골랐어요',
                ),
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
                          reason: r.reason,
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

/// Maps a raw reason string from the ML recommendation API to a short
/// human-readable Korean label shown on the card chip.
String? _reasonLabel(String? reason) {
  switch (reason) {
    case 'community_popular':
      return '많이 읽힌 책';
    case 'similar_readers':
      return '비슷한 독자들이 읽은 책';
    case 'recently_added':
      return '최근 많이 읽힌 책';
    default:
      return null;
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
    this.reason,
  });

  final String id;
  final String title;
  final String author;
  final String? coverUrl;
  // reason is only set for ML-recommended items.
  final String? reason;
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.subtitle});

  final String title;
  // Optional supporting line shown below the main title.
  final String? subtitle;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
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
    final label = _reasonLabel(item.reason);

    return GestureDetector(
      onTap: () => context.push('/books/${item.id}'),
      child: Container(
        width: 100,
        margin: EdgeInsets.only(right: spacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: [
                BookCover(
                  coverUrl: item.coverUrl,
                  width: 100,
                  borderRadius: BorderRadius.circular(radii.md),
                ),
                if (label != null)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: _ReasonChip(
                      label: label,
                      borderRadius: radii.md,
                    ),
                  ),
              ],
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

/// Accent-coloured semi-transparent chip overlaid on the bottom of a book
/// cover image to explain why this title was recommended.
class _ReasonChip extends StatelessWidget {
  const _ReasonChip({required this.label, required this.borderRadius});

  final String label;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.82),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius),
        ),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onPrimary,
          fontWeight: FontWeight.w600,
          height: 1.2,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
    );
  }
}
