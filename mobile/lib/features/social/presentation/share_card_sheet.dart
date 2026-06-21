import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/theme/app_theme.dart';
import '../application/share_providers.dart';
import '../domain/share_card.dart';

/// One selectable card template with its Korean tab label.
class _CardTemplate {
  const _CardTemplate(this.type, this.label);
  final String type;
  final String label;
}

const List<_CardTemplate> _templates = <_CardTemplate>[
  _CardTemplate('book_completed', '완독'),
  _CardTemplate('reading_streak', '스트릭'),
  _CardTemplate('challenge_badge', '배지'),
  _CardTemplate('monthly_recap', '월간 결산'),
  _CardTemplate('progress_checkin', '진행 체크인'),
];

/// Selectable export aspect ratios for the rendered card.
enum _CardRatio {
  square('1:1', 1.0),
  portrait('4:5', 4 / 5),
  story('9:16', 9 / 16);

  const _CardRatio(this.label, this.value);
  final String label;
  final double value;
}

/// Bottom sheet that renders an SNS certification card for a reading milestone,
/// lets the user pick a template + aspect ratio, captures it as a PNG, shares
/// it via the system sheet, then records a share event for the M62 viral loop.
///
/// The triggering screen passes [initialCardType] plus the optional display
/// extras it already has in context ([bookCoverUrl], [detail]); identity, the
/// referral deep link, and caption come from the backend per template.
class ShareCardSheet extends ConsumerStatefulWidget {
  const ShareCardSheet({
    super.key,
    required this.initialCardType,
    this.bookCoverUrl,
    this.detail,
  });

  final String initialCardType;
  final String? bookCoverUrl;

  /// Short line of milestone specifics rendered on the card, e.g.
  /// "총 7시간 · ⭐ 4.5" or "23일 연속". Supplied by the trigger context.
  final String? detail;

  static Future<void> show(
    BuildContext context, {
    required String initialCardType,
    String? bookCoverUrl,
    String? detail,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => ShareCardSheet(
        initialCardType: initialCardType,
        bookCoverUrl: bookCoverUrl,
        detail: detail,
      ),
    );
  }

  @override
  ConsumerState<ShareCardSheet> createState() => _ShareCardSheetState();
}

class _ShareCardSheetState extends ConsumerState<ShareCardSheet> {
  final GlobalKey _cardKey = GlobalKey();
  late String _cardType = widget.initialCardType;
  _CardRatio _ratio = _CardRatio.square;
  bool _sharing = false;

  Future<void> _share(ShareCardMeta meta) async {
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

      final ShareResult result = await SharePlus.instance.share(
        ShareParams(
          files: <XFile>[
            XFile.fromData(pngBytes, mimeType: 'image/png', name: 'bookclub_card.png'),
          ],
          text: meta.caption,
        ),
      );

      if (result.status == ShareResultStatus.success) {
        await _recordEvent(meta);
      }
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  /// Logs the share for viral-loop analytics. The system share sheet hides the
  /// chosen target, so `platform` is left null; `referral_code` carries the
  /// attribution signal that links the share to downstream sign-ups.
  Future<void> _recordEvent(ShareCardMeta meta) async {
    try {
      await ref.read(shareApiProvider).recordShareEvent(<String, dynamic>{
        'card_type': meta.cardType,
        'platform': null,
        'referral_code': meta.referralCode,
      });
    } catch (_) {
      // Analytics are best-effort — never block or fail the share UX on them.
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final AsyncValue<ShareCardMeta> async =
        ref.watch(shareCardMetaProvider(_cardType));

    return Padding(
      padding: EdgeInsets.all(spacing.lg),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('인증 카드 공유', style: theme.textTheme.titleLarge),
            SizedBox(height: spacing.md),
            _TemplateSelector(
              selected: _cardType,
              onSelected: (type) => setState(() => _cardType = type),
            ),
            SizedBox(height: spacing.md),
            _RatioSelector(
              selected: _ratio,
              onSelected: (ratio) => setState(() => _ratio = ratio),
            ),
            SizedBox(height: spacing.lg),
            switch (async) {
              AsyncError(:final error) => _ErrorBody(
                  error: error,
                  onRetry: () =>
                      ref.invalidate(shareCardMetaProvider(_cardType)),
                ),
              AsyncData(:final value) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Center(
                      child: AspectRatio(
                        aspectRatio: _ratio.value,
                        child: RepaintBoundary(
                          key: _cardKey,
                          child: _CertificationCard(
                            meta: value,
                            detail: widget.detail,
                            bookCoverUrl: widget.bookCoverUrl,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: spacing.lg),
                    FilledButton.icon(
                      onPressed: _sharing ? null : () => _share(value),
                      icon: _sharing
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.ios_share_rounded),
                      label: Text(_sharing ? '공유 중…' : '공유하기'),
                    ),
                  ],
                ),
              _ => const SizedBox(
                  height: 240,
                  child: Center(child: CircularProgressIndicator()),
                ),
            },
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Selectors
// ---------------------------------------------------------------------------

class _TemplateSelector extends StatelessWidget {
  const _TemplateSelector({required this.selected, required this.onSelected});

  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          for (final t in _templates)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(t.label),
                selected: t.type == selected,
                onSelected: (_) => onSelected(t.type),
              ),
            ),
        ],
      ),
    );
  }
}

class _RatioSelector extends StatelessWidget {
  const _RatioSelector({required this.selected, required this.onSelected});

  final _CardRatio selected;
  final ValueChanged<_CardRatio> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        for (final r in _CardRatio.values)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(r.label),
              selected: r == selected,
              onSelected: (_) => onSelected(r),
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Card — also the screenshot capture target
// ---------------------------------------------------------------------------

class _CertificationCard extends StatelessWidget {
  const _CertificationCard({
    required this.meta,
    required this.detail,
    required this.bookCoverUrl,
  });

  final ShareCardMeta meta;
  final String? detail;
  final String? bookCoverUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color seed = theme.colorScheme.primary;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[seed, seed.withValues(alpha: 0.72)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '@${meta.nickname}',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            if (bookCoverUrl != null && bookCoverUrl!.isNotEmpty)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: bookCoverUrl!,
                    width: 96,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Text(
              meta.headline,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (detail != null && detail!.isNotEmpty) ...<Widget>[
              const SizedBox(height: 6),
              Text(
                detail!,
                style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
              ),
            ],
            const Spacer(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: Text(
                    '북클럽에서 함께 읽어요\nbookclub.app/join',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: QrImageView(
                    data: meta.joinUrl,
                    size: 64,
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: <Widget>[
          const Text('카드를 불러오지 못했어요.'),
          const SizedBox(height: 12),
          OutlinedButton(onPressed: onRetry, child: const Text('다시 시도')),
        ],
      ),
    );
  }
}
