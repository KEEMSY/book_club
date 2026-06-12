import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../application/club_providers.dart';
import '../domain/club.dart';
import 'club_detail_screen.dart';

class PublicClubsScreen extends ConsumerStatefulWidget {
  const PublicClubsScreen({super.key});

  @override
  ConsumerState<PublicClubsScreen> createState() => _PublicClubsScreenState();
}

class _PublicClubsScreenState extends ConsumerState<PublicClubsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _searchCtrl = TextEditingController();
  String _search = '';
  // 'newest' maps to tab index 0, 'popular' to index 1.
  String _sort = 'newest';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _sort = _tabController.index == 0 ? 'newest' : 'popular';
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
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

    final clubsAsync = ref.watch(
      publicClubsProvider((search: _search.isEmpty ? null : _search, sort: _sort)),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('클럽 찾기'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(96),
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
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: '최신순'),
                  Tab(text: '인기순'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: clubsAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        error: (_, __) => const Center(
          child: Text('클럽 목록을 불러오지 못했어요'),
        ),
        data: (clubs) {
          if (clubs.isEmpty) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(spacing.xl),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.group_off_rounded,
                      size: 52,
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.3),
                    ),
                    SizedBox(height: spacing.md),
                    Text(
                      '공개 클럽이 없어요',
                      style: theme.textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: spacing.sm),
                    Text(
                      '검색어를 바꾸거나 나중에 다시 확인해 보세요',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.all(spacing.md),
            itemCount: clubs.length,
            itemBuilder: (_, i) => _PublicClubCard(club: clubs[i]),
          );
        },
      ),
    );
  }
}

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
      // Invalidate the my-clubs list so the new club appears immediately.
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
                  Text(
                    '멤버 ${club.memberCount}/${club.maxMembers}명',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
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
