import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/comment.dart';

/// Single comment row. Used both for root comments and replies — the parent
/// sheet wraps replies in an indented container so the same widget renders
/// equivalently in both contexts.
///
/// `isReply` switches off the "답글" affordance because the backend rejects
/// 2-level nesting (`COMMENT_DEPTH_EXCEEDED`).
class CommentTile extends StatelessWidget {
  const CommentTile({
    super.key,
    required this.comment,
    required this.isReply,
    this.canDelete = false,
    this.onReply,
    this.onDelete,
  });

  final Comment comment;
  final bool isReply;
  final bool canDelete;
  final VoidCallback? onReply;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _Avatar(
            url: comment.user.profileImageUrl,
            name: comment.user.nickname,
          ),
          SizedBox(width: spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        comment.user.nickname,
                        style: theme.textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: spacing.xs),
                    Text(
                      _relativeTime(comment.createdAt),
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
                SizedBox(height: spacing.xs),
                Text(
                  comment.content,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.45),
                ),
                SizedBox(height: spacing.xs),
                Row(
                  children: <Widget>[
                    if (!isReply && onReply != null)
                      _ActionText(label: '답글', onTap: onReply!),
                    if (canDelete && onDelete != null) ...<Widget>[
                      if (!isReply && onReply != null)
                        SizedBox(width: spacing.md),
                      _ActionText(
                        label: '삭제',
                        onTap: onDelete!,
                        tone: theme.colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
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
          width: 36,
          height: 36,
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
      width: 36,
      height: 36,
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

class _ActionText extends StatelessWidget {
  const _ActionText({required this.label, required this.onTap, this.tone});

  final String label;
  final VoidCallback onTap;
  final Color? tone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: tone ?? theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
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
