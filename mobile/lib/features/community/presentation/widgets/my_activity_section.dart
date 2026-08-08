import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../book/presentation/widgets/book_cover.dart';
import '../../application/community_providers.dart';
import '../../domain/my_activity.dart';

/// "내 활동" dashboard (BC-83) — shown only on the caller's own profile.
///
/// Renders [MyActivitySummary]'s five categories (리뷰·하이라이트·발제문·참여
/// 모임·읽는 중 책) as count header + up to-5-item horizontal preview, each with
/// a "더보기" that pushes the category's dedicated paginated list screen. A
/// tap on any preview card deep-links straight to the underlying book/session/
/// club via the app's existing detail routes.
///
/// Fails quiet on error: this is a secondary profile section, not core
/// identity info, so a transient 5xx here should not block the rest of the
/// profile from rendering.
class MyActivitySection extends ConsumerWidget {
  const MyActivitySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<MyActivitySummary> async = ref.watch(myActivityProvider);
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    return async.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (summary) => Padding(
        padding: EdgeInsets.symmetric(horizontal: spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('내 활동', style: theme.textTheme.titleMedium),
            SizedBox(height: spacing.sm),
            _ActivityCategory(
              label: '리뷰',
              count: summary.counts.reviews,
              emptyLabel: '작성한 리뷰가 없어요',
              onMore: () => context.push(AppRoutes.myActivityReviews),
              itemCount: summary.reviews.length,
              itemBuilder: (context, i) =>
                  _ReviewPreviewCard(item: summary.reviews[i]),
            ),
            _ActivityCategory(
              label: '하이라이트',
              count: summary.counts.highlights,
              emptyLabel: '저장된 하이라이트가 없어요',
              onMore: () => context.push(AppRoutes.myActivityHighlights),
              itemCount: summary.highlights.length,
              itemBuilder: (context, i) =>
                  _HighlightPreviewCard(item: summary.highlights[i]),
            ),
            _ActivityCategory(
              label: '발제문',
              count: summary.counts.agendas,
              emptyLabel: '작성한 발제문이 없어요',
              onMore: () => context.push(AppRoutes.myActivityAgendas),
              itemCount: summary.agendas.length,
              itemBuilder: (context, i) =>
                  _AgendaPreviewCard(item: summary.agendas[i]),
            ),
            _ActivityCategory(
              label: '참여 모임',
              count: summary.counts.clubs,
              emptyLabel: '참여 중인 모임이 없어요',
              onMore: () => context.push(AppRoutes.myActivityClubs),
              itemCount: summary.clubs.length,
              itemBuilder: (context, i) =>
                  _ClubPreviewCard(item: summary.clubs[i]),
            ),
            _ActivityCategory(
              label: '읽는 중',
              count: summary.counts.readingBooks,
              emptyLabel: '읽는 중인 책이 없어요',
              onMore: () => context.push(AppRoutes.libraryTab(1)),
              itemCount: summary.readingBooks.length,
              itemBuilder: (context, i) =>
                  _ReadingBookPreviewCard(item: summary.readingBooks[i]),
            ),
            SizedBox(height: spacing.xs),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared category row — label + count + "더보기" header, horizontal preview
// ---------------------------------------------------------------------------

class _ActivityCategory extends StatelessWidget {
  const _ActivityCategory({
    required this.label,
    required this.count,
    required this.emptyLabel,
    required this.onMore,
    required this.itemCount,
    required this.itemBuilder,
  });

  final String label;
  final int count;
  final String emptyLabel;
  final VoidCallback onMore;
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    return Padding(
      padding: EdgeInsets.only(bottom: spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '$label $count',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton(
                onPressed: onMore,
                child: const Text('더보기'),
              ),
            ],
          ),
          if (itemCount == 0)
            Padding(
              padding: EdgeInsets.symmetric(vertical: spacing.xs),
              child: Text(
                emptyLabel,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            )
          else
            SizedBox(
              height: 132,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: itemCount,
                separatorBuilder: (_, __) => SizedBox(width: spacing.sm),
                itemBuilder: itemBuilder,
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Per-category preview cards
// ---------------------------------------------------------------------------

class _ReviewPreviewCard extends StatelessWidget {
  const _ReviewPreviewCard({required this.item});

  final ActivityReviewItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _PreviewCard(
      onTap: () => context.push(AppRoutes.bookDetail(item.bookId)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BookCover(
            coverUrl: item.bookCoverUrl,
            width: 56,
            height: 78,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          const SizedBox(height: 4),
          Row(
            children: List<Widget>.generate(
              item.rating.round().clamp(0, 5),
              (_) => Icon(
                Icons.star_rounded,
                size: 11,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          Text(
            item.bookTitle ?? '알 수 없는 책',
            style: theme.textTheme.labelSmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _HighlightPreviewCard extends StatelessWidget {
  const _HighlightPreviewCard({required this.item});

  final ActivityHighlightItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _PreviewCard(
      width: 160,
      onTap: () => context.push(AppRoutes.bookDetail(item.bookId)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            CupertinoIcons.quote_bubble,
            size: 14,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Text(
              item.quoteText,
              style: theme.textTheme.bodySmall,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (item.bookTitle != null)
            Text(
              item.bookTitle!,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }
}

class _AgendaPreviewCard extends StatelessWidget {
  const _AgendaPreviewCard({required this.item});

  final ActivityAgendaItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _PreviewCard(
      width: 160,
      onTap: () => context.push(
        AppRoutes.sessionDetail(item.clubId, item.sessionId),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.clubName,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.primary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Text(
              item.sessionTitle,
              style: theme.textTheme.bodySmall,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            item.status == 'published' ? '발행됨' : '초안',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClubPreviewCard extends StatelessWidget {
  const _ClubPreviewCard({required this.item});

  final ActivityClubItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _PreviewCard(
      width: 120,
      onTap: () => context.push(AppRoutes.clubDetail(item.id)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: theme.colorScheme.primaryContainer,
            child: Text(
              item.name.isNotEmpty ? item.name[0] : '?',
              style: TextStyle(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.name,
            style: theme.textTheme.labelSmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _ReadingBookPreviewCard extends StatelessWidget {
  const _ReadingBookPreviewCard({required this.item});

  final ActivityBookItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _PreviewCard(
      onTap: () => context.push(
        AppRoutes.bookDetail(item.bookId),
        extra: item.userBookId,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BookCover(
            coverUrl: item.coverUrl,
            width: 56,
            height: 78,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          const SizedBox(height: 4),
          Text(
            item.title,
            style: theme.textTheme.labelSmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({
    required this.child,
    required this.onTap,
    this.width = 96,
  });

  final Widget child;
  final VoidCallback onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: width,
      child: Material(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: child,
          ),
        ),
      ),
    );
  }
}
