import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/book_status.dart';

/// Horizontal segmented control for [BookStatus] tabs.
///
/// Selected tab fills with Rausch (Airbnb singular accent); unselected tabs
/// stay on the Foggy canvas with neutral gray labels. Rounds to pill radius
/// so the control reads as a single stateful capsule rather than four
/// separate buttons.
class StatusSegment extends StatelessWidget {
  const StatusSegment({
    super.key,
    required this.selected,
    required this.onChanged,
    this.statuses = BookStatus.values,
  });

  final BookStatus selected;
  final ValueChanged<BookStatus> onChanged;
  final List<BookStatus> statuses;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radii = theme.extension<AppRadius>()!;
    final spacing = theme.extension<AppSpacing>()!;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: spacing.md),
      child: Row(
        children: <Widget>[
          for (final BookStatus status in statuses) ...<Widget>[
            _Segment(
              status: status,
              selected: status == selected,
              onTap: () => onChanged(status),
              radius: radii.pill,
            ),
            SizedBox(width: spacing.sm),
          ],
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.status,
    required this.selected,
    required this.onTap,
    required this.radius,
  });

  final BookStatus status;
  final bool selected;
  final VoidCallback onTap;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color background =
        selected ? theme.colorScheme.primary : AppPalette.lightSurface;
    final Color foreground =
        selected ? AppPalette.pureWhite : AppPalette.nearBlack;

    return Material(
      color: background,
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            status.label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
