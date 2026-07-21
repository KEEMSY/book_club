import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../application/search_providers.dart';
import '../domain/search_result.dart';

/// Unified search screen that searches books, users, and clubs simultaneously.
///
/// Debounces keyboard input by 300 ms before firing the provider so we avoid
/// hammering the API on every keystroke. Results are split across three tabs —
/// 책, 사용자, 클럽 — each backed by the same [searchResultsProvider].
class UnifiedSearchScreen extends ConsumerStatefulWidget {
  const UnifiedSearchScreen({super.key});

  @override
  ConsumerState<UnifiedSearchScreen> createState() =>
      _UnifiedSearchScreenState();
}

class _UnifiedSearchScreenState extends ConsumerState<UnifiedSearchScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late final TabController _tabController;

  // Reflects the debounced query that is actually sent to the provider.
  String _debouncedQuery = '';
  Timer? _debounceTimer;
  // Hidden once the user commits a query (taps a suggestion or submits) so the
  // dropdown does not linger over the results.
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    _debounceTimer?.cancel();
    setState(() => _showSuggestions = value.trim().isNotEmpty);
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() => _debouncedQuery = value);
      }
    });
  }

  void _onSubmitted(String _) {
    setState(() => _showSuggestions = false);
  }

  void _onSuggestionSelected(String suggestion) {
    _debounceTimer?.cancel();
    _controller.text = suggestion;
    _controller.selection = TextSelection.collapsed(offset: suggestion.length);
    setState(() {
      _debouncedQuery = suggestion;
      _showSuggestions = false;
    });
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text('통합 검색', style: theme.textTheme.titleLarge),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '책'),
            Tab(text: '사용자'),
            Tab(text: '클럽'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              spacing.md,
              spacing.sm,
              spacing.md,
              spacing.sm,
            ),
            child: _SearchField(
              controller: _controller,
              onChanged: _onQueryChanged,
              onSubmitted: _onSubmitted,
            ),
          ),
          if (_showSuggestions && _debouncedQuery.trim().length >= 2)
            _AutocompleteDropdown(
              query: _debouncedQuery,
              onSelected: _onSuggestionSelected,
            ),
          Expanded(
            child: _ResultView(
              query: _debouncedQuery,
              tabController: _tabController,
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.onChanged,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      autofocus: true,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: '책, 사용자, 클럽 검색',
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
        fillColor: theme.colorScheme.surfaceContainerHigh,
      ),
    );
  }
}

/// M69 — trigram autocomplete suggestions shown below the search field.
///
/// Renders up to 5 title/author suggestions. Stays silent (zero height) while
/// loading, on error, or when there are no matches, so it never pushes the
/// results down for an empty list.
class _AutocompleteDropdown extends ConsumerWidget {
  const _AutocompleteDropdown({
    required this.query,
    required this.onSelected,
  });

  final String query;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final async = ref.watch(autocompleteSuggestionsProvider(query: query));
    final suggestions = async.valueOrNull ?? const <String>[];
    if (suggestions.isEmpty) return const SizedBox.shrink();

    return Material(
      color: theme.colorScheme.surfaceContainerHigh,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final suggestion in suggestions)
            ListTile(
              dense: true,
              leading: Icon(
                Icons.north_west_rounded,
                size: 18,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              title: Text(
                suggestion,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () => onSelected(suggestion),
            ),
          const Divider(height: 0.5),
        ],
      ),
    );
  }
}

class _ResultView extends ConsumerWidget {
  const _ResultView({
    required this.query,
    required this.tabController,
  });

  final String query;
  final TabController tabController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Show empty state before the user starts typing.
    if (query.trim().isEmpty) {
      return const _EmptyPrompt();
    }

    final async = ref.watch(
      searchResultsProvider(query: query),
    );

    return switch (async) {
      AsyncLoading() =>
        const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      AsyncError(:final error) => _ErrorView(error: error.toString()),
      AsyncData(:final value) when value == null => const _EmptyPrompt(),
      AsyncData(:final value) => _TabResults(
          result: value!,
          tabController: tabController,
        ),
      _ => const SizedBox.shrink(),
    };
  }
}

