import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../experiment/application/experiment_providers.dart';
import '../../experiment/domain/user_experiments.dart';
import '../application/club_providers.dart';
import '../domain/club.dart';
import 'club_detail_screen.dart';

// M48: category options for filter chips
const _kCategories = ['전체', '소설', '자기계발', '인문학', '과학', '기타'];

class PublicClubsScreen extends ConsumerStatefulWidget {
  const PublicClubsScreen({super.key});

  @override
  ConsumerState<PublicClubsScreen> createState() => _PublicClubsScreenState();
}

class _PublicClubsScreenState extends ConsumerState<PublicClubsScreen> {
  final _searchCtrl = TextEditingController();
  String _search = '';
  String _sort = 'popular';
  // null means '전체' (no category filter)
  String? _selectedCategory;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() => _search = value.trim());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final radii = theme.extension<AppRadius>()!;

    final filteredAsync = ref.watch(
      filteredPublicClubsProvider((
        category: _selectedCategory,
        tag: null,
        sort: _sort,
      )),
    );

    final recommendedAsync = ref.watch(recommendedClubsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('클럽 찾기'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(112),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.lg,
                  vertical: spacing.sm,
                ),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: '클럽 이름으로 검색',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _search.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded),
                            onPressed: () {
                              _searchCtrl.clear();
                              _onSearchChanged('');
                            },
                          )
                        : null,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: spacing.sm,
                      horizontal: spacing.md,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(radii.md),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                  ),
                ),
              ),
              // Category filter chips row
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: spacing.lg),
                  itemCount: _kCategories.length,
                  separatorBuilder: (_, __) => SizedBox(width: spacing.xs),
                  itemBuilder: (_, i) {
                    final cat = _kCategories[i];
                    final isAll = cat == '전체';
                    final isSelected = isAll
                        ? _selectedCategory == null
                        : _selectedCategory == cat;
                    return FilterChip(
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() {
                          _selectedCategory = isAll ? null : cat;
                        });
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: spacing.xs),
            ],
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // Sort toggle bar
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: spacing.lg,
                vertical: spacing.sm,
              ),
              child: Row(
                children: [
                  Text(
                    '정렬',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  SizedBox(width: spacing.sm),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'popular', label: Text('인기순')),
                      ButtonSegment(value: 'new', label: Text('최신순')),
                    ],
                    selected: {_sort},
                    onSelectionChanged: (val) {
                      setState(() => _sort = val.first);
                    },
                    style: ButtonStyle(
                      visualDensity: VisualDensity.compact,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // AI recommended clubs section
          SliverToBoxAdapter(
            child: recommendedAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
              data: (clubs) {
                if (clubs.isEmpty) return const SizedBox.shrink();
                return _RecommendedSection(clubs: clubs);
              },
            ),
          ),

          // Main public club list
          SliverPadding(
            padding: EdgeInsets.all(spacing.md),
            sliver: filteredAsync.when(
              loading: () => const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              error: (_, __) => const SliverFillRemaining(
                child: Center(child: Text('클럽 목록을 불러오지 못했어요')),
              ),
              data: (clubs) {
                // Apply client-side search filter on top of server results
                final displayed = _search.isEmpty
                    ? clubs
                    : clubs
                        .where((c) => c.name
                            .toLowerCase()
                            .contains(_search.toLowerCase()))
                        .toList();

                if (displayed.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(spacing.xl),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.group_off_rounded,
                              size: 52,
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.3),
                            ),
                            SizedBox(height: spacing.md),
                            Text(
                              '공개 클럽이 없어요',
                              style: theme.textTheme.bodyLarge,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: spacing.sm),
                            Text(
                              '검색어나 카테고리를 바꿔 보세요',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return SliverList.builder(
                  itemCount: displayed.length,
                  itemBuilder: (_, i) => _PublicClubCard(club: displayed[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// AI Recommended clubs horizontal section
// ─────────────────────────────────────────────

class _RecommendedSection extends ConsumerWidget {
  const _RecommendedSection({required this.clubs});

  final List<Club> clubs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
              spacing.lg, spacing.sm, spacing.lg, spacing.xs),
          child: Row(
            children: [
              const Icon(Icons.auto_awesome_rounded, size: 16),
              SizedBox(width: spacing.xs),
              Text(
                'AI 추천 클럽',
                style: theme.textTheme.titleSmall,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 140,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: spacing.lg),
            itemCount: clubs.length,
            separatorBuilder: (_, __) => SizedBox(width: spacing.sm),
            itemBuilder: (_, i) => _RecommendedClubCard(club: clubs[i]),
          ),
        ),
        SizedBox(height: spacing.sm),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing.lg),
          child: Divider(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
      ],
    );
  }
}

class _RecommendedClubCard extends ConsumerStatefulWidget {
  const _RecommendedClubCard({required this.club});

  final Club club;

  @override
  ConsumerState<_RecommendedClubCard> createState() =>
      _RecommendedClubCardState();
}

class _RecommendedClubCardState
    extends ConsumerState<_RecommendedClubCard> {
  bool _joining = false;

  Future<void> _join() async {
    setState(() => _joining = true);
    try {
      final joined = await ref
          .read(clubRepositoryProvider)
          .joinPublicClub(widget.club.id);
      if (!mounted) return;
      ref.invalidate(myClubsProvider);
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ClubDetailScreen(club: joined),
        ),
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('클럽 가입에 실패했습니다.')),
        );
      }
    } finally {
      if (mounted) setState(() => _joining = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final club = widget.club;

    return SizedBox(
      width: 160,
      child: Card(
        child: InkWell(
          onTap: _joining ? null : _join,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(spacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: theme.colorScheme.primaryContainer,
                      child: Text(
                        club.name[0],
                        style: TextStyle(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    SizedBox(width: spacing.xs),
                    Expanded(
                      child: Text(
                        club.name,
                        style: theme.textTheme.labelMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: spacing.xs),
                if (club.category != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      club.category!,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                const Spacer(),
                Text(
                  '멤버 ${club.memberCount}명',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                SizedBox(height: spacing.xs),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.tonal(
                    onPressed: _joining ? null : _join,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: _joining
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child:
                                CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('가입', style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Public club list card (with category + tags)
// ─────────────────────────────────────────────

class _PublicClubCard extends ConsumerStatefulWidget {
  const _PublicClubCard({required this.club});

  final Club club;

  @override
  ConsumerState<_PublicClubCard> createState() => _PublicClubCardState();
}

class _PublicClubCardState extends ConsumerState<_PublicClubCard> {
  bool _joining = false;

  Future<void> _join() async {
    setState(() => _joining = true);
    try {
      final joined = await ref
          .read(clubRepositoryProvider)
          .joinPublicClub(widget.club.id);
      if (!mounted) return;
      ref.invalidate(myClubsProvider);
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ClubDetailScreen(club: joined),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      if (_isClubLimitError(e)) {
        final experiments = ref.read(userExperimentsProvider).valueOrNull;
        final variant = experiments?.variantFor('paywall_entry_v1');
        if (variant == 'club_limit') {
          GoRouter.of(context).push(AppRoutes.paywall);
          return;
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('클럽 가입에 실패했습니다.')),
      );
    } finally {
      if (mounted) setState(() => _joining = false);
    }
  }

  bool _isClubLimitError(Object error) {
    return error.toString().contains('CLUB_LIMIT_EXCEEDED');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final club = widget.club;

    return Card(
      margin: EdgeInsets.only(bottom: spacing.sm),
      child: Padding(
        padding: EdgeInsets.all(spacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text(
                club.name[0],
                style: TextStyle(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(club.name, style: theme.textTheme.titleSmall),
                  if (club.bookTitle != null) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.menu_book_rounded,
                          size: 12,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            club.bookTitle!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '멤버 ${club.memberCount}/${club.maxMembers}명',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                        ),
                      ),
                      if (club.category != null) ...[
                        SizedBox(width: spacing.xs),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            club.category!,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color:
                                  theme.colorScheme.onSecondaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  // Tag chips
                  if (club.tags.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 4,
                      runSpacing: 2,
                      children: club.tags
                          .take(3)
                          .map(
                            (tag) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: theme.colorScheme.outline
                                      .withValues(alpha: 0.4),
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '#$tag',
                                style:
                                    theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.7),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(width: spacing.sm),
            FilledButton.tonal(
              onPressed: _joining ? null : _join,
              style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.md,
                  vertical: spacing.xs,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: _joining
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('가입'),
            ),
          ],
        ),
      ),
    );
  }
}
