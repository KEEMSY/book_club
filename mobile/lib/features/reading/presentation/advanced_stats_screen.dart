import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../subscription/application/subscription_notifier.dart';
import '../application/advanced_stats_providers.dart';
import '../application/reading_providers.dart';
import '../data/advanced_stats_models.dart';
import '../data/advanced_stats_repository.dart';

/// `/reading/stats/advanced` — Pro-only deep analytics (M53).
///
/// Sections:
///   1. 독서 속도 트렌드 — weekly minutes-per-page line chart (CustomPaint).
///   2. 장르 분포 — proportion bars per genre.
///   3. 올해 vs 작년 — yearly book-count comparison card.
///   4. 최장 연속 독서 — longest streak figure card.
///
/// Non-Pro users (or a 403 from the endpoint) see a lock screen routing to the
/// paywall instead of the analytics body.
class AdvancedStatsScreen extends ConsumerWidget {
  const AdvancedStatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final bool isPro = ref.watch(subscriptionNotifierProvider).maybeWhen(
          data: (s) => s.isPro,
          orElse: () => false,
        );

    return Scaffold(
      appBar: AppBar(
        title: Text('고급 통계', style: theme.textTheme.titleLarge),
      ),
      body: isPro ? const _AdvancedStatsBody() : const _ProLockBody(),
    );
  }
}

// ---------------------------------------------------------------------------
// Pro lock screen
// ---------------------------------------------------------------------------

class _ProLockBody extends StatelessWidget {
  const _ProLockBody();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    const Color accent = Color(0xFF6B21A8);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_rounded,
                size: 36,
                color: accent,
              ),
            ),
            SizedBox(height: spacing.lg),
            Text(
              'Pro 전용 기능',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: spacing.sm),
            Text(
              '독서 속도 트렌드, 장르 분포, 연간 비교 등\n깊이 있는 통계는 Book Club Pro에서 만나보세요.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.xl),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => GoRouter.of(context).push(AppRoutes.paywall),
                style: FilledButton.styleFrom(
                  backgroundColor: accent,
                  padding: EdgeInsets.symmetric(vertical: spacing.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'Pro 시작하기',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
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
// Body
// ---------------------------------------------------------------------------

class _AdvancedStatsBody extends ConsumerWidget {
  const _AdvancedStatsBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color accent = ref.watch(gradePrimaryProvider);
    final AsyncValue<AdvancedStatsDto> statsAsync =
        ref.watch(advancedStatsProvider);

    return statsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) {
        // A 403 here means entitlement lapsed mid-session — show the upsell.
        if (e is ProRequiredException) return const _ProLockBody();
        return _ErrorBody(
          onRetry: () => ref.invalidate(advancedStatsProvider),
        );
      },
      data: (AdvancedStatsDto stats) =>
          _StatsContent(stats: stats, accent: accent),
    );
  }
}

class _StatsContent extends StatelessWidget {
  const _StatsContent({required this.stats, required this.accent});

  final AdvancedStatsDto stats;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    return ListView(
      padding: EdgeInsets.fromLTRB(
        spacing.lg,
        spacing.md,
        spacing.lg,
        spacing.xl,
      ),
      children: <Widget>[
        _SpeedTrendCard(items: stats.speedTrend, accent: accent),
        SizedBox(height: spacing.md),
        _GenreDistributionCard(items: stats.genreDistribution, accent: accent),
        SizedBox(height: spacing.md),
        _YearlyComparisonCard(
          comparison: stats.yearlyComparison,
          accent: accent,
        ),
        SizedBox(height: spacing.md),
        _LongestStreakCard(days: stats.longestStreakDays, accent: accent),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 1. 독서 속도 트렌드 (line chart)
// ---------------------------------------------------------------------------

class _SpeedTrendCard extends StatelessWidget {
  const _SpeedTrendCard({required this.items, required this.accent});

  final List<SpeedTrendItem> items;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final AppShadows shadows = theme.extension<AppShadows>()!;

    return _SectionCard(
      shadows: shadows,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const _SectionTitle(title: '독서 속도 트렌드'),
          SizedBox(height: spacing.xs),
          Text(
            '주차별 페이지당 소요 시간 (낮을수록 빠름)',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: spacing.md),
          if (items.length < 2)
            Text(
              '추세를 그리기에 데이터가 부족합니다.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          else ...<Widget>[
            SizedBox(
              height: 140,
              child: CustomPaint(
                size: Size.infinite,
                painter: _SpeedTrendPainter(
                  items: items,
                  lineColor: accent,
                  gridColor: theme.colorScheme.outlineVariant,
                ),
              ),
            ),
            SizedBox(height: spacing.sm),
            _TrendAxisLabels(items: items, theme: theme),
          ],
        ],
      ),
    );
  }
}

class _TrendAxisLabels extends StatelessWidget {
  const _TrendAxisLabels({required this.items, required this.theme});

  final List<SpeedTrendItem> items;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final DateFormat fmt = DateFormat('M/d');
    final SpeedTrendItem first = items.first;
    final SpeedTrendItem last = items.last;
    final TextStyle? style = theme.textTheme.labelSmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(fmt.format(first.weekStart), style: style),
        Text(fmt.format(last.weekStart), style: style),
      ],
    );
  }
}

class _SpeedTrendPainter extends CustomPainter {
  _SpeedTrendPainter({
    required this.items,
    required this.lineColor,
    required this.gridColor,
  });

