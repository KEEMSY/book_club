import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../application/reading_providers.dart';
import '../application/reading_stats_notifier.dart';
import '../domain/reading_stats.dart';

/// `/reading/stats` — full reading analytics screen (M21).
///
/// Five sections rendered with pure Flutter widgets (no fl_chart dependency):
///   1. 평균 독서 속도 — minutes/page figure card.
///   2. 포맷별 비중 — horizontal bar breakdown (paper / ebook / audio).
///   3. 최근 독서 시간 — 6-month vertical bar chart.
///   4. 장르 분포 — top-5 genre rank list with proportion bars.
///   5. 평균 완독 기간 — days figure card.
class ReadingStatsScreen extends ConsumerWidget {
  const ReadingStatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final Color accent = ref.watch(gradePrimaryProvider);
    final AsyncValue<ReadingStats> statsAsync = ref.watch(readingStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('독서 통계', style: theme.textTheme.titleLarge),
      ),
      body: statsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorBody(
          message: '통계를 불러오지 못했습니다.',
          onRetry: () => ref.invalidate(readingStatsProvider),
        ),
        data: (ReadingStats stats) => _StatsBody(stats: stats, accent: accent),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Body
// ---------------------------------------------------------------------------

class _StatsBody extends StatelessWidget {
  const _StatsBody({required this.stats, required this.accent});

