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

    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: radius,
        child: AspectRatio(
          aspectRatio: 2 / 3,
          child: _buildContent(theme),
        ),
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    final Color bg = theme.colorScheme.primary.withValues(alpha: 0.10);
    final Color ic = theme.colorScheme.primary.withValues(alpha: 0.55);

    if (coverUrl == null || coverUrl!.isEmpty) {
      return _placeholder(bg, ic);
    }

    return Image.network(
      coverUrl!,
      fit: fit,
      loadingBuilder: (_, child, progress) =>
          progress == null ? child : _shimmer(bg),
      errorBuilder: (_, __, ___) => _placeholder(bg, ic),
    );
  }

  Widget _placeholder(Color background, Color icon) {
    return Container(
      color: background,
      alignment: Alignment.center,
      child: Icon(Icons.menu_book_rounded, size: 28, color: icon),
    );
  }

  Widget _shimmer(Color color) {
    return Container(color: color);
  }
}
