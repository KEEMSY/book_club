import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../application/book_search_notifier.dart';
import '../application/book_search_state.dart';
import '../domain/book.dart';
import 'widgets/book_card.dart';
import 'widgets/empty_states.dart';

/// Full-width Airbnb-style search. Debounce lives inside the notifier so the
/// screen stays declarative; we only own the TextField, the scroll-position
/// listener, and the state → UI branches.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Trigger pagination once we are within 200px of the bottom. Matches the
    // listing-card feel of Airbnb's native infinite scroll.
    if (!_scrollController.hasClients) {
      return;
    }
    final double remaining = _scrollController.position.maxScrollExtent -
        _scrollController.position.pixels;
    if (remaining < 200) {
      ref.read(bookSearchNotifierProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final BookSearchState state = ref.watch(bookSearchNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('책 검색', style: theme.textTheme.titleLarge),
        toolbarHeight: 56,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(
              spacing.md,
              spacing.sm,
              spacing.md,
              spacing.sm,
            ),
            child: _SearchField(
              controller: _controller,
              onChanged: (value) => ref
                  .read(bookSearchNotifierProvider.notifier)
                  .queryChanged(value),
            ),
          ),
          Expanded(child: _Body(state: state, scroll: _scrollController)),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: '제목, 저자, ISBN 으로 검색',
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: controller.text.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () {
                  controller.clear();
                  onChanged('');
                },
                tooltip: '지우기',
              ),
        filled: true,
        fillColor: AppPalette.lightSurface,
      ),
      style: theme.textTheme.bodyLarge?.copyWith(
        color: theme.colorScheme.onSurface,
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.state, required this.scroll});

  final BookSearchState state;
  final ScrollController scroll;

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case BookSearchIdle():
        return const BookEmptyState(
          icon: Icons.search_rounded,
          title: '읽고 싶은 책을 검색해보세요',
          subtitle: '제목이나 저자를 입력하면 바로 찾아드려요.',
        );
      case BookSearchLoading():
        return const Center(child: CircularProgressIndicator());
      case BookSearchError(:final String code, :final String message):
        return _ErrorView(code: code, message: message);
      case BookSearchLoaded(
          :final List<Book> items,
          :final bool hasMore,
          :final bool isLoadingMore,
        ):
        if (items.isEmpty) {
          return const BookEmptyState(
            icon: Icons.menu_book_outlined,
            title: '검색 결과가 없어요',
            subtitle: '다른 키워드로 다시 시도해보세요.',
          );
        }
        return _ResultList(
          items: items,
          hasMore: hasMore,
          isLoadingMore: isLoadingMore,
          scroll: scroll,
        );
    }
  }
}

class _ResultList extends StatelessWidget {
  const _ResultList({
    required this.items,
    required this.hasMore,
    required this.isLoadingMore,
    required this.scroll,
  });

  final List<Book> items;
  final bool hasMore;
  final bool isLoadingMore;
  final ScrollController scroll;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final int childCount = items.length + ((hasMore || isLoadingMore) ? 1 : 0);

    return ListView.separated(
      controller: scroll,
      padding: EdgeInsets.symmetric(vertical: spacing.sm),
      itemCount: childCount,
      separatorBuilder: (_, __) => const Divider(height: 0.5),
      itemBuilder: (context, index) {
        if (index >= items.length) {
          return const _PaginationSpinner();
        }
        final Book book = items[index];
        return BookCard(
          book: book,
          onTap: () => context.push('/books/${book.id}'),
        );
      },
    );
  }
}

class _PaginationSpinner extends StatelessWidget {
  const _PaginationSpinner();

  @override
  Widget build(BuildContext context) {
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
}

class _ErrorView extends ConsumerWidget {
  const _ErrorView({required this.code, required this.message});

  final String code;
  final String message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    // 502 maps to UPSTREAM_UNAVAILABLE → a gentler "잠시 후 다시 시도" prompt.
    final String primary =
        code == 'UPSTREAM_UNAVAILABLE' ? '잠시 후 다시 시도해주세요' : '검색 중 오류가 발생했어요';
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing.xl),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.cloud_off_rounded, size: 48),
            SizedBox(height: spacing.md),
            Text(primary, style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: spacing.xs),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppPalette.secondaryGray,
                  ),
            ),
            SizedBox(height: spacing.lg),
            FilledButton(
              onPressed: () =>
                  ref.read(bookSearchNotifierProvider.notifier).retry(),
              child: const Text('다시 시도'),
            ),
          ],
        ),
      ),
    );
  }
}
