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
  }) : _layout = _BookCardLayout.list;

  const BookCard.grid({
    super.key,
    required this.book,
    this.status,
    this.onTap,
  }) : _layout = _BookCardLayout.grid;

  final Book book;
  final BookStatus? status;
  final VoidCallback? onTap;
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
  });

  final Book book;
  final BookStatus? status;
  final AppSpacing spacing;
  final ThemeData theme;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final radii = theme.extension<AppRadius>()!;
    return InkWell(
      onTap: onTap,
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
              if (status != null)
                Positioned(
                  right: spacing.xs,
                  bottom: spacing.xs,
                  child: _StatusPill(status: status!),
                ),
            ],
          ),
          SizedBox(height: spacing.sm),
          Text(
            book.title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: spacing.xs / 2),
          Text(
            book.author,
            style: theme.textTheme.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
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

    // Pill color reflects the state: reading uses Rausch, completed uses a
    // deeper plum (luxe/mastery), paused muted gray, dropped subtle strike.
    final Color background;
    final Color foreground;
    switch (status) {
      case BookStatus.reading:
        background = AppPalette.rausch;
        foreground = AppPalette.pureWhite;
      case BookStatus.completed:
        background = AppPalette.plusMagenta;
        foreground = AppPalette.pureWhite;
      case BookStatus.paused:
        background = AppPalette.secondaryGray;
        foreground = AppPalette.pureWhite;
      case BookStatus.dropped:
        background = AppPalette.borderGray;
        foreground = AppPalette.nearBlack;
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
