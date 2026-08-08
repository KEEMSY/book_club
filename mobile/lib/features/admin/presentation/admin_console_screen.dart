import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/dev_login_gate.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../application/admin_providers.dart';
import '../application/admin_users_notifier.dart';
import '../application/admin_users_state.dart';
import '../data/admin_repository.dart';
import '../domain/admin_overview.dart';
import '../domain/admin_stats.dart';
import '../domain/admin_user.dart';
import '../domain/conversion_funnel.dart';
import '../domain/revenue_metrics.dart';

/// Admin console (BC-87) — usage/paywall/revenue metrics plus user
/// management (search, paginate, toggle `is_active`/`is_admin`).
///
/// Reachable only at `/admin`; the router's top-level redirect bounces
/// non-`is_admin` sessions to `/home` before this ever builds, and every
/// backing endpoint independently re-checks `is_admin` server-side (BC-88).
class AdminConsoleScreen extends ConsumerWidget {
  const AdminConsoleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final overviewAsync = ref.watch(adminOverviewProvider);
    final usersState = ref.watch(adminUsersNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('관리자 콘솔')),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                spacing.lg,
                spacing.lg,
                spacing.lg,
                spacing.sm,
              ),
              child: overviewAsync.when(
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (_, __) => _MetricsError(
                  onRetry: () => ref.invalidate(adminOverviewProvider),
                ),
                data: (overview) =>
                    _MetricsSection(overview: overview, spacing: spacing),
              ),
            ),
          ),
          if (DevLoginGate.isEnabled())
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: spacing.lg),
                child: _DevToolsEntry(
                  onTap: () => context.push(AppRoutes.devLogin),
                ),
              ),
            ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                spacing.lg,
                spacing.lg,
                spacing.lg,
                spacing.sm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('사용자 관리', style: theme.textTheme.titleMedium),
                  SizedBox(height: spacing.sm),
                  TextField(
                    onChanged: (value) => ref
                        .read(adminUsersNotifierProvider.notifier)
                        .searchChanged(value),
                    decoration: const InputDecoration(
                      hintText: '닉네임 또는 이메일로 검색',
                      prefixIcon: Icon(Icons.search_rounded),
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _UsersSliver(state: usersState, spacing: spacing),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Metrics section — stats · conversion funnel · revenue
// ---------------------------------------------------------------------------

class _MetricsSection extends StatelessWidget {
  const _MetricsSection({required this.overview, required this.spacing});

  final AdminOverview overview;
  final AppSpacing spacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('지표', style: theme.textTheme.titleMedium),
        SizedBox(height: spacing.sm),
        _StatsCard(stats: overview.stats),
        SizedBox(height: spacing.sm),
        _FunnelCard(funnel: overview.funnel),
        SizedBox(height: spacing.sm),
        _RevenueCard(revenue: overview.revenue),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.title, required this.rows});

  final String title;
  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 20,
            runSpacing: 8,
            children: <Widget>[
              for (final (label, value) in rows)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      value,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      label,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.stats});

  final AdminStats stats;

  @override
  Widget build(BuildContext context) {
    return _MetricCard(
      title: '사용량',
      rows: <(String, String)>[
        ('MAU', '${stats.mau}'),
        ('DAU', '${stats.dau}'),
        ('신규 가입(7일)', '${stats.newUsers7d}'),
        ('Pro 사용자', '${stats.proUsers}'),
      ],
    );
  }
}

class _FunnelCard extends StatelessWidget {
  const _FunnelCard({required this.funnel});

  final ConversionFunnel funnel;

  @override
  Widget build(BuildContext context) {
    return _MetricCard(
      title: '결제 전환',
      rows: <(String, String)>[
        ('페이월 노출', '${funnel.paywallViews}'),
        ('페이월 클릭', '${funnel.paywallClicks}'),
        ('구독 전환', '${funnel.subscriptions}'),
        ('전환율', '${(funnel.conversionRate * 100).toStringAsFixed(1)}%'),
      ],
    );
  }
}

class _RevenueCard extends StatelessWidget {
  const _RevenueCard({required this.revenue});

  final RevenueMetrics revenue;

  @override
  Widget build(BuildContext context) {
    return _MetricCard(
      title: '매출',
      rows: <(String, String)>[
        ('MRR', _formatKrw(revenue.mrr)),
        ('ARR', _formatKrw(revenue.arr)),
        ('활성 구독자', '${revenue.activeSubscribers}'),
        ('30일 이탈', '${revenue.churned30d}'),
        ('팀 플랜 MRR', _formatKrw(revenue.teamMrr)),
      ],
    );
  }

