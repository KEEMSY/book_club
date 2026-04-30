import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../feed/application/highlight_notifier.dart';
import '../../feed/application/highlight_state.dart';
import '../../feed/domain/highlight.dart';
import '../../feed/presentation/book_feed_section.dart';
import '../../feed/presentation/widgets/add_highlight_sheet.dart';
import '../application/book_detail_notifier.dart';
import '../application/book_detail_state.dart';
import '../application/book_providers.dart';
import '../application/library_notifier.dart';
import '../domain/book.dart';
import '../domain/book_status.dart';
import 'widgets/book_cover.dart';

/// Two-pane Airbnb-toned book detail:
///   * Hero cover with a three-layer shadow (AppShadows.elevated).
///   * Serif title (Playfair displaySmall) + Inter author row + publisher chip.
///   * Description collapses to ~6 lines with a "더 보기" toggle.
///   * Primary CTA "내 서재에 담기" — Rausch FilledButton with loading / added
///     / duplicate machine bound to BookDetailNotifier.libraryState.
class BookDetailScreen extends ConsumerWidget {
  const BookDetailScreen({super.key, required this.bookId});

  final String bookId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final BookDetailState state = ref.watch(bookDetailNotifierProvider(bookId));

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 56,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            }
          },
        ),
      ),
      body: switch (state) {
        BookDetailLoading() => const Center(child: CircularProgressIndicator()),
        BookDetailError(:final String message) => _ErrorView(
            message: message,
            onRetry: () =>
                ref.read(bookDetailNotifierProvider(bookId).notifier).load(),
          ),
        BookDetailLoaded(
          :final Book book,
          :final LibraryCtaState libraryState
        ) =>
          _Content(
            book: book,
            libraryState: libraryState,
            spacing: spacing,
            userBookId: switch (libraryState) {
              LibraryCtaAdded(:final userBook) => userBook.id,
              LibraryCtaDuplicate(:final duplicateUserBookId) =>
                duplicateUserBookId,
              _ => null,
            },
            onAdd: () async {
              final messenger = ScaffoldMessenger.of(context);
              final userBook = await ref
                  .read(bookDetailNotifierProvider(bookId).notifier)
                  .addToLibrary();
              if (userBook != null) {
                ref.read(libraryNotifierProvider.notifier).upsert(userBook);
                messenger.showSnackBar(
                  const SnackBar(content: Text('서재에 담겼어요')),
                );
              }
            },
            onAddWishlist: () async {
              final messenger = ScaffoldMessenger.of(context);
              final userBook = await ref
                  .read(bookDetailNotifierProvider(bookId).notifier)
                  .addToWishlist();
              if (userBook != null) {
                ref.read(libraryNotifierProvider.notifier).upsert(userBook);
                messenger.showSnackBar(
                  const SnackBar(content: Text('읽고 싶어요 목록에 추가됐어요')),
                );
              }
            },
            onGoToLibrary: () {
              final (String? id, String? pendingTab) = switch (libraryState) {
                LibraryCtaAdded(:final userBook) =>
                  (userBook.id, userBook.status.wire),
                LibraryCtaDuplicate(:final duplicateUserBookId) =>
                  (duplicateUserBookId, null),
                _ => (null, null),
              };
              if (pendingTab != null) {
                ref.read(libraryPendingTabProvider.notifier).state =
                    BookStatus.fromWire(pendingTab);
              }
              final String uri =
                  id != null ? '/library?highlight=$id' : '/library';
              context.go(uri);
            },
          ),
      },
    );
  }
}

class _Content extends StatefulWidget {
  const _Content({
    required this.book,
    required this.libraryState,
    required this.spacing,
    required this.onAdd,
    required this.onAddWishlist,
    required this.onGoToLibrary,
    this.userBookId,
  });

  final Book book;
  final LibraryCtaState libraryState;
  final AppSpacing spacing;
  final VoidCallback onAdd;
  final VoidCallback onAddWishlist;
  final VoidCallback onGoToLibrary;
  final String? userBookId;

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  bool _expanded = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shadows = theme.extension<AppShadows>()!;
    final radii = theme.extension<AppRadius>()!;
    final spacing = widget.spacing;

    final Book book = widget.book;
    final String? description = book.description;
    final bool hasDescription =
        description != null && description.trim().isNotEmpty;

    return SafeArea(
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: EdgeInsets.fromLTRB(
          spacing.lg,
          spacing.sm,
          spacing.lg,
          spacing.xl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Hero cover: 160×240, centered, three-layer Airbnb shadow.
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(radii.md)),
                  boxShadow: shadows.elevated,
                ),
                child: BookCover(
                  coverUrl: book.coverUrl,
                  width: 160,
                  height: 240,
                  borderRadius: BorderRadius.all(Radius.circular(radii.md)),
                ),
              ),
            ),
            SizedBox(height: spacing.lg),
            Text(book.title, style: theme.textTheme.displaySmall),
            SizedBox(height: spacing.sm),
            Text(
              book.author,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (book.publisher.isNotEmpty) ...<Widget>[
              SizedBox(height: spacing.sm),
              _PublisherChip(publisher: book.publisher),
            ],
            if (hasDescription) ...<Widget>[
              SizedBox(height: spacing.lg),
              _Description(
                text: description.trim(),
                expanded: _expanded,
                onToggle: () => setState(() => _expanded = !_expanded),
              ),
            ],
            SizedBox(height: spacing.xl),
            _LibraryCta(
              state: widget.libraryState,
              onAdd: widget.onAdd,
              onAddWishlist: widget.onAddWishlist,
              onGoToLibrary: widget.onGoToLibrary,
            ),
            if (widget.userBookId != null) ...<Widget>[
              SizedBox(height: spacing.xl),
              _HighlightSection(
                userBookId: widget.userBookId!,
                bookId: book.id,
              ),
            ],
            SizedBox(height: spacing.xl),
            BookFeedSection(
              bookId: book.id,
              scrollController: _scrollController,
            ),
          ],
        ),
      ),
    );
  }
}

