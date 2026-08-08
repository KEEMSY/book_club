import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../club/application/club_providers.dart';
import '../../club/domain/club.dart';

/// "내 활동 > 참여 모임" 더보기 (BC-83) — reuses `myClubsProvider`
/// (`GET /clubs/me`), the same "clubs I've joined" list [ClubsTab] shows on
/// the home tab. Not paginated: a user's own club membership count is small
/// enough that the backend returns the full list in one response.
///
/// Each row deep-links to the club's detail screen ([AppRoutes.clubDetail]).
class MyClubsScreen extends ConsumerWidget {
  const MyClubsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final AsyncValue<List<Club>> clubsAsync = ref.watch(myClubsProvider);

    return Scaffold(
      appBar: const _MyClubsAppBar(),
      body: clubsAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        error: (_, __) => Center(
          child: Padding(
            padding: EdgeInsets.all(spacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('모임을 불러오지 못했어요', style: theme.textTheme.bodyMedium),
                SizedBox(height: spacing.sm),
                FilledButton(
                  onPressed: () => ref.invalidate(myClubsProvider),
                  child: const Text('다시 시도'),
                ),
              ],
            ),
          ),
        ),
        data: (clubs) => clubs.isEmpty
            ? Center(
                child: Text(
                  '참여 중인 모임이 없어요',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              )
            : ListView.separated(
                padding: EdgeInsets.all(spacing.lg),
                itemCount: clubs.length,
                separatorBuilder: (_, __) => SizedBox(height: spacing.sm),
                itemBuilder: (_, i) => _MyClubCard(club: clubs[i]),
              ),
      ),
    );
  }
}

class _MyClubsAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const _MyClubsAppBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int? count = ref.watch(myClubsProvider).valueOrNull?.length;
    return AppBar(title: Text(count != null ? '참여 모임 ($count)' : '참여 모임'));
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MyClubCard extends StatelessWidget {
  const _MyClubCard({required this.club});

  final Club club;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push(AppRoutes.clubDetail(club.id)),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: theme.colorScheme.primaryContainer,
            child: Text(
              club.name.isNotEmpty ? club.name[0] : '?',
              style: TextStyle(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(club.name, style: theme.textTheme.titleSmall),
          subtitle: club.bookTitle != null
              ? Text(
                  club.bookTitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              : null,
          trailing: Text(
            '${club.memberCount}/${club.maxMembers}명',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
      ),
    );
  }
}
