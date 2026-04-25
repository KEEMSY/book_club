import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/post_type.dart';

/// Small pill that labels a post by its type.
///
/// Tint mapping (theme-adaptive):
///   * highlight  → primary  (Rausch — brand-locked because hi-light is the
///                            tier closest to the act of "marking" and
///                            deserves the editorial accent)
///   * thought    → secondary (neutral chip surface)
///   * question   → outlineVariant (muted neutral; questions are open-ended)
///   * discussion → tertiary  (plus-magenta — editorial "starting point")
class PostTypePill extends StatelessWidget {
  const PostTypePill({super.key, required this.type, this.compact = false});

  final PostType type;
  final bool compact;

  IconData get _icon {
    switch (type) {
      case PostType.highlight:
        return Icons.bookmark_outline_rounded;
      case PostType.thought:
        return Icons.chat_bubble_outline_rounded;
      case PostType.question:
        return Icons.help_outline_rounded;
      case PostType.discussion:
        return Icons.forum_outlined;
    }
  }

  ({Color background, Color foreground}) _palette(ThemeData theme) {
    switch (type) {
      case PostType.highlight:
        return (
          background: theme.colorScheme.primary.withValues(alpha: 0.12),
          foreground: theme.colorScheme.primary,
        );
      case PostType.thought:
        return (
          background: theme.colorScheme.surfaceContainerHigh,
          foreground: theme.colorScheme.onSurface,
        );
      case PostType.question:
        return (
          background: theme.colorScheme.outlineVariant,
          foreground: theme.colorScheme.onSurface,
        );
      case PostType.discussion:
        return (
          background: theme.colorScheme.tertiary.withValues(alpha: 0.14),
          foreground: theme.colorScheme.tertiary,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radii = theme.extension<AppRadius>()!;
    final palette = _palette(theme);
    final double horizontal = compact ? 8 : 10;
    final double vertical = compact ? 3 : 5;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      decoration: BoxDecoration(
        color: palette.background,
        borderRadius: BorderRadius.all(Radius.circular(radii.pill)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(_icon, size: compact ? 12 : 14, color: palette.foreground),
          SizedBox(width: compact ? 4 : 6),
          Text(
            type.koreanLabel,
            style: theme.textTheme.labelMedium?.copyWith(
              color: palette.foreground,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
