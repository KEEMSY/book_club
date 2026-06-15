import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../application/challenge_providers.dart';
import '../data/challenge_models.dart';

/// Badge collection screen — pinned badges (reorderable) + earned grid +
/// full catalogue with lock overlay.
class BadgeCollectionScreen extends ConsumerWidget {
  const BadgeCollectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myAsync = ref.watch(myBadgesProvider);
    final allAsync = ref.watch(badgesProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('배지 컬렉션', style: theme.textTheme.titleLarge),
      ),
      body: myAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        error: (e, _) => _ErrorBody(
          onRetry: () {
            ref.invalidate(myBadgesProvider);
            ref.invalidate(badgesProvider);
          },
        ),
        data: (myBadges) => allAsync.when(
          loading: () =>
              const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          error: (e, _) => _ErrorBody(
            onRetry: () {
              ref.invalidate(myBadgesProvider);
              ref.invalidate(badgesProvider);
            },
          ),
          data: (allBadges) => _BadgeBody(
            myBadges: myBadges,
            allBadges: allBadges,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Body
// ---------------------------------------------------------------------------

class _BadgeBody extends ConsumerWidget {
  const _BadgeBody({required this.myBadges, required this.allBadges});

  final List<BadgeEarnedDto> myBadges;
  final List<BadgeDto> allBadges;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final pinAsync = ref.watch(badgePinNotifierProvider);
    final earnedMap = {for (final e in myBadges) e.badge.id: e};
    final allBadgeMap = {for (final b in allBadges) b.id: b};

    return CustomScrollView(
      slivers: <Widget>[
        // ── Pinned badges section ──────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              spacing.md,
              spacing.md,
              spacing.md,
              spacing.xs,
            ),
            child: Row(
              children: <Widget>[
                Text('핀된 배지', style: theme.textTheme.titleMedium),
                const SizedBox(width: 6),
                Text(
                  '(최대 $kMaxPinnedBadges개 · 길게 눌러 순서 변경)',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        ),
        pinAsync.when(
          loading: () => const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
          error: (_, __) => const SliverToBoxAdapter(child: SizedBox.shrink()),
          data: (pinnedIds) {
            return SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: spacing.md),
                child: _PinnedBadgesGrid(
                  pinnedIds: pinnedIds,
                  earnedMap: earnedMap,
                  allBadgeMap: allBadgeMap,
                  onReorder: (newIds) =>
                      ref.read(badgePinNotifierProvider.notifier).reorder(newIds),
                ),
              ),
            );
          },
        ),

        SliverToBoxAdapter(child: SizedBox(height: spacing.lg)),

        // ── Earned badges section ──────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              spacing.md,
              0,
              spacing.md,
              spacing.sm,
            ),
            child: Text('획득한 배지', style: theme.textTheme.titleMedium),
          ),
        ),
        if (myBadges.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: spacing.md,
                vertical: spacing.sm,
              ),
              child: Text(
                '아직 획득한 배지가 없어요. 챌린지에 참여해 배지를 모아보세요!',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
          )
        else
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: spacing.md),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final earned = myBadges[index];
                  return _BadgeCard(
                    badge: earned.badge,
                    earned: true,
                    earnedAt: earned.earnedAt,
                    isExclusive: earned.isExclusive,
                  );
                },
                childCount: myBadges.length,
              ),
            ),
          ),

        SliverToBoxAdapter(child: SizedBox(height: spacing.lg)),

        // ── All badges catalogue ───────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              spacing.md,
              0,
              spacing.md,
              spacing.sm,
            ),
            child: Text('전체 배지 도감', style: theme.textTheme.titleMedium),
          ),
        ),
        if (allBadges.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing.md),
              child: Text(
                '등록된 배지가 없어요.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
          )
        else
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              spacing.md,
              0,
              spacing.md,
              spacing.xl,
            ),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final badge = allBadges[index];
                  final earnedItem = earnedMap[badge.id];
                  return _BadgeCard(
                    badge: badge,
                    earned: earnedItem != null,
                    earnedAt: earnedItem?.earnedAt,
                  );
                },
                childCount: allBadges.length,
              ),
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Pinned badges grid (3 × 2 = 6 slots) with ReorderableListView rows
// ---------------------------------------------------------------------------

class _PinnedBadgesGrid extends StatefulWidget {
  const _PinnedBadgesGrid({
    required this.pinnedIds,
    required this.earnedMap,
    required this.allBadgeMap,
    required this.onReorder,
  });