  final List<SpeedTrendItem> items;
  final Color lineColor;
  final Color gridColor;

  @override
  void paint(Canvas canvas, Size size) {
    final double maxV = items
        .map((e) => e.minutesPerPage)
        .fold(0.0, (prev, v) => math.max(prev, v));
    final double minV = items
        .map((e) => e.minutesPerPage)
        .fold(double.infinity, (prev, v) => math.min(prev, v));
    // Pad the range so a flat line doesn't collapse onto an axis.
    final double range = (maxV - minV).abs() < 1e-6 ? 1.0 : maxV - minV;

    final Paint gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    for (int i = 0; i <= 3; i++) {
      final double y = size.height * i / 3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    Offset pointFor(int i) {
      final double x = items.length == 1
          ? size.width / 2
          : size.width * i / (items.length - 1);
      final double norm = (items[i].minutesPerPage - minV) / range;
      // Invert: a smaller minutes/page (faster) sits higher on the chart.
      final double y = size.height - norm * size.height;
      return Offset(x, y);
    }

    final Path linePath = Path();
    for (int i = 0; i < items.length; i++) {
      final Offset p = pointFor(i);
      if (i == 0) {
        linePath.moveTo(p.dx, p.dy);
      } else {
        linePath.lineTo(p.dx, p.dy);
      }
    }

    // Filled gradient area under the line.
    final Path fillPath = Path.from(linePath)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            lineColor.withValues(alpha: 0.25),
            lineColor.withValues(alpha: 0.0),
          ],
        ).createShader(Offset.zero & size),
    );

    canvas.drawPath(
      linePath,
      Paint()
        ..color = lineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeJoin = StrokeJoin.round,
    );

    final Paint dotPaint = Paint()..color = lineColor;
    for (int i = 0; i < items.length; i++) {
      canvas.drawCircle(pointFor(i), 3, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _SpeedTrendPainter old) =>
      old.items != items ||
      old.lineColor != lineColor ||
      old.gridColor != gridColor;
}

// ---------------------------------------------------------------------------
// 2. 장르 분포
// ---------------------------------------------------------------------------

class _GenreDistributionCard extends StatelessWidget {
  const _GenreDistributionCard({required this.items, required this.accent});

  final List<GenreDistributionItem> items;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final AppShadows shadows = theme.extension<AppShadows>()!;

    return _SectionCard(
      shadows: shadows,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const _SectionTitle(title: '장르 분포'),
          SizedBox(height: spacing.md),
          if (items.isEmpty)
            Text(
              '독서 데이터가 없습니다.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          else
            Column(
              children: List<Widget>.generate(items.length, (i) {
                final GenreDistributionItem g = items[i];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: i < items.length - 1 ? spacing.sm : 0,
                  ),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 80,
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
                                height: 12,
                                color: accent.withValues(alpha: 0.12),
                              ),
                              FractionallySizedBox(
                                widthFactor: (g.pct / 100).clamp(0.0, 1.0),
                                child: Container(height: 12, color: accent),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 64,
                        child: Text(
                          '${g.pct.toStringAsFixed(0)}% · ${g.count}권',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.end,
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
// 3. 올해 vs 작년
// ---------------------------------------------------------------------------

class _YearlyComparisonCard extends StatelessWidget {
  const _YearlyComparisonCard({
    required this.comparison,
    required this.accent,
  });

  final Map<String, int> comparison;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final AppShadows shadows = theme.extension<AppShadows>()!;

    final int current = comparison['current_year'] ?? 0;
    final int prev = comparison['prev_year'] ?? 0;
    final int delta = current - prev;
    final bool up = delta >= 0;

    return _SectionCard(
      shadows: shadows,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const _SectionTitle(title: '올해 vs 작년'),
          SizedBox(height: spacing.md),
          Row(
            children: <Widget>[
              Expanded(
                child: _FigureCell(
                  value: '$current',
                  unit: '올해 (권)',
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
                  value: '$prev',
                  unit: '작년 (권)',
                  accent: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                up ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                size: 18,
                color: up ? const Color(0xFF1B873F) : const Color(0xFFE11D48),
              ),
              const SizedBox(width: 6),
              Text(
                up ? '작년보다 ${delta.abs()}권 더 읽었어요' : '작년보다 ${delta.abs()}권 적어요',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: up ? const Color(0xFF1B873F) : const Color(0xFFE11D48),
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
// 4. 최장 연속 독서
// ---------------------------------------------------------------------------

class _LongestStreakCard extends StatelessWidget {
  const _LongestStreakCard({required this.days, required this.accent});

  final int days;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final AppShadows shadows = theme.extension<AppShadows>()!;

    return _SectionCard(
      shadows: shadows,
      child: Row(
        children: <Widget>[
          Icon(Icons.local_fire_department_rounded, color: accent, size: 32),
          SizedBox(width: spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const _SectionTitle(title: '최장 연속 독서'),
                SizedBox(height: spacing.xs),
                Text(
                  '하루도 빠지지 않고 이어간 최고 기록',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$days일',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: accent,
              fontWeight: FontWeight.w700,
            ),
          ),
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

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.onRetry});

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
            Text(
              '통계를 불러오지 못했습니다.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: spacing.lg),
            FilledButton(onPressed: onRetry, child: const Text('다시 시도')),
          ],
        ),
      ),
    );
  }
}
