import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../application/challenge_providers.dart';
import '../data/challenge_models.dart';

/// Badge collection screen — earned badges + full catalogue with lock overlay.
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

class _BadgeBody extends StatelessWidget {
  const _BadgeBody({required this.myBadges, required this.allBadges});

  final List<BadgeEarnedDto> myBadges;
  final List<BadgeDto> allBadges;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    // Build a set of earned badge IDs for O(1) lookup.
    final earnedIds = {for (final e in myBadges) e.badge.id: e};

    return CustomScrollView(
      slivers: <Widget>[
        // My badges section
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                spacing.md, spacing.md, spacing.md, spacing.sm,),
            child: Text('획득한 배지', style: theme.textTheme.titleMedium),
          ),
        ),
        if (myBadges.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: spacing.md, vertical: spacing.sm,),
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
                  );
                },
                childCount: myBadges.length,
              ),
            ),
          ),

        SliverToBoxAdapter(child: SizedBox(height: spacing.lg)),

        // All badges section
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                spacing.md, 0, spacing.md, spacing.sm,),
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
                spacing.md, 0, spacing.md, spacing.xl,),
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
                  final earnedItem = earnedIds[badge.id];
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
// Badge card
// ---------------------------------------------------------------------------

class _BadgeCard extends StatelessWidget {
  const _BadgeCard({
    required this.badge,
    required this.earned,
    this.earnedAt,
  });

  final BadgeDto badge;
  final bool earned;
  final DateTime? earnedAt;

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
                      color:
                          theme.colorScheme.surface.withValues(alpha: 0.6),
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
  });

  final BadgeDto badge;
  final bool earned;
  final DateTime? earnedAt;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            spacing.lg, spacing.lg, spacing.lg, spacing.lg,),
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