  final List<String> pinnedIds;
  final Map<String, BadgeEarnedDto> earnedMap;
  final Map<String, BadgeDto> allBadgeMap;
  final void Function(List<String> newIds) onReorder;

  @override
  State<_PinnedBadgesGrid> createState() => _PinnedBadgesGridState();
}

class _PinnedBadgesGridState extends State<_PinnedBadgesGrid> {
  late List<String?> _slots; // length == kMaxPinnedBadges, null = empty slot

  @override
  void initState() {
    super.initState();
    _slots = _buildSlots(widget.pinnedIds);
  }

  @override
  void didUpdateWidget(_PinnedBadgesGrid old) {
    super.didUpdateWidget(old);
    if (old.pinnedIds != widget.pinnedIds) {
      _slots = _buildSlots(widget.pinnedIds);
    }
  }

  List<String?> _buildSlots(List<String> ids) {
    final slots = List<String?>.filled(kMaxPinnedBadges, null);
    for (var i = 0; i < ids.length && i < kMaxPinnedBadges; i++) {
      slots[i] = ids[i];
    }
    return slots;
  }

  void _handleReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex--;
      final item = _slots.removeAt(oldIndex);
      _slots.insert(newIndex, item);
    });
    final ids = _slots.whereType<String>().toList();
    widget.onReorder(ids);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Split 6 slots into 2 rows of 3 for the grid layout.
    // ReorderableListView wraps both rows, where each row is a ReorderableListView item.
    // Because Flutter's ReorderableListView is list-based (single axis), we
    // use it as a vertical list of rows (each row holds 3 items) and embed
    // individual drag handles on each badge tile.

    // Alternative approach: flat ReorderableListView with 6 items rendered
    // as a Wrap-like grid using LayoutBuilder. Flutter's ReorderableListView
    // supports any child layout via proxyDecorator.

    return SizedBox(
      // 2 rows × (tile height ~80) + spacing
      height: 180,
      child: ReorderableListView.builder(
        scrollDirection: Axis.horizontal,
        buildDefaultDragHandles: false,
        itemCount: kMaxPinnedBadges,
        itemBuilder: (ctx, index) {
          final id = _slots[index];
          final badge = id != null ? widget.allBadgeMap[id] : null;
          final earned = id != null ? widget.earnedMap[id] : null;
          return ReorderableDragStartListener(
            key: ValueKey('pin_$index'),
            index: index,
            child: _PinnedSlotTile(
              badge: badge,
              earnedAt: earned?.earnedAt,
            ),
          );
        },
        onReorder: _handleReorder,
        proxyDecorator: (child, index, animation) {
          return AnimatedBuilder(
            animation: animation,
            builder: (_, __) {
              final scale = lerpDouble(1.0, 1.12, animation.value)!;
              return Transform.scale(
                scale: scale,
                child: Material(
                  color: Colors.transparent,
                  elevation: 4 * animation.value,
                  shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.4),
                  child: child,
                ),
              );
            },
            child: child,
          );
        },
      ),
    );
  }
}

/// A single pinned slot — either a badge tile or an empty dashed-border slot.
class _PinnedSlotTile extends StatelessWidget {
  const _PinnedSlotTile({this.badge, this.earnedAt});

  final BadgeDto? badge;
  final DateTime? earnedAt;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = theme.extension<AppRadius>()!;

    if (badge == null) {
      return SizedBox(
        width: 80,
        height: 80,
        child: CustomPaint(
          painter: _DashedBorderPainter(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
            borderRadius: radius.md,
          ),
          child: Center(
            child: Icon(
              Icons.add,
              size: 22,
              color: theme.colorScheme.outlineVariant,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: 80,
      height: 80,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: _BadgeCard(
          badge: badge!,
          earned: true,
          earnedAt: earnedAt,
        ),
      ),
    );
  }
}

/// CustomPainter that draws a rounded dashed border.
class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({
    required this.color,
    required this.borderRadius,
  });

  final Color color;
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const dashWidth = 5.0;
    const dashSpace = 4.0;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(1, 1, size.width - 2, size.height - 2),
      Radius.circular(borderRadius),
    );
    final path = Path()..addRRect(rrect);
    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        canvas.drawPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) =>
      old.color != color || old.borderRadius != borderRadius;
}

// ---------------------------------------------------------------------------
// Badge card
// ---------------------------------------------------------------------------

class _BadgeCard extends StatelessWidget {
  const _BadgeCard({
    required this.badge,
    required this.earned,
    this.earnedAt,
    this.isExclusive = false,
  });