class _TabResults extends StatelessWidget {
  const _TabResults({required this.result, required this.tabController});

  final SearchResult result;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: [
        _BookList(books: result.books),
        _UserList(users: result.users),
        _ClubList(clubs: result.clubs),
      ],
    );
  }
}

// ── Book tab ──────────────────────────────────────────────────────────────────

class _BookList extends StatelessWidget {
  const _BookList({required this.books});

  final List<BookSearchItem> books;

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) {
      return const _EmptyResult(message: '검색 결과가 없어요');
    }
    return ListView.separated(
      itemCount: books.length,
      separatorBuilder: (_, __) => const Divider(height: 0.5),
      itemBuilder: (context, index) => _BookTile(book: books[index]),
    );
  }
}

class _BookTile extends StatelessWidget {
  const _BookTile({required this.book});

  final BookSearchItem book;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: spacing.md,
        vertical: spacing.xs,
      ),
      leading: book.thumbnailUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                book.thumbnailUrl!,
                width: 40,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const _BookPlaceholder(),
              ),
            )
          : const _BookPlaceholder(),
      title: Text(book.title, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        book.author,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      onTap: () => context.push(AppRoutes.bookDetail(book.id)),
    );
  }
}

class _BookPlaceholder extends StatelessWidget {
  const _BookPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 56,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Icon(Icons.book_outlined, size: 20),
    );
  }
}

// ── User tab ──────────────────────────────────────────────────────────────────

class _UserList extends StatelessWidget {
  const _UserList({required this.users});

  final List<UserSearchItem> users;

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return const _EmptyResult(message: '검색 결과가 없어요');
    }
    return ListView.separated(
      itemCount: users.length,
      separatorBuilder: (_, __) => const Divider(height: 0.5),
      itemBuilder: (context, index) => _UserTile(user: users[index]),
    );
  }
}

class _UserTile extends StatelessWidget {
  const _UserTile({required this.user});

  final UserSearchItem user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: spacing.md),
      leading: CircleAvatar(
        radius: 20,
        backgroundImage:
            user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
        child: user.avatarUrl == null
            ? const Icon(Icons.person_outline_rounded)
            : null,
      ),
      title: Text(user.nickname),
      onTap: () => context.push(AppRoutes.userProfile(user.id)),
    );
  }
}

// ── Club tab ──────────────────────────────────────────────────────────────────

class _ClubList extends StatelessWidget {
  const _ClubList({required this.clubs});

  final List<ClubSearchItem> clubs;

  @override
  Widget build(BuildContext context) {
    if (clubs.isEmpty) {
      return const _EmptyResult(message: '검색 결과가 없어요');
    }
    return ListView.separated(
      itemCount: clubs.length,
      separatorBuilder: (_, __) => const Divider(height: 0.5),
      itemBuilder: (context, index) => _ClubTile(club: clubs[index]),
    );
  }
}

class _ClubTile extends StatelessWidget {
  const _ClubTile({required this.club});

  final ClubSearchItem club;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: spacing.md),
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: theme.colorScheme.secondaryContainer,
        child: Icon(
          Icons.group_rounded,
          size: 20,
          color: theme.colorScheme.onSecondaryContainer,
        ),
      ),
      title: Text(club.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${club.memberCount}명',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (club.currentBookTitle != null)
            Text(
              club.currentBookTitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
      isThreeLine: club.currentBookTitle != null,
    );
  }
}

// ── Shared empty states ───────────────────────────────────────────────────────

class _EmptyPrompt extends StatelessWidget {
  const _EmptyPrompt();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_rounded,
              size: 56,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            SizedBox(height: spacing.md),
            Text(
              '검색어를 입력해보세요',
              style: theme.textTheme.titleMedium,
            ),
            SizedBox(height: spacing.xs),
            Text(
              '책, 독자, 독서 클럽을 한 번에 찾아드려요',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyResult extends StatelessWidget {
  const _EmptyResult({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 48,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            SizedBox(height: spacing.md),
            Text('검색 중 오류가 발생했어요', style: theme.textTheme.titleMedium),
            SizedBox(height: spacing.xs),
            Text(
              error,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
