import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../application/club_providers.dart';
import '../domain/club.dart';
import 'club_detail_screen.dart';
import 'create_club_sheet.dart';

class ClubsTab extends ConsumerWidget {
  const ClubsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final clubsAsync = ref.watch(myClubsProvider);

    return Scaffold(
      body: clubsAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        error: (_, __) => Center(
          child: Text(
            '그룹을 불러오지 못했어요',
            style: theme.textTheme.bodyMedium,
          ),
        ),
        data: (clubs) => clubs.isEmpty
            ? _EmptyState(spacing: spacing, theme: theme)
            : ListView.builder(
                padding: EdgeInsets.all(spacing.md),
                itemCount: clubs.length,
                itemBuilder: (_, i) => _ClubCard(club: clubs[i]),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await CreateClubSheet.show(context);
          ref.invalidate(myClubsProvider);
        },
        child: const Icon(Icons.group_add_rounded),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.spacing, required this.theme});

  final AppSpacing spacing;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              CupertinoIcons.person_3,
              size: 52,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            SizedBox(height: spacing.md),
            Text(
              '아직 참여 중인 그룹이 없어요',
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.sm),
            Text(
              '+ 버튼으로 새 독서 그룹을 만들거나\n초대 코드로 참여해 보세요',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ClubCard extends StatelessWidget {
  const _ClubCard({required this.club});

  final Club club;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    return Card(
      margin: EdgeInsets.only(bottom: spacing.sm),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Text(
            club.name[0],
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
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ClubDetailScreen(club: club),
          ),
        ),
      ),
    );
  }
}