  final BadgeDto badge;
  final bool earned;
  final DateTime? earnedAt;

  /// Whether the badge was obtained through a time-limited exclusive challenge.
  final bool isExclusive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = theme.extension<AppRadius>()!;

    return GestureDetector(
      onTap: () => _showDetail(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Opacity(
                  opacity: earned ? 1.0 : 0.4,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(radius.md),
                      color: earned
                          ? theme.colorScheme.primaryContainer
                              .withValues(alpha: 0.5)
                          : theme.colorScheme.surfaceContainerHighest,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: _BadgeIconWidget(badge: badge),
                    ),
                  ),
                ),
                if (!earned)
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface.withValues(alpha: 0.6),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      Icons.lock_outline,
                      size: 18,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            badge.name,
            style: theme.textTheme.labelSmall?.copyWith(
              color: earned
                  ? null
                  : theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (earned && isExclusive) ...<Widget>[
            const SizedBox(height: 2),
            Text(
              '✦ 기간 한정 획득',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: Colors.amber.shade700,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  void _showDetail(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _BadgeDetailSheet(
        badge: badge,
        earned: earned,
        earnedAt: earnedAt,
        isExclusive: isExclusive,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Badge detail bottom sheet
// ---------------------------------------------------------------------------

class _BadgeDetailSheet extends StatelessWidget {
  const _BadgeDetailSheet({
    required this.badge,
    required this.earned,
    this.earnedAt,
    this.isExclusive = false,
  });

  final BadgeDto badge;
  final bool earned;
  final DateTime? earnedAt;

  /// Whether the badge was earned via an exclusive limited-time challenge.
  final bool isExclusive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          spacing.lg,
          spacing.lg,
          spacing.lg,
          spacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Drag handle
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Badge icon
            _BadgeIconWidget(badge: badge, size: 72),
            SizedBox(height: spacing.md),

            // Name
            Text(badge.name, style: theme.textTheme.titleLarge),
            SizedBox(height: spacing.xs),

            // Category chip
            _CategoryChip(category: badge.category),
            SizedBox(height: spacing.sm),

            // Description
            Text(
              badge.description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
            ),

            // Earned date
            if (earned && earnedAt != null) ...<Widget>[
              SizedBox(height: spacing.sm),
              Text(
                '획득일: ${_formatDate(earnedAt!)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ] else if (!earned) ...<Widget>[
              SizedBox(height: spacing.sm),
              Text(
                '아직 획득하지 못한 배지예요.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],

            // Exclusive acquisition label
            if (earned && isExclusive) ...<Widget>[
              SizedBox(height: spacing.xs),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.shade600.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.shade600, width: 1),
                ),
                child: Text(
                  '✦ 기간 한정 획득',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.amber.shade800,
                  ),
                ),
              ),
            ],

            SizedBox(height: spacing.sm),
          ],
        ),
      ),
    );
  }

  static String _formatDate(DateTime dt) =>
      '${dt.year}.${dt.month.toString().padLeft(2, '0')}.${dt.day.toString().padLeft(2, '0')}';
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.category});

  final String category;

  String get _label {
    switch (category) {
      case 'reading':
        return '독서';
      case 'challenge':
        return '챌린지';
      case 'social':
        return '소셜';
      default:
        return category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSecondaryContainer,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Badge icon widget (shared)
// ---------------------------------------------------------------------------

class _BadgeIconWidget extends StatelessWidget {
  const _BadgeIconWidget({required this.badge, this.size});

  final BadgeDto badge;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final iconSize = size ?? 48.0;
    if (badge.iconUrl != null) {
      return CachedNetworkImage(
        imageUrl: badge.iconUrl!,
        width: iconSize,
        height: iconSize,
        fit: BoxFit.contain,
        placeholder: (_, __) => _FallbackIcon(size: iconSize),
        errorWidget: (_, __, ___) => _FallbackIcon(size: iconSize),
      );
    }
    return _FallbackIcon(size: iconSize);
  }
}

class _FallbackIcon extends StatelessWidget {
  const _FallbackIcon({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Icon(
      Icons.workspace_premium,
      size: size * 0.85,
      color: theme.colorScheme.primary.withValues(alpha: 0.7),
    );
  }
}

// ---------------------------------------------------------------------------
// Error body
// ---------------------------------------------------------------------------

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('배지를 불러오지 못했어요', style: theme.textTheme.bodyMedium),
          SizedBox(height: spacing.sm),
          FilledButton(onPressed: onRetry, child: const Text('다시 시도')),
        ],
      ),
    );
  }
}
