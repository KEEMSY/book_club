import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../auth/application/auth_notifier.dart';
import '../../auth/domain/auth_state.dart';
import '../../subscription/application/subscription_notifier.dart';
import '../application/reading_plan_providers.dart';
import '../domain/club.dart';
import '../domain/reading_plan.dart';
import 'create_reading_plan_sheet.dart';

/// "독서 계획" tab inside [ClubDetailScreen]'s TabBarView (M52).
class ReadingPlanTab extends ConsumerWidget {
  const ReadingPlanTab({super.key, required this.club});

  final Club club;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final planAsync = ref.watch(clubReadingPlanProvider(club.id));

    return planAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      error: (_, __) => Center(
        child: Text('독서 계획을 불러오지 못했어요', style: theme.textTheme.bodyMedium),
      ),
      data: (plan) => plan == null
          ? _EmptyPlan(club: club)
          : _PlanContent(club: club, plan: plan),
    );
  }
}

class _EmptyPlan extends ConsumerWidget {
  const _EmptyPlan({required this.club});

  final Club club;

  bool _isOwner(WidgetRef ref) {
    final auth = ref.watch(authNotifierProvider);
    return switch (auth) {
      Authenticated(:final user) => user.id == club.ownerId,
      _ => false,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final isPro = ref.watch(subscriptionNotifierProvider).maybeWhen(
          data: (s) => s.isPro,
          orElse: () => false,
        );
    final canCreate = _isOwner(ref) && isPro;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.event_note_rounded,
              size: 48,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            SizedBox(height: spacing.md),
            Text(
              '독서 계획이 없어요',
              style: theme.textTheme.titleMedium,
            ),
            SizedBox(height: spacing.xs),
            Text(
              canCreate
                  ? '멤버들과 함께 읽을 계획을 만들어 보세요'
                  : 'Pro 클럽장이 독서 계획을 만들면 함께 진도를 맞춰요',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            if (canCreate) ...[
              SizedBox(height: spacing.lg),
              FilledButton.icon(
                onPressed:
                    club.bookId == null ? null : () => _openSheet(context, ref),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('계획 생성'),
              ),
              if (club.bookId == null) ...[
                SizedBox(height: spacing.sm),
                Text(
                  '먼저 클럽 책을 설정해 주세요',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _openSheet(BuildContext context, WidgetRef ref) async {
    final created = await CreateReadingPlanSheet.show(
      context,
      clubId: club.id,
      bookId: club.bookId!,
      bookTitle: club.bookTitle,
    );
    if (created ?? false) {
      ref.invalidate(clubReadingPlanProvider(club.id));
      ref.invalidate(clubProgressProvider(club.id));
    }
  }
}

class _PlanContent extends ConsumerWidget {
  const _PlanContent({required this.club, required this.plan});

  final Club club;
  final ReadingPlan plan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final progressAsync = ref.watch(clubProgressProvider(club.id));

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(clubProgressProvider(club.id));
        await ref.read(clubProgressProvider(club.id).future);
      },
      child: ListView(
        padding: EdgeInsets.all(spacing.lg),
        children: [
          _PlanSummaryCard(plan: plan),
          SizedBox(height: spacing.lg),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _updateProgress(context, ref),
              icon: const Icon(Icons.edit_rounded, size: 18),
              label: const Text('내 진도 업데이트'),
            ),
          ),
          SizedBox(height: spacing.lg),
          Text(
            '멤버 진도',
            style: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          SizedBox(height: spacing.sm),
          progressAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
            error: (_, __) => Text(
              '진도를 불러오지 못했어요',
              style: theme.textTheme.bodySmall,
            ),
            data: (progress) => progress.members.isEmpty
                ? Text(
                    '아직 진도를 기록한 멤버가 없어요',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  )
                : Column(
                    children: [
                      for (final m in progress.members)
                        _MemberProgressRow(member: m),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateProgress(BuildContext context, WidgetRef ref) async {
    final page = await showDialog<int>(
      context: context,
      builder: (_) => const _ProgressInputDialog(),
    );
    if (page == null) return;
    try {
      await ref.read(readingPlanRepositoryProvider).updateProgress(
            club.id,
            page,
          );
      ref.invalidate(clubProgressProvider(club.id));
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('진도 업데이트에 실패했어요.')),
        );
      }
    }
  }
}

class _PlanSummaryCard extends StatelessWidget {
  const _PlanSummaryCard({required this.plan});

  final ReadingPlan plan;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final radii = theme.extension<AppRadius>()!;

    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.all(Radius.circular(radii.md)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.flag_rounded,
            color: theme.colorScheme.primary,
          ),
          SizedBox(width: spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '주간 목표 ${plan.weeklyPages}쪽',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                SizedBox(height: spacing.xs),
                Text(
                  '${_fmt(plan.startDate)} ~ ${_fmt(plan.endDate)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(DateTime d) =>
      '${d.year}.${d.month.toString().padLeft(2, '0')}.${d.day.toString().padLeft(2, '0')}';
}

class _MemberProgressRow extends StatelessWidget {
  const _MemberProgressRow({required this.member});

  final MemberProgress member;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final pct = (member.progressPct / 100).clamp(0.0, 1.0);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  member.nickname,
                  style: theme.textTheme.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '${member.progressPct.round()}% · ${member.currentPage}쪽',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.xs),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 6,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressInputDialog extends StatefulWidget {
  const _ProgressInputDialog();

  @override
  State<_ProgressInputDialog> createState() => _ProgressInputDialogState();
}

class _ProgressInputDialogState extends State<_ProgressInputDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('내 진도 업데이트'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(
          labelText: '현재 페이지',
          suffixText: '쪽',
        ),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: _submit,
          child: const Text('저장'),
        ),
      ],
    );
  }

  void _submit() {
    final page = int.tryParse(_controller.text.trim());
    if (page == null || page < 0) return;
    Navigator.of(context).pop(page);
  }
}
