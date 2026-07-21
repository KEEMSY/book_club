import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/theme/app_theme.dart';
import '../application/reading_providers.dart';
import '../application/recap_notifier.dart';
import '../domain/monthly_recap.dart';

/// Full-screen monthly recap card. Receives optional [year] and [month] via
/// go_router `extra`; if both are null the backend returns the current month.
///
/// The UI mirrors the half-year [ReadingRecapScreen] style: gradient card,
/// key stats, previous-month comparison arrow, and a share button.
class MonthlyRecapScreen extends ConsumerStatefulWidget {
  const MonthlyRecapScreen({super.key, this.year, this.month});

  final int? year;
  final int? month;

  @override
  ConsumerState<MonthlyRecapScreen> createState() => _MonthlyRecapScreenState();
}

class _MonthlyRecapScreenState extends ConsumerState<MonthlyRecapScreen> {
  final GlobalKey _cardKey = GlobalKey();
  bool _sharing = false;

  Future<void> _share(MonthlyRecap recap) async {
    if (_sharing) return;
    setState(() => _sharing = true);
    try {
      final RenderRepaintBoundary boundary =
          _cardKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;
      final Uint8List pngBytes = byteData.buffer.asUint8List();

      final int hours = recap.totalHours.floor();
      final int minutes = ((recap.totalHours - hours) * 60).round();
      final String timeLabel = hours > 0 ? '$hours시간 $minutes분' : '$minutes분';

      final String text = '${recap.fullLabel} 독서 회고\n'
          '총 ${recap.booksCompleted}권 · $timeLabel 읽었어요 📚\n'
          '#북클럽 #독서기록';

      await SharePlus.instance.share(
        ShareParams(
          files: <XFile>[
            XFile.fromData(
              pngBytes,
              mimeType: 'image/png',
              name: 'monthly_recap.png',
            ),
          ],
          text: text,
        ),
      );
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color accent = ref.watch(gradePrimaryProvider);

    final AsyncValue<MonthlyRecap> async = ref.watch(
      monthlyRecapProvider(year: widget.year, month: widget.month),
    );

    final String title = widget.year != null && widget.month != null
        ? '${widget.year}년 ${widget.month}월 회고'
        : '이번 달 회고';

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: theme.textTheme.titleLarge),
        actions: <Widget>[
          if (async case AsyncData(:final value))
            _sharing
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : IconButton(
                    icon: const Icon(Icons.share_rounded),
                    tooltip: '공유',
                    onPressed: () => _share(value),
                  ),
        ],
      ),
      body: switch (async) {
        AsyncLoading() => const Center(child: CircularProgressIndicator()),
        AsyncError(:final error) => _ErrorView(
            error: error,
            onRetry: () => ref.invalidate(
              monthlyRecapProvider(year: widget.year, month: widget.month),
            ),
          ),
        AsyncData(:final value) => SingleChildScrollView(
            padding: EdgeInsets.all(
              Theme.of(context).extension<AppSpacing>()!.lg,
            ),
            child: RepaintBoundary(
              key: _cardKey,
              child: _MonthlyRecapCard(recap: value, accent: accent),
            ),
          ),
        _ => const SizedBox.shrink(),
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Card widget — also the target for screenshot capture
// ---------------------------------------------------------------------------

class _MonthlyRecapCard extends StatelessWidget {
  const _MonthlyRecapCard({required this.recap, required this.accent});

  final MonthlyRecap recap;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppSpacing spacing = theme.extension<AppSpacing>()!;

    final int hours = recap.totalHours.floor();
    final int minutes = ((recap.totalHours - hours) * 60).round();
    final String timeLabel = hours > 0 ? '$hours시간 $minutes분' : '$minutes분';

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            accent,
            accent.withValues(alpha: 0.72),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: accent.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: EdgeInsets.all(spacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Header
          Text(
            recap.fullLabel,
            style: theme.textTheme.labelLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.80),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '월간 독서 회고',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: spacing.xl),

          // Stats row
          Row(
            children: <Widget>[
              _StatItem(label: '완독', value: '${recap.booksCompleted}권'),
              SizedBox(width: spacing.lg),
              _StatItem(label: '읽은 시간', value: timeLabel),
              SizedBox(width: spacing.lg),
              _StatItem(label: '최장 스트릭', value: '${recap.longestStreak}일'),
            ],
          ),
          SizedBox(height: spacing.md),

          // Average daily reading
          _StatItem(
            label: '하루 평균',
            value: '${recap.avgDailyMinutes.round()}분',
          ),

          if (recap.topGenre != null) ...<Widget>[
            SizedBox(height: spacing.md),
            _StatItem(label: '대표 장르', value: recap.topGenre!),
          ],

          // Previous-month comparison
          if (recap.hoursDelta != null) ...<Widget>[
            SizedBox(height: spacing.md),
            _PrevMonthComparison(delta: recap.hoursDelta!),
          ],

          SizedBox(height: spacing.lg),
          // Footer watermark
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '골방',
              style: theme.textTheme.labelSmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.55),
                letterSpacing: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared sub-widgets
// ---------------------------------------------------------------------------

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.70),
          ),
        ),
      ],
    );
  }
}

/// Up/down arrow indicator comparing this month's hours to the previous month.
class _PrevMonthComparison extends StatelessWidget {
  const _PrevMonthComparison({required this.delta});

  final double delta;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isUp = delta >= 0;
    final IconData icon =
        isUp ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded;
    final String deltaText =
        '${isUp ? '+' : ''}${delta.abs().toStringAsFixed(1)}시간';
    final String label = isUp ? '지난 달보다 더 읽었어요' : '지난 달보다 덜 읽었어요';

    return Row(
      children: <Widget>[
        Icon(icon, color: Colors.white.withValues(alpha: 0.85), size: 16),
        const SizedBox(width: 4),
        Text(
          '$deltaText — $label',
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.85),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Error view
// ---------------------------------------------------------------------------

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.cloud_off_rounded,
              size: 48,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              '회고를 불러오지 못했어요',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            FilledButton.tonal(
              onPressed: onRetry,
              child: const Text('다시 시도'),
            ),
          ],
        ),
      ),
    );
  }
}
