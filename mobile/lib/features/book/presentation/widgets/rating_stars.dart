import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

/// 5-star rating selector styled to the Airbnb coral palette.
///
/// [value] is 0..5 (half-stars disabled for simpler validation — backend
/// accepts integers only). Wraps `flutter_rating_bar` so the haptics and
/// gesture semantics stay consistent with what users expect in a mobile app.
class RatingStars extends StatelessWidget {
  const RatingStars({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = 36,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final double size;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return RatingBar.builder(
      initialRating: value.toDouble(),
      minRating: 0,
      maxRating: 5,
      allowHalfRating: false,
      itemCount: 5,
      unratedColor: theme.colorScheme.outline,
      itemSize: size,
      itemPadding: const EdgeInsets.symmetric(horizontal: 2),
      glow: false,
      onRatingUpdate: (double next) => onChanged(next.round()),
      // Active star stays on the theme primary — brand-semantic but theme-aware
      // so dark mode picks up rauschDark without the star vanishing.
      itemBuilder: (context, _) => Icon(
        Icons.star_rounded,
        color: theme.colorScheme.primary,
      ),
    );
  }
}
