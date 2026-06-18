import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../auth/application/auth_notifier.dart';
import '../../../auth/domain/auth_state.dart';
import '../../../reading/application/reading_providers.dart';
import '../../application/review_providers.dart';
import '../../data/book_repository.dart' show BookRepositoryException;
import '../../data/review_models.dart';
import 'write_review_sheet.dart';

/// Book-detail review section (M54): average rating, distribution bars, the
/// latest reviews, and a write / edit entry point.
///
/// [canWrite] gates the primary CTA on completion — the caller passes `true`
/// only when the user has finished the book. Once a review exists the CTA
/// switches to "내 리뷰 수정" regardless of [canWrite].
class ReviewSection extends ConsumerWidget {
  const ReviewSection({
    super.key,
    required this.bookId,
    this.bookTitle,
    this.canWrite = false,
  });

  final String bookId;
  final String? bookTitle;
  final bool canWrite;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final AsyncValue<BookReviewSummaryDto> async =
        ref.watch(bookReviewSummaryProvider(bookId));

    return async.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => Padding(
        padding: EdgeInsets.symmetric(vertical: spacing.md),
        child: Text(
          '리뷰를 불러오지 못했어요.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
      data: (BookReviewSummaryDto summary) {
        final String? myUserId = _currentUserId(ref);
        ReviewDto? myReview;
        for (final ReviewDto r in summary.reviews) {
          if (myUserId != null && r.userId == myUserId) {
            myReview = r;
            break;
          }
        }
        final List<ReviewDto> others = summary.reviews
            .where((ReviewDto r) => r.userId != myUserId)
            .take(5)
            .toList(growable: false);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _SummaryHeader(summary: summary),
            SizedBox(height: spacing.lg),
            _DistributionBars(summary: summary),
            SizedBox(height: spacing.lg),
            _WriteCta(
              bookId: bookId,
              bookTitle: bookTitle,
              canWrite: canWrite,
              myReview: myReview,
            ),
            SizedBox(height: spacing.xl),
            Text('최신 리뷰', style: theme.textTheme.titleMedium),
            SizedBox(height: spacing.md),
            if (others.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: spacing.md),
                child: Text(
                  '아직 다른 독자의 리뷰가 없어요.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              )
            else
              ...others.map(
                (ReviewDto r) => _ReviewCard(bookId: bookId, review: r),
              ),
          ],
        );
      },
    );
  }

  String? _currentUserId(WidgetRef ref) {
    final AuthState auth = ref.watch(authNotifierProvider);
    return switch (auth) {
      Authenticated(:final user) => user.id,
      _ => null,
    };
  }
}

class _SummaryHeader extends ConsumerWidget {
  const _SummaryHeader({required this.summary});

  final BookReviewSummaryDto summary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final Color accent = ref.watch(gradePrimaryProvider);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          summary.averageRating.toStringAsFixed(1),
          style: theme.textTheme.displaySmall,
        ),
        SizedBox(width: spacing.md),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DisplayStars(
              rating: summary.averageRating,
              size: 18,
              color: accent,
            ),
            const SizedBox(height: 4),
            Text(
              '리뷰 ${summary.ratingCount}개',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DistributionBars extends StatelessWidget {
  const _DistributionBars({required this.summary});

  final BookReviewSummaryDto summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final int total = summary.ratingCount;
    return Column(
      children: <Widget>[
        for (int star = 5; star >= 1; star--)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 28,
                  child: Text(
                    '$star점',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: total == 0
                          ? 0
                          : (summary.distribution['$star'] ?? 0) / total,
                      minHeight: 8,
                      backgroundColor: theme.colorScheme.surfaceContainerHigh,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 32,
                  child: Text(
                    '${summary.distribution['$star'] ?? 0}',
                    textAlign: TextAlign.end,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _WriteCta extends ConsumerWidget {
  const _WriteCta({
    required this.bookId,
    required this.bookTitle,
    required this.canWrite,
    required this.myReview,
  });

  final String bookId;
  final String? bookTitle;
  final bool canWrite;
  final ReviewDto? myReview;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final ReviewDto? mine = myReview;

    if (mine != null) {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () => WriteReviewSheet.show(
            context,
            bookId: bookId,
            bookTitle: bookTitle,
            initialRating: mine.rating,
            initialBody: mine.body,
            isEdit: true,
          ),
          icon: const Icon(Icons.edit_outlined, size: 18),
          label: const Text('내 리뷰 수정'),
        ),
      );
    }

    if (!canWrite) {
      return Text(
        '완독 후 리뷰를 남길 수 있어요.',
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: () => WriteReviewSheet.show(
          context,
          bookId: bookId,
          bookTitle: bookTitle,
        ),
        icon: const Icon(Icons.rate_review_outlined, size: 18),
        label: const Text('리뷰 쓰기'),
      ),
    );
  }
}

class _ReviewCard extends ConsumerWidget {
  const _ReviewCard({required this.bookId, required this.review});

  final String bookId;
  final ReviewDto review;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final radii = theme.extension<AppRadius>()!;
    final String nickname = (review.authorNickname?.isNotEmpty ?? false)
        ? review.authorNickname!
        : '익명 독자';

    return Container(
      margin: EdgeInsets.only(bottom: spacing.sm),
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.all(Radius.circular(radii.md)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 16,
                backgroundColor: theme.colorScheme.secondaryContainer,
                backgroundImage: review.authorProfileImageUrl != null
                    ? CachedNetworkImageProvider(review.authorProfileImageUrl!)
                    : null,
                child: review.authorProfileImageUrl == null
                    ? Text(
                        nickname[0],
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSecondaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : null,
              ),
              SizedBox(width: spacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      nickname,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    DisplayStars(rating: review.rating, size: 13),
                  ],
                ),
              ),
              _ReportButton(bookId: bookId, reviewId: review.id),
            ],
          ),
          if (review.body != null && review.body!.isNotEmpty) ...<Widget>[
            SizedBox(height: spacing.sm),
            Text(
              review.body!,
              style: theme.textTheme.bodySmall?.copyWith(height: 1.5),
            ),
          ],
        ],
      ),
    );
  }
}

class _ReportButton extends ConsumerWidget {
  const _ReportButton({required this.bookId, required this.reviewId});

  final String bookId;
  final String reviewId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return IconButton(
      icon: const Icon(Icons.flag_outlined, size: 16),
      color: theme.colorScheme.onSurfaceVariant,
      tooltip: '신고',
      onPressed: () => _report(context, ref),
    );
  }

  Future<void> _report(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(reviewRepositoryProvider).report(bookId, reviewId);
      messenger.showSnackBar(
        const SnackBar(content: Text('신고가 접수되었어요')),
      );
    } on BookRepositoryException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    }
  }
}

/// Read-only star row supporting half-step display for a [rating] in 0..5.
class DisplayStars extends StatelessWidget {
  const DisplayStars({
    super.key,
    required this.rating,
    this.size = 16,
    this.color,
  });

  final double rating;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color filled = color ?? theme.colorScheme.primary;
    return Semantics(
      label: '5점 만점에 ${rating.toStringAsFixed(1)}점',
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List<Widget>.generate(5, (int i) {
          final int starValue = i + 1;
          final IconData icon;
          if (rating >= starValue) {
            icon = Icons.star_rounded;
          } else if (rating >= starValue - 0.5) {
            icon = Icons.star_half_rounded;
          } else {
            icon = Icons.star_outline_rounded;
          }
          return Icon(
            icon,
            size: size,
            color:
                rating >= starValue - 0.5 ? filled : theme.colorScheme.outline,
          );
        }),
      ),
    );
  }
}