  static String _formatKrw(double value) => '₩${value.toStringAsFixed(0)}';
}

class _MetricsError extends StatelessWidget {
  const _MetricsError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.cloud_off_rounded, color: theme.colorScheme.outline),
          const SizedBox(height: 8),
          Text('지표를 불러오지 못했어요', style: theme.textTheme.bodyMedium),
          const SizedBox(height: 8),
          FilledButton(onPressed: onRetry, child: const Text('다시 시도')),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Dev tools entry — BC-86 `/dev-login`, gated by [DevLoginGate]
// ---------------------------------------------------------------------------

class _DevToolsEntry extends StatelessWidget {
  const _DevToolsEntry({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: const Icon(Icons.build_circle_outlined),
        title: const Text('개발자 로그인 도구'),
        subtitle: const Text('테스트/개발자 계정으로 전환 (dev 빌드 전용)'),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// User list — search + pagination + is_active/is_admin toggles
// ---------------------------------------------------------------------------

class _UsersSliver extends ConsumerWidget {
  const _UsersSliver({required this.state, required this.spacing});

  final AdminUsersState state;
  final AppSpacing spacing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (state) {
      AdminUsersLoading() => const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
      AdminUsersError(message: final message) => SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(spacing.lg),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(message),
                  SizedBox(height: spacing.sm),
                  FilledButton(
                    onPressed: () =>
                        ref.read(adminUsersNotifierProvider.notifier).retry(),
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            ),
          ),
        ),
      final AdminUsersLoaded loaded when loaded.items.isEmpty =>
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(spacing.lg),
            child: Center(
              child: Text(
                '검색 결과가 없습니다.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        ),
      final AdminUsersLoaded loaded => SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final List<AdminUser> items = loaded.items;
            if (index == items.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              );
            }
            if (index == items.length - 1 &&
                loaded.hasMore &&
                !loaded.isLoadingMore) {
              ref.read(adminUsersNotifierProvider.notifier).loadMore();
            }
            return _AdminUserTile(user: items[index]);
          }, childCount: loaded.items.length + (loaded.hasMore ? 1 : 0)),
        ),
    };
  }
}

class _AdminUserTile extends ConsumerWidget {
  const _AdminUserTile({required this.user});

  final AdminUser user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return ListTile(
      title: Row(
        children: <Widget>[
          Flexible(child: Text(user.nickname, overflow: TextOverflow.ellipsis)),
          if (user.isPro) ...[
            const SizedBox(width: 6),
            _Badge(label: 'Pro', color: theme.colorScheme.primary),
          ],
          if (user.isAdmin) ...[
            const SizedBox(width: 6),
            _Badge(label: '관리자', color: theme.colorScheme.tertiary),
          ],
          if (!user.isActive) ...[
            const SizedBox(width: 6),
            _Badge(label: '비활성', color: theme.colorScheme.error),
          ],
        ],
      ),
      subtitle: Text(user.email ?? '이메일 없음'),
      trailing: PopupMenuButton<_UserAction>(
        onSelected: (action) => _onSelected(context, ref, action),
        itemBuilder: (_) => <PopupMenuEntry<_UserAction>>[
          PopupMenuItem<_UserAction>(
            value: _UserAction.toggleActive,
            child: Text(user.isActive ? '비활성화' : '활성화'),
          ),
          PopupMenuItem<_UserAction>(
            value: _UserAction.toggleAdmin,
            child: Text(user.isAdmin ? '관리자 해제' : '관리자로 지정'),
          ),
        ],
      ),
    );
  }

  Future<void> _onSelected(
    BuildContext context,
    WidgetRef ref,
    _UserAction action,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      switch (action) {
        case _UserAction.toggleActive:
          await ref
              .read(adminUsersNotifierProvider.notifier)
              .togglePatch(user.id, isActive: !user.isActive);
        case _UserAction.toggleAdmin:
          await ref
              .read(adminUsersNotifierProvider.notifier)
              .togglePatch(user.id, isAdmin: !user.isAdmin);
      }
    } on AdminRepositoryException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    }
  }
}

enum _UserAction { toggleActive, toggleAdmin }

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
