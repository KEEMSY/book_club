import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/post.dart';
import 'image_grid.dart';
import 'post_type_pill.dart';
import 'reaction_bar.dart';

/// Airbnb-toned post card.
///
/// Layout:
///   * Header — avatar · nickname · relative time · type pill
///   * Content — body text
///   * Optional image grid (1..4)
///   * Reaction bar
///   * "댓글 N" text button → opens comments sheet
///
/// Card is rendered inside the `BookFeedSection` as a flat surface
/// (`surfaceContainerLowest`) wrapped in [AppShadows.elevated] so it follows
/// the same elevation language as the listing cards on the library tab.
class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.bookId,
    required this.post,
    required this.onTapComments,
  });

  final String bookId;
  final Post post;
  final VoidCallback onTapComments;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final shadows = theme.extension<AppShadows>()!;
    final radii = theme.extension<AppRadius>()!;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.all(Radius.circular(radii.md)),
        boxShadow: shadows.elevated,
      ),
      padding: EdgeInsets.fromLTRB(
        spacing.md,
        spacing.md,
        spacing.md,
        spacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _Header(post: post),
          SizedBox(height: spacing.sm),
          Text(
            post.content,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface,
              height: 1.5,
            ),
          ),
          if (post.imageUrls.isNotEmpty) ...<Widget>[
            SizedBox(height: spacing.sm),
            ImageGrid(urls: post.imageUrls),
          ],
          SizedBox(height: spacing.sm),
          ReactionBar(bookId: bookId, post: post),
          SizedBox(height: spacing.xs),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: onTapComments,
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.onSurfaceVariant,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              icon: const Icon(
                Icons.mode_comment_outlined,
                size: 16,
              ),
              label: Text('댓글 ${post.commentCount}'),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    return Row(
      children: <Widget>[
        _Avatar(url: post.user.profileImageUrl, name: post.user.nickname),
        SizedBox(width: spacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                post.user.nickname,
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                _relativeTime(post.createdAt),
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
        PostTypePill(type: post.postType, compact: true),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.url, required this.name});

  final String? url;
  final String name;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (url != null && url!.isNotEmpty) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: url!,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          placeholder: (_, __) => _placeholder(theme),
          errorWidget: (_, __, ___) => _placeholder(theme),
        ),
      );
    }
    return _placeholder(theme);
  }

  Widget _placeholder(ThemeData theme) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        shape: BoxShape.circle,
      ),
      child: Text(
        name.isNotEmpty ? name.characters.first : '?',
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

String _relativeTime(DateTime created) {
  final DateTime now = DateTime.now();
  final Duration diff = now.difference(created);
  if (diff.inSeconds < 60) return '방금 전';
  if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
  if (diff.inHours < 24) return '${diff.inHours}시간 전';
  if (diff.inDays < 7) return '${diff.inDays}일 전';
  return '${created.year}.${created.month.toString().padLeft(2, '0')}.${created.day.toString().padLeft(2, '0')}';
}
