import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../book/application/my_reviews_notifier.dart';
import '../../book/data/review_models.dart';

/// "내 활동 > 내 리뷰" 더보기 (BC-83) — `GET /me/reviews`, 최신순 오프셋 페이지네이션.
///
/// Each row deep-links to the reviewed book's detail screen ([AppRoutes.
/// bookDetail]) — there is no standalone review-detail route in this app.
class MyReviewsScreen extends ConsumerStatefulWidget {
  const MyReviewsScreen({super.key});

  @override
  ConsumerState<MyReviewsScreen> createState() => _MyReviewsScreenState();
}

class _MyReviewsScreenState extends ConsumerState<MyReviewsScreen> {
  final ScrollController _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(myReviewsNotifierProvider.notifier).fetchFirst(),
    );
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll.removeListener(_onScroll);
    _scroll.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;
    if (_scroll.position.maxScrollExtent - _scroll.position.pixels < 200) {
      ref.read(myReviewsNotifierProvider.notifier).fetchMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final MyReviewsState state = ref.watch(myReviewsNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: Text('내 리뷰 (${state.total})')),
      body: _buildBody(context, theme, spacing, state),
    );
  }

  Widget _buildBody(
    BuildContext context,
    ThemeData theme,
    AppSpacing spacing,
    MyReviewsState state,
  ) {
    if (state.isLoading && state.items.isEmpty) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }
    if (state.error != null && state.items.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(spacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('리뷰를 불러오지 못했어요', style: theme.textTheme.bodyMedium),
              SizedBox(height: spacing.sm),
              FilledButton(
                onPressed: () =>
                    ref.read(myReviewsNotifierProvider.notifier).fetchFirst(),
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
      );
    }
    if (state.items.isEmpty) {
      return Center(
        child: Text(
          '작성한 리뷰가 없어요',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      );
    }
    return ListView.separated(
      controller: _scroll,
      padding: EdgeInsets.all(spacing.lg),
      itemCount: state.items.length + (state.hasMore ? 1 : 0),
      separatorBuilder: (_, __) => SizedBox(height: spacing.sm),
      itemBuilder: (context, index) {
        if (index == state.items.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }
        return _MyReviewCard(item: state.items[index]);
      },
    );
  }
}

class _MyReviewCard extends StatelessWidget {
  const _MyReviewCard({required this.item});

  final MyReviewItemDto item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    return Material(
      color: theme.colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push(AppRoutes.bookDetail(item.bookId)),
        child: Padding(
          padding: EdgeInsets.all(spacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.bookTitle ?? '알 수 없는 책',
                style: theme.textTheme.titleSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: spacing.xs),
              Row(
                children: List<Widget>.generate(
                  item.rating.round().clamp(0, 5),
                  (_) => Icon(
                    Icons.star_rounded,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              if (item.body != null && item.body!.isNotEmpty) ...[
                SizedBox(height: spacing.xs),
                Text(
                  item.body!,
                  style: theme.textTheme.bodySmall,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
