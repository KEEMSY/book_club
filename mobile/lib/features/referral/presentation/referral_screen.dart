import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/theme/app_theme.dart';
import '../application/referral_notifier.dart';
import '../domain/referral_stats.dart';

/// Full-screen referral / friend-invite surface.
///
/// Entry point: profile tab → "친구 초대" list tile.
///
/// Sections (top to bottom):
///   1. Benefit description card
///   2. Invite code display + copy button
///   3. Share action buttons (link copy / kakaotalk)
///   4. Invitation statistics (invited / completed counts)
///   5. Referral code input for users who received an invite
class ReferralScreen extends ConsumerWidget {
  const ReferralScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(referralStatsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('친구 초대')),
      body: statsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => _ErrorBody(onRetry: () => ref.invalidate(referralStatsProvider)),
        data: (stats) => _ReferralBody(stats: stats),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Error state
// ---------------------------------------------------------------------------

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '초대 정보를 불러오지 못했습니다.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.md),
            FilledButton(
              onPressed: onRetry,
              child: const Text('다시 시도'),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Main body
// ---------------------------------------------------------------------------

class _ReferralBody extends StatelessWidget {
  const _ReferralBody({required this.stats});

  final ReferralStats stats;

  static String _inviteUrl(String code) => 'https://bookclub.app/invite/$code';

  static String _shareText(String code) =>
      '독서 앱 Book Club에서 함께 책 읽어요! 📚\n'
      '초대 코드: $code\n'
      '${_inviteUrl(code)}';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    return SingleChildScrollView(
      padding: EdgeInsets.all(spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Benefit card
          _BenefitCard(),
          SizedBox(height: spacing.lg),

          // 2. Invite code display
          _CodeBox(code: stats.code),
          SizedBox(height: spacing.md),

          // 3. Share buttons
          _ShareButtons(
            shareText: _shareText(stats.code),
            inviteUrl: _inviteUrl(stats.code),
            code: stats.code,
          ),
          SizedBox(height: spacing.xl),

          // 4. Statistics
          _StatsSection(stats: stats),
          SizedBox(height: spacing.xl),

          // 5. Apply code section
          const _ApplyCodeSection(),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 1. Benefit card
// ---------------------------------------------------------------------------

class _BenefitCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(
              Icons.auto_awesome_rounded,
              color: theme.colorScheme.primary,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                '친구를 초대하면 독서 쉴드를 받아요!',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 2. Invite code display
// ---------------------------------------------------------------------------

class _CodeBox extends StatelessWidget {
  const _CodeBox({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '내 초대 코드',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                code,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          IconButton.filledTonal(
            onPressed: () => _copyCode(context, code),
            icon: const Icon(Icons.copy_rounded),
            tooltip: '복사',
          ),
        ],
      ),
    );
  }

  Future<void> _copyCode(BuildContext context, String code) async {
    await Clipboard.setData(ClipboardData(text: code));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('초대 코드가 복사되었습니다.')),
    );
  }
}

// ---------------------------------------------------------------------------
// 3. Share buttons
// ---------------------------------------------------------------------------

class _ShareButtons extends StatelessWidget {
  const _ShareButtons({
    required this.shareText,
    required this.inviteUrl,
    required this.code,
  });

  final String shareText;
  final String inviteUrl;
  final String code;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton.icon(
          onPressed: () => _copyLink(context),
          icon: const Icon(Icons.link_rounded),
          label: const Text('링크 복사'),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => _shareViaSystem(context),
          icon: const Icon(Icons.share_rounded),
          label: const Text('카카오톡 공유'),
        ),
      ],
    );
  }

  Future<void> _copyLink(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: inviteUrl));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('초대 링크가 복사되었습니다.')),
    );
  }

  Future<void> _shareViaSystem(BuildContext context) async {
    await SharePlus.instance.share(
      ShareParams(text: shareText),
    );
  }
}

// ---------------------------------------------------------------------------
// 4. Statistics section
// ---------------------------------------------------------------------------

class _StatsSection extends StatelessWidget {
  const _StatsSection({required this.stats});

  final ReferralStats stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('초대 현황', style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: '초대한 친구',
                value: '${stats.invitedCount}명',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                label: '독서 시작',
                value: '${stats.completedCount}명',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 5. Apply code section
// ---------------------------------------------------------------------------

class _ApplyCodeSection extends ConsumerStatefulWidget {
  const _ApplyCodeSection();

  @override
  ConsumerState<_ApplyCodeSection> createState() => _ApplyCodeSectionState();
}

class _ApplyCodeSectionState extends ConsumerState<_ApplyCodeSection> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final applyState = ref.watch(applyReferralProvider);
    final isLoading = applyState is AsyncLoading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('초대 코드가 있으신가요?', style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                enabled: !isLoading,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  hintText: '초대 코드 입력',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 8),
            FilledButton(
              onPressed: isLoading ? null : _applyCode,
              child: isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('적용'),
            ),
          ],
        ),
        if (applyState is AsyncError) ...[
          const SizedBox(height: 8),
          Text(
            applyState.error is Exception
                ? (applyState.error as dynamic).message as String? ??
                    '코드 적용에 실패했습니다.'
                : '코드 적용에 실패했습니다.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ],
        if (applyState is AsyncData && _controller.text.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            '초대 코드가 적용되었습니다!',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _applyCode() async {
    final code = _controller.text.trim();
    if (code.isEmpty) return;
    await ref.read(applyReferralProvider.notifier).apply(code);
    final state = ref.read(applyReferralProvider);
    if (!mounted) return;
    if (state is AsyncData) {
      _controller.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('초대 코드가 적용되었습니다!')),
      );
    }
  }
}
