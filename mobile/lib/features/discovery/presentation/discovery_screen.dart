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

/// Two AI-recommendation strategy tabs shown in the "AI 추천" section.
enum _AiStrategy {
  similarReaders('similar_readers', '비슷한 독자'),
  tasteMatch('taste_match', '취향 매칭');

  const _AiStrategy(this.apiValue, this.label);

  final String apiValue;
  final String label;
}

class DiscoveryScreen extends ConsumerStatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  ConsumerState<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends ConsumerState<DiscoveryScreen> {
  _AiStrategy _selectedStrategy = _AiStrategy.similarReaders;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final discoverAsync = ref.watch(discoverBooksProvider);

    final List<DiscoverSectionDto> sections =
        discoverAsync.valueOrNull?.sections ?? [];
    final bool showSpinner = discoverAsync is AsyncLoading;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── 헤더 + 검색 바 ───────────────────────────────────────────────
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
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => context.push(AppRoutes.search),
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color:
                                  theme.colorScheme.surfaceContainerHighest,
                              borderRadius:
                                  BorderRadius.circular(spacing.md),
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: spacing.md),
                                Icon(
                                  Icons.search_rounded,
                                  color:
                                      theme.colorScheme.onSurfaceVariant,
                                  size: 20,
                                ),
                                SizedBox(width: spacing.sm),
                                Text(
                                  '책 제목, 저자, ISBN 검색',
                                  style:
                                      theme.textTheme.bodyMedium?.copyWith(
                                    color:
                                        theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: spacing.sm),
                      // M38 — unified search button (books + users + clubs).
                      IconButton(
                        icon: const Icon(Icons.manage_search_rounded),
                        tooltip: '통합 검색',
                        onPressed: () =>
                            context.push(AppRoutes.unifiedSearch),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (showSpinner)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else ...[
            // ── 클럽 찾기 진입 배너 (M32) ──────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  spacing.lg,
                  0,
                  spacing.lg,
                  spacing.md,
                ),
                child: _ClubDiscoveryBanner(),
              ),
            ),
            // ── AI 추천 섹션 (M44) ─────────────────────────────────────────
            SliverToBoxAdapter(
              child: _AiRecommendationSection(
                selectedStrategy: _selectedStrategy,
                onStrategyChanged: (s) =>
                    setState(() => _selectedStrategy = s),
              ),
            ),
            // ── 인기차트 (popular/new sections, always the default) ─────────
            for (final section in sections) ...[
              SliverToBoxAdapter(
                child: _SectionHeader(title: section.title),
              ),
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

/// AI 추천 섹션: 헤더 + 전략 탭 + 추천 책 목록.
class _AiRecommendationSection extends ConsumerWidget {
  const _AiRecommendationSection({
    required this.selectedStrategy,
    required this.onStrategyChanged,
  });

  final _AiStrategy selectedStrategy;
  final ValueChanged<_AiStrategy> onStrategyChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recsAsync = ref.watch(
      recommendationsProvider(strategy: selectedStrategy.apiValue),
    );
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row.
        Padding(
          padding: EdgeInsets.fromLTRB(
            spacing.lg,
            spacing.lg,
            spacing.lg,
            spacing.sm,
          ),
          child: Row(
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                size: 18,
                color: theme.colorScheme.primary,
              ),
              SizedBox(width: spacing.xs),
              Text(
                'AI 추천',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        // Strategy tabs.
        Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing.lg),
          child: Row(
            children: _AiStrategy.values.map((s) {
              final bool active = s == selectedStrategy;
              return Padding(
                padding: EdgeInsets.only(right: spacing.sm),
                child: FilterChip(
                  selected: active,
                  label: Text(s.label),
                  onSelected: (_) => onStrategyChanged(s),
                  showCheckmark: false,
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: spacing.sm),
        // Recommendation list.
        recsAsync.when(
          data: (recs) => recs.isEmpty
              ? Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: spacing.lg,
                    vertical: spacing.md,
                  ),
                  child: Text(
                    '추천 데이터를 쌓는 중이에요. 더 읽으면 정확해져요!',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                )
              : _AiBookList(recs: recs),
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          error: (_, __) => Padding(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.lg,
              vertical: spacing.md,
            ),
            child: Text(
              '추천 데이터를 불러오지 못했어요.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Horizontal scrollable list of AI-recommended book cards with reason text.
class _AiBookList extends StatelessWidget {
  const _AiBookList({required this.recs});

  final List<RecommendedBook> recs;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: spacing.lg),
        itemCount: recs.length,
        itemBuilder: (_, i) => _AiBookCard(rec: recs[i]),
      ),
    );
  }
}

/// Single AI-recommended book card.
///
/// Renders the cover image, title, author, and [reason] text on one line below
/// the author (bodySmall, onSurfaceVariant colour) as specified in M44.
class _AiBookCard extends StatelessWidget {
  const _AiBookCard({required this.rec});

  final RecommendedBook rec;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final radii = theme.extension<AppRadius>()!;

    return GestureDetector(
      onTap: () => context.push('/books/${rec.id}'),
      child: Container(
        width: 110,
        margin: EdgeInsets.only(right: spacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BookCover(
              coverUrl: rec.coverUrl,
              width: 110,
              borderRadius: BorderRadius.circular(radii.md),
            ),
            SizedBox(height: spacing.xs),
            Text(
              rec.title,
              style: theme.textTheme.labelMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              rec.author,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            // reason line — M44 spec: bodySmall, grey
            Text(
              rec.reason,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.7,
                ),
                fontSize: 10,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
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

/// Normalised card data so discover-section books share the same widget.
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
          children: [
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

/// Banner card linking to the public club discovery screen (M32).
class _ClubDiscoveryBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radii = theme.extension<AppRadius>()!;
    final spacing = theme.extension<AppSpacing>()!;

    return InkWell(
      onTap: () => context.push(AppRoutes.publicClubs),
      borderRadius: BorderRadius.circular(radii.md),
      child: Ink(
        decoration: BoxDecoration(
          color: theme.colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(radii.md),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: spacing.md,
            vertical: spacing.sm,
          ),
          child: Row(
            children: [
              Icon(
                Icons.group_rounded,
                color: theme.colorScheme.onSecondaryContainer,
              ),
              SizedBox(width: spacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '클럽 찾기',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '공개 독서 클럽에 지금 참여해 보세요',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSecondaryContainer
                            .withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: theme.colorScheme.onSecondaryContainer,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
