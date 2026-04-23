import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Book cover thumbnail rendered at the canonical 2:3 aspect ratio.
///
/// Falls back to a Rausch-tinted placeholder with a book glyph when the
/// upstream catalog returns no cover URL — Naver/Kakao routinely omit
/// covers for indie publishers, so a graceful default keeps the list tidy.
class BookCover extends StatelessWidget {
  const BookCover({
    super.key,
    required this.coverUrl,
    this.width,
    this.height,
    this.borderRadius,
    this.fit = BoxFit.cover,
  });

  final String? coverUrl;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radii = theme.extension<AppRadius>()!;
    final BorderRadius radius =
        borderRadius ?? BorderRadius.all(Radius.circular(radii.sm));

    final Widget child = AspectRatio(
      aspectRatio: 2 / 3,
      child: _buildContent(theme),
    );

    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: radius,
        child: child,
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    // Brand-tinted placeholder — derive from the theme primary so it picks up
    // rauschDark automatically in dark mode instead of washing out on #161616.
    final Color placeholderBackground =
        theme.colorScheme.primary.withValues(alpha: 0.10);
    final Color placeholderIcon =
        theme.colorScheme.primary.withValues(alpha: 0.55);

    if (coverUrl == null || coverUrl!.isEmpty) {
      return _placeholder(placeholderBackground, placeholderIcon);
    }
    return CachedNetworkImage(
      imageUrl: coverUrl!,
      fit: fit,
      placeholder: (_, __) =>
          _placeholder(placeholderBackground, placeholderIcon),
      errorWidget: (_, __, ___) =>
          _placeholder(placeholderBackground, placeholderIcon),
    );
  }

  Widget _placeholder(Color background, Color icon) {
    return Container(
      color: background,
      alignment: Alignment.center,
      child: Icon(
        Icons.menu_book_rounded,
        size: 28,
        color: icon,
      ),
    );
  }
}
