import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/image_uploader.dart';

/// Horizontal scrollable strip of picked-image thumbnails plus a "+ 이미지"
/// chip that triggers the gallery picker. Reaches the cap (4 images) and
/// hides the chip until one is removed.
class ImagePickerRow extends StatelessWidget {
  const ImagePickerRow({
    super.key,
    required this.images,
    required this.onPick,
    required this.onRemove,
    this.maxImages = 4,
  });

  final List<PickedImage> images;
  final VoidCallback onPick;
  final ValueChanged<int> onRemove;
  final int maxImages;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final radii = theme.extension<AppRadius>()!;
    final bool canPick = images.length < maxImages;

    return SizedBox(
      height: 84,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: spacing.lg),
        itemCount: images.length + (canPick ? 1 : 0),
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (canPick && index == images.length) {
            return InkWell(
              borderRadius: BorderRadius.all(Radius.circular(radii.md)),
              onTap: onPick,
              child: Container(
                width: 84,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.all(Radius.circular(radii.md)),
                  border: Border.all(color: theme.colorScheme.outline),
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.add_photo_alternate_outlined,
                      color: theme.colorScheme.onSurface,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '이미지',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          final PickedImage img = images[index];
          return Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(radii.md)),
                child: Image.memory(
                  img.bytes,
                  width: 84,
                  height: 84,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: InkWell(
                  onTap: () => onRemove(index),
                  customBorder: const CircleBorder(),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
