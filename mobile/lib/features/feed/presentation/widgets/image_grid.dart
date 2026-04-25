import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// Renders 1..4 image URLs in a layout that mirrors common social-feed
/// conventions:
///
///   1 image  — full-width 16:9 frame.
///   2 images — two-column row.
///   3 images — first image full-height, two stacked on the right.
///   4 images — 2×2 grid.
class ImageGrid extends StatelessWidget {
  const ImageGrid({super.key, required this.urls, this.maxHeight = 240});

  final List<String> urls;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    final radii = Theme.of(context).extension<AppRadius>()!;
    final BorderRadius radius = BorderRadius.all(Radius.circular(radii.md));

    if (urls.isEmpty) return const SizedBox.shrink();

    if (urls.length == 1) {
      return ClipRRect(
        borderRadius: radius,
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: _CachedTile(url: urls.first),
        ),
      );
    }

    if (urls.length == 2) {
      return ClipRRect(
        borderRadius: radius,
        child: SizedBox(
          height: maxHeight,
          child: Row(
            children: <Widget>[
              Expanded(child: _CachedTile(url: urls[0])),
              const SizedBox(width: 2),
              Expanded(child: _CachedTile(url: urls[1])),
            ],
          ),
        ),
      );
    }

    if (urls.length == 3) {
      return ClipRRect(
        borderRadius: radius,
        child: SizedBox(
          height: maxHeight,
          child: Row(
            children: <Widget>[
              Expanded(child: _CachedTile(url: urls[0])),
              const SizedBox(width: 2),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Expanded(child: _CachedTile(url: urls[1])),
                    const SizedBox(height: 2),
                    Expanded(child: _CachedTile(url: urls[2])),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: radius,
      child: SizedBox(
        height: maxHeight,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(child: _CachedTile(url: urls[0])),
                  const SizedBox(width: 2),
                  Expanded(child: _CachedTile(url: urls[1])),
                ],
              ),
            ),
            const SizedBox(height: 2),
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(child: _CachedTile(url: urls[2])),
                  const SizedBox(width: 2),
                  Expanded(child: _CachedTile(url: urls[3])),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CachedTile extends StatelessWidget {
  const _CachedTile({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (_, __) =>
          Container(color: theme.colorScheme.surfaceContainerHigh),
      errorWidget: (_, __, ___) => Container(
        color: theme.colorScheme.surfaceContainerHigh,
        alignment: Alignment.center,
        child: Icon(
          Icons.image_outlined,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
