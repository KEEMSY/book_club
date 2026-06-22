import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../auth/application/auth_notifier.dart';
import '../../auth/domain/auth_state.dart';
import '../application/team_providers.dart';
import '../data/team_repository.dart';
import '../domain/team_subscription.dart';

const Color _kProPurple = Color(0xFF6B21A8);

/// Team-plan admin console (M70).
///
/// Shows the team name, validity window, and seat usage; lists members with a
/// swipe-to-remove affordance (admin only); and offers a "멤버 초대" FAB that
/// adds a member by user id. Reads `GET /teams/{id}` on load.
class TeamAdminScreen extends ConsumerWidget {
  const TeamAdminScreen({super.key, required this.teamId});

  final String teamId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final teamAsync = ref.watch(teamProvider(teamId));

    final String? currentUserId = switch (ref.watch(authNotifierProvider)) {
      Authenticated(:final user) => user.id,
      _ => null,
    };

    return Scaffold(
      appBar: AppBar(title: const Text('팀 플랜 관리')),
      floatingActionButton: teamAsync.maybeWhen(
        data: (team) => team.adminUserId == currentUserId
            ? FloatingActionButton.extended(
                backgroundColor: _kProPurple,
                onPressed: () => _showInviteDialog(context, ref),
                icon: const Icon(Icons.person_add_alt_1_rounded),
                label: const Text('멤버 초대'),
              )
            : null,
        orElse: () => null,
      ),
      body: teamAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const _CenteredMessage(
          icon: Icons.cloud_off_rounded,
          title: '팀 정보를 불러오지 못했어요',
          subtitle: '다시 시도해 주세요.',
        ),
        data: (team) => _Content(
          team: team,
          spacing: spacing,
          isAdmin: team.adminUserId == currentUserId,
          onRemove: (member) => _removeMember(context, ref, member),
        ),
      ),
    );
  }

  Future<void> _showInviteDialog(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final controller = TextEditingController();
    final userId = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('멤버 초대'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: '사용자 ID',
            hintText: '초대할 회원의 ID를 입력하세요',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('닫기'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(controller.text.trim()),
            child: const Text('초대'),
          ),
        ],
      ),
    );
    if (userId == null || userId.isEmpty) return;

    try {
      await ref
          .read(teamRepositoryProvider)
          .addMember(teamId: teamId, userId: userId);
      ref.invalidate(teamProvider(teamId));
      messenger.showSnackBar(const SnackBar(content: Text('멤버를 초대했어요.')));
    } on TeamRepositoryException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<void> _removeMember(
    BuildContext context,
    WidgetRef ref,
    TeamMember member,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref
          .read(teamRepositoryProvider)
          .removeMember(teamId: teamId, userId: member.userId);
      ref.invalidate(teamProvider(teamId));
      messenger.showSnackBar(
        SnackBar(content: Text('${member.nickname} 님을 제거했어요.')),
      );
    } on TeamRepositoryException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    }
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.team,
    required this.spacing,
    required this.isAdmin,
    required this.onRemove,
  });

  final TeamSubscription team;
  final AppSpacing spacing;
  final bool isAdmin;
  final ValueChanged<TeamMember> onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: EdgeInsets.all(spacing.lg),
      children: [
        _TeamHeaderCard(team: team, spacing: spacing),
        SizedBox(height: spacing.lg),
        Text(
          '멤버 ${team.usedSeats}/${team.seatCount}',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: spacing.sm),
        ...team.members.map(
          (m) => _MemberTile(
            member: m,
            // The admin cannot remove themselves; only the admin sees removal.
            removable: isAdmin && m.userId != team.adminUserId,
            isAdmin: m.userId == team.adminUserId,
            onRemove: () => onRemove(m),
          ),
        ),
      ],
    );
  }
}

class _TeamHeaderCard extends StatelessWidget {
  const _TeamHeaderCard({required this.team, required this.spacing});

  final TeamSubscription team;
  final AppSpacing spacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final usageRatio =
        team.seatCount == 0 ? 0.0 : team.usedSeats / team.seatCount;
    return Container(
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6B21A8), Color(0xFF9333EA)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            team.teamName,
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: spacing.xs),
          Text(
            '${_fmtDate(team.validUntil)}까지 이용 가능',
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
          SizedBox(height: spacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: usageRatio.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          SizedBox(height: spacing.xs),
          Text(
            '좌석 ${team.usedSeats} / ${team.seatCount} 사용 중',
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _MemberTile extends StatelessWidget {
  const _MemberTile({
    required this.member,
    required this.removable,
    required this.isAdmin,
    required this.onRemove,
  });

  final TeamMember member;
  final bool removable;
  final bool isAdmin;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tile = ListTile(
      leading: CircleAvatar(
        backgroundImage: member.profileImageUrl != null
            ? NetworkImage(member.profileImageUrl!)
            : null,
        child: member.profileImageUrl == null
            ? Text(member.nickname.characters.first)
            : null,
      ),
      title: Row(
        children: [
          Flexible(child: Text(member.nickname)),
          if (isAdmin) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: _kProPurple.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '관리자',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: _kProPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
      subtitle: Text('${_fmtDate(member.joinedAt)} 합류'),
    );

    if (!removable) return tile;

    return Dismissible(
      key: ValueKey(member.userId),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _confirm(context),
      onDismissed: (_) => onRemove(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        color: theme.colorScheme.error,
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      ),
      child: tile,
    );
  }

  Future<bool> _confirm(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('멤버 제거'),
        content: Text('${member.nickname} 님을 팀에서 제거할까요? Pro 혜택이 해제됩니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('닫기'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('제거'),
          ),
        ],
      ),
    );
    return ok ?? false;
  }
}

class _CenteredMessage extends StatelessWidget {
  const _CenteredMessage({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: theme.colorScheme.outline),
          const SizedBox(height: 12),
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }
}

String _fmtDate(DateTime dt) {
  final local = dt.toLocal();
  return '${local.year}.${local.month.toString().padLeft(2, '0')}.'
      '${local.day.toString().padLeft(2, '0')}';
}
