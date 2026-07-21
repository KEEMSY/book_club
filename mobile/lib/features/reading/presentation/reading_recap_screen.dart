import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/theme/app_theme.dart';
import '../../book/presentation/widgets/book_cover.dart';
import '../application/recap_notifier.dart';
import '../application/reading_providers.dart';
import '../domain/reading_recap.dart';

/// Full-screen reading recap card for a given half-year period.
///
/// Receives [recapKey] via go_router `extra`. Fetches data via
/// [readingRecapProvider] and displays a gradient card with key stats and
/// top books. A share button captures the card as an image and invokes
/// [SharePlus.instance.share].
class ReadingRecapScreen extends ConsumerStatefulWidget {
  const ReadingRecapScreen({super.key, required this.recapKey});

  final RecapKey recapKey;

  @override
  ConsumerState<ReadingRecapScreen> createState() => _ReadingRecapScreenState();
}

class _ReadingRecapScreenState extends ConsumerState<ReadingRecapScreen> {
  final GlobalKey _cardKey = GlobalKey();
  bool _sharing = false;

  Future<void> _share(ReadingRecap recap) async {
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

      final String halfLabel = recap.half == 1 ? '상반기' : '하반기';
      final int hours = recap.totalSeconds ~/ 3600;
      final String text = '${recap.year}년 $halfLabel 독서 회고\n'
          '총 ${recap.totalBooks}권 · $hours시간 읽었어요 📚\n'
          '#북클럽 #독서기록';

      await SharePlus.instance.share(
        ShareParams(
          files: <XFile>[
            XFile.fromData(pngBytes, mimeType: 'image/png', name: 'recap.png'),
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
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final Color accent = ref.watch(gradePrimaryProvider);
    final AsyncValue<ReadingRecap> async =
        ref.watch(readingRecapProvider(widget.recapKey));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.recapKey.year}년 '
          '${widget.recapKey.half == 1 ? '상반기' : '하반기'} 회고',
        ),
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
            onRetry: () =>
                ref.invalidate(readingRecapProvider(widget.recapKey)),
          ),
        AsyncData(:final value) => SingleChildScrollView(
            padding: EdgeInsets.all(spacing.lg),
            child: RepaintBoundary(
              key: _cardKey,
              child: _RecapCard(recap: value, accent: accent),
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

class _RecapCard extends StatelessWidget {
  const _RecapCard({required this.recap, required this.accent});

  final ReadingRecap recap;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final int hours = recap.totalSeconds ~/ 3600;
    final int minutes = (recap.totalSeconds % 3600) ~/ 60;
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
            '${recap.year}년 ${recap.halfLabel}',
            style: theme.textTheme.labelLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.80),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '독서 회고',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: spacing.xl),

          // Stats row
          Row(
            children: <Widget>[
              _StatItem(label: '완독한 책', value: '${recap.totalBooks}권'),
              SizedBox(width: spacing.lg),
              _StatItem(label: '읽은 시간', value: timeLabel),
              SizedBox(width: spacing.lg),
              _StatItem(
                label: '최장 연속',
                value: '${recap.longestStreakDays}일',
              ),
            ],
          ),

          if (recap.topBooks.isNotEmpty) ...<Widget>[
            SizedBox(height: spacing.xl),
            Text(
              '많이 읽은 책',
              style: theme.textTheme.titleSmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.80),
              ),
            ),
            SizedBox(height: spacing.md),
            ...recap.topBooks.take(3).map(
                  (book) => _TopBookRow(book: book, spacing: spacing),
                ),
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

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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

class _TopBookRow extends StatelessWidget {
  const _TopBookRow({required this.book, required this.spacing});

  final RecapBook book;
  final AppSpacing spacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final int minutes = book.readSeconds ~/ 60;
    final String duration =
        minutes >= 60 ? '${minutes ~/ 60}시간 ${minutes % 60}분' : '$minutes분';

    return Padding(
      padding: EdgeInsets.only(bottom: spacing.sm),
      child: Row(
        children: <Widget>[
          BookCover(
            coverUrl: book.coverUrl,
            width: 36,
            height: 50,
            borderRadius: BorderRadius.circular(4),
          ),
          SizedBox(width: spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  book.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  book.author,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.75),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: spacing.sm),
          Text(
            duration,
            style: theme.textTheme.labelSmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.80),
            ),
          ),
        ],
      ),
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
    final theme = Theme.of(context);
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
