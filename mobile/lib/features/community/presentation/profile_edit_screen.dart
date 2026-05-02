import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../auth/application/auth_providers.dart';
import '../../social/domain/user_summary.dart';
import '../application/community_providers.dart';

/// Screen for editing the authenticated user's own profile.
///
/// Calls `PATCH /me` with only the changed fields; on success the upstream
/// [userProfileProvider] is invalidated so the profile screen reflects the
/// new values immediately on pop.
class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key, required this.profile});

  final UserProfile profile;

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  late final TextEditingController _nickCtrl;
  late final TextEditingController _bioCtrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nickCtrl = TextEditingController(text: widget.profile.nickname);
    _bioCtrl = TextEditingController(text: widget.profile.bio ?? '');
  }

  @override
  void dispose() {
    _nickCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필 편집'),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('저장'),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('닉네임', style: theme.textTheme.labelLarge),
            SizedBox(height: spacing.sm),
            TextField(
              controller: _nickCtrl,
              maxLength: 64,
              decoration: const InputDecoration(hintText: '닉네임'),
            ),
            SizedBox(height: spacing.lg),
            Text('소개글', style: theme.textTheme.labelLarge),
            SizedBox(height: spacing.sm),
            TextField(
              controller: _bioCtrl,
              maxLength: 200,
              maxLines: 4,
              decoration:
                  const InputDecoration(hintText: '독서 취향이나 소개를 적어보세요'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final repo = ref.read(authRepositoryProvider);
      final nick = _nickCtrl.text.trim();
      final bio = _bioCtrl.text.trim();
      await repo.updateProfile(
        nickname: nick.isEmpty ? null : nick,
        bio: bio.isEmpty ? null : bio,
      );
      if (!mounted) return;
      ref.invalidate(userProfileProvider(widget.profile.id));
      context.pop();
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('저장에 실패했습니다. 다시 시도해주세요.')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
