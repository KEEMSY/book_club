import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/book.dart';
import '../../domain/book_status.dart';
import 'book_cover.dart';

/// Airbnb-toned book row: 56×80 cover, title · author · publisher metadata.
///
/// [status] is optional — when provided, a small Rausch-tinted pill overlays
/// the cover's bottom-right corner to hint at the user's library state.
/// Library screen uses the grid variant via [BookCard.grid]; search uses the
/// default horizontal list variant.
class BookCard extends StatelessWidget {
  const BookCard({
    super.key,
    required this.book,
    this.status,
    this.onTap,
    this.onLongPress,
  })  : _layout = _BookCardLayout.list,
        onStatusTap = null,
        onMoreTap = null,
        onPlayTap = null;

  const BookCard.grid({
    super.key,
    required this.book,
    this.status,
    this.onTap,
    this.onLongPress,
    this.onStatusTap,
    this.onMoreTap,
    this.onPlayTap,
  }) : _layout = _BookCardLayout.grid;

  final Book book;
  final BookStatus? status;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onStatusTap;
  final VoidCallback? onMoreTap;
  final VoidCallback? onPlayTap;
  final _BookCardLayout _layout;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    switch (_layout) {
      case _BookCardLayout.list:
        return _ListLayout(
          book: book,
          status: status,
          spacing: spacing,
          theme: theme,
          onTap: onTap,
        );
      case _BookCardLayout.grid:
        return _GridLayout(
          book: book,
          status: status,
          spacing: spacing,
          theme: theme,
          onTap: onTap,
          onLongPress: onLongPress,
          onStatusTap: onStatusTap,
          onMoreTap: onMoreTap,
          onPlayTap: onPlayTap,
        );
    }
  }
}

enum _BookCardLayout { list, grid }

class _ListLayout extends StatelessWidget {
  const _ListLayout({
    required this.book,
    required this.status,
    required this.spacing,
    required this.theme,
    required this.onTap,
  });

  final Book book;
  final BookStatus? status;
  final AppSpacing spacing;
  final ThemeData theme;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(
        theme.extension<AppRadius>()!.md,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.md,
          vertical: spacing.sm,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                BookCover(
                  coverUrl: book.coverUrl,
                  width: 56,
                  height: 80,
                ),
                if (status != null)
                  Positioned(
                    right: 2,
                    bottom: 2,
                    child: _StatusPill(status: status!),
                  ),
              ],
            ),
            SizedBox(width: spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    book.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: spacing.xs),
                  Text(
                    book.author,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (book.publisher.isNotEmpty) ...<Widget>[
                    SizedBox(height: spacing.xs / 2),
                    Text(
                      book.publisher,
                      style: theme.textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GridLayout extends StatelessWidget {
  const _GridLayout({
    required this.book,
    required this.status,
    required this.spacing,
    required this.theme,
    required this.onTap,
    this.onLongPress,
    this.onStatusTap,
    this.onMoreTap,
    this.onPlayTap,
  });

  final Book book;
  final BookStatus? status;
  final AppSpacing spacing;
  final ThemeData theme;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onStatusTap;
  final VoidCallback? onMoreTap;
  final VoidCallback? onPlayTap;

  @override
  Widget build(BuildContext context) {
    final radii = theme.extension<AppRadius>()!;
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(radii.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: <Widget>[
              BookCover(
                coverUrl: book.coverUrl,
                borderRadius: BorderRadius.circular(radii.md),
              ),
              if (onPlayTap != null)
                Positioned(
                  right: 6,
                  bottom: 6,
                  child: GestureDetector(
                    onTap: onPlayTap,
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color:
                            theme.colorScheme.surface.withValues(alpha: 0.88),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.play_arrow_rounded,
                        size: 20,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: spacing.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(
                  book.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (onMoreTap != null)
                GestureDetector(
                  onTap: onMoreTap,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Icon(
                      Icons.more_vert,
                      size: 18,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: spacing.xs / 2),
          Text(
            book.author,
            style: theme.textTheme.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (status != null) ...<Widget>[
            SizedBox(height: spacing.xs),
            _StatusChip(status: status!, onTap: onStatusTap),
          ],
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final BookStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radii = theme.extension<AppRadius>()!;

    // Pill color reflects the state. Reading pulls the theme's primary so the
    // pill adapts to the dark-mode rauschDark tone; completed retains the plum
    // editorial accent; paused/dropped route through theme neutrals so they
    // stay legible on both canvases.
    final Color background;
    final Color foreground;
    switch (status) {
      case BookStatus.reading:
        background = theme.colorScheme.primary;
        foreground = theme.colorScheme.onPrimary;
      case BookStatus.completed:
        background = AppPalette.plusMagenta;
        foreground = AppPalette.pureWhite;
      case BookStatus.paused:
        background = theme.colorScheme.onSurface.withValues(alpha: 0.55);
        foreground = theme.colorScheme.surface;
      case BookStatus.dropped:
        background = theme.colorScheme.surfaceContainerHighest;
        foreground = theme.colorScheme.onSurface;
      case BookStatus.wishlist:
        background = theme.colorScheme.secondaryContainer;
        foreground = theme.colorScheme.onSecondaryContainer;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.all(Radius.circular(radii.pill)),
      ),
      child: Text(
        status.label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: foreground,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Tonal dropdown-style chip shown below the book title in the grid card.
/// The down-arrow signals that tapping changes the reading status.
class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status, this.onTap});

  final BookStatus status;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radii = theme.extension<AppRadius>()!;

    final Color chipColor = switch (status) {
      BookStatus.reading => theme.colorScheme.primary,
      BookStatus.completed => AppPalette.plusMagenta,
      BookStatus.paused => theme.colorScheme.onSurface.withValues(alpha: 0.55),
      BookStatus.dropped => theme.colorScheme.onSurface.withValues(alpha: 0.40),
      BookStatus.wishlist => theme.colorScheme.secondary,
    };

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: chipColor.withValues(alpha: 0.12),
          border: Border.all(
            color: chipColor.withValues(alpha: 0.45),
          ),
          borderRadius: BorderRadius.all(Radius.circular(radii.pill)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              status.label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: chipColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 2),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 13,
              color: chipColor,
            ),
          ],
        ),
      ),
    );
  }
}