  final ReadingStats stats;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    return ListView(
      padding: EdgeInsets.fromLTRB(
        spacing.lg,
        spacing.md,
        spacing.lg,
        spacing.xl,
      ),
      children: <Widget>[
        const _AdvancedStatsCta(),
        SizedBox(height: spacing.md),
        _SpeedCard(stats: stats, accent: accent),
        SizedBox(height: spacing.md),
        _FormatCard(stats: stats, accent: accent),
        SizedBox(height: spacing.md),
        _MonthlyChart(stats: stats, accent: accent),
        SizedBox(height: spacing.md),
        _GenreList(stats: stats, accent: accent),
        SizedBox(height: spacing.md),
        _CompletionCard(stats: stats, accent: accent),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 1. 평균 독서 속도
// ---------------------------------------------------------------------------

class _SpeedCard extends StatelessWidget {
  const _SpeedCard({required this.stats, required this.accent});

  final ReadingStats stats;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final AppShadows shadows = theme.extension<AppShadows>()!;

    final String speed = stats.avgMinutesPerPage != null
        ? stats.avgMinutesPerPage!.toStringAsFixed(1)
        : '-';
    final String pph = stats.avgPagesPerHour != null
        ? stats.avgPagesPerHour!.toStringAsFixed(0)
        : '-';

    return _SectionCard(
      shadows: shadows,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const _SectionTitle(title: '평균 독서 속도'),
          SizedBox(height: spacing.md),
          Row(
            children: <Widget>[
              Expanded(
                child: _FigureCell(
                  value: speed,
                  unit: '분/페이지',
                  accent: accent,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: theme.colorScheme.outlineVariant,
              ),
              Expanded(
                child: _FigureCell(
                  value: pph,
                  unit: '페이지/시간',
                  accent: accent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 2. 포맷별 비중
// ---------------------------------------------------------------------------

class _FormatCard extends StatelessWidget {
  const _FormatCard({required this.stats, required this.accent});

  final ReadingStats stats;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final AppShadows shadows = theme.extension<AppShadows>()!;

    final int total = stats.totalFormatBooks;

    return _SectionCard(
      shadows: shadows,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const _SectionTitle(title: '포맷별 비중'),
          SizedBox(height: spacing.md),
          if (total == 0)
            Text(
              '독서 데이터가 없습니다.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          else
            Column(
              children: <Widget>[
                _FormatRow(
                  label: '종이책',
                  count: stats.formatPaper,
                  total: total,
                  color: accent,
                ),
                SizedBox(height: spacing.sm),
                _FormatRow(
                  label: '전자책',
                  count: stats.formatEbook,
                  total: total,
                  color: theme.colorScheme.secondary,
                ),
                SizedBox(height: spacing.sm),
                _FormatRow(
                  label: '오디오북',
                  count: stats.formatAudio,
                  total: total,
                  color: theme.colorScheme.tertiary,
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _FormatRow extends StatelessWidget {
  const _FormatRow({
    required this.label,
    required this.count,
    required this.total,
    required this.color,
  });

  final String label;
  final int count;
  final int total;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double fraction = total > 0 ? count / total : 0.0;
    final String pct = '${(fraction * 100).round()}%';

    return Row(
      children: <Widget>[
        SizedBox(
          width: 60,
          child: Text(label, style: theme.textTheme.bodySmall),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: <Widget>[
                    Container(
                      height: 12,
                      color: color.withValues(alpha: 0.12),
                    ),
                    FractionallySizedBox(
                      widthFactor: fraction,
                      child: Container(height: 12, color: color),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 36,
          child: Text(
            pct,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.end,
          ),
        ),
        const SizedBox(width: 4),
        SizedBox(
          width: 28,
          child: Text(
            '$count권',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 3. 최근 독서 시간 (세로 막대 차트)
// ---------------------------------------------------------------------------

class _MonthlyChart extends StatelessWidget {
  const _MonthlyChart({required this.stats, required this.accent});

  final ReadingStats stats;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final AppShadows shadows = theme.extension<AppShadows>()!;

    // Show last 6 months; pad with zeros when backend returns fewer entries.
    final List<MonthlyHours> data = stats.monthlyHours.length > 6
        ? stats.monthlyHours.sublist(stats.monthlyHours.length - 6)
        : stats.monthlyHours;
    final double maxHours =
        data.fold(0.0, (prev, e) => e.hours > prev ? e.hours : prev);

    return _SectionCard(
      shadows: shadows,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const _SectionTitle(title: '월별 독서 시간'),
          SizedBox(height: spacing.md),
          if (data.isEmpty)
            Text(
              '독서 데이터가 없습니다.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          else
            SizedBox(
              height: 120,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: data.map((m) {
                  final double fraction =
                      maxHours > 0 ? m.hours / maxHours : 0.0;
                  final String shortMonth = m.month.substring(5); // "MM"
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          if (m.hours > 0)
                            Text(
                              m.hours >= 10
                                  ? '${m.hours.round()}h'
                                  : '${m.hours.toStringAsFixed(1)}h',
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontSize: 9,
                                color: accent,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          const SizedBox(height: 2),
                          Flexible(
                            child: FractionallySizedBox(
                              heightFactor: fraction.clamp(0.04, 1.0),
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: m.hours > 0
                                      ? accent
                                      : accent.withValues(alpha: 0.15),
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(4),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            shortMonth,
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontSize: 10,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(growable: false),
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 4. 장르 분포
// ---------------------------------------------------------------------------

class _GenreList extends StatelessWidget {
  const _GenreList({required this.stats, required this.accent});

  final ReadingStats stats;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final AppShadows shadows = theme.extension<AppShadows>()!;

    final List<GenreCount> top5 = stats.genreBreakdown.take(5).toList();
    final int totalGenreBooks = top5.fold(0, (sum, g) => sum + g.count);

    return _SectionCard(
      shadows: shadows,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const _SectionTitle(title: '장르 분포'),
          SizedBox(height: spacing.md),
          if (top5.isEmpty)
            Text(
              '독서 데이터가 없습니다.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          else
            Column(
              children: List<Widget>.generate(top5.length, (i) {
                final GenreCount g = top5[i];
                final double fraction =
                    totalGenreBooks > 0 ? g.count / totalGenreBooks : 0.0;
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: i < top5.length - 1 ? spacing.sm : 0,
                  ),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 20,
                        child: Text(
                          '${i + 1}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: i == 0
                                ? accent
                                : theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      SizedBox(
                        width: 72,
                        child: Text(
                          g.genre,
                          style: theme.textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Stack(
                            children: <Widget>[
                              Container(
                                height: 10,
                                color: accent.withValues(alpha: 0.12),
                              ),
                              FractionallySizedBox(
                                widthFactor: fraction,
                                child: Container(height: 10, color: accent),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${g.count}권',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 5. 평균 완독 기간
// ---------------------------------------------------------------------------

class _CompletionCard extends StatelessWidget {
  const _CompletionCard({required this.stats, required this.accent});

  final ReadingStats stats;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final AppShadows shadows = Theme.of(context).extension<AppShadows>()!;

    final String days = stats.avgCompletionDays != null
        ? stats.avgCompletionDays!.round().toString()
        : '-';

    return _SectionCard(
      shadows: shadows,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const _SectionTitle(title: '평균 완독 기간'),
          SizedBox(height: spacing.md),
          _FigureCell(value: days, unit: '일', accent: accent),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared atoms
// ---------------------------------------------------------------------------

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child, required this.shadows});

  final Widget child;
  final AppShadows shadows;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    return Container(
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
        boxShadow: shadows.elevated,
      ),
      child: child,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
    );
  }
}

class _FigureCell extends StatelessWidget {
  const _FigureCell({
    required this.value,
    required this.unit,
    required this.accent,
  });

  final String value;
  final String unit;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: <Widget>[
        Text(
          value,
          style: theme.textTheme.displaySmall?.copyWith(
            color: accent,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          unit,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Upsell card linking to the Pro-only advanced analytics screen.
///
/// Always visible — the destination screen gates itself on Pro entitlement, so
/// non-Pro users land on the paywall from here.
class _AdvancedStatsCta extends StatelessWidget {
  const _AdvancedStatsCta();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => GoRouter.of(context).push(AppRoutes.advancedStats),
        child: Ink(
          padding: EdgeInsets.all(spacing.lg),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[Color(0xFF6B21A8), Color(0xFF9333EA)],
            ),
          ),
          child: Row(
            children: <Widget>[
              const Icon(
                Icons.insights_rounded,
                color: Colors.white,
                size: 28,
              ),
              SizedBox(width: spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          'Pro 전용 고급 통계 보기',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.22),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'PRO',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '속도 트렌드 · 장르 분포 · 연간 비교',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Colors.white70,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    return Padding(
      padding: EdgeInsets.all(spacing.xl),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.cloud_off_rounded, size: 40),
            SizedBox(height: spacing.md),
            Text(message, style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: spacing.lg),
            FilledButton(onPressed: onRetry, child: const Text('다시 시도')),
          ],
        ),
      ),
    );
  }
}