class _Description extends StatelessWidget {
  const _Description({
    required this.text,
    required this.expanded,
    required this.onToggle,
  });

  final String text;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          text,
          maxLines: expanded ? null : 6,
          overflow: expanded ? TextOverflow.visible : TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: onToggle,
            child: Text(expanded ? '접기' : '더 보기'),
          ),
        ),
      ],
    );
  }
}

class _PublisherChip extends StatelessWidget {
  const _PublisherChip({required this.publisher});

  final String publisher;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radii = theme.extension<AppRadius>()!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.all(Radius.circular(radii.sm)),
      ),
      child: Text(
        publisher,
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _LibraryCta extends StatelessWidget {
  const _LibraryCta({
    required this.state,
    required this.onAdd,
    required this.onAddWishlist,
    required this.onGoToLibrary,
  });

  final LibraryCtaState state;
  final VoidCallback onAdd;
  final VoidCallback onAddWishlist;
  final VoidCallback onGoToLibrary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radii = theme.extension<AppRadius>()!;

    final ButtonStyle pillStyle = FilledButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(radii.pill)),
      ),
      minimumSize: const Size.fromHeight(52),
    );
    final ButtonStyle outlinePillStyle = OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(radii.pill)),
      ),
      minimumSize: const Size.fromHeight(52),
    );

    return switch (state) {
      LibraryCtaIdle() => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            FilledButton(
              style: pillStyle,
              onPressed: onAdd,
              child: const Text('내 서재에 담기'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              style: outlinePillStyle,
              onPressed: onAddWishlist,
              child: const Text('읽고 싶어요'),
            ),
          ],
        ),
      LibraryCtaAdding() => FilledButton(
          style: pillStyle,
          onPressed: null,
          child: const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
      LibraryCtaAdded() => FilledButton(
          style: pillStyle,
          onPressed: onGoToLibrary,
          child: const Text('서재에서 보기'),
        ),
      LibraryCtaDuplicate() => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              '이미 서재에 있는 책이에요',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            FilledButton(
              style: pillStyle,
              onPressed: onGoToLibrary,
              child: const Text('서재에서 보기'),
            ),
          ],
        ),
      LibraryCtaError(:final String message) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 8),
            FilledButton(
              style: pillStyle,
              onPressed: onAdd,
              child: const Text('다시 시도'),
            ),
          ],
        ),
    };
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing.xl),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.error_outline_rounded, size: 40),
            SizedBox(height: spacing.md),
            Text(message, style: theme.textTheme.titleLarge),
            SizedBox(height: spacing.lg),
            FilledButton(
              onPressed: onRetry,
              child: const Text('다시 시도'),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Highlight section
// ---------------------------------------------------------------------------

class _HighlightSection extends ConsumerWidget {
  const _HighlightSection({required this.userBookId, required this.bookId});

  final String userBookId;
  final String bookId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final spacing = theme.extension<AppSpacing>()!;
    final HighlightState state = ref.watch(highlightNotifierProvider(userBookId));

    // Load on first build.
    ref.listen<HighlightState>(highlightNotifierProvider(userBookId), (_, __) {});
    if (state is HighlightInitial) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(highlightNotifierProvider(userBookId).notifier).load();
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text('내 하이라이트', style: theme.textTheme.titleMedium),
            ),
            TextButton.icon(
              onPressed: () => _showAddModal(context, ref),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('추가'),
            ),
          ],
        ),
        if (state is HighlightLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (state is HighlightLoaded && state.items.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: spacing.md),
            child: Text(
              '기억하고 싶은 문장을 저장해보세요.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          )
        else if (state is HighlightLoaded)
          ...state.items
              .map((Highlight h) => _HighlightCard(highlight: h, userBookId: userBookId)),
      ],
    );
  }

  Future<void> _showAddModal(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => AddHighlightSheet(userBookId: userBookId),
    );
  }
}

class _HighlightCard extends ConsumerWidget {
  const _HighlightCard({required this.highlight, required this.userBookId});

  final Highlight highlight;
  final String userBookId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final radii = theme.extension<AppRadius>()!;
    final spacing = theme.extension<AppSpacing>()!;
    return Container(
      margin: EdgeInsets.only(bottom: spacing.sm),
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        border: Border(
          left: BorderSide(
            color: theme.colorScheme.primary,
            width: 3,
          ),
        ),
        borderRadius: BorderRadius.all(Radius.circular(radii.sm)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '"${highlight.quoteText}"',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                    height: 1.6,
                  ),
                ),
                if (highlight.pageNumber != null) ...<Widget>[
                  const SizedBox(height: 4),
                  Text(
                    'p.${highlight.pageNumber}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 18),
            onPressed: () => ref
                .read(highlightNotifierProvider(userBookId).notifier)
                .delete(highlight.id),
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}

