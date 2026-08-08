import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../application/auth_notifier.dart';
import '../data/auth_repository.dart';
import '../domain/auth_state.dart';
import '../domain/auth_user.dart';

/// Account management screen (BC-82 settings-hub entry).
///
/// Shows the social login provider the current session is tied to and lets
/// the user permanently delete their account (`DELETE /me`, soft-delete —
/// see `backend/app/domains/auth/service.py`). Reachable only while
/// authenticated; the router redirect bounces unauthenticated sessions
/// before this ever builds.
class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final auth = ref.watch(authNotifierProvider);
    final AuthUser? user = auth is Authenticated ? auth.user : null;

    return Scaffold(
      appBar: AppBar(title: const Text('계정 관리')),
      body: ListView(
        padding: EdgeInsets.all(spacing.lg),
        children: <Widget>[
          Text('연동된 계정', style: theme.textTheme.titleSmall),
          SizedBox(height: spacing.sm),
          if (user != null) _ProviderTile(user: user),
          SizedBox(height: spacing.xl),
          Text(
            '계정 탈퇴',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
          SizedBox(height: spacing.sm),
          Text(
            '탈퇴하면 프로필, 독서 기록, 게시글 등 계정 데이터에 더 이상 '
            '접근할 수 없습니다. 이 작업은 되돌릴 수 없습니다.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: spacing.md),
          OutlinedButton(
            onPressed: () => _confirmAndDelete(context, ref),
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
              side: BorderSide(color: theme.colorScheme.error),
            ),
            child: const Text('계정 탈퇴'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmAndDelete(BuildContext context, WidgetRef ref) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('계정을 탈퇴할까요?'),
        content: const Text(
          '탈퇴하면 즉시 로그아웃되며 프로필과 독서 기록에 다시 접근할 수 '
          '없습니다. 이 작업은 되돌릴 수 없습니다.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              '탈퇴',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    try {
      await ref.read(authNotifierProvider.notifier).deleteAccount();
    } on AuthRepositoryException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }
}

class _ProviderTile extends StatelessWidget {
  const _ProviderTile({required this.user});

  final AuthUser user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isApple = user.provider == AuthProvider.apple;
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: Icon(
          isApple ? Icons.apple : Icons.chat_bubble_rounded,
          color:
              isApple ? theme.colorScheme.onSurface : const Color(0xFFFEE500),
        ),
        title: Text(isApple ? 'Apple로 로그인됨' : '카카오로 로그인됨'),
        subtitle: user.email != null && user.email!.isNotEmpty
            ? Text(user.email!)
            : null,
      ),
    );
  }
}
