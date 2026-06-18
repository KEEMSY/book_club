import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/highlight_models.dart';

/// Card rendering a single highlight in the feed (M51).
///
/// Uses the theme's surfaceContainerLow instead of sampling the cover's
/// dominant color so we avoid the per-image decode/quantize cost on scroll.
class HighlightFeedCard extends StatelessWidget {
  const HighlightFeedCard({super.key, required this.highlight, this.onTap});

  final HighlightDto highlight;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radii = theme.extension<AppRadius>()!;
    final spacing = theme.extension<AppSpacing>()!;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.all(Radius.circular(radii.md)),
      child: Container(
        padding: EdgeInsets.all(spacing.md),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.all(Radius.circular(radii.md)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _Cover(url: highlight.bookCoverUrl),
            SizedBox(width: spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    highlight.quoteText,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                      height: 1.55,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: spacing.sm),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          _subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      SizedBox(width: spacing.xs),
                      Icon(
                        _visibilityIcon(highlight.visibility),
                        size: 14,
                        color: theme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.7),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get _subtitle {
    final int? page = highlight.page;
    if (page != null) return '${highlight.bookTitle} · p.$page';
    return highlight.bookTitle;
  }
}

/// Fixed 40×55 cover thumbnail with a neutral placeholder fallback.
class _Cover extends StatelessWidget {
  const _Cover({this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final placeholder = Container(
      width: 40,
      height: 55,
      color: theme.colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.menu_book_rounded,
        size: 18,
        color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: (url == null || url!.isEmpty)
          ? placeholder
          : CachedNetworkImage(
              imageUrl: url!,
              width: 40,
              height: 55,
              fit: BoxFit.cover,
              placeholder: (_, __) => placeholder,
              errorWidget: (_, __, ___) => placeholder,
            ),
    );
  }
}

IconData _visibilityIcon(HighlightVisibility visibility) {
  switch (visibility) {
    case HighlightVisibility.private:
      return Icons.lock_outline_rounded;
    case HighlightVisibility.followers:
      return Icons.group_outlined;
    case HighlightVisibility.public:
      return Icons.public_rounded;
  }
}
