import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/post.dart';
import '../../domain/post_type.dart';
import '../../domain/reaction_type.dart';
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
    this.onTapAuthor,
    this.onReactionApplied,
  });

  final String bookId;
  final Post post;
  final VoidCallback onTapComments;
  /// If provided, tapping the author avatar/nickname navigates to their profile.
  final void Function(String userId)? onTapAuthor;
  /// If provided, reaction toggles update the caller's list; otherwise falls
  /// back to BookFeedNotifier (book feed context).
  final void Function(
    String postId,
    ReactionType type,
    ReactionToggleState toggleState,
    Map<ReactionType, int> counts,
  )? onReactionApplied;

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
          _Header(post: post, onTapAuthor: onTapAuthor),
          SizedBox(height: spacing.sm),
          if (post.postType == PostType.highlight)
            _HighlightBody(
              content: post.content,
              bookId: post.bookId,
              bookTitle: post.bookTitle,
              bookCoverUrl: post.bookCoverUrl,
            )
          else
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
          ReactionBar(bookId: bookId, post: post, onApplied: onReactionApplied),
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
  const _Header({required this.post, this.onTapAuthor});

  final Post post;
  final void Function(String userId)? onTapAuthor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final row = Row(
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
    if (onTapAuthor == null) return row;
    return GestureDetector(
      onTap: () => onTapAuthor!(post.user.id),
      behavior: HitTestBehavior.opaque,
      child: row,
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

class _HighlightBody extends StatelessWidget {
  const _HighlightBody({
    required this.content,
    required this.bookId,
    this.bookTitle,
    this.bookCoverUrl,
  });

  final String content;
  final String bookId;
  final String? bookTitle;
  final String? bookCoverUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radii = theme.extension<AppRadius>()!;
    final spacing = theme.extension<AppSpacing>()!;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        border: Border(
          left: BorderSide(color: theme.colorScheme.primary, width: 3),
        ),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(radii.sm),
          bottomRight: Radius.circular(radii.sm),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (bookTitle != null)
            InkWell(
              onTap: () => context.push(AppRoutes.bookDetail(bookId)),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(radii.sm),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(12, spacing.sm, 12, spacing.xs),
                child: Row(
                  children: <Widget>[
                    if (bookCoverUrl != null && bookCoverUrl!.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: CachedNetworkImage(
                          imageUrl: bookCoverUrl!,
                          width: 28,
                          height: 40,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => const SizedBox(
                            width: 28,
                            height: 40,
                          ),
                        ),
                      ),
                    if (bookCoverUrl != null && bookCoverUrl!.isNotEmpty)
                      SizedBox(width: spacing.sm),
                    Expanded(
                      child: Text(
                        bookTitle!,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                    ),
                  ],
                ),
              ),
            ),
          if (bookTitle != null)
            Divider(
              height: 1,
              thickness: 1,
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
              indent: 12,
              endIndent: 12,
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: Text(
              '"$content"',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontStyle: FontStyle.italic,
                color: theme.colorScheme.onSurface,
                height: 1.6,
              ),
            ),
          ),
        ],
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
