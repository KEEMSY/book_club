import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../application/highlight_providers.dart';
import '../domain/highlight_explore.dart';

/// Browse publicly shared highlights, sorted by recency or popularity (M51).
class HighlightExploreScreen extends ConsumerStatefulWidget {
  const HighlightExploreScreen({super.key});

  @override
  ConsumerState<HighlightExploreScreen> createState() =>
      _HighlightExploreScreenState();
}

class _HighlightExploreScreenState
    extends ConsumerState<HighlightExploreScreen> {
  String _sort = 'recent';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final AsyncValue<List<HighlightExplore>> async =
        ref.watch(exploreHighlightsProvider(sort: _sort));

    return Scaffold(
      appBar: AppBar(title: const Text('하이라이트 탐색')),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(spacing.md),
            child: SegmentedButton<String>(
              segments: const <ButtonSegment<String>>[
                ButtonSegment<String>(value: 'recent', label: Text('최신순')),
                ButtonSegment<String>(value: 'top', label: Text('인기순')),
              ],
              selected: <String>{_sort},
              onSelectionChanged: (Set<String> selection) {
                setState(() => _sort = selection.first);
              },
            ),
          ),
          Expanded(
            child: async.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (Object err, _) => _ErrorState(
                onRetry: () =>
                    ref.invalidate(exploreHighlightsProvider(sort: _sort)),
              ),
              data: (List<HighlightExplore> items) {
                if (items.isEmpty) return const _EmptyState();
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(exploreHighlightsProvider(sort: _sort));
                    await ref
                        .read(exploreHighlightsProvider(sort: _sort).future);
                  },
                  child: ListView.separated(
                    padding: EdgeInsets.fromLTRB(
                        spacing.md, 0, spacing.md, spacing.lg),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => SizedBox(height: spacing.sm),
                    itemBuilder: (_, int index) =>
                        _HighlightExploreCard(highlight: items[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HighlightExploreCard extends StatelessWidget {
  const _HighlightExploreCard({required this.highlight});

  final HighlightExplore highlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radii = theme.extension<AppRadius>()!;
    final spacing = theme.extension<AppSpacing>()!;

    return Container(
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.all(Radius.circular(radii.md)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _Cover(url: highlight.bookCoverUrl),
          SizedBox(width: spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  highlight.quoteText,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                    height: 1.55,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: spacing.sm),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        _subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    SizedBox(width: spacing.xs),
                    Icon(
                      Icons.favorite_rounded,
                      size: 13,
                      color: theme.colorScheme.primary.withValues(alpha: 0.7),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '${highlight.reactionCount}',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String get _subtitle {
    final int? page = highlight.page;
    if (page != null) return '${highlight.bookTitle} · p.$page';
    return highlight.bookTitle;
  }
}

class _Cover extends StatelessWidget {
  const _Cover({this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final placeholder = Container(
      width: 40,
      height: 55,
      color: theme.colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.menu_book_rounded,
        size: 18,
        color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: (url == null || url!.isEmpty)
          ? placeholder
          : CachedNetworkImage(
              imageUrl: url!,
              width: 40,
              height: 55,
              fit: BoxFit.cover,
              placeholder: (_, __) => placeholder,
              errorWidget: (_, __, ___) => placeholder,
            ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      children: <Widget>[
        SizedBox(height: MediaQuery.sizeOf(context).height * 0.3),
        Icon(
          Icons.auto_stories_outlined,
          size: 48,
          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            '아직 공개된 하이라이트가 없어요',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('하이라이트를 불러오지 못했어요'),
          const SizedBox(height: 8),
          FilledButton.tonal(onPressed: onRetry, child: const Text('다시 시도')),
        ],
      ),
    );
  }
}
